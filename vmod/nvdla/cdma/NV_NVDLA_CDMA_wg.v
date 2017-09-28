// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_wg.v

module NV_NVDLA_CDMA_wg (
   nvdla_core_clk            //|< i
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_core_rstn           //|< i
  ,cvif2wg_dat_rd_rsp_pd     //|< i
  ,cvif2wg_dat_rd_rsp_valid  //|< i
  ,mcif2wg_dat_rd_rsp_pd     //|< i
  ,mcif2wg_dat_rd_rsp_valid  //|< i
  ,pwrbus_ram_pd             //|< i
  ,reg2dp_conv_mode          //|< i
  ,reg2dp_conv_x_stride      //|< i
  ,reg2dp_conv_y_stride      //|< i
  ,reg2dp_data_bank          //|< i
  ,reg2dp_data_reuse         //|< i
  ,reg2dp_datain_addr_high_0 //|< i
  ,reg2dp_datain_addr_low_0  //|< i
  ,reg2dp_datain_channel     //|< i
  ,reg2dp_datain_format      //|< i
  ,reg2dp_datain_height      //|< i
  ,reg2dp_datain_height_ext  //|< i
  ,reg2dp_datain_ram_type    //|< i
  ,reg2dp_datain_width       //|< i
  ,reg2dp_datain_width_ext   //|< i
  ,reg2dp_dma_en             //|< i
  ,reg2dp_entries            //|< i
  ,reg2dp_in_precision       //|< i
  ,reg2dp_line_stride        //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_pad_bottom         //|< i *
  ,reg2dp_pad_left           //|< i
  ,reg2dp_pad_right          //|< i
  ,reg2dp_pad_top            //|< i
  ,reg2dp_pad_value          //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_skip_data_rls      //|< i
  ,reg2dp_surf_stride        //|< i
  ,sc2cdma_dat_pending_req   //|< i
  ,status2dma_free_entries   //|< i
  ,status2dma_fsm_switch     //|< i
  ,status2dma_valid_slices   //|< i *
  ,status2dma_wr_idx         //|< i
  ,wg2sbuf_p0_rd_data        //|< i
  ,wg2sbuf_p1_rd_data        //|< i
  ,wg_dat2cvif_rd_req_ready  //|< i
  ,wg_dat2mcif_rd_req_ready  //|< i
  ,cvif2wg_dat_rd_rsp_ready  //|> o
  ,dp2reg_wg_rd_latency      //|> o
  ,dp2reg_wg_rd_stall        //|> o
  ,mcif2wg_dat_rd_rsp_ready  //|> o
  ,slcg_wg_gate_dc           //|> o
  ,slcg_wg_gate_img          //|> o
  ,wg2cvt_dat_wr_addr        //|> o
  ,wg2cvt_dat_wr_data        //|> o
  ,wg2cvt_dat_wr_en          //|> o
  ,wg2cvt_dat_wr_hsel        //|> o
  ,wg2cvt_dat_wr_info_pd     //|> o
  ,wg2sbuf_p0_rd_addr        //|> o
  ,wg2sbuf_p0_rd_en          //|> o
  ,wg2sbuf_p0_wr_addr        //|> o
  ,wg2sbuf_p0_wr_data        //|> o
  ,wg2sbuf_p0_wr_en          //|> o
  ,wg2sbuf_p1_rd_addr        //|> o
  ,wg2sbuf_p1_rd_en          //|> o
  ,wg2sbuf_p1_wr_addr        //|> o
  ,wg2sbuf_p1_wr_data        //|> o
  ,wg2sbuf_p1_wr_en          //|> o
  ,wg2status_dat_entries     //|> o
  ,wg2status_dat_slices      //|> o
  ,wg2status_dat_updt        //|> o
  ,wg2status_state           //|> o
  ,wg_dat2cvif_rd_req_pd     //|> o
  ,wg_dat2cvif_rd_req_valid  //|> o
  ,wg_dat2mcif_rd_req_pd     //|> o
  ,wg_dat2mcif_rd_req_valid  //|> o
  );


//
// NV_NVDLA_CDMA_wg_ports.v
//
input  nvdla_core_clk;   /* wg_dat2mcif_rd_req, wg_dat2cvif_rd_req, mcif2wg_dat_rd_rsp, cvif2wg_dat_rd_rsp, wg2cvt_dat_wr, wg2cvt_dat_wr_info, switch_status2dma, state_wg2status, dat_up_wg2status, bc_status2dma, wg2sbuf_p0_wr, wg2sbuf_p1_wr, wg2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */
input  nvdla_core_rstn;  /* wg_dat2mcif_rd_req, wg_dat2cvif_rd_req, mcif2wg_dat_rd_rsp, cvif2wg_dat_rd_rsp, wg2cvt_dat_wr, wg2cvt_dat_wr_info, switch_status2dma, state_wg2status, dat_up_wg2status, bc_status2dma, wg2sbuf_p0_wr, wg2sbuf_p1_wr, wg2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */

input [31:0] pwrbus_ram_pd;

output        wg_dat2mcif_rd_req_valid;  /* data valid */
input         wg_dat2mcif_rd_req_ready;  /* data return handshake */
output [78:0] wg_dat2mcif_rd_req_pd;

output        wg_dat2cvif_rd_req_valid;  /* data valid */
input         wg_dat2cvif_rd_req_ready;  /* data return handshake */
output [78:0] wg_dat2cvif_rd_req_pd;

input          mcif2wg_dat_rd_rsp_valid;  /* data valid */
output         mcif2wg_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2wg_dat_rd_rsp_pd;

input          cvif2wg_dat_rd_rsp_valid;  /* data valid */
output         cvif2wg_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2wg_dat_rd_rsp_pd;

output         wg2cvt_dat_wr_en;    /* data valid */
output  [11:0] wg2cvt_dat_wr_addr;
output         wg2cvt_dat_wr_hsel;
output [511:0] wg2cvt_dat_wr_data;

output [11:0] wg2cvt_dat_wr_info_pd;

input  status2dma_fsm_switch;

output [1:0] wg2status_state;

output        wg2status_dat_updt;     /* data valid */
output [11:0] wg2status_dat_entries;
output [11:0] wg2status_dat_slices;

input [11:0] status2dma_valid_slices;
input [11:0] status2dma_free_entries;
input [11:0] status2dma_wr_idx;

output         wg2sbuf_p0_wr_en;    /* data valid */
output   [7:0] wg2sbuf_p0_wr_addr;
output [255:0] wg2sbuf_p0_wr_data;

output         wg2sbuf_p1_wr_en;    /* data valid */
output   [7:0] wg2sbuf_p1_wr_addr;
output [255:0] wg2sbuf_p1_wr_data;

output       wg2sbuf_p0_rd_en;    /* data valid */
output [7:0] wg2sbuf_p0_rd_addr;

input [255:0] wg2sbuf_p0_rd_data;

output       wg2sbuf_p1_rd_en;    /* data valid */
output [7:0] wg2sbuf_p1_rd_addr;

input [255:0] wg2sbuf_p1_rd_data;

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
input [12:0]  reg2dp_datain_width_ext;
input [12:0] reg2dp_datain_height_ext;
input [12:0]        reg2dp_datain_channel;
input [0:0]       reg2dp_datain_ram_type;
input [31:0] reg2dp_datain_addr_high_0;
input [26:0]   reg2dp_datain_addr_low_0;
input [26:0]             reg2dp_line_stride;
input [26:0]             reg2dp_surf_stride;
input [11:0]             reg2dp_entries;
input [2:0]           reg2dp_conv_x_stride;
input [2:0]           reg2dp_conv_y_stride;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;
input [4:0]                reg2dp_pad_top;
input [5:0]             reg2dp_pad_bottom;
input [15:0]        reg2dp_pad_value;
input [3:0]                      reg2dp_data_bank;
input [0:0]                  reg2dp_dma_en;

output slcg_wg_gate_dc;
output slcg_wg_gate_img;

output [31:0]       dp2reg_wg_rd_stall;
output [31:0]   dp2reg_wg_rd_latency;

wire            cbuf_wr_info_ext128;
wire            cbuf_wr_info_ext64;
wire            cbuf_wr_info_interleave;
wire      [3:0] cbuf_wr_info_mask;
wire            cbuf_wr_info_mean;
wire      [2:0] cbuf_wr_info_sub_h;
wire            cbuf_wr_info_uint;
wire            cv_dma_rd_req_rdy;
wire            cv_dma_rd_req_vld;
wire    [513:0] cv_dma_rd_rsp_pd;
wire            cv_dma_rd_rsp_vld;
wire     [78:0] cv_int_rd_req_pd;
wire     [78:0] cv_int_rd_req_pd_d0;
wire            cv_int_rd_req_ready;
wire            cv_int_rd_req_ready_d0;
wire            cv_int_rd_req_valid;
wire            cv_int_rd_req_valid_d0;
wire    [513:0] cv_int_rd_rsp_pd;
wire            cv_int_rd_rsp_ready;
wire            cv_int_rd_rsp_valid;
wire            cv_rd_req_rdyi;
wire    [513:0] cvif2wg_dat_rd_rsp_pd_d0;
wire            cvif2wg_dat_rd_rsp_ready_d0;
wire            cvif2wg_dat_rd_rsp_valid_d0;
wire   [1023:0] dat_cur_normal;
wire      [4:0] delay_cnt_end;
wire     [63:0] dma_rd_req_addr;
wire     [78:0] dma_rd_req_pd;
wire            dma_rd_req_rdy;
wire     [15:0] dma_rd_req_size;
wire            dma_rd_req_type;
wire            dma_rd_req_vld;
wire    [511:0] dma_rd_rsp_data;
wire      [1:0] dma_rd_rsp_mask;
wire    [513:0] dma_rd_rsp_pd;
wire            dma_rd_rsp_rdy;
wire            dma_rd_rsp_vld;
wire            dma_req_fifo_ready;
wire    [255:0] dma_rsp_data_p0;
wire    [255:0] dma_rsp_data_p1;
wire      [4:0] dma_rsp_fifo_data;
wire            dma_rsp_fifo_req;
wire            dp2reg_wg_rd_stall_dec;
wire            ltc_1_dec;
wire            ltc_1_inc;
wire            ltc_2_dec;
wire            ltc_2_inc;
wire            mc_dma_rd_req_rdy;
wire            mc_dma_rd_req_vld;
wire    [513:0] mc_dma_rd_rsp_pd;
wire            mc_dma_rd_rsp_vld;
wire     [78:0] mc_int_rd_req_pd;
wire     [78:0] mc_int_rd_req_pd_d0;
wire            mc_int_rd_req_ready;
wire            mc_int_rd_req_ready_d0;
wire            mc_int_rd_req_valid;
wire            mc_int_rd_req_valid_d0;
wire    [513:0] mc_int_rd_rsp_pd;
wire            mc_int_rd_rsp_ready;
wire            mc_int_rd_rsp_valid;
wire            mc_rd_req_rdyi;
wire    [513:0] mcif2wg_dat_rd_rsp_pd_d0;
wire            mcif2wg_dat_rd_rsp_ready_d0;
wire            mcif2wg_dat_rd_rsp_valid_d0;
wire            pending_req_end;
wire            rd_req_rdyi;
wire     [58:0] req_addr_base;
wire      [3:0] req_size;
wire   [1023:0] rsp_data_l0;
wire   [1023:0] rsp_data_l1;
wire            rsp_en;
wire      [1:0] rsp_sel;
wire      [1:0] rsp_sel_d0;
wire            rsp_vld;
wire            rsp_vld_d0;
wire            slcg_wg_en_w;
wire      [1:0] slcg_wg_gate_w;
wire            width_dummy;
wire     [12:0] x_offset;
reg      [26:0] c_offset;
reg      [26:0] c_offset_d1;
reg       [3:0] conv_x_stride;
reg       [3:0] conv_x_stride_w;
reg      [10:0] conv_xy_stride;
reg      [10:0] conv_xy_stride_w;
reg       [3:0] conv_y_stride;
reg       [3:0] conv_y_stride_w;
reg       [1:0] cur_state;
reg    [1023:0] dat_cur;
reg    [1023:0] dat_cur_expand;
reg    [1023:0] dat_cur_remapped;
reg    [1023:0] dat_cur_shrink;
reg       [3:0] data_bank;
reg      [11:0] data_entries;
reg      [11:0] data_entries_add;
reg      [11:0] data_entries_w;
reg      [13:0] data_height;
reg      [14:0] data_height_st_w;
reg      [13:0] data_height_w;
reg       [9:0] data_surf;
reg       [9:0] data_surf_w;
reg      [11:0] data_width_ext;
reg      [11:0] data_width_ext_w;
reg       [4:0] delay_cnt;
reg       [4:0] delay_cnt_w;
reg     [511:0] dma_pad_data;
reg             dma_rd_rsp_blocking;
reg       [4:0] dma_req_fifo_data;
reg             dma_req_fifo_req;
reg     [511:0] dma_rsp_data;
reg             dma_rsp_dummy;
reg             dma_rsp_fifo_ready;
reg       [1:0] dma_rsp_mask;
reg       [3:0] dma_rsp_size;
reg       [3:0] dma_rsp_size_cnt;
reg       [3:0] dma_rsp_size_cnt_inc;
reg       [3:0] dma_rsp_size_cnt_w;
reg             dma_rsp_vld;
reg      [31:0] dp2reg_wg_rd_latency;
reg      [31:0] dp2reg_wg_rd_stall;
reg             fetch_done;
reg      [14:0] h_coord;
reg      [14:0] h_coord_sub_h;
reg      [14:0] h_coord_surf;
reg      [14:0] h_coord_w;
reg      [10:0] h_ext_surf;
reg      [10:0] h_ext_surf_w;
reg             height_dummy;
reg      [10:0] height_ext_total;
reg             is_cbuf_ready;
reg             is_cbuf_ready_w;
reg             is_data_expand;
reg             is_data_expand_d1;
reg             is_data_normal;
reg             is_data_normal_d1;
reg             is_data_shrink;
reg             is_data_shrink_d1;
reg             is_done;
reg             is_feature;
reg             is_first_running;
reg             is_idle;
reg             is_input_int8;
reg             is_int8;
reg             is_last_req;
reg             is_last_rsp;
reg             is_pending;
reg             is_req_done;
reg             is_req_done_w;
reg             is_req_last_di;
reg             is_req_last_h_ext;
reg             is_req_last_lp;
reg             is_req_last_rp;
reg             is_req_last_sub_h;
reg             is_req_last_sub_w;
reg             is_req_last_surf;
reg             is_req_last_w_set;
reg             is_req_last_width;
reg             is_req_last_y_std;
reg             is_rsp_addr_wrap;
reg             is_rsp_done;
reg             is_rsp_done_w;
reg             is_rsp_last_h_ext;
reg             is_rsp_last_sub_cube;
reg             is_rsp_last_surf;
reg             is_rsp_last_width;
reg             is_rsp_last_x_std;
reg             is_rsp_last_y_std;
reg             is_running;
reg             is_running_d1;
reg             is_sbuf_wr_last_line;
reg             is_slice_done;
reg             is_w_set_di;
reg             is_w_set_lp;
reg             is_w_set_rp;
reg             is_wg;
reg             is_x_stride_one;
reg             is_x_stride_one_w;
reg       [3:0] last_data_bank;
reg       [3:0] last_lp;
reg       [3:0] last_lp_w;
reg       [3:0] last_rp;
reg       [3:0] last_rp_w;
reg             last_skip_data_rls;
reg             last_wg;
reg             layer_st;
reg             layer_st_d1;
reg       [4:0] lp_end;
reg       [4:0] lp_end_w;
reg             ltc_1_adv;
reg       [8:0] ltc_1_cnt_cur;
reg      [10:0] ltc_1_cnt_dec;
reg      [10:0] ltc_1_cnt_ext;
reg      [10:0] ltc_1_cnt_inc;
reg      [10:0] ltc_1_cnt_mod;
reg      [10:0] ltc_1_cnt_new;
reg      [10:0] ltc_1_cnt_nxt;
reg             ltc_2_adv;
reg      [31:0] ltc_2_cnt_cur;
reg      [33:0] ltc_2_cnt_dec;
reg      [33:0] ltc_2_cnt_ext;
reg      [33:0] ltc_2_cnt_inc;
reg      [33:0] ltc_2_cnt_mod;
reg      [33:0] ltc_2_cnt_new;
reg      [33:0] ltc_2_cnt_nxt;
reg             mode_match;
reg       [8:0] mon_c_offset;
reg       [4:0] mon_conv_xy_stride_w;
reg             mon_data_entries_w;
reg             mon_delay_cnt_w;
reg             mon_dma_rsp_size_cnt_inc;
reg             mon_h_coord_w;
reg       [9:0] mon_h_ext_surf_w;
reg             mon_lp_end_w;
reg             mon_rd_cube_cnt_w;
reg             mon_rd_sub_cnt_w;
reg             mon_req_addr_w;
reg             mon_req_cubf_needed;
reg             mon_req_h_ext_cnt_inc;
reg             mon_req_size_out;
reg             mon_req_sub_h_cnt_w;
reg             mon_req_sub_w_cnt_inc;
reg             mon_req_surf_cnt_inc;
reg             mon_req_w_set_cnt_inc;
reg             mon_req_y_std_cnt_inc;
reg             mon_rp_end_w;
reg             mon_rsp_addr_inc;
reg             mon_rsp_addr_offset_w;
reg       [1:0] mon_rsp_addr_wrap;
reg             mon_rsp_ch_offset_w;
reg             mon_rsp_h_ext_cnt_inc;
reg             mon_rsp_sub_cube_cnt_inc;
reg             mon_rsp_surf_cnt_inc;
reg             mon_rsp_width_cnt_inc;
reg             mon_rsp_x_std_cnt_inc;
reg             mon_rsp_y_std_cnt_inc;
reg             mon_sbuf_avl_cube_w;
reg             mon_sbuf_wr_line_w;
reg             mon_sbuf_wr_p0_base_w;
reg             mon_sbuf_wr_p0_ch_inc;
reg             mon_sbuf_wr_p0_idx_lo;
reg             mon_sbuf_wr_p1_base_w;
reg             mon_sbuf_wr_p1_ch_inc;
reg             mon_sbuf_wr_p1_idx_lo;
reg      [10:0] mon_w_ext_surf_w;
reg             mon_wg_entry_onfly_w;
reg      [12:0] mon_y_offset;
reg             need_pending;
reg             no_lp;
reg             no_lp_w;
reg       [1:0] nxt_state;
reg       [8:0] outs_dp2reg_wg_rd_latency;
reg             pending_req;
reg             pending_req_d1;
reg       [3:0] rd_cube_cnt;
reg       [3:0] rd_cube_cnt_w;
reg       [2:0] rd_sub_cnt;
reg       [2:0] rd_sub_cnt_w;
reg      [58:0] req_addr_d2;
reg      [58:0] req_addr_w;
reg             req_adv;
reg      [11:0] req_cbuf_needed;
reg             req_dummy_d1;
reg             req_dummy_d2;
reg      [10:0] req_h_ext_cnt;
reg      [10:0] req_h_ext_cnt_inc;
reg      [10:0] req_h_ext_cnt_w;
reg             req_h_ext_en;
reg             req_ready;
reg             req_ready_d1;
reg             req_ready_d2;
reg       [3:0] req_size_d1;
reg       [3:0] req_size_d2;
reg       [2:0] req_size_out;
reg       [2:0] req_size_out_d1;
reg       [2:0] req_size_out_d2;
reg       [1:0] req_sub_h_cnt;
reg       [1:0] req_sub_h_cnt_w;
reg             req_sub_h_en;
reg      [12:0] req_sub_w_cnt;
reg      [12:0] req_sub_w_cnt_inc;
reg      [12:0] req_sub_w_cnt_w;
reg       [3:0] req_sub_w_cur;
reg             req_sub_w_en;
reg       [8:0] req_surf_cnt;
reg       [8:0] req_surf_cnt_inc;
reg       [8:0] req_surf_cnt_w;
reg             req_surf_en;
reg             req_valid;
reg             req_valid_d1;
reg             req_valid_d1_w;
reg             req_valid_d2;
reg             req_valid_d2_w;
reg       [1:0] req_w_set_cnt;
reg       [1:0] req_w_set_cnt_inc;
reg       [1:0] req_w_set_cnt_w;
reg             req_w_set_en;
reg       [2:0] req_y_std_cnt;
reg       [2:0] req_y_std_cnt_inc;
reg       [2:0] req_y_std_cnt_w;
reg             req_y_std_en;
reg       [5:0] rp_end;
reg       [5:0] rp_end_w;
reg      [11:0] rsp_addr;
reg      [11:0] rsp_addr_base;
reg      [11:0] rsp_addr_d1;
reg      [12:0] rsp_addr_inc;
reg      [11:0] rsp_addr_offset;
reg      [11:0] rsp_addr_offset_w;
reg      [11:0] rsp_addr_wrap;
reg      [11:0] rsp_ch_offset;
reg             rsp_ch_offset_en;
reg      [11:0] rsp_ch_offset_w;
reg      [11:0] rsp_ch_surf_add;
reg      [11:0] rsp_ch_surf_base;
reg             rsp_ch_surf_base_en;
reg      [11:0] rsp_ch_w_base;
reg             rsp_ch_w_base_en;
reg      [11:0] rsp_ch_x_std_add;
reg      [11:0] rsp_ch_x_std_base;
reg             rsp_ch_x_std_base_en;
reg      [11:0] rsp_ch_y_std_add;
reg      [11:0] rsp_ch_y_std_base;
reg             rsp_ch_y_std_base_en;
reg             rsp_dat_vld_d1;
reg             rsp_dat_vld_d2;
reg     [511:0] rsp_data_d1;
reg     [511:0] rsp_data_d1_w;
reg     [511:0] rsp_data_l0c0;
reg             rsp_data_l0c0_en;
reg     [511:0] rsp_data_l0c1;
reg             rsp_data_l0c1_en;
reg     [511:0] rsp_data_l1c0;
reg             rsp_data_l1c0_en;
reg     [511:0] rsp_data_l1c1;
reg             rsp_data_l1c1_en;
reg             rsp_en_d1;
reg      [10:0] rsp_h_ext_cnt;
reg      [10:0] rsp_h_ext_cnt_inc;
reg      [10:0] rsp_h_ext_cnt_w;
reg             rsp_h_ext_en;
reg             rsp_hsel;
reg             rsp_hsel_d1;
reg             rsp_layer_done_d1;
reg       [1:0] rsp_sel_d1;
reg       [1:0] rsp_sel_d2;
reg             rsp_slice_done_d1;
reg       [2:0] rsp_sub_cube_cnt;
reg       [2:0] rsp_sub_cube_cnt_inc;
reg       [2:0] rsp_sub_cube_cnt_w;
reg             rsp_sub_cube_en;
reg       [8:0] rsp_surf_cnt;
reg       [8:0] rsp_surf_cnt_inc;
reg       [8:0] rsp_surf_cnt_w;
reg             rsp_surf_en;
reg             rsp_vld_d1;
reg             rsp_vld_d2;
reg      [10:0] rsp_width_cnt;
reg      [10:0] rsp_width_cnt_inc;
reg      [10:0] rsp_width_cnt_w;
reg             rsp_width_en;
reg       [2:0] rsp_x_std_cnt;
reg       [2:0] rsp_x_std_cnt_inc;
reg       [2:0] rsp_x_std_cnt_w;
reg             rsp_x_std_en;
reg       [2:0] rsp_y_std_cnt;
reg       [2:0] rsp_y_std_cnt_inc;
reg       [2:0] rsp_y_std_cnt_w;
reg             rsp_y_std_en;
reg       [3:0] sbuf_avl_cube;
reg       [3:0] sbuf_avl_cube_add;
reg             sbuf_avl_cube_en;
reg             sbuf_avl_cube_sub;
reg       [3:0] sbuf_avl_cube_w;
reg             sbuf_blocking;
reg             sbuf_blocking_w;
reg             sbuf_cube_inc_en;
reg             sbuf_cube_inc_en_d1;
reg       [3:0] sbuf_cube_inc_size;
reg       [3:0] sbuf_cube_inc_size_d1;
reg             sbuf_rd_en;
reg             sbuf_rd_en_d1;
reg       [7:0] sbuf_rd_p0_idx;
reg       [7:0] sbuf_rd_p0_idx_d1;
reg       [7:0] sbuf_rd_p1_idx;
reg       [7:0] sbuf_rd_p1_idx_d1;
reg       [1:0] sbuf_rd_sel_d1;
reg       [1:0] sbuf_wr_add;
reg             sbuf_wr_addr_en;
reg             sbuf_wr_addr_ori_en;
reg       [1:0] sbuf_wr_line;
reg       [1:0] sbuf_wr_line_w;
reg       [3:0] sbuf_wr_p0_base;
reg       [3:0] sbuf_wr_p0_base_ori;
reg       [3:0] sbuf_wr_p0_base_w;
reg       [3:0] sbuf_wr_p0_ch;
reg       [3:0] sbuf_wr_p0_ch_inc;
reg       [3:0] sbuf_wr_p0_ch_ori;
reg       [3:0] sbuf_wr_p0_ch_w;
reg     [255:0] sbuf_wr_p0_data_d1;
reg             sbuf_wr_p0_en;
reg             sbuf_wr_p0_en_d1;
reg       [7:0] sbuf_wr_p0_idx;
reg       [7:0] sbuf_wr_p0_idx_d1;
reg       [3:0] sbuf_wr_p0_idx_lo;
reg             sbuf_wr_p0_of;
reg             sbuf_wr_p0_of_0;
reg             sbuf_wr_p0_of_1;
reg       [2:0] sbuf_wr_p0_offset;
reg       [3:0] sbuf_wr_p0_offset_inc;
reg       [2:0] sbuf_wr_p0_offset_ori;
reg       [2:0] sbuf_wr_p0_offset_w;
reg       [3:0] sbuf_wr_p1_base;
reg       [3:0] sbuf_wr_p1_base_ori;
reg       [3:0] sbuf_wr_p1_base_w;
reg       [1:0] sbuf_wr_p1_ch;
reg       [1:0] sbuf_wr_p1_ch_inc;
reg       [1:0] sbuf_wr_p1_ch_ori;
reg       [1:0] sbuf_wr_p1_ch_w;
reg     [255:0] sbuf_wr_p1_data_d1;
reg             sbuf_wr_p1_en;
reg             sbuf_wr_p1_en_d1;
reg       [7:0] sbuf_wr_p1_idx;
reg       [7:0] sbuf_wr_p1_idx_d1;
reg       [3:0] sbuf_wr_p1_idx_lo;
reg             sbuf_wr_p1_of;
reg             sbuf_wr_p1_of_0;
reg             sbuf_wr_p1_of_1;
reg       [2:0] sbuf_wr_p1_offset;
reg       [3:0] sbuf_wr_p1_offset_inc;
reg       [2:0] sbuf_wr_p1_offset_ori;
reg       [2:0] sbuf_wr_p1_offset_w;
reg       [1:0] sbuf_x_stride_inc_size;
reg       [1:0] slcg_wg_gate_d1;
reg       [1:0] slcg_wg_gate_d2;
reg       [1:0] slcg_wg_gate_d3;
reg             stl_adv;
reg      [31:0] stl_cnt_cur;
reg      [33:0] stl_cnt_dec;
reg      [33:0] stl_cnt_ext;
reg      [33:0] stl_cnt_inc;
reg      [33:0] stl_cnt_mod;
reg      [33:0] stl_cnt_new;
reg      [33:0] stl_cnt_nxt;
reg       [8:0] surf_cnt_total;
reg       [8:0] surf_cnt_total_w;
reg      [10:0] w_ext_surf;
reg      [10:0] w_ext_surf_w;
reg       [1:0] wg2status_state;
reg       [1:0] wg2status_state_w;
reg             wg_en;
reg      [11:0] wg_entry_onfly;
reg      [11:0] wg_entry_onfly_add;
reg             wg_entry_onfly_en;
reg      [11:0] wg_entry_onfly_sub;
reg      [11:0] wg_entry_onfly_w;
reg             wg_rd_latency_cen;
reg             wg_rd_latency_clr;
reg             wg_rd_latency_dec;
reg             wg_rd_latency_inc;
reg             wg_rd_stall_cen;
reg             wg_rd_stall_clr;
reg             wg_rd_stall_inc;
reg      [10:0] width_ext_total;
reg       [1:0] width_set_total;
reg       [1:0] width_set_total_w;
reg      [12:0] x_offset_d1;
reg      [26:0] y_offset;
reg      [26:0] y_offset_d1;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// CDMA winograd convolution data fetching logic FSM                  //
////////////////////////////////////////////////////////////////////////

//## fsm (1) output

//|)

//## fsm (1) defines

localparam WG_STATE_IDLE = 2'b00;
localparam WG_STATE_PEND = 2'b01;
localparam WG_STATE_BUSY = 2'b10;
localparam WG_STATE_DONE = 2'b11;

//## fsm (1) com block

always @(
  cur_state
  or wg_en
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
      WG_STATE_IDLE: begin
        if ((wg_en & need_pending)) begin
          nxt_state = WG_STATE_PEND; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((wg_en & need_pending)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((wg_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) begin
          nxt_state = WG_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((wg_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (wg_en) begin
          nxt_state = WG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((wg_en) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WG_STATE_PEND: begin
        if ((pending_req_end)) begin
          nxt_state = WG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((pending_req_end)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WG_STATE_BUSY: begin
        if (fetch_done) begin
          nxt_state = WG_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((fetch_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      WG_STATE_DONE: begin
        if (status2dma_fsm_switch) begin
          nxt_state = WG_STATE_IDLE; 
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
        nxt_state = WG_STATE_IDLE; 
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
    cur_state <= WG_STATE_IDLE;
  end else begin
  cur_state <= nxt_state;
  end
end

//## fsm (1) reachable testpoints


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WG_STATE_IDLE
    `define COVER_OR_TP__state_reachable_WG_STATE_IDLE_OR_COVER
  `endif // TP__state_reachable_WG_STATE_IDLE

`ifdef COVER_OR_TP__state_reachable_WG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_IDLE ::: cur_state==WG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_IDLE ::: testpoint_0_goal_0
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
            if ((cur_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_IDLE ::: testpoint_0_goal_0");
 `endif
            if ((cur_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
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
    wire testpoint_0_goal_0_active = ((cur_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WG_STATE_IDLE_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WG_STATE_PEND
    `define COVER_OR_TP__state_reachable_WG_STATE_PEND_OR_COVER
  `endif // TP__state_reachable_WG_STATE_PEND

`ifdef COVER_OR_TP__state_reachable_WG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_PEND ::: cur_state==WG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_PEND ::: testpoint_1_goal_0
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
            if ((cur_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_PEND ::: testpoint_1_goal_0");
 `endif
            if ((cur_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
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
    wire testpoint_1_goal_0_active = ((cur_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WG_STATE_PEND_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WG_STATE_BUSY
    `define COVER_OR_TP__state_reachable_WG_STATE_BUSY_OR_COVER
  `endif // TP__state_reachable_WG_STATE_BUSY

`ifdef COVER_OR_TP__state_reachable_WG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_BUSY ::: cur_state==WG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_BUSY ::: testpoint_2_goal_0
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
            if ((cur_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_BUSY ::: testpoint_2_goal_0");
 `endif
            if ((cur_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
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
    wire testpoint_2_goal_0_active = ((cur_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WG_STATE_BUSY_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_WG_STATE_DONE
    `define COVER_OR_TP__state_reachable_WG_STATE_DONE_OR_COVER
  `endif // TP__state_reachable_WG_STATE_DONE

`ifdef COVER_OR_TP__state_reachable_WG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_WG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_DONE ::: cur_state==WG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_DONE ::: testpoint_3_goal_0
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
            if ((cur_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: state_reachable_WG_STATE_DONE ::: testpoint_3_goal_0");
 `endif
            if ((cur_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
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
    wire testpoint_3_goal_0_active = ((cur_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_WG_STATE_DONE_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_WG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) transition testpoints

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND_OR_COVER
  `endif // TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND

`ifdef COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_IDLE__to__WG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_PEND ::: (cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_PEND)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_PEND ::: testpoint_4_goal_0
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
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_PEND ::: testpoint_4_goal_0");
 `endif
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
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
    wire testpoint_4_goal_0_active = (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_IDLE__to__WG_STATE_PEND_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE_OR_COVER
  `endif // TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE

`ifdef COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_IDLE__to__WG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_DONE ::: (cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_DONE ::: testpoint_5_goal_0
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
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_DONE ::: testpoint_5_goal_0");
 `endif
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
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
    wire testpoint_5_goal_0_active = (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_IDLE__to__WG_STATE_DONE_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY
    `define COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY_OR_COVER
  `endif // TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY

`ifdef COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_IDLE__to__WG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_BUSY ::: (cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_BUSY ::: testpoint_6_goal_0
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
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_IDLE__to__WG_STATE_BUSY ::: testpoint_6_goal_0");
 `endif
            if (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
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
    wire testpoint_6_goal_0_active = (((cur_state==WG_STATE_IDLE) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_IDLE__to__WG_STATE_BUSY_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_IDLE__to__WG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE
    `define COVER_OR_TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_OR_COVER
  `endif // TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE

`ifdef COVER_OR_TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE ::: cur_state==WG_STATE_IDLE && nxt_state==WG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE ::: testpoint_7_goal_0
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
            if ((cur_state==WG_STATE_IDLE && nxt_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE ::: testpoint_7_goal_0");
 `endif
            if ((cur_state==WG_STATE_IDLE && nxt_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
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
    wire testpoint_7_goal_0_active = ((cur_state==WG_STATE_IDLE && nxt_state==WG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WG_STATE_IDLE__to__WG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY
    `define COVER_OR_TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY_OR_COVER
  `endif // TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY

`ifdef COVER_OR_TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_PEND__to__WG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_PEND__to__WG_STATE_BUSY ::: (cur_state==WG_STATE_PEND) && (nxt_state == WG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_PEND__to__WG_STATE_BUSY ::: testpoint_8_goal_0
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
            if (((cur_state==WG_STATE_PEND) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_PEND__to__WG_STATE_BUSY ::: testpoint_8_goal_0");
 `endif
            if (((cur_state==WG_STATE_PEND) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
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
    wire testpoint_8_goal_0_active = (((cur_state==WG_STATE_PEND) && (nxt_state == WG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_PEND__to__WG_STATE_BUSY_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_PEND__to__WG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND
    `define COVER_OR_TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND_OR_COVER
  `endif // TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND

`ifdef COVER_OR_TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WG_STATE_PEND__to__WG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_PEND__to__WG_STATE_PEND ::: cur_state==WG_STATE_PEND && nxt_state==WG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_PEND__to__WG_STATE_PEND ::: testpoint_9_goal_0
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
            if ((cur_state==WG_STATE_PEND && nxt_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_PEND__to__WG_STATE_PEND ::: testpoint_9_goal_0");
 `endif
            if ((cur_state==WG_STATE_PEND && nxt_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
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
    wire testpoint_9_goal_0_active = ((cur_state==WG_STATE_PEND && nxt_state==WG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WG_STATE_PEND__to__WG_STATE_PEND_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WG_STATE_PEND__to__WG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE
    `define COVER_OR_TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE_OR_COVER
  `endif // TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE

`ifdef COVER_OR_TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_BUSY__to__WG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_BUSY__to__WG_STATE_DONE ::: (cur_state==WG_STATE_BUSY) && (nxt_state == WG_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_BUSY__to__WG_STATE_DONE ::: testpoint_10_goal_0
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
            if (((cur_state==WG_STATE_BUSY) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_BUSY__to__WG_STATE_DONE ::: testpoint_10_goal_0");
 `endif
            if (((cur_state==WG_STATE_BUSY) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
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
    wire testpoint_10_goal_0_active = (((cur_state==WG_STATE_BUSY) && (nxt_state == WG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_BUSY__to__WG_STATE_DONE_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_BUSY__to__WG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY
    `define COVER_OR_TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_OR_COVER
  `endif // TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY

`ifdef COVER_OR_TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY ::: cur_state==WG_STATE_BUSY && nxt_state==WG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY ::: testpoint_11_goal_0
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
            if ((cur_state==WG_STATE_BUSY && nxt_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY ::: testpoint_11_goal_0");
 `endif
            if ((cur_state==WG_STATE_BUSY && nxt_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
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
    wire testpoint_11_goal_0_active = ((cur_state==WG_STATE_BUSY && nxt_state==WG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WG_STATE_BUSY__to__WG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE
    `define COVER_OR_TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE_OR_COVER
  `endif // TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE

`ifdef COVER_OR_TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_WG_STATE_DONE__to__WG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_DONE__to__WG_STATE_IDLE ::: (cur_state==WG_STATE_DONE) && (nxt_state == WG_STATE_IDLE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: transition_WG_STATE_DONE__to__WG_STATE_IDLE ::: testpoint_12_goal_0
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
            if (((cur_state==WG_STATE_DONE) && (nxt_state == WG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: transition_WG_STATE_DONE__to__WG_STATE_IDLE ::: testpoint_12_goal_0");
 `endif
            if (((cur_state==WG_STATE_DONE) && (nxt_state == WG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
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
    wire testpoint_12_goal_0_active = (((cur_state==WG_STATE_DONE) && (nxt_state == WG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_WG_STATE_DONE__to__WG_STATE_IDLE_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_WG_STATE_DONE__to__WG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE
    `define COVER_OR_TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE_OR_COVER
  `endif // TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE

`ifdef COVER_OR_TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_WG_STATE_DONE__to__WG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_DONE__to__WG_STATE_DONE ::: cur_state==WG_STATE_DONE && nxt_state==WG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_DONE__to__WG_STATE_DONE ::: testpoint_13_goal_0
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
            if ((cur_state==WG_STATE_DONE && nxt_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_wg ::: self_transition_WG_STATE_DONE__to__WG_STATE_DONE ::: testpoint_13_goal_0");
 `endif
            if ((cur_state==WG_STATE_DONE && nxt_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
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
    wire testpoint_13_goal_0_active = ((cur_state==WG_STATE_DONE && nxt_state==WG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_WG_STATE_DONE__to__WG_STATE_DONE_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_WG_STATE_DONE__to__WG_STATE_DONE_OR_COVER
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
  or is_req_done
  or is_rsp_done
  or delay_cnt
  or delay_cnt_end
  ) begin
    fetch_done = is_running & is_req_done & is_rsp_done & (delay_cnt == delay_cnt_end);
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
  wg_en
  or last_wg
  ) begin
    mode_match = wg_en & last_wg;
end

always @(
  reg2dp_datain_format
  ) begin
    is_feature = (reg2dp_datain_format == 1'h0 );
end

always @(
  reg2dp_conv_mode
  ) begin
    is_wg = (reg2dp_conv_mode == 1'h1 );
end

always @(
  reg2dp_op_en
  or is_wg
  or is_feature
  ) begin
    wg_en = reg2dp_op_en & is_wg & is_feature;
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

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! fifo is not empty when done!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (is_rsp_done & dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Req is not done when rsp is done!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (is_running & is_rsp_done & ~is_req_done)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! entry_onfly is non zero when idle")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (fetch_done & |(wg_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  wg_en
  or is_idle
  ) begin
    layer_st = wg_en & is_idle;
end

//&Always;
//    layer_end = status2dma_fsm_switch;
//&End;

always @(
  cur_state
  ) begin
    is_idle = (cur_state == WG_STATE_IDLE);
end

always @(
  cur_state
  ) begin
    is_pending = (cur_state == WG_STATE_PEND);
end

always @(
  cur_state
  ) begin
    is_running = (cur_state == WG_STATE_BUSY);
end

always @(
  cur_state
  ) begin
    is_done = (cur_state == WG_STATE_DONE);
end

always @(
  is_running_d1
  or is_running
  ) begin
    is_first_running = ~is_running_d1 & is_running;
end

always @(
  nxt_state
  ) begin
    wg2status_state_w = (nxt_state == WG_STATE_PEND) ? 1  : 
                        (nxt_state == WG_STATE_BUSY) ? 2  : 
                        (nxt_state == WG_STATE_DONE) ? 3  :
                        0 ;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_st_d1 <= 1'b0;
  end else begin
  layer_st_d1 <= layer_st;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg2status_state <= 0;
  end else begin
  wg2status_state <= wg2status_state_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_running_d1 <= 1'b0;
  end else begin
  is_running_d1 <= is_running;
  end
end

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
assign pending_req_end = pending_req_d1 & ~pending_req;

//================  Non-SLCG clock domain ================//
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_wg <= 1'b0;
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_wg <= wg_en;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_wg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    last_skip_data_rls <= wg_en & reg2dp_skip_data_rls;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
assign slcg_wg_en_w = wg_en & (is_running | is_pending | is_done);
assign slcg_wg_gate_w = {2{~slcg_wg_en_w}};

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_gate_d1 <= {2{1'b1}};
  end else begin
  slcg_wg_gate_d1 <= slcg_wg_gate_w;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_gate_d2 <= {2{1'b1}};
  end else begin
  slcg_wg_gate_d2 <= slcg_wg_gate_d1;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_gate_d3 <= {2{1'b1}};
  end else begin
  slcg_wg_gate_d3 <= slcg_wg_gate_d2;
  end
end

assign slcg_wg_gate_dc = slcg_wg_gate_d3[0];
assign slcg_wg_gate_img = slcg_wg_gate_d3[1];

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////

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
  reg2dp_conv_x_stride
  ) begin
    is_x_stride_one_w = ~(|reg2dp_conv_x_stride);
end

always @(
  reg2dp_pad_top
  ) begin
    data_height_st_w = 14'b0 - reg2dp_pad_top;
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
    surf_cnt_total_w = is_int8 ? {1'b0, reg2dp_datain_channel[12:5]} :
                       reg2dp_datain_channel[12:4];
end

always @(
  reg2dp_datain_width_ext
  ) begin
    data_width_ext_w = reg2dp_datain_width_ext[12:2] + 1'b1;
end

always @(
  is_int8
  or reg2dp_datain_channel
  ) begin
    data_surf_w = is_int8 ? {1'b0, reg2dp_datain_channel[12:5]} + 1'b1 :
                  reg2dp_datain_channel[12:4] + 1'b1;
end

always @(
  conv_x_stride_w
  or data_width_ext_w
  ) begin
    {mon_conv_xy_stride_w,
     conv_xy_stride_w} = conv_x_stride_w * data_width_ext_w;
end

always @(
  data_width_ext_w
  or data_surf
  ) begin
    {mon_w_ext_surf_w,
     w_ext_surf_w} = data_width_ext_w * data_surf;
end

always @(
  conv_xy_stride
  or data_surf
  ) begin
    {mon_h_ext_surf_w,
     h_ext_surf_w} = conv_xy_stride * data_surf;
end

always @(
  reg2dp_conv_x_stride
  ) begin
    conv_x_stride_w = reg2dp_conv_x_stride + 1'b1;
end

always @(
  reg2dp_conv_y_stride
  ) begin
    conv_y_stride_w = reg2dp_conv_y_stride + 1'b1;
end

always @(
  reg2dp_entries
  ) begin
    {mon_data_entries_w,
     data_entries_w} = {reg2dp_entries[9:0], 2'b0} + 3'h4;
end

always @(
  reg2dp_pad_left
  or reg2dp_pad_right
  ) begin
    width_set_total_w[1:0] = (|reg2dp_pad_left) + (|reg2dp_pad_right);
    no_lp_w = ~(|reg2dp_pad_left);
end

always @(
  reg2dp_pad_left
  ) begin
    {mon_lp_end_w,
     lp_end_w} = ~(|reg2dp_pad_left[2:0]) ? (reg2dp_pad_left - 4'h8) :
                 {reg2dp_pad_left[4:3], 3'b0};
end

always @(
  reg2dp_pad_left
  ) begin
    last_lp_w = ~(|reg2dp_pad_left[2:0]) ? 4'h8 : {1'b0, reg2dp_pad_left[2:0]};
end

always @(
  reg2dp_pad_right
  ) begin
    {mon_rp_end_w,
     rp_end_w} = ~(|reg2dp_pad_right[2:0]) ? (reg2dp_pad_right - 4'h8) :
                 {reg2dp_pad_right[5:3], 3'b0};
end

always @(
  reg2dp_pad_right
  ) begin
    last_rp_w = ~(|reg2dp_pad_right[2:0]) ? 4'h8 : {1'b0, reg2dp_pad_right[2:0]};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_data_expand_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_data_expand_d1 <= is_data_expand;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_data_expand_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    is_data_normal_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_data_normal_d1 <= is_data_normal;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_data_normal_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    is_data_shrink_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_data_shrink_d1 <= is_data_shrink;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_data_shrink_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    is_x_stride_one <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_x_stride_one <= is_x_stride_one_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_x_stride_one <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    surf_cnt_total <= {9{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    surf_cnt_total <= surf_cnt_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    surf_cnt_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    data_width_ext <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_width_ext <= data_width_ext_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_width_ext <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    data_surf <= {10{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_surf <= data_surf_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_surf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    conv_x_stride <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    conv_x_stride <= conv_x_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    conv_x_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    conv_y_stride <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    conv_y_stride <= conv_y_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    conv_y_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    conv_xy_stride <= {11{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    conv_xy_stride <= conv_xy_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    conv_xy_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_set_total <= {2{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    width_set_total <= width_set_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    width_set_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    no_lp <= 1'b1;
  end else begin
  if ((layer_st) == 1'b1) begin
    no_lp <= no_lp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    no_lp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    lp_end <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    lp_end <= lp_end_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    lp_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    last_lp <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    last_lp <= last_lp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    last_lp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rp_end <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    rp_end <= rp_end_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    rp_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    last_rp <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    last_rp <= last_rp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    last_rp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    width_ext_total <= {11{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    width_ext_total <= reg2dp_datain_width_ext[12:2];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    width_ext_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    height_ext_total <= {11{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    height_ext_total <= reg2dp_datain_height_ext[12:2];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    height_ext_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    w_ext_surf <= {11{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    w_ext_surf <= w_ext_surf_w;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    w_ext_surf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    h_ext_surf <= {11{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    h_ext_surf <= h_ext_surf_w;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    h_ext_surf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error Config! None feature input when wg!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (layer_st & is_wg & ~is_feature)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! data_entries_w is overflow!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_data_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! width is not divisible by conv_x_stride")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (layer_st & ((reg2dp_pad_left + reg2dp_datain_width + reg2dp_pad_right + 1) % conv_x_stride_w != 0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! height is not divisible by conv_y_stride")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (layer_st & ((reg2dp_pad_top + reg2dp_datain_height + reg2dp_pad_bottom + 1) % conv_y_stride_w != 0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! channel is not divisible by 16/32")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (layer_st & ((is_int8 & (reg2dp_datain_channel[4:0] != 5'h1f)) | (~is_int8 & (reg2dp_datain_channel[3:0] != 4'hf))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! width_ext is not divisible by 4")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (reg2dp_datain_width_ext[1:0] != 2'b11))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! height_ext is not divisible by 4")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (reg2dp_datain_height_ext[1:0] != 2'b11))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! width and width_ext not match")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (((reg2dp_pad_left + reg2dp_datain_width + reg2dp_pad_right + 1) / conv_x_stride_w) != (reg2dp_datain_width_ext + 1)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! height and height_ext not match")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (((reg2dp_pad_top + reg2dp_datain_height + reg2dp_pad_bottom + 1) / conv_y_stride_w) != (reg2dp_datain_height_ext + 1)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! reg2dp_entries is out of range in winograd mode!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (layer_st & is_wg & (|reg2dp_entries[11:10]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_one_hot #(0,3,0,"Error! conflict data type mode")      zzz_assert_one_hot_42x (nvdla_core_clk, `ASSERT_RESET, ({is_data_normal, is_data_expand, is_data_shrink})); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! data_width_ext_w is out of range when expand!")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|data_width_ext_w[13  -2: 12 -3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! data_width_ext_w is out of range when normal!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|data_width_ext_w[13  -2: 12 -2]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! data_width_ext_w is out of range when shrink!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|data_width_ext_w[13  -2: 12 -1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! w_ext_surf_w is overflow!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (|mon_w_ext_surf_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! h_ext_surf_w is overflow!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (|mon_h_ext_surf_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! w_ext_surf_w is out of range when expand!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (|w_ext_surf_w[12 -2: 12 -3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! w_ext_surf_w is out of range when normal!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & w_ext_surf_w[12 -2])); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! h_ext_surf_w is out of range when expand!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (|h_ext_surf_w[12 -2: 12 -3]))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! h_ext_surf_w is out of range when normal!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & h_ext_surf_w[12 -2])); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  entries on-the-fly                                                //
////////////////////////////////////////////////////////////////////////

//how many entries onfly
//current onfly entries + valid entries can be write in Cbuf - entries per slice
always @(
  is_req_done
  or is_cbuf_ready
  or is_cbuf_ready_w
  or data_entries
  ) begin
    wg_entry_onfly_add = (~is_req_done & ~is_cbuf_ready & is_cbuf_ready_w) ? data_entries : 12'b0;
end

always @(
  wg2status_dat_updt
  or wg2status_dat_entries
  ) begin
    wg_entry_onfly_sub = wg2status_dat_updt ? wg2status_dat_entries : 12'b0;
end

always @(
  wg_entry_onfly
  or wg_entry_onfly_add
  or wg_entry_onfly_sub
  ) begin
    {mon_wg_entry_onfly_w,
     wg_entry_onfly_w} = wg_entry_onfly + wg_entry_onfly_add - wg_entry_onfly_sub;
end

always @(
  wg2status_dat_updt
  or is_req_done
  or is_cbuf_ready
  or is_cbuf_ready_w
  ) begin
    wg_entry_onfly_en = wg2status_dat_updt | (~is_req_done & ~is_cbuf_ready & is_cbuf_ready_w);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_entry_onfly <= {12{1'b0}};
  end else begin
  if ((wg_entry_onfly_en) == 1'b1) begin
    wg_entry_onfly <= wg_entry_onfly_w;
  // VCS coverage off
  end else if ((wg_entry_onfly_en) == 1'b0) begin
  end else begin
    wg_entry_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wg_entry_onfly_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! wg_entry_onfly_w is overflow!")      zzz_assert_never_53x (nvdla_core_clk, `ASSERT_RESET, (wg_entry_onfly_en & mon_wg_entry_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! wg_entry_onfly is not zero when idle!")      zzz_assert_never_54x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|wg_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//////////////// extended height count ////////////////

always @(
  req_h_ext_cnt
  ) begin
    {mon_req_h_ext_cnt_inc,
     req_h_ext_cnt_inc} = req_h_ext_cnt + 1'b1;
end

always @(
  layer_st
  or req_h_ext_cnt_inc
  ) begin
    req_h_ext_cnt_w = layer_st ? 11'b0 :
                      req_h_ext_cnt_inc;
end

always @(
  req_h_ext_cnt
  or height_ext_total
  ) begin
    is_req_last_h_ext = (req_h_ext_cnt == height_ext_total);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_h_ext_cnt <= {11{1'b0}};
  end else begin
  if ((req_h_ext_en) == 1'b1) begin
    req_h_ext_cnt <= req_h_ext_cnt_w;
  // VCS coverage off
  end else if ((req_h_ext_en) == 1'b0) begin
  end else begin
    req_h_ext_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_h_ext_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// surface count ////////////////

always @(
  req_surf_cnt
  ) begin
    {mon_req_surf_cnt_inc,
     req_surf_cnt_inc} = req_surf_cnt + 1'b1;
end

always @(
  layer_st
  or is_req_last_surf
  or req_surf_cnt_inc
  ) begin
    req_surf_cnt_w = (layer_st | is_req_last_surf) ? 9'b0 :
                     req_surf_cnt_inc;
end

always @(
  req_surf_cnt
  or surf_cnt_total
  ) begin
    is_req_last_surf = (req_surf_cnt == surf_cnt_total);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_surf_cnt <= {9{1'b0}};
  end else begin
  if ((req_surf_en) == 1'b1) begin
    req_surf_cnt <= req_surf_cnt_w;
  // VCS coverage off
  end else if ((req_surf_en) == 1'b0) begin
  end else begin
    req_surf_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_surf_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// conv y stride count ////////////////

always @(
  req_y_std_cnt
  ) begin
    {mon_req_y_std_cnt_inc,
     req_y_std_cnt_inc} = req_y_std_cnt + 1'b1;
end

always @(
  layer_st
  or is_req_last_y_std
  or req_y_std_cnt_inc
  ) begin
    req_y_std_cnt_w = (layer_st | is_req_last_y_std) ? 3'b0 :
                      req_y_std_cnt_inc;
end

always @(
  req_y_std_cnt
  or reg2dp_conv_y_stride
  ) begin
    is_req_last_y_std = (req_y_std_cnt == reg2dp_conv_y_stride);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_y_std_cnt <= {3{1'b0}};
  end else begin
  if ((req_y_std_en) == 1'b1) begin
    req_y_std_cnt <= req_y_std_cnt_w;
  // VCS coverage off
  end else if ((req_y_std_en) == 1'b0) begin
  end else begin
    req_y_std_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_y_std_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// width set count ////////////////

always @(
  req_w_set_cnt
  ) begin
    {mon_req_w_set_cnt_inc,
     req_w_set_cnt_inc} = req_w_set_cnt + 1'b1;
end

always @(
  layer_st
  or is_req_last_w_set
  or req_w_set_cnt_inc
  ) begin
    req_w_set_cnt_w = (layer_st | is_req_last_w_set) ? 2'b0 :
                      req_w_set_cnt_inc;
end

always @(
  req_w_set_cnt
  or width_set_total
  ) begin
    is_req_last_w_set = (req_w_set_cnt == width_set_total);
end

always @(
  req_w_set_cnt
  or no_lp
  ) begin
    is_w_set_rp = (req_w_set_cnt == 2'h2) | (no_lp & (req_w_set_cnt == 2'h1));
    is_w_set_lp = ~no_lp & (req_w_set_cnt == 2'h0);
    is_w_set_di = no_lp ? (req_w_set_cnt == 2'h0) : (req_w_set_cnt == 2'h1);
end

assign width_dummy = ~is_w_set_di;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_w_set_cnt <= {2{1'b0}};
  end else begin
  if ((req_w_set_en) == 1'b1) begin
    req_w_set_cnt <= req_w_set_cnt_w;
  // VCS coverage off
  end else if ((req_w_set_en) == 1'b0) begin
  end else begin
    req_w_set_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_w_set_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_one_hot #(0,3,0,"Error! width section select error!")      zzz_assert_one_hot_59x (nvdla_core_clk, `ASSERT_RESET, ({is_w_set_lp, is_w_set_di, is_w_set_rp})); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// sub width count ////////////////

always @(
  req_sub_w_cnt
  ) begin
    {mon_req_sub_w_cnt_inc,
     req_sub_w_cnt_inc} = req_sub_w_cnt + 4'h8;
end

always @(
  layer_st
  or is_req_last_sub_w
  or req_sub_w_cnt_inc
  ) begin
    req_sub_w_cnt_w = (layer_st | is_req_last_sub_w) ? 13'b0 :
                      req_sub_w_cnt_inc;
end

always @(
  is_req_last_lp
  or last_lp
  or is_req_last_rp
  or last_rp
  or is_req_last_di
  or reg2dp_datain_width
  ) begin
    req_sub_w_cur = is_req_last_lp ? last_lp :
                    is_req_last_rp ? last_rp :
                    is_req_last_di ? (reg2dp_datain_width[2:0] + 1'b1) :
                    4'h8;
end

always @(
  is_w_set_lp
  or req_sub_w_cnt
  or lp_end
  or is_w_set_rp
  or rp_end
  or is_w_set_di
  or reg2dp_datain_width
  ) begin
    is_req_last_lp = (is_w_set_lp & (~(|req_sub_w_cnt[12:5]) & (req_sub_w_cnt[4:0] == lp_end)));
    is_req_last_rp = (is_w_set_rp & (~(|req_sub_w_cnt[12:6]) & (req_sub_w_cnt[5:0] == rp_end)));
    is_req_last_di = (is_w_set_di & (req_sub_w_cnt == {reg2dp_datain_width[12:3], 3'b0}));
end

always @(
  is_req_last_lp
  or is_req_last_di
  or is_req_last_rp
  ) begin
    is_req_last_sub_w = is_req_last_lp | is_req_last_di | is_req_last_rp;
end

always @(
  is_req_last_sub_w
  or is_req_last_w_set
  ) begin
    is_req_last_width = is_req_last_sub_w & is_req_last_w_set;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_sub_w_cnt <= {13{1'b0}};
  end else begin
  if ((req_sub_w_en) == 1'b1) begin
    req_sub_w_cnt <= req_sub_w_cnt_w;
  // VCS coverage off
  end else if ((req_sub_w_en) == 1'b0) begin
  end else begin
    req_sub_w_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_sub_w_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// sub h count ////////////////

always @(
  layer_st
  or is_req_last_sub_h
  or req_sub_h_cnt
  ) begin
    {mon_req_sub_h_cnt_w,
     req_sub_h_cnt_w} = (layer_st | is_req_last_sub_h) ? 3'b0 : 
                        (req_sub_h_cnt + 1'b1);
end

always @(
  req_sub_h_cnt
  ) begin
    is_req_last_sub_h = (req_sub_h_cnt == 2'h3);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_sub_h_cnt <= {2{1'b0}};
  end else begin
  if ((req_sub_h_en) == 1'b1) begin
    req_sub_h_cnt <= req_sub_h_cnt_w;
  // VCS coverage off
  end else if ((req_sub_h_en) == 1'b0) begin
  end else begin
    req_sub_h_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_sub_h_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// loop control logic ////////////////

always @(
  layer_st
  or is_last_req
  or is_req_done
  ) begin
    is_req_done_w = layer_st ? 1'b0 :
                    is_last_req ? 1'b1 :
                    is_req_done;
end

always @(
  is_running
  or is_req_done
  or is_cbuf_ready
  ) begin
    req_valid = is_running & ~is_req_done & is_cbuf_ready;
end

always @(
  is_req_last_h_ext
  or is_cbuf_ready
  or data_entries
  ) begin
    data_entries_add = (is_req_last_h_ext & is_cbuf_ready) ? 12'b0 : data_entries;
end

always @(
  data_entries_add
  or wg_entry_onfly
  ) begin
    {mon_req_cubf_needed,
     req_cbuf_needed} = data_entries_add + wg_entry_onfly;
end

always @(
  is_running
  or req_h_ext_en
  or is_cbuf_ready
  or req_cbuf_needed
  or status2dma_free_entries
  ) begin
    is_cbuf_ready_w = (~is_running | req_h_ext_en) ? 1'b0 :
                      (~is_cbuf_ready) ? (req_cbuf_needed <= status2dma_free_entries) :
                      is_cbuf_ready;
end

always @(
  req_valid_d1
  or req_ready_d1
  ) begin
    req_ready = ~req_valid_d1 | req_ready_d1;
end

always @(
  req_valid
  or req_ready
  ) begin
    req_adv = req_valid & req_ready;
end

always @(
  layer_st
  or req_adv
  ) begin
    req_sub_h_en = layer_st | req_adv;
end

always @(
  layer_st
  or req_adv
  or is_req_last_sub_h
  ) begin
    req_sub_w_en = layer_st | (req_adv & is_req_last_sub_h);
end

always @(
  layer_st
  or req_adv
  or is_req_last_sub_h
  or is_req_last_sub_w
  ) begin
    req_w_set_en = layer_st | (req_adv & is_req_last_sub_h & is_req_last_sub_w);
end

always @(
  layer_st
  or req_adv
  or is_req_last_sub_h
  or is_req_last_sub_w
  or is_req_last_w_set
  ) begin
    req_y_std_en = layer_st | (req_adv & is_req_last_sub_h & is_req_last_sub_w & is_req_last_w_set);
end

always @(
  layer_st
  or req_adv
  or is_req_last_sub_h
  or is_req_last_sub_w
  or is_req_last_w_set
  or is_req_last_y_std
  ) begin
    req_surf_en = layer_st | (req_adv & is_req_last_sub_h & is_req_last_sub_w & is_req_last_w_set & is_req_last_y_std);
end

always @(
  layer_st
  or req_adv
  or is_req_last_sub_h
  or is_req_last_sub_w
  or is_req_last_w_set
  or is_req_last_y_std
  or is_req_last_surf
  ) begin
    req_h_ext_en = layer_st | (req_adv & is_req_last_sub_h & is_req_last_sub_w & is_req_last_w_set & is_req_last_y_std & is_req_last_surf);
end

always @(
  is_req_last_sub_h
  or is_req_last_sub_w
  or is_req_last_w_set
  or is_req_last_y_std
  or is_req_last_surf
  or is_req_last_h_ext
  ) begin
    is_last_req = (is_req_last_sub_h & is_req_last_sub_w & is_req_last_w_set & is_req_last_y_std & is_req_last_surf & is_req_last_h_ext);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_req_done <= 1'b1;
  end else begin
  if ((req_h_ext_en) == 1'b1) begin
    is_req_done <= is_req_done_w;
  // VCS coverage off
  end else if ((req_h_ext_en) == 1'b0) begin
  end else begin
    is_req_done <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_h_ext_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    is_cbuf_ready <= 1'b0;
  end else begin
  is_cbuf_ready <= is_cbuf_ready_w;
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! req_cbuf_needed is overflow!")      zzz_assert_never_63x (nvdla_core_clk, `ASSERT_RESET, (mon_req_cubf_needed)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// height coordinate count ////////////////

always @(
  layer_st
  or data_height_st_w
  or is_req_last_sub_h
  or h_coord
  or conv_y_stride
  or is_req_last_width
  or h_coord_sub_h
  or is_req_last_y_std
  or is_req_last_surf
  or h_coord_surf
  ) begin
    {mon_h_coord_w,
     h_coord_w} = (layer_st) ? {1'b0, data_height_st_w} :
                  (~is_req_last_sub_h) ? (h_coord + conv_y_stride) :
                  (~is_req_last_width & is_req_last_sub_h) ? {1'b0, h_coord_sub_h} :
                  (~is_req_last_y_std & is_req_last_width & is_req_last_sub_h) ? (h_coord_sub_h + 1'h1) :
                  (~is_req_last_surf & is_req_last_y_std & is_req_last_width & is_req_last_sub_h) ? {1'b0, h_coord_surf} :
                  (h_coord_surf + {conv_y_stride, 2'b0});
end

always @(
  h_coord
  or data_height
  ) begin
    height_dummy = (h_coord[13  +1]) | (h_coord[13:0] >= data_height);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_coord <= {15{1'b0}};
  end else begin
  if ((req_sub_h_en) == 1'b1) begin
    h_coord <= h_coord_w;
  // VCS coverage off
  end else if ((req_sub_h_en) == 1'b0) begin
  end else begin
    h_coord <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_sub_h_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    h_coord_sub_h <= {15{1'b0}};
  end else begin
  if ((req_y_std_en) == 1'b1) begin
    h_coord_sub_h <= h_coord_w;
  // VCS coverage off
  end else if ((req_y_std_en) == 1'b0) begin
  end else begin
    h_coord_sub_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_y_std_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    h_coord_surf <= {15{1'b0}};
  end else begin
  if ((req_surf_en) == 1'b1) begin
    h_coord_surf <= h_coord_w;
  // VCS coverage off
  end else if ((req_surf_en) == 1'b0) begin
  end else begin
    h_coord_surf <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_surf_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// package signals ////////////////

assign x_offset = req_sub_w_cnt[12:0];

always @(
  h_coord
  or reg2dp_line_stride
  ) begin
    {mon_y_offset,
     y_offset} = h_coord[12:0] * reg2dp_line_stride;
end

always @(
  req_surf_cnt
  or reg2dp_surf_stride
  ) begin
    {mon_c_offset,
     c_offset} = req_surf_cnt * reg2dp_surf_stride;
end

assign req_size = req_sub_w_cur;

always @(
  req_sub_w_cur
  ) begin
    {mon_req_size_out,
     req_size_out}  = req_sub_w_cur - 1'b1;
end

always @(
  req_valid_d2
  or req_ready_d2
  ) begin
    req_ready_d1 = ~req_valid_d2 | req_ready_d2;
end

always @(
  is_running
  or req_valid
  or req_ready_d1
  or req_valid_d1
  ) begin
    req_valid_d1_w = ~is_running ? 1'b0 :
                     req_valid ? 1'b1 :
                     req_ready_d1 ? 1'b0 :
                     req_valid_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_valid_d1 <= 1'b0;
  end else begin
  req_valid_d1 <= req_valid_d1_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((req_adv) == 1'b1) begin
    x_offset_d1 <= x_offset;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
  end else begin
    x_offset_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((req_adv) == 1'b1) begin
    y_offset_d1 <= y_offset;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
  end else begin
    y_offset_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((req_adv) == 1'b1) begin
    c_offset_d1 <= c_offset;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
  end else begin
    c_offset_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_size_d1 <= {4{1'b0}};
  end else begin
  if ((req_adv) == 1'b1) begin
    req_size_d1 <= req_size;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((req_adv) == 1'b1) begin
    req_size_out_d1 <= req_size_out;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_dummy_d1 <= 1'b0;
  end else begin
  if ((req_adv) == 1'b1) begin
    req_dummy_d1 <= width_dummy | height_dummy;
  // VCS coverage off
  end else if ((req_adv) == 1'b0) begin
  end else begin
    req_dummy_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// package signals d2 ////////////////

assign req_addr_base = {reg2dp_datain_addr_high_0, reg2dp_datain_addr_low_0};

always @(
  req_addr_base
  or x_offset_d1
  or y_offset_d1
  or c_offset_d1
  ) begin
    {mon_req_addr_w,
     req_addr_w} = req_addr_base + x_offset_d1 + y_offset_d1 + c_offset_d1;
end

always @(
  is_running
  or req_valid_d1
  or req_ready_d2
  or req_valid_d2
  ) begin
    req_valid_d2_w = ~is_running ? 1'b0 :
                     req_valid_d1 ? 1'b1 :
                     req_ready_d2 ? 1'b0 :
                     req_valid_d2;
end

always @(
  dma_req_fifo_ready
  or dma_rd_req_rdy
  or req_valid_d2
  or req_dummy_d2
  ) begin
    req_ready_d2 = dma_req_fifo_ready & (dma_rd_req_rdy | (req_valid_d2 & req_dummy_d2));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_valid_d2 <= 1'b0;
  end else begin
  req_valid_d2 <= req_valid_d2_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((req_valid_d1 & req_ready_d1 & ~req_dummy_d1) == 1'b1) begin
    req_addr_d2 <= req_addr_w;
  // VCS coverage off
  end else if ((req_valid_d1 & req_ready_d1 & ~req_dummy_d1) == 1'b0) begin
  end else begin
    req_addr_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_size_d2 <= {4{1'b0}};
  end else begin
  if ((req_valid_d1 & req_ready_d1) == 1'b1) begin
    req_size_d2 <= req_size_d1;
  // VCS coverage off
  end else if ((req_valid_d1 & req_ready_d1) == 1'b0) begin
  end else begin
    req_size_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_valid_d1 & req_ready_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_size_out_d2 <= {3{1'b0}};
  end else begin
  if ((req_valid_d1 & req_ready_d1) == 1'b1) begin
    req_size_out_d2 <= req_size_out_d1;
  // VCS coverage off
  end else if ((req_valid_d1 & req_ready_d1) == 1'b0) begin
  end else begin
    req_size_out_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_valid_d1 & req_ready_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    req_dummy_d2 <= 1'b0;
  end else begin
  if ((req_valid_d1 & req_ready_d1) == 1'b1) begin
    req_dummy_d2 <= req_dummy_d1;
  // VCS coverage off
  end else if ((req_valid_d1 & req_ready_d1) == 1'b0) begin
  end else begin
    req_dummy_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_valid_d1 & req_ready_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

`ifdef NVDLA_PRINT_CDMA
always @ (posedge nvdla_core_clk)
begin
    if(req_valid_d2 & req_ready_d2)
    begin
        $display("[CDMA WG REQ] Dummy = %d, Addr = 0x%010h, size = %0d, time = %0d", req_dummy_d2, req_addr_d2, req_size_d2, $stime);
    end
end
`endif

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
NV_NVDLA_CDMA_WG_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])     //|< w
  ,.mc_dma_rd_req_vld   (mc_dma_rd_req_vld)       //|< w
  ,.mc_int_rd_req_ready (mc_int_rd_req_ready)     //|< w
  ,.mc_dma_rd_req_rdy   (mc_dma_rd_req_rdy)       //|> w
  ,.mc_int_rd_req_pd    (mc_int_rd_req_pd[78:0])  //|> w
  ,.mc_int_rd_req_valid (mc_int_rd_req_valid)     //|> w
  );
NV_NVDLA_CDMA_WG_pipe_p2 pipe_p2 (
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
assign wg_dat2mcif_rd_req_valid = mc_int_rd_req_valid_d0;
assign mc_int_rd_req_ready_d0 = wg_dat2mcif_rd_req_ready;
assign wg_dat2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d0[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
assign wg_dat2cvif_rd_req_valid = cv_int_rd_req_valid_d0;
assign cv_int_rd_req_ready_d0 = wg_dat2cvif_rd_req_ready;
assign wg_dat2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d0[78:0];

// rd Channel: Response

assign mcif2wg_dat_rd_rsp_valid_d0 = mcif2wg_dat_rd_rsp_valid;
assign mcif2wg_dat_rd_rsp_ready = mcif2wg_dat_rd_rsp_ready_d0;
assign mcif2wg_dat_rd_rsp_pd_d0[513:0] = mcif2wg_dat_rd_rsp_pd[513:0];
assign mc_int_rd_rsp_valid = mcif2wg_dat_rd_rsp_valid_d0;
assign mcif2wg_dat_rd_rsp_ready_d0 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2wg_dat_rd_rsp_pd_d0[513:0];


assign cvif2wg_dat_rd_rsp_valid_d0 = cvif2wg_dat_rd_rsp_valid;
assign cvif2wg_dat_rd_rsp_ready = cvif2wg_dat_rd_rsp_ready_d0;
assign cvif2wg_dat_rd_rsp_pd_d0[513:0] = cvif2wg_dat_rd_rsp_pd[513:0];
assign cv_int_rd_rsp_valid = cvif2wg_dat_rd_rsp_valid_d0;
assign cvif2wg_dat_rd_rsp_ready_d0 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2wg_dat_rd_rsp_pd_d0[513:0];

NV_NVDLA_CDMA_WG_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.mc_int_rd_rsp_pd    (mc_int_rd_rsp_pd[513:0]) //|< w
  ,.mc_int_rd_rsp_valid (mc_int_rd_rsp_valid)     //|< w
  ,.mc_dma_rd_rsp_pd    (mc_dma_rd_rsp_pd[513:0]) //|> w
  ,.mc_dma_rd_rsp_vld   (mc_dma_rd_rsp_vld)       //|> w
  ,.mc_int_rd_rsp_ready (mc_int_rd_rsp_ready)     //|> w
  );
NV_NVDLA_CDMA_WG_pipe_p4 pipe_p4 (
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
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//assign dma_rd_req_vld = dma_req_fifo_ready & req_valid_d1 & cbuf_entry_ready;
assign dma_rd_req_vld = dma_req_fifo_ready & req_valid_d2 & ~req_dummy_d2;
assign dma_rd_req_addr = {req_addr_d2[58:0], 5'b0};
assign dma_rd_req_size = {{13{1'b0}}, req_size_out_d2};
assign dma_rd_req_type = reg2dp_datain_ram_type;
assign dma_rd_rsp_rdy = ~dma_rd_rsp_blocking;

NV_NVDLA_CDMA_WG_fifo u_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (dma_req_fifo_ready)      //|> w
  ,.wr_req              (dma_req_fifo_req)        //|< r
  ,.wr_data             (dma_req_fifo_data[4:0])  //|< r
  ,.rd_ready            (dma_rsp_fifo_ready)      //|< r
  ,.rd_req              (dma_rsp_fifo_req)        //|> w
  ,.rd_data             (dma_rsp_fifo_data[4:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

always @(
  req_valid_d2
  or dma_rd_req_rdy
  or req_dummy_d2
  ) begin
    dma_req_fifo_req = req_valid_d2 & (dma_rd_req_rdy | req_dummy_d2);
end

always @(
  req_dummy_d2
  or req_size_d2
  ) begin
    dma_req_fifo_data = {req_dummy_d2, req_size_d2};
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Receive input data when not busy")      zzz_assert_never_74x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA WG read response connection                                  //
////////////////////////////////////////////////////////////////////////



// PKT_UNPACK_WIRE( dma_read_data , dma_rd_rsp_ , dma_rd_rsp_pd )
assign       dma_rd_rsp_data[511:0] =    dma_rd_rsp_pd[511:0];
assign       dma_rd_rsp_mask[1:0] =    dma_rd_rsp_pd[513:512];

always @(
  dma_rsp_fifo_data
  ) begin
    {dma_rsp_dummy, dma_rsp_size} = dma_rsp_fifo_data;
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_dummy
  or sbuf_blocking
  ) begin
    dma_rd_rsp_blocking = (dma_rsp_fifo_req & dma_rsp_dummy) | sbuf_blocking;
end

always @(
  dma_rsp_fifo_req
  or sbuf_blocking
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  or dma_rd_rsp_mask
  ) begin
    dma_rsp_mask[0] = (~dma_rsp_fifo_req | sbuf_blocking) ? 1'b0 :
                      ~dma_rsp_dummy ? (dma_rd_rsp_vld & dma_rd_rsp_mask[0]) :
                      1'b1;
end

always @(
  dma_rsp_fifo_req
  or sbuf_blocking
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  or dma_rd_rsp_mask
  or dma_rsp_size
  or dma_rsp_size_cnt
  ) begin
    dma_rsp_mask[1] = (~dma_rsp_fifo_req | sbuf_blocking) ? 1'b0 :
                      ~dma_rsp_dummy ? (dma_rd_rsp_vld & dma_rd_rsp_mask[1]) :
                      (dma_rsp_size[3:1] == dma_rsp_size_cnt[3:1]) ? 1'b0 :
                      1'b1;
end

always @(
  dma_rsp_size_cnt
  or dma_rsp_mask
  ) begin
    {mon_dma_rsp_size_cnt_inc,
     dma_rsp_size_cnt_inc} = dma_rsp_size_cnt + dma_rsp_mask[0] + dma_rsp_mask[1];
end

always @(
  dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_size_cnt_w = (dma_rsp_size_cnt_inc == dma_rsp_size) ? 4'b0 :
                         dma_rsp_size_cnt_inc;
end

always @(
  dma_rsp_fifo_req
  or sbuf_blocking
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  ) begin
    dma_rsp_vld = dma_rsp_fifo_req & ~sbuf_blocking & (dma_rsp_dummy | dma_rd_rsp_vld);
end

always @(
  dma_rsp_vld
  or dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_fifo_ready = (dma_rsp_vld  & (dma_rsp_size_cnt_inc == dma_rsp_size));
end

always @(
  is_int8
  or reg2dp_pad_value
  ) begin
    dma_pad_data = is_int8 ? {64{reg2dp_pad_value[7:0]}} : {32{reg2dp_pad_value}};
end

always @(
  dma_rsp_dummy
  or dma_pad_data
  or dma_rd_rsp_data
  ) begin
    dma_rsp_data = dma_rsp_dummy ? dma_pad_data[511:0] : dma_rd_rsp_data[511:0];
end

assign {dma_rsp_data_p1, dma_rsp_data_p0} = dma_rsp_data;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_rsp_size_cnt <= {4{1'b0}};
  end else begin
  if ((dma_rsp_vld) == 1'b1) begin
    dma_rsp_size_cnt <= dma_rsp_size_cnt_w;
  // VCS coverage off
  end else if ((dma_rsp_vld) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rsp_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_76x (nvdla_core_clk, `ASSERT_RESET, (~dma_rsp_fifo_req & dma_rd_rsp_vld)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_77x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > dma_rsp_size)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_78x (nvdla_core_clk, `ASSERT_RESET, (mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_79x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > 8'h8)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  WG write data to shared buffer                                    //
////////////////////////////////////////////////////////////////////////
//////////////// line selection ////////////////

always @(
  layer_st
  or sbuf_wr_line
  ) begin
    {mon_sbuf_wr_line_w,
     sbuf_wr_line_w} = (layer_st) ? 3'b0 :
                       sbuf_wr_line + 1'b1;
end

always @(
  sbuf_wr_line
  ) begin
    is_sbuf_wr_last_line = (sbuf_wr_line == 2'h3);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_wr_line <= {2{1'b0}};
  end else begin
  if ((layer_st | dma_rsp_fifo_ready) == 1'b1) begin
    sbuf_wr_line <= sbuf_wr_line_w;
  // VCS coverage off
  end else if ((layer_st | dma_rsp_fifo_ready) == 1'b0) begin
  end else begin
    sbuf_wr_line <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | dma_rsp_fifo_ready))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// write port 0 ////////////////

always @(
  dma_rsp_mask
  ) begin
    sbuf_wr_add = dma_rsp_mask[1] ? 2'h2 : 2'h1;
end

always @(
  layer_st
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p0_base_ori
  or sbuf_wr_p0_ch
  or sbuf_wr_p0_of
  or sbuf_wr_p0_base
  or conv_x_stride
  or is_x_stride_one
  or dma_rsp_mask
  or sbuf_wr_p1_base
  ) begin
    {mon_sbuf_wr_p0_base_w,
     sbuf_wr_p0_base_w} = (layer_st) ? 5'b0 :
                          (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? {1'b0, sbuf_wr_p0_base_ori} :
                          ((sbuf_wr_p0_ch[1:0] == 2'h3) & sbuf_wr_p0_of) ? sbuf_wr_p0_base + conv_x_stride :
                          ((sbuf_wr_p0_ch[1:0] == 2'h2) & is_x_stride_one & dma_rsp_mask[1]) ? sbuf_wr_p1_base + conv_x_stride :
                          sbuf_wr_p0_base;
end

always @(
  layer_st
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p1_base_ori
  or sbuf_wr_p1_ch
  or sbuf_wr_p1_of
  or sbuf_wr_p1_base
  or conv_x_stride
  or is_x_stride_one
  or dma_rsp_mask
  ) begin
    {mon_sbuf_wr_p1_base_w,
     sbuf_wr_p1_base_w} = (layer_st) ? 5'b0 :
                          (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? {1'b0, sbuf_wr_p1_base_ori} :
                          ((sbuf_wr_p1_ch[1:0] == 2'h3) & sbuf_wr_p1_of) ? sbuf_wr_p1_base + conv_x_stride :
                          ((sbuf_wr_p1_ch[1:0] == 2'h2) & is_x_stride_one & dma_rsp_mask[1]) ? sbuf_wr_p1_base + conv_x_stride :
                          sbuf_wr_p1_base;
end

always @(
  sbuf_wr_p0_offset
  or sbuf_wr_add
  or sbuf_wr_p1_offset
  ) begin
    sbuf_wr_p0_offset_inc = sbuf_wr_p0_offset + sbuf_wr_add;
    sbuf_wr_p1_offset_inc = sbuf_wr_p1_offset + sbuf_wr_add;
end

always @(
  sbuf_wr_p0_offset_inc
  or conv_x_stride
  or is_x_stride_one
  ) begin
    sbuf_wr_p0_of_0 = (sbuf_wr_p0_offset_inc == conv_x_stride) | is_x_stride_one;
    sbuf_wr_p0_of_1 = (sbuf_wr_p0_offset_inc > conv_x_stride);
    sbuf_wr_p0_of = sbuf_wr_p0_of_0 | sbuf_wr_p0_of_1;
end

always @(
  sbuf_wr_p1_offset_inc
  or conv_x_stride
  or is_x_stride_one
  ) begin
    sbuf_wr_p1_of_0 = (sbuf_wr_p1_offset_inc == conv_x_stride) | is_x_stride_one;
    sbuf_wr_p1_of_1 = (sbuf_wr_p1_offset_inc > conv_x_stride);
    sbuf_wr_p1_of = sbuf_wr_p1_of_0 | sbuf_wr_p1_of_1;
end

always @(
  layer_st
  or is_x_stride_one
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p0_offset_ori
  or sbuf_wr_p0_of_1
  or sbuf_wr_p0_of_0
  or sbuf_wr_p0_offset_inc
  ) begin
    sbuf_wr_p0_offset_w = (layer_st | is_x_stride_one) ? 3'b0 :
                          (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? sbuf_wr_p0_offset_ori :
                          (sbuf_wr_p0_of_1) ? 3'b1 :
                          (sbuf_wr_p0_of_0) ? 3'b0 :
                          sbuf_wr_p0_offset_inc[2:0];
end

always @(
  is_x_stride_one_w
  or layer_st
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p1_offset_ori
  or sbuf_wr_p1_of_1
  or sbuf_wr_p1_of_0
  or sbuf_wr_p1_offset_inc
  ) begin
    sbuf_wr_p1_offset_w = (is_x_stride_one_w) ? 3'b0 :
                          (layer_st) ? 3'b1 :
                          (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? sbuf_wr_p1_offset_ori :
                          (sbuf_wr_p1_of_1) ? 3'b1 :
                          (sbuf_wr_p1_of_0) ? 3'b0 :
                          sbuf_wr_p1_offset_inc[2:0];
end

always @(
  is_x_stride_one
  or sbuf_wr_p0_ch
  or sbuf_wr_add
  ) begin
    {mon_sbuf_wr_p0_ch_inc,
     sbuf_wr_p0_ch_inc} = (is_x_stride_one) ? (sbuf_wr_p0_ch + sbuf_wr_add) : 
                          (sbuf_wr_p0_ch + 1'b1);
end

always @(
  is_x_stride_one
  or sbuf_wr_p1_ch
  or sbuf_wr_add
  ) begin
    {mon_sbuf_wr_p1_ch_inc,
     sbuf_wr_p1_ch_inc} = (is_x_stride_one) ? (sbuf_wr_p1_ch + sbuf_wr_add) : 
                          (sbuf_wr_p1_ch + 1'b1);
end

always @(
  layer_st
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p0_ch_ori
  or sbuf_wr_p0_of
  or sbuf_wr_p0_ch_inc
  or sbuf_wr_p0_ch
  ) begin
    sbuf_wr_p0_ch_w = (layer_st) ? 4'b0 :
                      (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? sbuf_wr_p0_ch_ori :
                      (dma_rsp_fifo_ready & is_sbuf_wr_last_line & sbuf_wr_p0_of) ? {2'd0, sbuf_wr_p0_ch_inc[1:0]} :
                      (dma_rsp_fifo_ready & is_sbuf_wr_last_line & ~sbuf_wr_p0_of) ? {2'd0, sbuf_wr_p0_ch[1:0]} :
                      (sbuf_wr_p0_of) ? sbuf_wr_p0_ch_inc :
                      sbuf_wr_p0_ch;
end

always @(
  layer_st
  or is_x_stride_one_w
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p1_ch_ori
  or sbuf_wr_p1_of
  or sbuf_wr_p1_ch_inc
  or sbuf_wr_p1_ch
  ) begin
    sbuf_wr_p1_ch_w = (layer_st & is_x_stride_one_w) ? 2'b1 :
                      (layer_st & ~is_x_stride_one_w) ? 2'b0 :
                      (dma_rsp_fifo_ready & ~is_sbuf_wr_last_line) ? sbuf_wr_p1_ch_ori :
                      (sbuf_wr_p1_of) ? sbuf_wr_p1_ch_inc :
                      sbuf_wr_p1_ch;
end

always @(
  layer_st
  or dma_rsp_vld
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  ) begin
    sbuf_wr_addr_en = layer_st | dma_rsp_vld;
    sbuf_wr_addr_ori_en = layer_st | (dma_rsp_fifo_ready & is_sbuf_wr_last_line);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_wr_p0_base <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p0_base <= sbuf_wr_p0_base_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_base <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p1_base <= sbuf_wr_p1_base_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_offset <= {3{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p0_offset <= sbuf_wr_p0_offset_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_offset <= {3{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p1_offset <= sbuf_wr_p1_offset_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_ch <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p0_ch <= sbuf_wr_p0_ch_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_ch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_ch <= {2{1'b0}};
  end else begin
  if ((sbuf_wr_addr_en) == 1'b1) begin
    sbuf_wr_p1_ch <= sbuf_wr_p1_ch_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_ch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_base_ori <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p0_base_ori <= sbuf_wr_p0_base_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_base_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_base_ori <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p1_base_ori <= sbuf_wr_p1_base_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_base_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_offset_ori <= {3{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p0_offset_ori <= sbuf_wr_p0_offset_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_offset_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_offset_ori <= {3{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p1_offset_ori <= sbuf_wr_p1_offset_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_offset_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_ch_ori <= {4{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p0_ch_ori <= sbuf_wr_p0_ch_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_ch_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_ch_ori <= {2{1'b0}};
  end else begin
  if ((sbuf_wr_addr_ori_en) == 1'b1) begin
    sbuf_wr_p1_ch_ori <= sbuf_wr_p1_ch_w;
  // VCS coverage off
  end else if ((sbuf_wr_addr_ori_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_ch_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_addr_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! p0 overflow conflict!")      zzz_assert_never_93x (nvdla_core_clk, `ASSERT_RESET, (sbuf_wr_addr_en & ~is_x_stride_one & sbuf_wr_p0_of_0 & sbuf_wr_p1_of_0 & (~is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! p1 overflow conflict!")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (sbuf_wr_addr_en & ~is_x_stride_one & sbuf_wr_p0_of_1 & sbuf_wr_p1_of_1 & (~is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sbuf_wr_p0_ch_inc is overflow!")      zzz_assert_never_95x (nvdla_core_clk, `ASSERT_RESET, (sbuf_wr_addr_en & mon_sbuf_wr_p0_ch_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sbuf_wr_p0_ch_inc is out of range!")      zzz_assert_never_96x (nvdla_core_clk, `ASSERT_RESET, (sbuf_wr_addr_en & (sbuf_wr_p0_ch_inc[3:2] > 2'h2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// current write index ////////////////

always @(
  sbuf_wr_p0_base
  or sbuf_wr_p0_offset
  ) begin
    {mon_sbuf_wr_p0_idx_lo,
     sbuf_wr_p0_idx_lo} = sbuf_wr_p0_base + sbuf_wr_p0_offset;
end

always @(
  sbuf_wr_p1_base
  or sbuf_wr_p1_offset
  ) begin
    {mon_sbuf_wr_p1_idx_lo,
     sbuf_wr_p1_idx_lo} = sbuf_wr_p1_base + sbuf_wr_p1_offset;
end

always @(
  sbuf_wr_p0_idx_lo
  or sbuf_wr_line
  or sbuf_wr_p0_ch
  or sbuf_wr_p1_idx_lo
  or sbuf_wr_p1_ch
  ) begin
    sbuf_wr_p0_idx = {sbuf_wr_p0_idx_lo[0], sbuf_wr_line[0], sbuf_wr_p0_ch[1:0], sbuf_wr_line[1], sbuf_wr_p0_idx_lo[8 -5:1]};
    sbuf_wr_p1_idx = {sbuf_wr_p1_idx_lo[0], sbuf_wr_line[0], sbuf_wr_p1_ch[1:0], sbuf_wr_line[1], sbuf_wr_p1_idx_lo[8 -5:1]};
end

always @(
  dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  or sbuf_wr_p0_of
  or sbuf_wr_p0_ch_inc
  or sbuf_wr_p0_ch
  ) begin
    sbuf_x_stride_inc_size = (~dma_rsp_fifo_ready | ~is_sbuf_wr_last_line) ? 2'b0 :
                             (sbuf_wr_p0_of) ? sbuf_wr_p0_ch_inc[3:2] : sbuf_wr_p0_ch[3:2];
end

always @(
  sbuf_x_stride_inc_size
  or conv_x_stride
  ) begin
    sbuf_cube_inc_size = sbuf_x_stride_inc_size[1] ? {conv_x_stride[2:0], 1'b0} :
                         sbuf_x_stride_inc_size[0] ? conv_x_stride :
                         4'b0;
end

always @(
  dma_rsp_vld
  or dma_rsp_mask
  or dma_rsp_fifo_ready
  or is_sbuf_wr_last_line
  ) begin
    sbuf_wr_p0_en = dma_rsp_vld & dma_rsp_mask[0];
    sbuf_wr_p1_en = dma_rsp_vld & dma_rsp_mask[1];
    sbuf_cube_inc_en = dma_rsp_fifo_ready & is_sbuf_wr_last_line;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_wr_p0_en_d1 <= 1'b0;
  end else begin
  sbuf_wr_p0_en_d1 <= sbuf_wr_p0_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_wr_p1_en_d1 <= 1'b0;
  end else begin
  sbuf_wr_p1_en_d1 <= sbuf_wr_p1_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_wr_p0_idx_d1 <= {8{1'b0}};
  end else begin
  if ((sbuf_wr_p0_en) == 1'b1) begin
    sbuf_wr_p0_idx_d1 <= sbuf_wr_p0_idx;
  // VCS coverage off
  end else if ((sbuf_wr_p0_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_p0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_idx_d1 <= {8{1'b0}};
  end else begin
  if ((sbuf_wr_p1_en) == 1'b1) begin
    sbuf_wr_p1_idx_d1 <= sbuf_wr_p1_idx;
  // VCS coverage off
  end else if ((sbuf_wr_p1_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_p1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p0_data_d1 <= {256{1'b0}};
  end else begin
  if ((sbuf_wr_p0_en) == 1'b1) begin
    sbuf_wr_p0_data_d1 <= dma_rsp_data_p0;
  // VCS coverage off
  end else if ((sbuf_wr_p0_en) == 1'b0) begin
  end else begin
    sbuf_wr_p0_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_p0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_wr_p1_data_d1 <= {256{1'b0}};
  end else begin
  if ((sbuf_wr_p1_en) == 1'b1) begin
    sbuf_wr_p1_data_d1 <= dma_rsp_data_p1;
  // VCS coverage off
  end else if ((sbuf_wr_p1_en) == 1'b0) begin
  end else begin
    sbuf_wr_p1_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_wr_p1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_cube_inc_en_d1 <= 1'b0;
  end else begin
  sbuf_cube_inc_en_d1 <= sbuf_cube_inc_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_cube_inc_size_d1 <= {4{1'b0}};
  end else begin
  if ((sbuf_cube_inc_en) == 1'b1) begin
    sbuf_cube_inc_size_d1 <= sbuf_cube_inc_size;
  // VCS coverage off
  end else if ((sbuf_cube_inc_en) == 1'b0) begin
  end else begin
    sbuf_cube_inc_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_cube_inc_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sbuf x_stride increase size out of range!")      zzz_assert_never_102x (nvdla_core_clk, `ASSERT_RESET, (sbuf_cube_inc_en & sbuf_x_stride_inc_size[1] & (|reg2dp_conv_x_stride))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sbuf cube increase size out of range!")      zzz_assert_never_103x (nvdla_core_clk, `ASSERT_RESET, (sbuf_cube_inc_en & (sbuf_cube_inc_size > 4'h8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
assign wg2sbuf_p0_wr_en = sbuf_wr_p0_en_d1;
assign wg2sbuf_p1_wr_en = sbuf_wr_p1_en_d1;

assign wg2sbuf_p0_wr_addr = sbuf_wr_p0_idx_d1;
assign wg2sbuf_p1_wr_addr = sbuf_wr_p1_idx_d1;
assign wg2sbuf_p0_wr_data = sbuf_wr_p0_data_d1;
assign wg2sbuf_p1_wr_data = sbuf_wr_p1_data_d1;

////////////////////////////////////////////////////////////////////////
//  WG read data from shared buffer                                     //
////////////////////////////////////////////////////////////////////////

always @(
  sbuf_cube_inc_en_d1
  or sbuf_cube_inc_size_d1
  ) begin
    sbuf_avl_cube_add = sbuf_cube_inc_en_d1 ? sbuf_cube_inc_size_d1 : 4'b0;
end

always @(
  sbuf_rd_en
  or rd_sub_cnt
  ) begin
    sbuf_avl_cube_sub = sbuf_rd_en & (rd_sub_cnt == 3'h7);
end

always @(
  layer_st
  or sbuf_avl_cube
  or sbuf_avl_cube_add
  or sbuf_avl_cube_sub
  ) begin
    {mon_sbuf_avl_cube_w,
     sbuf_avl_cube_w} = (layer_st) ? 5'b0 :
                        (sbuf_avl_cube + sbuf_avl_cube_add - sbuf_avl_cube_sub);
end

always @(
  sbuf_avl_cube_w
  ) begin
    sbuf_blocking_w = (sbuf_avl_cube_w >= 4'h8) ? 1'b1 : 1'b0;
end

always @(
  sbuf_avl_cube
  ) begin
    sbuf_rd_en = (|sbuf_avl_cube);
end

always @(
  layer_st
  or rd_sub_cnt
  ) begin
    {mon_rd_sub_cnt_w,
     rd_sub_cnt_w} = (layer_st) ? 4'b0 :
                     (rd_sub_cnt + 1'b1);
end

always @(
  sbuf_avl_cube_sub
  or sbuf_cube_inc_en_d1
  ) begin
    sbuf_avl_cube_en = sbuf_avl_cube_sub | sbuf_cube_inc_en_d1;
end

always @(
  layer_st
  or rd_cube_cnt
  ) begin
    {mon_rd_cube_cnt_w,
     rd_cube_cnt_w} = (layer_st) ? 5'b0 :
                      rd_cube_cnt + 1;
end

always @(
  is_data_shrink_d1
  or rd_cube_cnt
  or rd_sub_cnt
  ) begin
    sbuf_rd_p0_idx = (is_data_shrink_d1) ? {rd_cube_cnt[0], 1'b0, rd_sub_cnt[1], rd_cube_cnt[8 -5:1], rd_sub_cnt[2], rd_sub_cnt[0]} :
                     {rd_cube_cnt[0], 1'b0, rd_sub_cnt[0], rd_cube_cnt[8 -5:1], rd_sub_cnt[2:1]};
end

always @(
  is_data_shrink_d1
  or rd_cube_cnt
  or rd_sub_cnt
  ) begin
    sbuf_rd_p1_idx = (is_data_shrink_d1) ? {rd_cube_cnt[0], 1'b1, rd_sub_cnt[1], rd_cube_cnt[8 -5:1], rd_sub_cnt[2], rd_sub_cnt[0]} :
                     {rd_cube_cnt[0], 1'b1, rd_sub_cnt[0], rd_cube_cnt[8 -5:1], rd_sub_cnt[2:1]};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_avl_cube <= {4{1'b0}};
  end else begin
  if ((layer_st | sbuf_avl_cube_en) == 1'b1) begin
    sbuf_avl_cube <= sbuf_avl_cube_w;
  // VCS coverage off
  end else if ((layer_st | sbuf_avl_cube_en) == 1'b0) begin
  end else begin
    sbuf_avl_cube <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | sbuf_avl_cube_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_blocking <= 1'b0;
  end else begin
  if ((layer_st | sbuf_avl_cube_en) == 1'b1) begin
    sbuf_blocking <= sbuf_blocking_w;
  // VCS coverage off
  end else if ((layer_st | sbuf_avl_cube_en) == 1'b0) begin
  end else begin
    sbuf_blocking <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | sbuf_avl_cube_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rd_cube_cnt <= {4{1'b0}};
  end else begin
  if ((layer_st | sbuf_avl_cube_sub) == 1'b1) begin
    rd_cube_cnt <= rd_cube_cnt_w;
  // VCS coverage off
  end else if ((layer_st | sbuf_avl_cube_sub) == 1'b0) begin
  end else begin
    rd_cube_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_106x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | sbuf_avl_cube_sub))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rd_sub_cnt <= {3{1'b0}};
  end else begin
  if ((layer_st | sbuf_rd_en) == 1'b1) begin
    rd_sub_cnt <= rd_sub_cnt_w;
  // VCS coverage off
  end else if ((layer_st | sbuf_rd_en) == 1'b0) begin
  end else begin
    rd_sub_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | sbuf_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_rd_en_d1 <= 1'b0;
  end else begin
  sbuf_rd_en_d1 <= sbuf_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_rd_p0_idx_d1 <= {8{1'b0}};
  end else begin
  if ((sbuf_rd_en) == 1'b1) begin
    sbuf_rd_p0_idx_d1 <= sbuf_rd_p0_idx;
  // VCS coverage off
  end else if ((sbuf_rd_en) == 1'b0) begin
  end else begin
    sbuf_rd_p0_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_rd_p1_idx_d1 <= {8{1'b0}};
  end else begin
  if ((sbuf_rd_en) == 1'b1) begin
    sbuf_rd_p1_idx_d1 <= sbuf_rd_p1_idx;
  // VCS coverage off
  end else if ((sbuf_rd_en) == 1'b0) begin
  end else begin
    sbuf_rd_p1_idx_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sbuf_rd_sel_d1 <= {2{1'b0}};
  end else begin
  if ((sbuf_rd_en) == 1'b1) begin
    sbuf_rd_sel_d1 <= rd_sub_cnt[1:0];
  // VCS coverage off
  end else if ((sbuf_rd_en) == 1'b0) begin
  end else begin
    sbuf_rd_sel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sbuf_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rd_sub_cnt is not zero when idle!")      zzz_assert_never_111x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|rd_sub_cnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sbuf_avl_cube_w is overflow!")      zzz_assert_never_112x (nvdla_core_clk, `ASSERT_RESET, (sbuf_avl_cube_en & mon_sbuf_avl_cube_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  Shared buffer read signals                                        //
////////////////////////////////////////////////////////////////////////
assign wg2sbuf_p0_rd_en = sbuf_rd_en_d1;
assign wg2sbuf_p1_rd_en = sbuf_rd_en_d1;
assign wg2sbuf_p0_rd_addr = sbuf_rd_p0_idx_d1;
assign wg2sbuf_p1_rd_addr = sbuf_rd_p1_idx_d1;

////////////////////////////////////////////////////////////////////////
//  pipeline to sync the sbuf read to output to convertor             //
////////////////////////////////////////////////////////////////////////
assign rsp_vld_d0 = sbuf_rd_en_d1;
assign rsp_sel_d0 = sbuf_rd_sel_d1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_vld_d1 <= 1'b0;
  end else begin
  rsp_vld_d1 <= rsp_vld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sel_d1 <= {2{1'b0}};
  end else begin
  if ((rsp_vld_d0) == 1'b1) begin
    rsp_sel_d1 <= rsp_sel_d0;
  // VCS coverage off
  end else if ((rsp_vld_d0) == 1'b0) begin
  end else begin
    rsp_sel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_vld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_vld_d2 <= 1'b0;
  end else begin
  rsp_vld_d2 <= rsp_vld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sel_d2 <= {2{1'b0}};
  end else begin
  if ((rsp_vld_d1) == 1'b1) begin
    rsp_sel_d2 <= rsp_sel_d1;
  // VCS coverage off
  end else if ((rsp_vld_d1) == 1'b0) begin
  end else begin
    rsp_sel_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_114x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_vld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


assign rsp_vld = rsp_vld_d2;
assign rsp_sel = rsp_sel_d2;



////////////////////////////////////////////////////////////////////////
//  WG local cache                                                    //
////////////////////////////////////////////////////////////////////////

always @(
  rsp_vld
  or rsp_sel
  ) begin
    rsp_data_l0c0_en = (rsp_vld & (rsp_sel == 2'h0));
    rsp_data_l0c1_en = (rsp_vld & (rsp_sel == 2'h1));
    rsp_data_l1c0_en = (rsp_vld & (rsp_sel == 2'h2));
    rsp_data_l1c1_en = (rsp_vld & (rsp_sel == 2'h3));
end

always @(posedge nvdla_core_clk) begin
  if ((rsp_data_l0c0_en) == 1'b1) begin
    rsp_data_l0c0 <= {wg2sbuf_p1_rd_data, wg2sbuf_p0_rd_data};
  // VCS coverage off
  end else if ((rsp_data_l0c0_en) == 1'b0) begin
  end else begin
    rsp_data_l0c0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_data_l0c1_en) == 1'b1) begin
    rsp_data_l0c1 <= {wg2sbuf_p1_rd_data, wg2sbuf_p0_rd_data};
  // VCS coverage off
  end else if ((rsp_data_l0c1_en) == 1'b0) begin
  end else begin
    rsp_data_l0c1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_data_l1c0_en) == 1'b1) begin
    rsp_data_l1c0 <= {wg2sbuf_p1_rd_data, wg2sbuf_p0_rd_data};
  // VCS coverage off
  end else if ((rsp_data_l1c0_en) == 1'b0) begin
  end else begin
    rsp_data_l1c0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_data_l1c1_en) == 1'b1) begin
    rsp_data_l1c1 <= {wg2sbuf_p1_rd_data, wg2sbuf_p0_rd_data};
  // VCS coverage off
  end else if ((rsp_data_l1c1_en) == 1'b0) begin
  end else begin
    rsp_data_l1c1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_dat_vld_d1 <= 1'b0;
  end else begin
  rsp_dat_vld_d1 <= rsp_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_dat_vld_d2 <= 1'b0;
  end else begin
  rsp_dat_vld_d2 <= rsp_dat_vld_d1;
  end
end

////////////////////////////////////////////////////////////////////////
//  WG response data counter                                          //
////////////////////////////////////////////////////////////////////////
//////////////// sub cube count ////////////////

always @(
  rsp_sub_cube_cnt
  ) begin
    {mon_rsp_sub_cube_cnt_inc,
     rsp_sub_cube_cnt_inc} = rsp_sub_cube_cnt + 1'b1;
end

always @(
  layer_st
  or is_rsp_last_sub_cube
  or rsp_sub_cube_cnt_inc
  ) begin
    rsp_sub_cube_cnt_w = (layer_st | is_rsp_last_sub_cube) ? 3'b0 :
                         rsp_sub_cube_cnt_inc;
end

always @(
  rsp_sub_cube_cnt
  ) begin
    is_rsp_last_sub_cube = (rsp_sub_cube_cnt == 3'h7);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sub_cube_cnt <= {3{1'b0}};
  end else begin
  if ((rsp_sub_cube_en) == 1'b1) begin
    rsp_sub_cube_cnt <= rsp_sub_cube_cnt_w;
  // VCS coverage off
  end else if ((rsp_sub_cube_en) == 1'b0) begin
  end else begin
    rsp_sub_cube_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sub_cube_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// conv x stride count ////////////////

always @(
  rsp_x_std_cnt
  ) begin
    {mon_rsp_x_std_cnt_inc,
     rsp_x_std_cnt_inc} = rsp_x_std_cnt + 1'b1;
end

always @(
  layer_st
  or is_rsp_last_x_std
  or rsp_x_std_cnt_inc
  ) begin
    rsp_x_std_cnt_w = (layer_st | is_rsp_last_x_std) ? 3'b0 :
                      rsp_x_std_cnt_inc;
end

always @(
  rsp_x_std_cnt
  or reg2dp_conv_x_stride
  ) begin
    is_rsp_last_x_std = (rsp_x_std_cnt == reg2dp_conv_x_stride);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_x_std_cnt <= {3{1'b0}};
  end else begin
  if ((rsp_x_std_en) == 1'b1) begin
    rsp_x_std_cnt <= rsp_x_std_cnt_w;
  // VCS coverage off
  end else if ((rsp_x_std_en) == 1'b0) begin
  end else begin
    rsp_x_std_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_x_std_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// width_ext count ////////////////

always @(
  rsp_width_cnt
  ) begin
    {mon_rsp_width_cnt_inc,
     rsp_width_cnt_inc} = rsp_width_cnt + 1'b1;
end

always @(
  layer_st
  or is_rsp_last_width
  or rsp_width_cnt_inc
  ) begin
    rsp_width_cnt_w = (layer_st | is_rsp_last_width) ? 11'b0 :
                      rsp_width_cnt_inc;
end

always @(
  rsp_width_cnt
  or width_ext_total
  ) begin
    is_rsp_last_width = (rsp_width_cnt == width_ext_total);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_width_cnt <= {11{1'b0}};
  end else begin
  if ((rsp_width_en) == 1'b1) begin
    rsp_width_cnt <= rsp_width_cnt_w;
  // VCS coverage off
  end else if ((rsp_width_en) == 1'b0) begin
  end else begin
    rsp_width_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_width_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// conv y stride count ////////////////

always @(
  rsp_y_std_cnt
  ) begin
    {mon_rsp_y_std_cnt_inc,
     rsp_y_std_cnt_inc} = rsp_y_std_cnt + 1'b1;
end

always @(
  layer_st
  or is_rsp_last_y_std
  or rsp_y_std_cnt_inc
  ) begin
    rsp_y_std_cnt_w = (layer_st | is_rsp_last_y_std) ? 3'b0 :
                      rsp_y_std_cnt_inc;
end

always @(
  rsp_y_std_cnt
  or reg2dp_conv_y_stride
  ) begin
    is_rsp_last_y_std = (rsp_y_std_cnt == reg2dp_conv_y_stride);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_y_std_cnt <= {3{1'b0}};
  end else begin
  if ((rsp_y_std_en) == 1'b1) begin
    rsp_y_std_cnt <= rsp_y_std_cnt_w;
  // VCS coverage off
  end else if ((rsp_y_std_en) == 1'b0) begin
  end else begin
    rsp_y_std_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_118x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_y_std_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// surf count ////////////////

always @(
  rsp_surf_cnt
  ) begin
    {mon_rsp_surf_cnt_inc,
     rsp_surf_cnt_inc} = rsp_surf_cnt + 1'b1;
end

always @(
  layer_st
  or is_rsp_last_surf
  or rsp_surf_cnt_inc
  ) begin
    rsp_surf_cnt_w = (layer_st | is_rsp_last_surf) ? 4'b0 :
                     rsp_surf_cnt_inc;
end

always @(
  rsp_surf_cnt
  or surf_cnt_total
  ) begin
    is_rsp_last_surf = (rsp_surf_cnt == surf_cnt_total);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_surf_cnt <= {9{1'b0}};
  end else begin
  if ((rsp_surf_en) == 1'b1) begin
    rsp_surf_cnt <= rsp_surf_cnt_w;
  // VCS coverage off
  end else if ((rsp_surf_en) == 1'b0) begin
  end else begin
    rsp_surf_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_119x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_surf_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// height ext ////////////////

always @(
  rsp_h_ext_cnt
  ) begin
    {mon_rsp_h_ext_cnt_inc,
     rsp_h_ext_cnt_inc} = rsp_h_ext_cnt + 1'b1;
end

always @(
  layer_st
  or rsp_h_ext_cnt_inc
  ) begin
    rsp_h_ext_cnt_w = layer_st ? 11'b0 :
                      rsp_h_ext_cnt_inc;
end

always @(
  rsp_h_ext_cnt
  or height_ext_total
  ) begin
    is_rsp_last_h_ext = (rsp_h_ext_cnt == height_ext_total);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_h_ext_cnt <= {11{1'b0}};
  end else begin
  if ((rsp_h_ext_en) == 1'b1) begin
    rsp_h_ext_cnt <= rsp_h_ext_cnt_w;
  // VCS coverage off
  end else if ((rsp_h_ext_en) == 1'b0) begin
  end else begin
    rsp_h_ext_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_h_ext_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
//////////////// control signal ////////////////
assign rsp_en = rsp_dat_vld_d2;

always @(
  layer_st
  or rsp_en
  ) begin
    rsp_sub_cube_en = layer_st | rsp_en;
end

always @(
  layer_st
  or rsp_en
  or is_rsp_last_sub_cube
  ) begin
    rsp_x_std_en = layer_st | (rsp_en & is_rsp_last_sub_cube);
end

always @(
  layer_st
  or rsp_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  ) begin
    rsp_width_en = layer_st | (rsp_en & is_rsp_last_sub_cube & is_rsp_last_x_std);
end

always @(
  layer_st
  or rsp_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  ) begin
    rsp_y_std_en = layer_st | (rsp_en & is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width);
end

always @(
  layer_st
  or rsp_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  or is_rsp_last_y_std
  ) begin
    rsp_surf_en = layer_st | (rsp_en & is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width & is_rsp_last_y_std);
end

always @(
  layer_st
  or rsp_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  or is_rsp_last_y_std
  or is_rsp_last_surf
  ) begin
    rsp_h_ext_en = layer_st | (rsp_en & is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width & is_rsp_last_y_std & is_rsp_last_surf);
end

always @(
  is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  or is_rsp_last_y_std
  or is_rsp_last_surf
  ) begin
    is_slice_done = (is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width & is_rsp_last_y_std & is_rsp_last_surf);
end

always @(
  is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  or is_rsp_last_y_std
  or is_rsp_last_surf
  or is_rsp_last_h_ext
  ) begin
    is_last_rsp = (is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width & is_rsp_last_y_std & is_rsp_last_surf & is_rsp_last_h_ext);
end

////////////////////////////////////////////////////////////////////////
//  WG response CBUF address generator                                //
////////////////////////////////////////////////////////////////////////
//////////////// base address ////////////////

always @(
  layer_st
  or rsp_addr_offset
  or data_entries
  ) begin
    {mon_rsp_addr_offset_w,
     rsp_addr_offset_w} = layer_st ? 13'b0 : 
                          rsp_addr_offset + data_entries;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_addr_base <= {12{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    rsp_addr_base <= status2dma_wr_idx;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    rsp_addr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_121x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_first_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_addr_offset <= {12{1'b0}};
  end else begin
  if ((rsp_h_ext_en) == 1'b1) begin
    rsp_addr_offset <= rsp_addr_offset_w;
  // VCS coverage off
  end else if ((rsp_h_ext_en) == 1'b0) begin
  end else begin
    rsp_addr_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_122x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_h_ext_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_addr_offset is overflow!")      zzz_assert_never_123x (nvdla_core_clk, `ASSERT_RESET, (mon_rsp_addr_offset_w & rsp_h_ext_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// offset ////////////////

//aaa = rsp_sub_surf * data_width_ext 
//bbb = rsp_sub_surf * data_width_ext * conv_x_stride;
//ccc = rsp_sub_surf_per_surf * data_width_ext;

always @(
  is_data_shrink_d1
  or w_ext_surf
  or is_data_normal_d1
  ) begin
    rsp_ch_x_std_add = is_data_shrink_d1 ? {w_ext_surf, 1'b0} :
                       is_data_normal_d1 ? {w_ext_surf[12 -3:0], 2'b0} :
                       {w_ext_surf[12 -4:0], 3'b0};
end

always @(
  is_data_shrink_d1
  or h_ext_surf
  or is_data_normal_d1
  ) begin
    rsp_ch_y_std_add = is_data_shrink_d1 ? {h_ext_surf, 1'b0} :
                       is_data_normal_d1 ? {h_ext_surf[12 -3:0], 2'b0} :
                       {h_ext_surf[12 -4:0], 3'b0};
end

always @(
  is_data_shrink_d1
  or data_width_ext
  or is_data_normal_d1
  ) begin
    rsp_ch_surf_add = is_data_shrink_d1 ? {data_width_ext[12 -2:0], 1'b0} :
                      is_data_normal_d1 ? {data_width_ext[12 -3:0], 2'b0} :
                      {data_width_ext[12 -4:0], 3'b0};
end

always @(
  layer_st
  or is_rsp_last_sub_cube
  or rsp_ch_offset
  or data_width_ext
  or is_rsp_last_x_std
  or rsp_ch_x_std_base
  or rsp_ch_x_std_add
  or is_rsp_last_width
  or rsp_ch_w_base
  or is_rsp_last_y_std
  or rsp_ch_y_std_base
  or rsp_ch_y_std_add
  or is_rsp_last_surf
  or rsp_ch_surf_base
  or rsp_ch_surf_add
  ) begin
    {mon_rsp_ch_offset_w,
     rsp_ch_offset_w} = (layer_st) ? 13'b0 :
                        (~is_rsp_last_sub_cube) ? (rsp_ch_offset + data_width_ext) :
                        (~is_rsp_last_x_std) ? (rsp_ch_x_std_base + rsp_ch_x_std_add) :
                        (~is_rsp_last_width) ? (rsp_ch_w_base + 1'b1) :
                        (~is_rsp_last_y_std) ? (rsp_ch_y_std_base + rsp_ch_y_std_add) :
                        (~is_rsp_last_surf) ? (rsp_ch_surf_base + rsp_ch_surf_add) :
                        13'b0;
end

always @(
  rsp_en
  or is_data_expand_d1
  or is_data_normal_d1
  or rsp_sub_cube_cnt
  or is_data_shrink_d1
  ) begin
    rsp_ch_offset_en = (rsp_en & is_data_expand_d1) |
                       (rsp_en & is_data_normal_d1 & rsp_sub_cube_cnt[0]) |
                       (rsp_en & is_data_shrink_d1 & (&rsp_sub_cube_cnt[1:0]));
end

always @(
  rsp_ch_offset_en
  or is_rsp_last_sub_cube
  ) begin
    rsp_ch_x_std_base_en = rsp_ch_offset_en & is_rsp_last_sub_cube;
end

always @(
  rsp_ch_offset_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  ) begin
    rsp_ch_w_base_en = rsp_ch_offset_en & is_rsp_last_sub_cube & is_rsp_last_x_std;
end

always @(
  rsp_ch_offset_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  ) begin
    rsp_ch_y_std_base_en = rsp_ch_offset_en & is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width;
end

always @(
  rsp_ch_offset_en
  or is_rsp_last_sub_cube
  or is_rsp_last_x_std
  or is_rsp_last_width
  or is_rsp_last_y_std
  ) begin
    rsp_ch_surf_base_en = rsp_ch_offset_en & is_rsp_last_sub_cube & is_rsp_last_x_std & is_rsp_last_width & is_rsp_last_y_std;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_ch_offset <= {12{1'b0}};
  end else begin
  if ((rsp_ch_offset_en) == 1'b1) begin
    rsp_ch_offset <= rsp_ch_offset_w;
  // VCS coverage off
  end else if ((rsp_ch_offset_en) == 1'b0) begin
  end else begin
    rsp_ch_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_ch_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_ch_x_std_base <= {12{1'b0}};
  end else begin
  if ((rsp_ch_x_std_base_en) == 1'b1) begin
    rsp_ch_x_std_base <= rsp_ch_offset_w;
  // VCS coverage off
  end else if ((rsp_ch_x_std_base_en) == 1'b0) begin
  end else begin
    rsp_ch_x_std_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_ch_x_std_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_ch_w_base <= {12{1'b0}};
  end else begin
  if ((rsp_ch_w_base_en) == 1'b1) begin
    rsp_ch_w_base <= rsp_ch_offset_w;
  // VCS coverage off
  end else if ((rsp_ch_w_base_en) == 1'b0) begin
  end else begin
    rsp_ch_w_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_ch_w_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_ch_y_std_base <= {12{1'b0}};
  end else begin
  if ((rsp_ch_y_std_base_en) == 1'b1) begin
    rsp_ch_y_std_base <= rsp_ch_offset_w;
  // VCS coverage off
  end else if ((rsp_ch_y_std_base_en) == 1'b0) begin
  end else begin
    rsp_ch_y_std_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_ch_y_std_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_ch_surf_base <= {12{1'b0}};
  end else begin
  if ((rsp_ch_surf_base_en) == 1'b1) begin
    rsp_ch_surf_base <= rsp_ch_offset_w;
  // VCS coverage off
  end else if ((rsp_ch_surf_base_en) == 1'b0) begin
  end else begin
    rsp_ch_surf_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_ch_surf_base_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_ch_offset_w is overflow!")      zzz_assert_never_129x (nvdla_core_clk, `ASSERT_RESET, (rsp_ch_offset_en & mon_rsp_ch_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_ch_offset_w is out of range!")      zzz_assert_never_130x (nvdla_core_clk, `ASSERT_RESET, (rsp_ch_offset_en & (rsp_ch_offset_w > 12'd3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////////////// write address  ////////////////

always @(
  rsp_addr_base
  or rsp_addr_offset
  or rsp_ch_offset
  ) begin
    {mon_rsp_addr_inc,
     rsp_addr_inc} = rsp_addr_base + rsp_addr_offset + rsp_ch_offset;
end

always @(
  rsp_addr_inc
  or data_bank
  ) begin
    {mon_rsp_addr_wrap,
     rsp_addr_wrap} = rsp_addr_inc - {1'b0, data_bank, 8'b0};
end

always @(
  rsp_addr_inc
  or data_bank
  ) begin
    is_rsp_addr_wrap = rsp_addr_inc[12 : 8 ] >= {1'b0, data_bank};
end

always @(
  is_rsp_addr_wrap
  or rsp_addr_inc
  or rsp_addr_wrap
  ) begin
    rsp_addr = ~is_rsp_addr_wrap ? rsp_addr_inc[12 -1:0] :
               rsp_addr_wrap;
end

always @(
  is_data_normal_d1
  or rsp_sub_cube_cnt
  or is_data_shrink_d1
  ) begin
    rsp_hsel = (is_data_normal_d1 & rsp_sub_cube_cnt[0]) |
               (is_data_shrink_d1 & rsp_sub_cube_cnt[1]);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_en_d1 <= 1'b0;
  end else begin
  rsp_en_d1 <= rsp_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_addr_d1 <= {12{1'b0}};
  end else begin
  if ((rsp_en) == 1'b1) begin
    rsp_addr_d1 <= rsp_addr;
  // VCS coverage off
  end else if ((rsp_en) == 1'b0) begin
  end else begin
    rsp_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_131x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_hsel_d1 <= 1'b0;
  end else begin
  if ((rsp_en) == 1'b1) begin
    rsp_hsel_d1 <= rsp_hsel;
  // VCS coverage off
  end else if ((rsp_en) == 1'b0) begin
  end else begin
    rsp_hsel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_132x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    rsp_slice_done_d1 <= 1'b0;
  end else begin
  rsp_slice_done_d1 <= rsp_en & is_slice_done;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_layer_done_d1 <= 1'b0;
  end else begin
  if ((rsp_en) == 1'b1) begin
    rsp_layer_done_d1 <= is_last_rsp;
  // VCS coverage off
  end else if ((rsp_en) == 1'b0) begin
  end else begin
    rsp_layer_done_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_133x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_addr_inc is overflow!")      zzz_assert_never_134x (nvdla_core_clk, `ASSERT_RESET, (rsp_en & mon_rsp_addr_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  WG response data output                                           //
////////////////////////////////////////////////////////////////////////
assign rsp_data_l0 = {rsp_data_l0c1, rsp_data_l0c0};
assign rsp_data_l1 = {rsp_data_l1c1, rsp_data_l1c0};

always @(
  rsp_sub_cube_cnt
  or rsp_data_l1
  or rsp_data_l0
  ) begin
    dat_cur = rsp_sub_cube_cnt[1] ? rsp_data_l1 : rsp_data_l0;
end

assign dat_cur_normal = dat_cur;

always @(
  dat_cur
  ) begin
    dat_cur_expand = {dat_cur[1023: 992], dat_cur[ 959: 928], dat_cur[ 895: 864], dat_cur[ 831: 800],
                      dat_cur[ 767: 736], dat_cur[ 703: 672], dat_cur[ 639: 608], dat_cur[ 575: 544],
                      dat_cur[ 511: 480], dat_cur[ 447: 416], dat_cur[ 383: 352], dat_cur[ 319: 288],
                      dat_cur[ 255: 224], dat_cur[ 191: 160], dat_cur[ 127:  96], dat_cur[  63:  32],
                      dat_cur[ 991: 960], dat_cur[ 927: 896], dat_cur[ 863: 832], dat_cur[ 799: 768],
                      dat_cur[ 735: 704], dat_cur[ 671: 640], dat_cur[ 607: 576], dat_cur[ 543: 512],
                      dat_cur[ 479: 448], dat_cur[ 415: 384], dat_cur[ 351: 320], dat_cur[ 287: 256],
                      dat_cur[ 223: 192], dat_cur[ 159: 128], dat_cur[  95:  64], dat_cur[  31:   0]};
end


always @(
  dat_cur
  ) begin
    dat_cur_shrink = {dat_cur[ 767: 704], dat_cur[ 703: 640], dat_cur[ 639: 576], dat_cur[ 575: 512], dat_cur[ 511: 448], dat_cur[ 447: 384], dat_cur[ 383: 320], dat_cur[ 319: 256],
                      dat_cur[ 511: 448], dat_cur[ 447: 384], dat_cur[ 383: 320], dat_cur[ 319: 256], dat_cur[ 255: 192], dat_cur[ 191: 128], dat_cur[ 127:  64], dat_cur[  63:   0]};
end


always @(
  is_data_shrink_d1
  or dat_cur_shrink
  or is_data_normal_d1
  or dat_cur_normal
  or dat_cur_expand
  ) begin
    dat_cur_remapped = is_data_shrink_d1 ? dat_cur_shrink :
                       is_data_normal_d1 ? dat_cur_normal :
                       dat_cur_expand;
end

always @(
  rsp_sub_cube_cnt
  or dat_cur_remapped
  ) begin
    rsp_data_d1_w = rsp_sub_cube_cnt[0] ? dat_cur_remapped[1023:512] :
                    dat_cur_remapped[511:0];
end

always @(posedge nvdla_core_clk) begin
  if ((rsp_en) == 1'b1) begin
    rsp_data_d1 <= rsp_data_d1_w;
  // VCS coverage off
  end else if ((rsp_en) == 1'b0) begin
  end else begin
    rsp_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

////////////////////////////////////////////////////////////////////////
//  WG to CDMA convertor                                              //
////////////////////////////////////////////////////////////////////////
assign wg2cvt_dat_wr_en = rsp_en_d1;
assign wg2cvt_dat_wr_addr = rsp_addr_d1;
assign wg2cvt_dat_wr_hsel = rsp_hsel_d1;
assign wg2cvt_dat_wr_data = rsp_data_d1;

assign cbuf_wr_info_mask = 4'h3;
assign cbuf_wr_info_interleave = 1'b0;
assign cbuf_wr_info_ext64 = 1'b0;
assign cbuf_wr_info_ext128 = 1'b0;
assign cbuf_wr_info_mean = 1'b0;
assign cbuf_wr_info_uint = 1'b0;
assign cbuf_wr_info_sub_h = 3'b0;


// PKT_PACK_WIRE( nvdla_ram_info ,  cbuf_wr_info_ ,  wg2cvt_dat_wr_info_pd )
assign       wg2cvt_dat_wr_info_pd[3:0] =     cbuf_wr_info_mask[3:0];
assign       wg2cvt_dat_wr_info_pd[4] =     cbuf_wr_info_interleave ;
assign       wg2cvt_dat_wr_info_pd[5] =     cbuf_wr_info_ext64 ;
assign       wg2cvt_dat_wr_info_pd[6] =     cbuf_wr_info_ext128 ;
assign       wg2cvt_dat_wr_info_pd[7] =     cbuf_wr_info_mean ;
assign       wg2cvt_dat_wr_info_pd[8] =     cbuf_wr_info_uint ;
assign       wg2cvt_dat_wr_info_pd[11:9] =     cbuf_wr_info_sub_h[2:0];

////////////////////////////////////////////////////////////////////////
//  WG response done signal                                           //
////////////////////////////////////////////////////////////////////////
always @(
  layer_st
  or rsp_en_d1
  or rsp_layer_done_d1
  or is_rsp_done
  ) begin
    is_rsp_done_w = layer_st ? 1'b0 :
                    (rsp_en_d1 & rsp_layer_done_d1) ? 1'b1 :
                    is_rsp_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_rsp_done <= 1'b1;
  end else begin
  is_rsp_done <= is_rsp_done_w;
  end
end

////////////////////////////////////////////////////////////////////////
//  WG to status update                                               //
////////////////////////////////////////////////////////////////////////
assign wg2status_dat_updt = rsp_slice_done_d1;
assign wg2status_dat_entries = data_entries;
assign wg2status_dat_slices = 12'h4;

////////////////////////////////////////////////////////////////////////
//  performance counting register                                     //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_stall_inc <= 1'b0;
  end else begin
  wg_rd_stall_inc <= dma_rd_req_vld & ~dma_rd_req_rdy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_stall_clr <= 1'b0;
  end else begin
  wg_rd_stall_clr <= status2dma_fsm_switch & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_stall_cen <= 1'b0;
  end else begin
  wg_rd_stall_cen <= reg2dp_op_en & reg2dp_dma_en;
  end
end




    assign dp2reg_wg_rd_stall_dec = 1'b0;

    // stl adv logic

    always @(
      wg_rd_stall_inc
      or dp2reg_wg_rd_stall_dec
      ) begin
      stl_adv = wg_rd_stall_inc ^ dp2reg_wg_rd_stall_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or wg_rd_stall_inc
      or dp2reg_wg_rd_stall_dec
      or stl_adv
      or wg_rd_stall_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (wg_rd_stall_inc && !dp2reg_wg_rd_stall_dec)? stl_cnt_inc : (!wg_rd_stall_inc && dp2reg_wg_rd_stall_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (wg_rd_stall_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (wg_rd_stall_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      dp2reg_wg_rd_stall[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_latency_inc <= 1'b0;
  end else begin
  wg_rd_latency_inc <= dma_rd_req_vld & dma_rd_req_rdy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_latency_dec <= 1'b0;
  end else begin
  wg_rd_latency_dec <= dma_rsp_fifo_ready & ~dma_rsp_dummy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_latency_clr <= 1'b0;
  end else begin
  wg_rd_latency_clr <= status2dma_fsm_switch;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wg_rd_latency_cen <= 1'b0;
  end else begin
  wg_rd_latency_cen <= reg2dp_op_en & reg2dp_dma_en;
  end
end




    // 
    assign ltc_1_inc = (outs_dp2reg_wg_rd_latency!=511) & wg_rd_latency_inc;
    assign ltc_1_dec = (outs_dp2reg_wg_rd_latency!=511) & wg_rd_latency_dec;

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
      or wg_rd_latency_clr
      ) begin
      // VCS sop_coverage_off start
      ltc_1_cnt_ext[10:0] = {1'b0, 1'b0, ltc_1_cnt_cur};
      ltc_1_cnt_inc[10:0] = ltc_1_cnt_cur + 1'b1; // spyglass disable W164b
      ltc_1_cnt_dec[10:0] = ltc_1_cnt_cur - 1'b1; // spyglass disable W164b
      ltc_1_cnt_mod[10:0] = (ltc_1_inc && !ltc_1_dec)? ltc_1_cnt_inc : (!ltc_1_inc && ltc_1_dec)? ltc_1_cnt_dec : ltc_1_cnt_ext;
      ltc_1_cnt_new[10:0] = (ltc_1_adv)? ltc_1_cnt_mod[10:0] : ltc_1_cnt_ext[10:0];
      ltc_1_cnt_nxt[10:0] = (wg_rd_latency_clr)? 11'd0 : ltc_1_cnt_new[10:0];
      // VCS sop_coverage_off end
    end

    // ltc_1 flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        ltc_1_cnt_cur[8:0] <= 0;
      end else begin
      if (wg_rd_latency_cen) begin
      ltc_1_cnt_cur[8:0] <= ltc_1_cnt_nxt[8:0];
      end
      end
    end

    // ltc_1 output logic

    always @(
      ltc_1_cnt_cur
      ) begin
      outs_dp2reg_wg_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
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
      nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_135x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && wg_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

      
    //assign dp2reg_wg_rd_latency_sub = 1'b0;
    assign ltc_2_dec = 1'b0;
    assign ltc_2_inc = (~&dp2reg_wg_rd_latency) & (|outs_dp2reg_wg_rd_latency);

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
      or wg_rd_latency_clr
      ) begin
      // VCS sop_coverage_off start
      ltc_2_cnt_ext[33:0] = {1'b0, 1'b0, ltc_2_cnt_cur};
      ltc_2_cnt_inc[33:0] = ltc_2_cnt_cur + 1'b1; // spyglass disable W164b
      ltc_2_cnt_dec[33:0] = ltc_2_cnt_cur - 1'b1; // spyglass disable W164b
      ltc_2_cnt_mod[33:0] = (ltc_2_inc && !ltc_2_dec)? ltc_2_cnt_inc : (!ltc_2_inc && ltc_2_dec)? ltc_2_cnt_dec : ltc_2_cnt_ext;
      ltc_2_cnt_new[33:0] = (ltc_2_adv)? ltc_2_cnt_mod[33:0] : ltc_2_cnt_ext[33:0];
      ltc_2_cnt_nxt[33:0] = (wg_rd_latency_clr)? 34'd0 : ltc_2_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // ltc_2 flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        ltc_2_cnt_cur[31:0] <= 0;
      end else begin
      if (wg_rd_latency_cen) begin
      ltc_2_cnt_cur[31:0] <= ltc_2_cnt_nxt[31:0];
      end
      end
    end

    // ltc_2 output logic

    always @(
      ltc_2_cnt_cur
      ) begin
      dp2reg_wg_rd_latency[31:0] = ltc_2_cnt_cur[31:0];
    end
        
      

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// assign obs_bus_cdma_wg_dma_rd_req_vld      = dma_rd_req_vld;
// assign obs_bus_cdma_wg_dma_rd_req_rdy      = dma_rd_req_rdy;
// assign obs_bus_cdma_wg_dma_req_fifo_req    = dma_req_fifo_req;
// assign obs_bus_cdma_wg_dma_req_fifo_ready  = dma_req_fifo_ready;
// assign obs_bus_cdma_wg_req_size_out_d2     = req_size_out_d2;
// assign obs_bus_cdma_wg_req_addr_d2_lo      = req_addr_d2[15:0];
// assign obs_bus_cdma_wg_req_dummy_d2        = req_dummy_d2;
// assign obs_bus_cdma_wg_dma_rd_rsp_vld      = dma_rd_rsp_vld;
// assign obs_bus_cdma_wg_dma_rd_rsp_rdy      = dma_rd_rsp_rdy;
// assign obs_bus_cdma_wg_dma_rd_rsp_mask     = dma_rd_rsp_mask;
// assign obs_bus_cdma_wg_dma_rsp_fifo_req    = dma_rsp_fifo_req;
// assign obs_bus_cdma_wg_dma_rsp_fifo_ready  = dma_rsp_fifo_ready;
// assign obs_bus_cdma_wg_fetch_done          = fetch_done;
// assign obs_bus_cdma_wg_is_rsp_done         = is_rsp_done;
// assign obs_bus_cdma_wg_cur_state           = cur_state;
// assign obs_bus_cdma_wg_nxt_state           = nxt_state;
// assign obs_bus_cdma_wg2cvt_dat_wr_en       = wg2cvt_dat_wr_en;
// assign obs_bus_cdma_wg2cvt_dat_wr_addr     = wg2cvt_dat_wr_addr;
// assign obs_bus_cdma_wg2cvt_dat_wr_hsel     = wg2cvt_dat_wr_hsel;
// assign obs_bus_cdma_wg2cvt_dat_wr_info_pd  = wg2cvt_dat_wr_info_pd;
// assign obs_bus_cdma_wg2status_dat_updt     = wg2status_dat_updt;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           {is_req_done,is_cbuf_ready}
//                           {req_valid_d1,req_dummy_d1}
//                           req_size_d1[1:0]
//                           sbuf_wr_line
//                           rd_cube_cnt[1:0]
//                           {rsp_dat_vld_d1,rsp_dat_vld_d2}
//                           {rsp_slice_done_d1,rsp_layer_done_d1};

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

    property cdma_wg__rsp_addr_wrap__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (rsp_en & is_rsp_addr_wrap);
    endproperty
    // Cover 0 : "(rsp_en & is_rsp_addr_wrap)"
    FUNCPOINT_cdma_wg__rsp_addr_wrap__0_COV : cover property (cdma_wg__rsp_addr_wrap__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_wg__wg_conv_stride_EQ_0__1_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_0 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_0__1_0_COV : cover property (cdma_wg__wg_conv_stride_EQ_0__1_0_cov);

    property cdma_wg__wg_conv_stride_EQ_1__1_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_1 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_1__1_1_COV : cover property (cdma_wg__wg_conv_stride_EQ_1__1_1_cov);

    property cdma_wg__wg_conv_stride_EQ_2__1_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_2 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_2__1_2_COV : cover property (cdma_wg__wg_conv_stride_EQ_2__1_2_cov);

    property cdma_wg__wg_conv_stride_EQ_3__1_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_3 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_3__1_3_COV : cover property (cdma_wg__wg_conv_stride_EQ_3__1_3_cov);

    property cdma_wg__wg_conv_stride_EQ_4__1_4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_4 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_4__1_4_COV : cover property (cdma_wg__wg_conv_stride_EQ_4__1_4_cov);

    property cdma_wg__wg_conv_stride_EQ_5__1_5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_5 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_5__1_5_COV : cover property (cdma_wg__wg_conv_stride_EQ_5__1_5_cov);

    property cdma_wg__wg_conv_stride_EQ_6__1_6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_6 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_6__1_6_COV : cover property (cdma_wg__wg_conv_stride_EQ_6__1_6_cov);

    property cdma_wg__wg_conv_stride_EQ_7__1_7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_7 : "(reg2dp_conv_x_stride == 0) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_7__1_7_COV : cover property (cdma_wg__wg_conv_stride_EQ_7__1_7_cov);

    property cdma_wg__wg_conv_stride_EQ_8__1_8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_8 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_8__1_8_COV : cover property (cdma_wg__wg_conv_stride_EQ_8__1_8_cov);

    property cdma_wg__wg_conv_stride_EQ_9__1_9_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_9 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_9__1_9_COV : cover property (cdma_wg__wg_conv_stride_EQ_9__1_9_cov);

    property cdma_wg__wg_conv_stride_EQ_10__1_10_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_10 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_10__1_10_COV : cover property (cdma_wg__wg_conv_stride_EQ_10__1_10_cov);

    property cdma_wg__wg_conv_stride_EQ_11__1_11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_11 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_11__1_11_COV : cover property (cdma_wg__wg_conv_stride_EQ_11__1_11_cov);

    property cdma_wg__wg_conv_stride_EQ_12__1_12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_12 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_12__1_12_COV : cover property (cdma_wg__wg_conv_stride_EQ_12__1_12_cov);

    property cdma_wg__wg_conv_stride_EQ_13__1_13_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_13 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_13__1_13_COV : cover property (cdma_wg__wg_conv_stride_EQ_13__1_13_cov);

    property cdma_wg__wg_conv_stride_EQ_14__1_14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_14 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_14__1_14_COV : cover property (cdma_wg__wg_conv_stride_EQ_14__1_14_cov);

    property cdma_wg__wg_conv_stride_EQ_15__1_15_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_15 : "(reg2dp_conv_x_stride == 1) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_15__1_15_COV : cover property (cdma_wg__wg_conv_stride_EQ_15__1_15_cov);

    property cdma_wg__wg_conv_stride_EQ_16__1_16_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_16 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_16__1_16_COV : cover property (cdma_wg__wg_conv_stride_EQ_16__1_16_cov);

    property cdma_wg__wg_conv_stride_EQ_17__1_17_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_17 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_17__1_17_COV : cover property (cdma_wg__wg_conv_stride_EQ_17__1_17_cov);

    property cdma_wg__wg_conv_stride_EQ_18__1_18_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_18 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_18__1_18_COV : cover property (cdma_wg__wg_conv_stride_EQ_18__1_18_cov);

    property cdma_wg__wg_conv_stride_EQ_19__1_19_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_19 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_19__1_19_COV : cover property (cdma_wg__wg_conv_stride_EQ_19__1_19_cov);

    property cdma_wg__wg_conv_stride_EQ_20__1_20_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_20 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_20__1_20_COV : cover property (cdma_wg__wg_conv_stride_EQ_20__1_20_cov);

    property cdma_wg__wg_conv_stride_EQ_21__1_21_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_21 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_21__1_21_COV : cover property (cdma_wg__wg_conv_stride_EQ_21__1_21_cov);

    property cdma_wg__wg_conv_stride_EQ_22__1_22_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_22 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_22__1_22_COV : cover property (cdma_wg__wg_conv_stride_EQ_22__1_22_cov);

    property cdma_wg__wg_conv_stride_EQ_23__1_23_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_23 : "(reg2dp_conv_x_stride == 2) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_23__1_23_COV : cover property (cdma_wg__wg_conv_stride_EQ_23__1_23_cov);

    property cdma_wg__wg_conv_stride_EQ_24__1_24_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_24 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_24__1_24_COV : cover property (cdma_wg__wg_conv_stride_EQ_24__1_24_cov);

    property cdma_wg__wg_conv_stride_EQ_25__1_25_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_25 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_25__1_25_COV : cover property (cdma_wg__wg_conv_stride_EQ_25__1_25_cov);

    property cdma_wg__wg_conv_stride_EQ_26__1_26_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_26 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_26__1_26_COV : cover property (cdma_wg__wg_conv_stride_EQ_26__1_26_cov);

    property cdma_wg__wg_conv_stride_EQ_27__1_27_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_27 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_27__1_27_COV : cover property (cdma_wg__wg_conv_stride_EQ_27__1_27_cov);

    property cdma_wg__wg_conv_stride_EQ_28__1_28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_28 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_28__1_28_COV : cover property (cdma_wg__wg_conv_stride_EQ_28__1_28_cov);

    property cdma_wg__wg_conv_stride_EQ_29__1_29_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_29 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_29__1_29_COV : cover property (cdma_wg__wg_conv_stride_EQ_29__1_29_cov);

    property cdma_wg__wg_conv_stride_EQ_30__1_30_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_30 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_30__1_30_COV : cover property (cdma_wg__wg_conv_stride_EQ_30__1_30_cov);

    property cdma_wg__wg_conv_stride_EQ_31__1_31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_31 : "(reg2dp_conv_x_stride == 3) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_31__1_31_COV : cover property (cdma_wg__wg_conv_stride_EQ_31__1_31_cov);

    property cdma_wg__wg_conv_stride_EQ_32__1_32_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_32 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_32__1_32_COV : cover property (cdma_wg__wg_conv_stride_EQ_32__1_32_cov);

    property cdma_wg__wg_conv_stride_EQ_33__1_33_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_33 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_33__1_33_COV : cover property (cdma_wg__wg_conv_stride_EQ_33__1_33_cov);

    property cdma_wg__wg_conv_stride_EQ_34__1_34_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_34 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_34__1_34_COV : cover property (cdma_wg__wg_conv_stride_EQ_34__1_34_cov);

    property cdma_wg__wg_conv_stride_EQ_35__1_35_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_35 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_35__1_35_COV : cover property (cdma_wg__wg_conv_stride_EQ_35__1_35_cov);

    property cdma_wg__wg_conv_stride_EQ_36__1_36_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_36 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_36__1_36_COV : cover property (cdma_wg__wg_conv_stride_EQ_36__1_36_cov);

    property cdma_wg__wg_conv_stride_EQ_37__1_37_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_37 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_37__1_37_COV : cover property (cdma_wg__wg_conv_stride_EQ_37__1_37_cov);

    property cdma_wg__wg_conv_stride_EQ_38__1_38_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_38 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_38__1_38_COV : cover property (cdma_wg__wg_conv_stride_EQ_38__1_38_cov);

    property cdma_wg__wg_conv_stride_EQ_39__1_39_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_39 : "(reg2dp_conv_x_stride == 4) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_39__1_39_COV : cover property (cdma_wg__wg_conv_stride_EQ_39__1_39_cov);

    property cdma_wg__wg_conv_stride_EQ_40__1_40_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_40 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_40__1_40_COV : cover property (cdma_wg__wg_conv_stride_EQ_40__1_40_cov);

    property cdma_wg__wg_conv_stride_EQ_41__1_41_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_41 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_41__1_41_COV : cover property (cdma_wg__wg_conv_stride_EQ_41__1_41_cov);

    property cdma_wg__wg_conv_stride_EQ_42__1_42_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_42 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_42__1_42_COV : cover property (cdma_wg__wg_conv_stride_EQ_42__1_42_cov);

    property cdma_wg__wg_conv_stride_EQ_43__1_43_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_43 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_43__1_43_COV : cover property (cdma_wg__wg_conv_stride_EQ_43__1_43_cov);

    property cdma_wg__wg_conv_stride_EQ_44__1_44_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_44 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_44__1_44_COV : cover property (cdma_wg__wg_conv_stride_EQ_44__1_44_cov);

    property cdma_wg__wg_conv_stride_EQ_45__1_45_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_45 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_45__1_45_COV : cover property (cdma_wg__wg_conv_stride_EQ_45__1_45_cov);

    property cdma_wg__wg_conv_stride_EQ_46__1_46_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_46 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_46__1_46_COV : cover property (cdma_wg__wg_conv_stride_EQ_46__1_46_cov);

    property cdma_wg__wg_conv_stride_EQ_47__1_47_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_47 : "(reg2dp_conv_x_stride == 5) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_47__1_47_COV : cover property (cdma_wg__wg_conv_stride_EQ_47__1_47_cov);

    property cdma_wg__wg_conv_stride_EQ_48__1_48_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_48 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_48__1_48_COV : cover property (cdma_wg__wg_conv_stride_EQ_48__1_48_cov);

    property cdma_wg__wg_conv_stride_EQ_49__1_49_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_49 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_49__1_49_COV : cover property (cdma_wg__wg_conv_stride_EQ_49__1_49_cov);

    property cdma_wg__wg_conv_stride_EQ_50__1_50_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_50 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_50__1_50_COV : cover property (cdma_wg__wg_conv_stride_EQ_50__1_50_cov);

    property cdma_wg__wg_conv_stride_EQ_51__1_51_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_51 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_51__1_51_COV : cover property (cdma_wg__wg_conv_stride_EQ_51__1_51_cov);

    property cdma_wg__wg_conv_stride_EQ_52__1_52_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_52 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_52__1_52_COV : cover property (cdma_wg__wg_conv_stride_EQ_52__1_52_cov);

    property cdma_wg__wg_conv_stride_EQ_53__1_53_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_53 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_53__1_53_COV : cover property (cdma_wg__wg_conv_stride_EQ_53__1_53_cov);

    property cdma_wg__wg_conv_stride_EQ_54__1_54_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_54 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_54__1_54_COV : cover property (cdma_wg__wg_conv_stride_EQ_54__1_54_cov);

    property cdma_wg__wg_conv_stride_EQ_55__1_55_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_55 : "(reg2dp_conv_x_stride == 6) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_55__1_55_COV : cover property (cdma_wg__wg_conv_stride_EQ_55__1_55_cov);

    property cdma_wg__wg_conv_stride_EQ_56__1_56_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 0));
    endproperty
    // Cover 1_56 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 0)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_56__1_56_COV : cover property (cdma_wg__wg_conv_stride_EQ_56__1_56_cov);

    property cdma_wg__wg_conv_stride_EQ_57__1_57_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 1));
    endproperty
    // Cover 1_57 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 1)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_57__1_57_COV : cover property (cdma_wg__wg_conv_stride_EQ_57__1_57_cov);

    property cdma_wg__wg_conv_stride_EQ_58__1_58_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 2));
    endproperty
    // Cover 1_58 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 2)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_58__1_58_COV : cover property (cdma_wg__wg_conv_stride_EQ_58__1_58_cov);

    property cdma_wg__wg_conv_stride_EQ_59__1_59_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 3));
    endproperty
    // Cover 1_59 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 3)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_59__1_59_COV : cover property (cdma_wg__wg_conv_stride_EQ_59__1_59_cov);

    property cdma_wg__wg_conv_stride_EQ_60__1_60_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 4));
    endproperty
    // Cover 1_60 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 4)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_60__1_60_COV : cover property (cdma_wg__wg_conv_stride_EQ_60__1_60_cov);

    property cdma_wg__wg_conv_stride_EQ_61__1_61_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 5));
    endproperty
    // Cover 1_61 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 5)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_61__1_61_COV : cover property (cdma_wg__wg_conv_stride_EQ_61__1_61_cov);

    property cdma_wg__wg_conv_stride_EQ_62__1_62_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 6));
    endproperty
    // Cover 1_62 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 6)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_62__1_62_COV : cover property (cdma_wg__wg_conv_stride_EQ_62__1_62_cov);

    property cdma_wg__wg_conv_stride_EQ_63__1_63_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 7));
    endproperty
    // Cover 1_63 : "(reg2dp_conv_x_stride == 7) && (reg2dp_conv_y_stride == 7)"
    FUNCPOINT_cdma_wg__wg_conv_stride_EQ_63__1_63_COV : cover property (cdma_wg__wg_conv_stride_EQ_63__1_63_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_wg__wg_reuse__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cur_state == WG_STATE_IDLE) & (nxt_state == WG_STATE_DONE));
    endproperty
    // Cover 2 : "((cur_state == WG_STATE_IDLE) & (nxt_state == WG_STATE_DONE))"
    FUNCPOINT_cdma_wg__wg_reuse__2_COV : cover property (cdma_wg__wg_reuse__2_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDMA_wg



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WG_pipe_p1 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_136x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_137x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_WG_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WG_pipe_p2 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_138x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_139x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_WG_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WG_pipe_p3 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_140x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_141x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_WG_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_WG_pipe_p4 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_wg_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_142x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_143x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_WG_pipe_p4



