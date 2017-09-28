// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_sg.v

module NV_NVDLA_CDMA_IMG_sg (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,cvif2img_dat_rd_rsp_pd         //|< i
  ,cvif2img_dat_rd_rsp_valid      //|< i
  ,img2status_dat_entries         //|< i
  ,img2status_dat_updt            //|< i
  ,img_dat2cvif_rd_req_ready      //|< i
  ,img_dat2mcif_rd_req_ready      //|< i
  ,is_running                     //|< i
  ,layer_st                       //|< i
  ,mcif2img_dat_rd_rsp_pd         //|< i
  ,mcif2img_dat_rd_rsp_valid      //|< i
  ,pixel_order                    //|< i
  ,pixel_planar                   //|< i
  ,pixel_planar0_bundle_limit     //|< i
  ,pixel_planar0_bundle_limit_1st //|< i
  ,pixel_planar0_byte_sft         //|< i
  ,pixel_planar0_lp_burst         //|< i
  ,pixel_planar0_lp_vld           //|< i
  ,pixel_planar0_rp_burst         //|< i
  ,pixel_planar0_rp_vld           //|< i
  ,pixel_planar0_width_burst      //|< i
  ,pixel_planar1_bundle_limit     //|< i
  ,pixel_planar1_bundle_limit_1st //|< i
  ,pixel_planar1_byte_sft         //|< i
  ,pixel_planar1_lp_burst         //|< i
  ,pixel_planar1_lp_vld           //|< i
  ,pixel_planar1_rp_burst         //|< i
  ,pixel_planar1_rp_vld           //|< i
  ,pixel_planar1_width_burst      //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_datain_addr_high_0      //|< i
  ,reg2dp_datain_addr_high_1      //|< i
  ,reg2dp_datain_addr_low_0       //|< i
  ,reg2dp_datain_addr_low_1       //|< i
  ,reg2dp_datain_height           //|< i
  ,reg2dp_datain_ram_type         //|< i
  ,reg2dp_dma_en                  //|< i
  ,reg2dp_entries                 //|< i
  ,reg2dp_line_stride             //|< i
  ,reg2dp_mean_format             //|< i
  ,reg2dp_op_en                   //|< i
  ,reg2dp_pixel_y_offset          //|< i *
  ,reg2dp_uv_line_stride          //|< i
  ,sg2pack_img_prdy               //|< i
  ,status2dma_free_entries        //|< i
  ,status2dma_fsm_switch          //|< i
  ,cvif2img_dat_rd_rsp_ready      //|> o
  ,dp2reg_img_rd_latency          //|> o
  ,dp2reg_img_rd_stall            //|> o
  ,img2sbuf_p0_wr_addr            //|> o
  ,img2sbuf_p0_wr_data            //|> o
  ,img2sbuf_p0_wr_en              //|> o
  ,img2sbuf_p1_wr_addr            //|> o
  ,img2sbuf_p1_wr_data            //|> o
  ,img2sbuf_p1_wr_en              //|> o
  ,img_dat2cvif_rd_req_pd         //|> o
  ,img_dat2cvif_rd_req_valid      //|> o
  ,img_dat2mcif_rd_req_pd         //|> o
  ,img_dat2mcif_rd_req_valid      //|> o
  ,mcif2img_dat_rd_rsp_ready      //|> o
  ,sg2pack_data_entries           //|> o
  ,sg2pack_entry_end              //|> o
  ,sg2pack_entry_mid              //|> o
  ,sg2pack_entry_st               //|> o
  ,sg2pack_height_total           //|> o
  ,sg2pack_img_pd                 //|> o
  ,sg2pack_img_pvld               //|> o
  ,sg2pack_mn_enable              //|> o
  ,sg2pack_sub_h_end              //|> o
  ,sg2pack_sub_h_mid              //|> o
  ,sg2pack_sub_h_st               //|> o
  ,sg_is_done                     //|> o
  );


input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cvif2img_dat_rd_rsp_pd;
input          cvif2img_dat_rd_rsp_valid;
input   [11:0] img2status_dat_entries;
input          img2status_dat_updt;
input          img_dat2cvif_rd_req_ready;
input          img_dat2mcif_rd_req_ready;
input          is_running;
input          layer_st;
input  [513:0] mcif2img_dat_rd_rsp_pd;
input          mcif2img_dat_rd_rsp_valid;
input   [10:0] pixel_order;
input          pixel_planar;
input    [3:0] pixel_planar0_bundle_limit;
input    [3:0] pixel_planar0_bundle_limit_1st;
input    [4:0] pixel_planar0_byte_sft;
input    [3:0] pixel_planar0_lp_burst;
input          pixel_planar0_lp_vld;
input    [3:0] pixel_planar0_rp_burst;
input          pixel_planar0_rp_vld;
input   [11:0] pixel_planar0_width_burst;
input    [4:0] pixel_planar1_bundle_limit;
input    [4:0] pixel_planar1_bundle_limit_1st;
input    [4:0] pixel_planar1_byte_sft;
input    [2:0] pixel_planar1_lp_burst;
input          pixel_planar1_lp_vld;
input    [2:0] pixel_planar1_rp_burst;
input          pixel_planar1_rp_vld;
input   [10:0] pixel_planar1_width_burst;
input   [31:0] pwrbus_ram_pd;
input          reg2dp_op_en;
input          sg2pack_img_prdy;
input   [11:0] status2dma_free_entries;
input          status2dma_fsm_switch;
output         cvif2img_dat_rd_rsp_ready;
output   [7:0] img2sbuf_p0_wr_addr;
output [255:0] img2sbuf_p0_wr_data;
output         img2sbuf_p0_wr_en;
output   [7:0] img2sbuf_p1_wr_addr;
output [255:0] img2sbuf_p1_wr_data;
output         img2sbuf_p1_wr_en;
output  [78:0] img_dat2cvif_rd_req_pd;
output         img_dat2cvif_rd_req_valid;
output  [78:0] img_dat2mcif_rd_req_pd;
output         img_dat2mcif_rd_req_valid;
output         mcif2img_dat_rd_rsp_ready;
output  [11:0] sg2pack_data_entries;
output  [11:0] sg2pack_entry_end;
output  [11:0] sg2pack_entry_mid;
output  [11:0] sg2pack_entry_st;
output  [12:0] sg2pack_height_total;
output  [10:0] sg2pack_img_pd;
output         sg2pack_img_pvld;
output         sg2pack_mn_enable;
output   [3:0] sg2pack_sub_h_end;
output   [3:0] sg2pack_sub_h_mid;
output   [3:0] sg2pack_sub_h_st;
output         sg_is_done;

input [2:0]         reg2dp_pixel_y_offset;
input [12:0]         reg2dp_datain_height;
input [0:0]       reg2dp_datain_ram_type;
input [31:0] reg2dp_datain_addr_high_0;
input [26:0]   reg2dp_datain_addr_low_0;
input [31:0] reg2dp_datain_addr_high_1;
input [26:0]   reg2dp_datain_addr_low_1;
input [26:0]             reg2dp_line_stride;
input [26:0]       reg2dp_uv_line_stride;
input [0:0]             reg2dp_mean_format;
input [11:0]             reg2dp_entries;
input [0:0]                  reg2dp_dma_en;

output [31:0]       dp2reg_img_rd_stall;
output [31:0]   dp2reg_img_rd_latency;

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
wire   [513:0] cvif2img_dat_rd_rsp_pd_d0;
wire           cvif2img_dat_rd_rsp_ready_d0;
wire           cvif2img_dat_rd_rsp_valid_d0;
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
wire    [10:0] dma_rsp_fifo_data;
wire           dma_rsp_fifo_req;
wire     [4:0] dma_rsp_w_burst_size;
wire           dp2reg_img_rd_stall_dec;
wire    [12:0] height_cnt_total_w;
wire           is_p0_req_real;
wire           is_p1_req_real;
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
wire   [513:0] mcif2img_dat_rd_rsp_pd_d0;
wire           mcif2img_dat_rd_rsp_ready_d0;
wire           mcif2img_dat_rd_rsp_valid_d0;
wire           planar1_enable;
wire    [11:0] pre_entry_mid_w;
wire     [3:0] pre_sub_h_end_d1;
wire     [3:0] pre_sub_h_mid_d1;
wire     [3:0] pre_sub_h_st_d1;
wire           rd_req_rdyi;
wire    [58:0] req_img_p0_addr_base_w;
wire     [3:0] req_img_p0_burst_size;
wire     [3:0] req_img_p0_burst_sub;
wire    [58:0] req_img_p1_addr_base_w;
wire     [4:0] req_img_p1_burst_size;
wire     [4:0] req_img_p1_burst_sub;
wire           req_reg_en;
wire   [511:0] rsp_dat;
wire           rsp_img_1st_burst_w;
wire   [511:0] rsp_img_data_sw_o0;
wire   [511:0] rsp_img_data_sw_o1;
wire   [511:0] rsp_img_data_sw_o10;
wire   [511:0] rsp_img_data_sw_o2;
wire   [511:0] rsp_img_data_sw_o3;
wire   [511:0] rsp_img_data_sw_o4;
wire   [511:0] rsp_img_data_sw_o5;
wire   [511:0] rsp_img_data_sw_o6;
wire   [511:0] rsp_img_data_sw_o7;
wire   [511:0] rsp_img_data_sw_o8;
wire   [511:0] rsp_img_data_sw_o9;
wire           sg2pack_img_layer_end;
wire           sg2pack_img_line_end;
wire     [3:0] sg2pack_img_p0_burst;
wire     [4:0] sg2pack_img_p1_burst;
wire    [10:0] sg2pack_pop_data;
wire           sg2pack_pop_ready;
wire           sg2pack_pop_req;
wire    [10:0] sg2pack_push_data;
wire           sg2pack_push_ready;
wire           sg2pack_push_req;
wire     [3:0] sub_h_end_limit;
wire     [3:0] sub_h_mid_w;
wire     [3:0] sub_h_st_limit;
reg     [11:0] cur_required_entry;
reg     [11:0] data_entries;
reg     [11:0] data_entries_w;
reg     [13:0] data_height;
reg     [13:0] data_height_w;
reg            dma_blocking;
reg     [10:0] dma_req_fifo_data;
reg            dma_req_fifo_req;
reg            dma_rsp_blocking;
reg            dma_rsp_bundle_end;
reg            dma_rsp_dummy;
reg            dma_rsp_end;
reg            dma_rsp_fifo_ready;
reg            dma_rsp_line_end;
reg            dma_rsp_line_st;
reg      [1:0] dma_rsp_mask;
reg            dma_rsp_planar;
reg      [4:0] dma_rsp_size;
reg      [4:0] dma_rsp_size_cnt;
reg      [4:0] dma_rsp_size_cnt_inc;
reg      [4:0] dma_rsp_size_cnt_w;
reg            dma_rsp_vld;
reg     [31:0] dp2reg_img_rd_latency;
reg     [31:0] dp2reg_img_rd_stall;
reg     [12:0] height_cnt_total;
reg     [11:0] img_entry_onfly;
reg     [11:0] img_entry_onfly_add;
reg            img_entry_onfly_en;
reg     [11:0] img_entry_onfly_sub;
reg     [11:0] img_entry_onfly_w;
reg            img_rd_latency_cen;
reg            img_rd_latency_clr;
reg            img_rd_latency_dec;
reg            img_rd_latency_inc;
reg            img_rd_stall_cen;
reg            img_rd_stall_clr;
reg            img_rd_stall_inc;
reg            is_1st_height;
reg            is_cbuf_enough;
reg            is_cbuf_ready;
reg            is_cbuf_ready_w;
reg            is_first_running;
reg            is_img_1st_burst;
reg            is_img_bundle_end;
reg            is_img_dummy;
reg            is_img_last_burst;
reg            is_img_last_planar;
reg            is_last_height;
reg            is_last_req;
reg            is_p0_1st_burst;
reg            is_p0_bundle_end;
reg            is_p0_cur_sec_end;
reg            is_p0_last_burst;
reg            is_p1_1st_burst;
reg            is_p1_bundle_end;
reg            is_p1_cur_sec_end;
reg            is_p1_last_burst;
reg            is_running_d1;
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
reg            mn_enable;
reg            mn_enable_d1;
reg            mon_data_entries_w;
reg            mon_dma_rsp_size_cnt_inc;
reg            mon_img_entry_onfly_w;
reg      [3:0] mon_pre_entry_end_w;
reg      [3:0] mon_pre_entry_st_w;
reg            mon_req_height_cnt_inc;
reg            mon_req_img_p0_addr;
reg            mon_req_img_p0_bundle_cnt_w;
reg            mon_req_img_p0_burst_offset_w;
reg            mon_req_img_p0_line_offset_w;
reg            mon_req_img_p0_sec_cnt_w;
reg            mon_req_img_p1_addr;
reg            mon_req_img_p1_bundle_cnt_w;
reg            mon_req_img_p1_burst_offset_w;
reg            mon_req_img_p1_line_offset_w;
reg            mon_req_img_p1_sec_cnt_w;
reg            mon_req_size_out;
reg            mon_rsp_img_p0_burst_cnt_inc;
reg    [255:0] mon_rsp_img_p0_data_d1_w;
reg            mon_rsp_img_p1_burst_cnt_inc;
reg    [255:0] mon_rsp_img_p1_data_d1_w;
reg            mon_total_required_entry;
reg      [8:0] outs_dp2reg_img_rd_latency;
reg     [11:0] pre_entry_end_d1;
reg     [11:0] pre_entry_end_w;
reg     [11:0] pre_entry_mid_d1;
reg     [11:0] pre_entry_st_d1;
reg     [11:0] pre_entry_st_w;
reg      [3:0] pre_sub_h_end;
reg      [3:0] pre_sub_h_mid;
reg      [3:0] pre_sub_h_st;
reg     [58:0] req_addr;
reg     [58:0] req_addr_d1;
reg            req_adv;
reg            req_bundle_end;
reg            req_bundle_end_d1;
reg            req_end_d1;
reg            req_grant_end;
reg            req_grant_end_d1;
reg     [12:0] req_height_cnt;
reg     [12:0] req_height_cnt_inc;
reg     [12:0] req_height_cnt_w;
reg            req_height_en;
reg      [4:0] req_img_burst_size;
reg     [58:0] req_img_p0_addr;
reg     [58:0] req_img_p0_addr_base;
reg      [3:0] req_img_p0_bundle_cnt;
reg      [3:0] req_img_p0_bundle_cnt_w;
reg     [11:0] req_img_p0_burst_cnt;
reg     [12:0] req_img_p0_burst_cnt_dec;
reg     [11:0] req_img_p0_burst_cnt_w;
reg            req_img_p0_burst_en;
reg     [26:0] req_img_p0_burst_offset;
reg            req_img_p0_burst_offset_en;
reg     [26:0] req_img_p0_burst_offset_w;
reg      [3:0] req_img_p0_cur_burst;
reg     [26:0] req_img_p0_line_offset;
reg     [26:0] req_img_p0_line_offset_w;
reg      [1:0] req_img_p0_sec_cnt;
reg      [1:0] req_img_p0_sec_cnt_w;
reg            req_img_p0_sec_en;
reg     [58:0] req_img_p1_addr;
reg     [58:0] req_img_p1_addr_base;
reg      [4:0] req_img_p1_bundle_cnt;
reg      [4:0] req_img_p1_bundle_cnt_w;
reg     [10:0] req_img_p1_burst_cnt;
reg     [11:0] req_img_p1_burst_cnt_dec;
reg     [10:0] req_img_p1_burst_cnt_w;
reg            req_img_p1_burst_en;
reg     [26:0] req_img_p1_burst_offset;
reg            req_img_p1_burst_offset_en;
reg     [26:0] req_img_p1_burst_offset_w;
reg      [4:0] req_img_p1_cur_burst;
reg     [26:0] req_img_p1_line_offset;
reg     [26:0] req_img_p1_line_offset_w;
reg      [1:0] req_img_p1_sec_cnt;
reg      [1:0] req_img_p1_sec_cnt_w;
reg            req_img_p1_sec_en;
reg            req_img_planar_cnt;
reg            req_img_planar_cnt_w;
reg            req_img_planar_en;
reg            req_img_reg_en;
reg            req_is_done;
reg            req_is_done_w;
reg            req_is_dummy;
reg            req_is_dummy_d1;
reg            req_line_end;
reg            req_line_end_d1;
reg            req_line_st;
reg            req_line_st_d1;
reg            req_planar_d1;
reg            req_ready_d1;
reg      [4:0] req_size;
reg      [4:0] req_size_d1;
reg      [4:0] req_size_out;
reg      [4:0] req_size_out_d1;
reg            req_valid;
reg            req_valid_d1;
reg            req_valid_d1_w;
reg            req_valid_w;
reg            rsp_img_1st_burst;
reg            rsp_img_bundle_done;
reg            rsp_img_bundle_done_d1;
reg            rsp_img_bundle_end;
reg    [255:0] rsp_img_c0l0;
reg            rsp_img_c0l0_wr_en;
reg            rsp_img_c0l0_wr_sel;
reg    [255:0] rsp_img_c1l0;
reg            rsp_img_c1l0_wr_en;
reg            rsp_img_c1l0_wr_sel;
reg            rsp_img_end;
reg            rsp_img_is_done;
reg            rsp_img_is_done_w;
reg    [255:0] rsp_img_l0_data;
reg            rsp_img_layer_end_d1;
reg            rsp_img_line_end;
reg            rsp_img_line_end_d1;
reg            rsp_img_line_st;
reg      [7:0] rsp_img_p0_addr;
reg      [7:0] rsp_img_p0_addr_d1;
reg      [3:0] rsp_img_p0_burst_cnt;
reg            rsp_img_p0_burst_cnt_en;
reg      [3:0] rsp_img_p0_burst_cnt_inc;
reg      [3:0] rsp_img_p0_burst_cnt_w;
reg      [3:0] rsp_img_p0_burst_size_d1;
reg            rsp_img_p0_burst_size_en;
reg      [3:0] rsp_img_p0_burst_size_w;
reg    [255:0] rsp_img_p0_cache_data;
reg    [255:0] rsp_img_p0_data;
reg    [255:0] rsp_img_p0_data_d1;
reg    [255:0] rsp_img_p0_data_d1_w;
reg    [255:0] rsp_img_p0_data_hi;
reg    [255:0] rsp_img_p0_data_lo;
reg    [255:0] rsp_img_p0_data_w;
reg            rsp_img_p0_planar0_en;
reg      [6:0] rsp_img_p0_planar0_idx;
reg      [7:0] rsp_img_p0_planar0_idx_inc;
reg      [6:0] rsp_img_p0_planar0_idx_w;
reg            rsp_img_p0_planar1_en;
reg      [6:0] rsp_img_p0_planar1_idx;
reg      [7:0] rsp_img_p0_planar1_idx_inc;
reg      [6:0] rsp_img_p0_planar1_idx_w;
reg            rsp_img_p0_vld;
reg            rsp_img_p0_vld_d1;
reg            rsp_img_p0_vld_d1_w;
reg            rsp_img_p0_vld_w;
reg      [7:0] rsp_img_p1_addr;
reg      [7:0] rsp_img_p1_addr_d1;
reg      [4:0] rsp_img_p1_burst_cnt;
reg            rsp_img_p1_burst_cnt_en;
reg      [4:0] rsp_img_p1_burst_cnt_inc;
reg      [4:0] rsp_img_p1_burst_cnt_w;
reg      [4:0] rsp_img_p1_burst_size_d1;
reg            rsp_img_p1_burst_size_en;
reg      [4:0] rsp_img_p1_burst_size_w;
reg    [255:0] rsp_img_p1_data;
reg    [255:0] rsp_img_p1_data_d1;
reg    [255:0] rsp_img_p1_data_d1_w;
reg    [255:0] rsp_img_p1_data_hi;
reg    [255:0] rsp_img_p1_data_lo;
reg    [255:0] rsp_img_p1_data_w;
reg            rsp_img_p1_planar0_en;
reg      [6:0] rsp_img_p1_planar0_idx;
reg      [7:0] rsp_img_p1_planar0_idx_inc;
reg      [6:0] rsp_img_p1_planar0_idx_w;
reg            rsp_img_p1_planar1_en;
reg      [6:0] rsp_img_p1_planar1_idx;
reg      [7:0] rsp_img_p1_planar1_idx_inc;
reg      [6:0] rsp_img_p1_planar1_idx_w;
reg            rsp_img_p1_vld;
reg            rsp_img_p1_vld_d1;
reg            rsp_img_p1_vld_d1_w;
reg            rsp_img_p1_vld_w;
reg            rsp_img_planar;
reg      [1:0] rsp_img_planar_idx_add;
reg            rsp_img_req_end;
reg     [10:0] rsp_img_sel;
reg      [4:0] rsp_img_sft;
reg            rsp_img_vld;
reg            rsp_img_vld_w;
reg      [4:0] rsp_img_w_burst_size;
reg            sg_is_done;
reg            sg_is_done_w;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg            sub_h_end_sel;
reg      [3:0] sub_h_end_w;
reg            sub_h_st_sel;
reg      [3:0] sub_h_st_w;
reg     [11:0] total_required_entry;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// general signal                                                     //
////////////////////////////////////////////////////////////////////////

assign planar1_enable = pixel_planar;

always @(
  reg2dp_datain_height
  ) begin
    data_height_w = reg2dp_datain_height + 1'b1;
end

assign height_cnt_total_w = reg2dp_datain_height;


always @(
  reg2dp_mean_format
  ) begin
    mn_enable = (reg2dp_mean_format == 1'h1 );
end

always @(
  reg2dp_entries
  ) begin
    {mon_data_entries_w,
     data_entries_w} = reg2dp_entries + 1'b1;
end

always @(
  is_running
  or is_running_d1
  ) begin
    is_first_running = is_running & ~is_running_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_running_d1 <= 1'b0;
  end else begin
  is_running_d1 <= is_running;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mn_enable_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    mn_enable_d1 <= mn_enable;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    mn_enable_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
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
    height_cnt_total <= {13{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    height_cnt_total <= height_cnt_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    height_cnt_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! Pixel height offset is not zero!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (is_running & (|reg2dp_pixel_y_offset))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error config! data_entries_w is much to big!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_data_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  generator preparing parameters                                    //
////////////////////////////////////////////////////////////////////////
///////////// sub_h for total control /////////////

assign sub_h_st_limit = 4'b1;
assign sub_h_mid_w = 4'h1;
assign sub_h_end_limit = 4'h1;
assign pre_entry_mid_w = data_entries[12 -1:0];

always @(
  data_height
  or sub_h_st_limit
  ) begin
    sub_h_st_sel = (~(|data_height[13:4]) && (data_height[3:0] <= sub_h_st_limit));
end

always @(
  sub_h_st_sel
  or data_height
  or sub_h_st_limit
  ) begin
    sub_h_st_w = sub_h_st_sel ? data_height[3:0] : sub_h_st_limit;
end

always @(
  data_height
  or sub_h_end_limit
  ) begin
    sub_h_end_sel = (~(|data_height[13:4]) && (data_height[3:0] <= sub_h_end_limit));
end

always @(
  sub_h_end_sel
  or data_height
  or sub_h_end_limit
  ) begin
    sub_h_end_w = sub_h_end_sel ? data_height[3:0] : sub_h_end_limit;
end

always @(
  sub_h_st_w
  or data_entries
  ) begin
    {mon_pre_entry_st_w,
     pre_entry_st_w} = sub_h_st_w * data_entries;
end

always @(
  sub_h_end_w
  or data_entries
  ) begin
    {mon_pre_entry_end_w,
     pre_entry_end_w} = sub_h_end_w * data_entries;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pre_sub_h_st <= {4{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_sub_h_st <= sub_h_st_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_sub_h_st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    pre_sub_h_mid <= {4{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_sub_h_mid <= sub_h_mid_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_sub_h_mid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    pre_sub_h_end <= {4{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_sub_h_end <= sub_h_end_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_sub_h_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    pre_entry_st_d1 <= {12{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_entry_st_d1 <= pre_entry_st_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_entry_st_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    pre_entry_mid_d1 <= {12{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_entry_mid_d1 <= pre_entry_mid_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_entry_mid_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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
    pre_entry_end_d1 <= {12{1'b0}};
  end else begin
  if ((is_first_running) == 1'b1) begin
    pre_entry_end_d1 <= pre_entry_end_w;
  // VCS coverage off
  end else if ((is_first_running) == 1'b0) begin
  end else begin
    pre_entry_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
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

assign pre_sub_h_st_d1 = pre_sub_h_st;
assign pre_sub_h_mid_d1 = pre_sub_h_mid;
assign pre_sub_h_end_d1 = pre_sub_h_end;

////////////////////////////////////////////////////////////////////////
//  request generator for input image                                 //
////////////////////////////////////////////////////////////////////////
localparam SRC_DUMMY  = 2'h0;
localparam SRC_P0     = 2'h1;
localparam SRC_P1     = 2'h2;

///////////// height counter /////////////

always @(
  req_height_cnt
  ) begin
    {mon_req_height_cnt_inc,
     req_height_cnt_inc} = req_height_cnt + 1'b1;
end

always @(
  req_height_cnt
  ) begin
    is_1st_height = ~(|req_height_cnt);
end

always @(
  req_height_cnt
  or height_cnt_total
  ) begin
    is_last_height = (req_height_cnt == height_cnt_total);
end

always @(
  is_first_running
  or req_height_cnt_inc
  ) begin
    req_height_cnt_w = (is_first_running) ? 13'b0 :
                       req_height_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_height_cnt <= {13{1'b0}};
  end else begin
  if ((req_height_en) == 1'b1) begin
    req_height_cnt <= req_height_cnt_w;
  // VCS coverage off
  end else if ((req_height_en) == 1'b0) begin
  end else begin
    req_height_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_height_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


///////////// image planar count /////////////
always @(
  req_img_planar_cnt
  or pixel_planar
  ) begin
    is_img_last_planar = (req_img_planar_cnt == pixel_planar);
end

always @(
  is_first_running
  or is_img_last_planar
  or req_img_planar_cnt
  ) begin
    req_img_planar_cnt_w = (is_first_running | is_img_last_planar) ? 1'b0 :
                           ~req_img_planar_cnt;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_planar_cnt <= 1'b0;
  end else begin
  if ((req_img_planar_en) == 1'b1) begin
    req_img_planar_cnt <= req_img_planar_cnt_w;
  // VCS coverage off
  end else if ((req_img_planar_en) == 1'b0) begin
  end else begin
    req_img_planar_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_planar_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// image planar 0 bundle and burst count /////////////

always @(
  is_first_running
  or is_p0_last_burst
  or pixel_planar0_bundle_limit_1st
  or is_p0_bundle_end
  or pixel_planar0_bundle_limit
  or req_img_p0_bundle_cnt
  or req_img_p0_cur_burst
  ) begin
    {mon_req_img_p0_bundle_cnt_w,
     req_img_p0_bundle_cnt_w} = (is_first_running | is_p0_last_burst) ? {1'b0, pixel_planar0_bundle_limit_1st} :
                                is_p0_bundle_end ? {1'b0, pixel_planar0_bundle_limit} :
                                req_img_p0_bundle_cnt - req_img_p0_cur_burst;
end

assign req_img_p0_burst_sub = req_img_p0_bundle_cnt;

always @(
  req_img_p0_burst_cnt
  or req_img_p0_burst_sub
  ) begin
    req_img_p0_burst_cnt_dec = req_img_p0_burst_cnt - req_img_p0_burst_sub;
end

always @(
  req_img_p0_burst_cnt_dec
  or req_img_p0_burst_cnt
  or req_img_p0_burst_sub
  ) begin
    req_img_p0_cur_burst = req_img_p0_burst_cnt_dec[13  -1] ? req_img_p0_burst_cnt[3:0] : req_img_p0_burst_sub;
end

always @(
  is_first_running
  or is_p0_last_burst
  or pixel_planar0_lp_vld
  or pixel_planar0_lp_burst
  or pixel_planar0_width_burst
  or req_img_p0_sec_cnt
  or is_p0_cur_sec_end
  or pixel_planar0_rp_burst
  or req_img_p0_burst_cnt_dec
  ) begin
    req_img_p0_burst_cnt_w = ((is_first_running | is_p0_last_burst) & pixel_planar0_lp_vld) ? {{8{1'b0}}, pixel_planar0_lp_burst} :
                             ((is_first_running | is_p0_last_burst) & ~pixel_planar0_lp_vld) ? pixel_planar0_width_burst :
                             ((req_img_p0_sec_cnt == 2'h0) & is_p0_cur_sec_end) ? pixel_planar0_width_burst :
                             ((req_img_p0_sec_cnt == 2'h1) & is_p0_cur_sec_end) ? {{8{1'b0}}, pixel_planar0_rp_burst} :
                             req_img_p0_burst_cnt_dec[11:0];
end

always @(
  is_first_running
  or is_p0_last_burst
  or pixel_planar0_lp_vld
  or req_img_p0_sec_cnt
  ) begin
    {mon_req_img_p0_sec_cnt_w,
     req_img_p0_sec_cnt_w} = ((is_first_running | is_p0_last_burst) & pixel_planar0_lp_vld) ? 3'h0 :
                             ((is_first_running | is_p0_last_burst) & ~pixel_planar0_lp_vld) ? 3'h1 :
                             req_img_p0_sec_cnt + 1'b1;
end

always @(
  req_img_p0_burst_cnt_dec
  or req_img_p0_burst_cnt
  or req_img_p0_burst_sub
  ) begin
    is_p0_cur_sec_end = req_img_p0_burst_cnt_dec[13  -1] | (req_img_p0_burst_cnt == {{8{1'b0}}, req_img_p0_burst_sub});
end

always @(
  req_img_p0_burst_cnt
  or pixel_planar0_lp_burst
  or req_img_p0_sec_cnt
  or pixel_planar0_width_burst
  or pixel_planar0_lp_vld
  ) begin
    is_p0_1st_burst = ((req_img_p0_burst_cnt == {{8{1'b0}}, pixel_planar0_lp_burst}) & (req_img_p0_sec_cnt == 2'h0)) |
                      ((req_img_p0_burst_cnt == pixel_planar0_width_burst) & (req_img_p0_sec_cnt == 2'h1) & ~pixel_planar0_lp_vld);
end

always @(
  is_p0_cur_sec_end
  or req_img_p0_sec_cnt
  or pixel_planar0_rp_vld
  ) begin
    is_p0_last_burst = (is_p0_cur_sec_end & (req_img_p0_sec_cnt == 2'h1) & ~pixel_planar0_rp_vld) |
                       (is_p0_cur_sec_end & (req_img_p0_sec_cnt == 2'h2));
end

always @(
  req_img_p0_cur_burst
  or req_img_p0_bundle_cnt
  or is_p0_last_burst
  ) begin
    is_p0_bundle_end = (req_img_p0_cur_burst == req_img_p0_bundle_cnt) | is_p0_last_burst;
end

assign req_img_p0_burst_size = req_img_p0_cur_burst;

assign is_p0_req_real = (req_img_p0_sec_cnt == 2'b1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p0_bundle_cnt <= {4{1'b0}};
  end else begin
  if ((req_img_p0_burst_en) == 1'b1) begin
    req_img_p0_bundle_cnt <= req_img_p0_bundle_cnt_w;
  // VCS coverage off
  end else if ((req_img_p0_burst_en) == 1'b0) begin
  end else begin
    req_img_p0_bundle_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p0_burst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p0_burst_cnt <= {12{1'b0}};
  end else begin
  if ((req_img_p0_burst_en) == 1'b1) begin
    req_img_p0_burst_cnt <= req_img_p0_burst_cnt_w;
  // VCS coverage off
  end else if ((req_img_p0_burst_en) == 1'b0) begin
  end else begin
    req_img_p0_burst_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p0_burst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p0_sec_cnt <= {2{1'b0}};
  end else begin
  if ((req_img_p0_sec_en) == 1'b1) begin
    req_img_p0_sec_cnt <= req_img_p0_sec_cnt_w;
  // VCS coverage off
  end else if ((req_img_p0_sec_en) == 1'b0) begin
  end else begin
    req_img_p0_sec_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p0_sec_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p0_bundle_cnt_w is overflow!")      zzz_assert_never_18x (nvdla_core_clk, `ASSERT_RESET, (req_img_p0_burst_en & mon_req_img_p0_bundle_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p0_sec_cnt_w is overflow!")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (req_img_p0_burst_en & mon_req_img_p0_sec_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// image planar 1 bundle and burst count /////////////

always @(
  is_first_running
  or is_p1_last_burst
  or pixel_planar1_bundle_limit_1st
  or is_p1_bundle_end
  or pixel_planar1_bundle_limit
  or req_img_p1_bundle_cnt
  or req_img_p1_cur_burst
  ) begin
    {mon_req_img_p1_bundle_cnt_w,
     req_img_p1_bundle_cnt_w} = (is_first_running | is_p1_last_burst) ? {1'b0, pixel_planar1_bundle_limit_1st} :
                                is_p1_bundle_end ? {1'b0, pixel_planar1_bundle_limit} :
                                req_img_p1_bundle_cnt - req_img_p1_cur_burst;
end

assign req_img_p1_burst_sub = req_img_p1_bundle_cnt;

always @(
  req_img_p1_burst_cnt
  or req_img_p1_burst_sub
  ) begin
    req_img_p1_burst_cnt_dec = req_img_p1_burst_cnt - req_img_p1_burst_sub;
end

always @(
  req_img_p1_burst_cnt_dec
  or req_img_p1_burst_cnt
  or req_img_p1_burst_sub
  ) begin
    req_img_p1_cur_burst = req_img_p1_burst_cnt_dec[13  -2] ? req_img_p1_burst_cnt[4:0] : req_img_p1_burst_sub;
end

always @(
  is_first_running
  or is_p1_last_burst
  or pixel_planar1_lp_vld
  or pixel_planar1_lp_burst
  or pixel_planar1_width_burst
  or req_img_p1_sec_cnt
  or is_p1_cur_sec_end
  or pixel_planar1_rp_burst
  or req_img_p1_burst_cnt_dec
  ) begin
    req_img_p1_burst_cnt_w = ((is_first_running | is_p1_last_burst) & pixel_planar1_lp_vld) ? {{8{1'b0}}, pixel_planar1_lp_burst} :
                             ((is_first_running | is_p1_last_burst) & ~pixel_planar1_lp_vld) ? pixel_planar1_width_burst :
                             ((req_img_p1_sec_cnt == 2'h0) & is_p1_cur_sec_end) ? pixel_planar1_width_burst :
                             ((req_img_p1_sec_cnt == 2'h1) & is_p1_cur_sec_end) ? {{8{1'b0}}, pixel_planar1_rp_burst} :
                             req_img_p1_burst_cnt_dec[10:0];
end

always @(
  is_first_running
  or is_p1_last_burst
  or pixel_planar1_lp_vld
  or req_img_p1_sec_cnt
  ) begin
    {mon_req_img_p1_sec_cnt_w,
     req_img_p1_sec_cnt_w} = ((is_first_running | is_p1_last_burst) & pixel_planar1_lp_vld) ? 3'h0 :
                             ((is_first_running | is_p1_last_burst) & ~pixel_planar1_lp_vld) ? 3'h1 :
                             req_img_p1_sec_cnt + 1'b1;
end

assign req_img_p1_burst_size = req_img_p1_cur_burst;

always @(
  req_img_p1_burst_cnt_dec
  or req_img_p1_burst_cnt
  or req_img_p1_burst_sub
  ) begin
    is_p1_cur_sec_end = req_img_p1_burst_cnt_dec[13  -2] | (req_img_p1_burst_cnt == {{6{1'b0}}, req_img_p1_burst_sub});
end

always @(
  req_img_p1_burst_cnt
  or pixel_planar1_lp_burst
  or req_img_p1_sec_cnt
  or pixel_planar1_width_burst
  or pixel_planar1_lp_vld
  ) begin
    is_p1_1st_burst = ((req_img_p1_burst_cnt == {{8{1'b0}}, pixel_planar1_lp_burst}) & (req_img_p1_sec_cnt == 2'h0)) |
                      ((req_img_p1_burst_cnt == pixel_planar1_width_burst) & (req_img_p1_sec_cnt == 2'h1) & ~pixel_planar1_lp_vld);
end

always @(
  is_p1_cur_sec_end
  or req_img_p1_sec_cnt
  or pixel_planar1_rp_vld
  ) begin
    is_p1_last_burst = (is_p1_cur_sec_end & (req_img_p1_sec_cnt == 2'h1) & ~pixel_planar1_rp_vld) |
                       (is_p1_cur_sec_end & (req_img_p1_sec_cnt == 2'h2));
end

always @(
  req_img_p1_cur_burst
  or req_img_p1_bundle_cnt
  or is_p1_last_burst
  ) begin
    is_p1_bundle_end = (req_img_p1_cur_burst == req_img_p1_bundle_cnt) | is_p1_last_burst;
end

assign is_p1_req_real = (req_img_p1_sec_cnt == 2'b1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p1_bundle_cnt <= {5{1'b0}};
  end else begin
  if ((req_img_p1_burst_en) == 1'b1) begin
    req_img_p1_bundle_cnt <= req_img_p1_bundle_cnt_w;
  // VCS coverage off
  end else if ((req_img_p1_burst_en) == 1'b0) begin
  end else begin
    req_img_p1_bundle_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p1_burst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p1_burst_cnt <= {11{1'b0}};
  end else begin
  if ((req_img_p1_burst_en) == 1'b1) begin
    req_img_p1_burst_cnt <= req_img_p1_burst_cnt_w;
  // VCS coverage off
  end else if ((req_img_p1_burst_en) == 1'b0) begin
  end else begin
    req_img_p1_burst_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p1_burst_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p1_sec_cnt <= {2{1'b0}};
  end else begin
  if ((req_img_p1_sec_en) == 1'b1) begin
    req_img_p1_sec_cnt <= req_img_p1_sec_cnt_w;
  // VCS coverage off
  end else if ((req_img_p1_sec_en) == 1'b0) begin
  end else begin
    req_img_p1_sec_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p1_sec_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p1_bundle_cnt_w is overflow!")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (req_img_p1_burst_en & mon_req_img_p1_bundle_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p1_sec_cnt_w is overflow!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (req_img_p1_burst_en & mon_req_img_p1_sec_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// image burst signal /////////////
always @(
  req_img_planar_cnt
  or is_p0_1st_burst
  or is_p1_1st_burst
  ) begin
    is_img_1st_burst = ~req_img_planar_cnt ? is_p0_1st_burst : is_p1_1st_burst;
end

always @(
  req_img_planar_cnt
  or is_p0_last_burst
  or is_p1_last_burst
  ) begin
    is_img_last_burst = ~req_img_planar_cnt ? is_p0_last_burst : is_p1_last_burst;
end

always @(
  req_img_planar_cnt
  or is_p0_bundle_end
  or is_p1_bundle_end
  ) begin
    is_img_bundle_end = ~req_img_planar_cnt ? is_p0_bundle_end : is_p1_bundle_end;
end

always @(
  req_img_planar_cnt
  or req_img_p0_burst_size
  or req_img_p1_burst_size
  ) begin
    req_img_burst_size = ~req_img_planar_cnt ? {1'b0, req_img_p0_burst_size} : req_img_p1_burst_size;
end

always @(
  req_img_planar_cnt
  or is_p0_req_real
  or is_p1_req_real
  ) begin
    is_img_dummy = ~req_img_planar_cnt ? ~is_p0_req_real : ~is_p1_req_real;
end

///////////// control signal /////////////
always @(
  is_running
  or is_first_running
  or req_reg_en
  or is_last_req
  or req_valid
  ) begin
    req_valid_w = (~is_running) ? 1'b0 :
                  is_first_running ? 1'b1 :
                  (req_reg_en & is_last_req) ? 1'b0 :
                  req_valid;
end

always @(
  req_valid
  or req_valid_d1
  or req_ready_d1
  ) begin
    req_adv = req_valid & (~req_valid_d1 | req_ready_d1);
end

always @(
  is_img_last_burst
  or is_img_last_planar
  or is_last_height
  ) begin
    is_last_req = (is_img_last_burst & is_img_last_planar & is_last_height);
end

always @(
  req_adv
  ) begin
    req_img_reg_en = req_adv;
end

assign req_reg_en = req_adv;

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  ) begin
    req_img_p0_burst_en = is_first_running | (req_img_reg_en & ~req_img_planar_cnt);
end

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  or is_p0_cur_sec_end
  ) begin
    req_img_p0_sec_en = is_first_running | (req_img_reg_en & ~req_img_planar_cnt & is_p0_cur_sec_end);
end

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  ) begin
    req_img_p1_burst_en = is_first_running | (req_img_reg_en & req_img_planar_cnt);
end

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  or is_p1_cur_sec_end
  ) begin
    req_img_p1_sec_en = is_first_running | (req_img_reg_en & req_img_planar_cnt & is_p1_cur_sec_end);
end

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  or is_p0_req_real
  or is_p0_last_burst
  ) begin
    req_img_p0_burst_offset_en = is_first_running | (req_img_reg_en & ~req_img_planar_cnt & (is_p0_req_real | is_p0_last_burst));
end

always @(
  is_first_running
  or req_img_reg_en
  or req_img_planar_cnt
  or is_p1_req_real
  or is_p1_last_burst
  ) begin
    req_img_p1_burst_offset_en = is_first_running | (req_img_reg_en & req_img_planar_cnt & (is_p1_req_real | is_p1_last_burst));
end

always @(
  is_first_running
  or req_img_reg_en
  or is_img_bundle_end
  ) begin
    req_img_planar_en = is_first_running | (req_img_reg_en & is_img_bundle_end);
end

always @(
  is_first_running
  or req_img_reg_en
  or is_img_last_burst
  or is_img_last_planar
  ) begin
    req_height_en = is_first_running | (req_img_reg_en & is_img_last_burst & is_img_last_planar);
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_valid <= 1'b0;
  end else begin
  req_valid <= req_valid_w;
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! req_reg_en set when not running!")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (~is_running & req_reg_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_valid set when not running!")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (~is_running & req_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// address line offset for image /////////////

always @(
  is_first_running
  or req_img_p0_line_offset
  or reg2dp_line_stride
  ) begin
    {mon_req_img_p0_line_offset_w,
     req_img_p0_line_offset_w} = (is_first_running) ? 28'b0 :
                                 (req_img_p0_line_offset + reg2dp_line_stride);
end

always @(
  is_first_running
  or req_img_p1_line_offset
  or reg2dp_uv_line_stride
  ) begin
    {mon_req_img_p1_line_offset_w,
     req_img_p1_line_offset_w} = (is_first_running) ? 28'b0 :
                                 (req_img_p1_line_offset + reg2dp_uv_line_stride);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p0_line_offset <= {27{1'b0}};
  end else begin
  if ((req_height_en) == 1'b1) begin
    req_img_p0_line_offset <= req_img_p0_line_offset_w;
  // VCS coverage off
  end else if ((req_height_en) == 1'b0) begin
  end else begin
    req_img_p0_line_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_height_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p1_line_offset <= {27{1'b0}};
  end else begin
  if ((req_height_en & planar1_enable) == 1'b1) begin
    req_img_p1_line_offset <= req_img_p1_line_offset_w;
  // VCS coverage off
  end else if ((req_height_en & planar1_enable) == 1'b0) begin
  end else begin
    req_img_p1_line_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_height_en & planar1_enable))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p0_line_offset_w is overflow!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (req_height_en & mon_req_img_p0_line_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p1_line_offset_w is overflow!")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (req_height_en & planar1_enable & mon_req_img_p1_line_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// address burst offset for image /////////////

always @(
  is_first_running
  or is_p0_last_burst
  or req_img_p0_burst_offset
  or req_img_p0_cur_burst
  ) begin
    {mon_req_img_p0_burst_offset_w,
     req_img_p0_burst_offset_w} = (is_first_running | is_p0_last_burst) ? 28'b0 :
                                  (req_img_p0_burst_offset + req_img_p0_cur_burst);
end

always @(
  is_first_running
  or is_p1_last_burst
  or req_img_p1_burst_offset
  or req_img_p1_cur_burst
  ) begin
    {mon_req_img_p1_burst_offset_w,
     req_img_p1_burst_offset_w} = (is_first_running | is_p1_last_burst) ? 28'b0 :
                                  (req_img_p1_burst_offset + req_img_p1_cur_burst);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p0_burst_offset <= {27{1'b0}};
  end else begin
  if ((req_img_p0_burst_offset_en) == 1'b1) begin
    req_img_p0_burst_offset <= req_img_p0_burst_offset_w;
  // VCS coverage off
  end else if ((req_img_p0_burst_offset_en) == 1'b0) begin
  end else begin
    req_img_p0_burst_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p0_burst_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_img_p1_burst_offset <= {27{1'b0}};
  end else begin
  if ((req_img_p1_burst_offset_en) == 1'b1) begin
    req_img_p1_burst_offset <= req_img_p1_burst_offset_w;
  // VCS coverage off
  end else if ((req_img_p1_burst_offset_en) == 1'b0) begin
  end else begin
    req_img_p1_burst_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_img_p1_burst_offset_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p0_burst_offset_w is overflow!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (req_img_p0_burst_offset_en & mon_req_img_p0_burst_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_img_p1_burst_offset_w is overflow!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (req_img_p1_burst_offset_en & mon_req_img_p1_burst_offset_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

///////////// address base for image /////////////

assign req_img_p0_addr_base_w = {reg2dp_datain_addr_high_0, reg2dp_datain_addr_low_0};
assign req_img_p1_addr_base_w = {reg2dp_datain_addr_high_1, reg2dp_datain_addr_low_1};

always @(
  req_img_p0_addr_base
  or req_img_p0_line_offset
  or req_img_p0_burst_offset
  ) begin
    {mon_req_img_p0_addr,
     req_img_p0_addr} = req_img_p0_addr_base + req_img_p0_line_offset + req_img_p0_burst_offset;
end

always @(
  req_img_p1_addr_base
  or req_img_p1_line_offset
  or req_img_p1_burst_offset
  ) begin
    {mon_req_img_p1_addr,
     req_img_p1_addr} = req_img_p1_addr_base + req_img_p1_line_offset + req_img_p1_burst_offset;
end

always @(posedge nvdla_core_clk) begin
  if ((layer_st) == 1'b1) begin
    req_img_p0_addr_base <= req_img_p0_addr_base_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    req_img_p0_addr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((layer_st) == 1'b1) begin
    req_img_p1_addr_base <= req_img_p1_addr_base_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    req_img_p1_addr_base <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


///////////// request package /////////////

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

always @(
  req_img_planar_cnt
  or req_img_p0_addr
  or req_img_p1_addr
  ) begin
    req_addr = ~req_img_planar_cnt ? req_img_p0_addr :
               req_img_p1_addr;
end

always @(
  req_img_burst_size
  ) begin
    req_size = req_img_burst_size;
end

always @(
  req_img_burst_size
  ) begin
    {mon_req_size_out,
     req_size_out} = req_img_burst_size - 1'b1;
end

always @(
  is_img_1st_burst
  ) begin
    req_line_st = is_img_1st_burst;
end

always @(
  is_img_bundle_end
  or is_img_last_planar
  ) begin
    req_bundle_end = (is_img_bundle_end & is_img_last_planar);
end

always @(
  is_img_last_burst
  or is_img_last_planar
  ) begin
    req_line_end = (is_img_last_burst & is_img_last_planar);
end

always @(
  is_img_last_burst
  or is_img_last_planar
  ) begin
    req_grant_end = (is_img_last_burst & is_img_last_planar);
end

always @(
  is_img_dummy
  ) begin
    req_is_dummy = is_img_dummy;
end

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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_size_d1 <= {5{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_size_d1 <= req_size;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_size_out_d1 <= {5{1'b0}};
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_size_out_d1 <= req_size_out;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_line_st_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_line_st_d1 <= req_line_st;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_line_st_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_bundle_end_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_bundle_end_d1 <= req_bundle_end;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_bundle_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_line_end_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_line_end_d1 <= req_line_end;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_line_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_grant_end_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_grant_end_d1 <= req_grant_end;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_grant_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_end_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_end_d1 <= is_last_req;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_planar_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_planar_d1 <= req_img_planar_cnt;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_planar_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_is_dummy_d1 <= 1'b0;
  end else begin
  if ((req_reg_en) == 1'b1) begin
    req_is_dummy_d1 <= req_is_dummy;
  // VCS coverage off
  end else if ((req_reg_en) == 1'b0) begin
  end else begin
    req_is_dummy_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! req_size_out is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (req_reg_en & mon_req_size_out)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    if(req_valid_d1 & req_ready_d1)
    begin
        $display("[CDMA IMG REQ] Dummy = %d, Addr = 0x%010h, size = %0d, time = %0d", req_is_dummy_d1, req_addr_d1, req_size_d1, $stime);
    end
end
`endif

////////////////////////////////////////////////////////////////////////
//  request arbiter and cbuf entry monitor                            //
////////////////////////////////////////////////////////////////////////
always @(
  dma_rd_req_rdy
  or req_is_dummy_d1
  or dma_req_fifo_ready
  or is_cbuf_ready
  ) begin
    req_ready_d1 = ((dma_rd_req_rdy | req_is_dummy_d1) & dma_req_fifo_ready & is_cbuf_ready);
end

always @(
  is_first_running
  or req_valid_d1
  or req_ready_d1
  or req_end_d1
  or req_is_done
  ) begin
    req_is_done_w = is_first_running ? 1'b0 :
                    (req_valid_d1 & req_ready_d1 & req_end_d1) ? 1'b1 :
                    req_is_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_is_done <= 1'b1;
  end else begin
  req_is_done <= req_is_done_w;
  end
end

///////////// cbuf monitor /////////////

always @(
  is_cbuf_ready
  or req_is_done
  or is_last_height
  or pre_entry_end_d1
  or is_1st_height
  or pre_entry_st_d1
  or pre_entry_mid_d1
  ) begin
    cur_required_entry = (is_cbuf_ready | req_is_done) ? 12'b0 :
                         is_last_height ? pre_entry_end_d1 :
                         is_1st_height ? pre_entry_st_d1 :
                         pre_entry_mid_d1;
end

always @(
  cur_required_entry
  or img_entry_onfly
  ) begin
    {mon_total_required_entry,
     total_required_entry} = cur_required_entry + img_entry_onfly;
end

always @(
  status2dma_free_entries
  or total_required_entry
  ) begin
    is_cbuf_enough = (status2dma_free_entries >= total_required_entry);
end

always @(
  is_running
  or is_first_running
  or req_valid_d1
  or req_ready_d1
  or req_grant_end_d1
  or is_cbuf_ready
  or is_cbuf_enough
  ) begin
    is_cbuf_ready_w = (~is_running | is_first_running) ? 1'b0 :
                      (req_valid_d1 & req_ready_d1 & req_grant_end_d1) ? 1'b0 :
                      (~is_cbuf_ready) ? is_cbuf_enough :
                      is_cbuf_ready;
end

always @(
  img2status_dat_updt
  or img2status_dat_entries
  ) begin
    img_entry_onfly_sub = img2status_dat_updt ? img2status_dat_entries :
                          12'b0;
end

always @(
  req_is_done
  or is_cbuf_enough
  or is_cbuf_ready
  or cur_required_entry
  ) begin
    img_entry_onfly_add = (~req_is_done & is_cbuf_enough & ~is_cbuf_ready) ? cur_required_entry :
                          12'b0;
end

always @(
  img_entry_onfly
  or img_entry_onfly_add
  or img_entry_onfly_sub
  ) begin
    {mon_img_entry_onfly_w,
     img_entry_onfly_w} = img_entry_onfly + img_entry_onfly_add - img_entry_onfly_sub;
end

always @(
  req_is_done
  or is_cbuf_enough
  or is_cbuf_ready
  or img2status_dat_updt
  ) begin
    img_entry_onfly_en = (~req_is_done & is_cbuf_enough & ~is_cbuf_ready) | img2status_dat_updt;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_cbuf_ready <= 1'b0;
  end else begin
  is_cbuf_ready <= is_cbuf_ready_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_entry_onfly <= {12{1'b0}};
  end else begin
  if ((img_entry_onfly_en) == 1'b1) begin
    img_entry_onfly <= img_entry_onfly_w;
  // VCS coverage off
  end else if ((img_entry_onfly_en) == 1'b0) begin
  end else begin
    img_entry_onfly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(img_entry_onfly_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! total_required_entry is overflow!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (mon_total_required_entry & ~is_cbuf_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! total_required_entry is out of range!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, ((total_required_entry > 3840) & ~req_is_done_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! img_entry_onfly_w is overflow!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (mon_img_entry_onfly_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! img_entry_onfly_w is out of range!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (img_entry_onfly_w > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! img_entry_onfly is not empty when idle!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (~is_running & (|img_entry_onfly))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA IMG read request interface                                   //
////////////////////////////////////////////////////////////////////////

// rd Channel: Request 
assign cv_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b0);
assign mc_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b1);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_type == 1'b0);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_type == 1'b1);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;
assign dma_rd_req_rdy= rd_req_rdyi;
NV_NVDLA_CDMA_IMG_SG_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])     //|< w
  ,.mc_dma_rd_req_vld   (mc_dma_rd_req_vld)       //|< w
  ,.mc_int_rd_req_ready (mc_int_rd_req_ready)     //|< w
  ,.mc_dma_rd_req_rdy   (mc_dma_rd_req_rdy)       //|> w
  ,.mc_int_rd_req_pd    (mc_int_rd_req_pd[78:0])  //|> w
  ,.mc_int_rd_req_valid (mc_int_rd_req_valid)     //|> w
  );
NV_NVDLA_CDMA_IMG_SG_pipe_p2 pipe_p2 (
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
assign img_dat2mcif_rd_req_valid = mc_int_rd_req_valid_d0;
assign mc_int_rd_req_ready_d0 = img_dat2mcif_rd_req_ready;
assign img_dat2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d0[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
assign img_dat2cvif_rd_req_valid = cv_int_rd_req_valid_d0;
assign cv_int_rd_req_ready_d0 = img_dat2cvif_rd_req_ready;
assign img_dat2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d0[78:0];

// rd Channel: Response

assign mcif2img_dat_rd_rsp_valid_d0 = mcif2img_dat_rd_rsp_valid;
assign mcif2img_dat_rd_rsp_ready = mcif2img_dat_rd_rsp_ready_d0;
assign mcif2img_dat_rd_rsp_pd_d0[513:0] = mcif2img_dat_rd_rsp_pd[513:0];
assign mc_int_rd_rsp_valid = mcif2img_dat_rd_rsp_valid_d0;
assign mcif2img_dat_rd_rsp_ready_d0 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2img_dat_rd_rsp_pd_d0[513:0];


assign cvif2img_dat_rd_rsp_valid_d0 = cvif2img_dat_rd_rsp_valid;
assign cvif2img_dat_rd_rsp_ready = cvif2img_dat_rd_rsp_ready_d0;
assign cvif2img_dat_rd_rsp_pd_d0[513:0] = cvif2img_dat_rd_rsp_pd[513:0];
assign cv_int_rd_rsp_valid = cvif2img_dat_rd_rsp_valid_d0;
assign cvif2img_dat_rd_rsp_ready_d0 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2img_dat_rd_rsp_pd_d0[513:0];

NV_NVDLA_CDMA_IMG_SG_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.mc_int_rd_rsp_pd    (mc_int_rd_rsp_pd[513:0]) //|< w
  ,.mc_int_rd_rsp_valid (mc_int_rd_rsp_valid)     //|< w
  ,.mc_dma_rd_rsp_pd    (mc_dma_rd_rsp_pd[513:0]) //|> w
  ,.mc_dma_rd_rsp_vld   (mc_dma_rd_rsp_vld)       //|> w
  ,.mc_int_rd_rsp_ready (mc_int_rd_rsp_ready)     //|> w
  );
NV_NVDLA_CDMA_IMG_SG_pipe_p4 pipe_p4 (
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



// PKT_PACK_WIRE( dma_read_cmd ,  dma_rd_req_ ,  dma_rd_req_pd )
assign       dma_rd_req_pd[63:0] =     dma_rd_req_addr[63:0];
assign       dma_rd_req_pd[78:64] =     dma_rd_req_size[14:0];
assign dma_rd_req_vld = req_valid_d1 & dma_req_fifo_ready & is_cbuf_ready & ~req_is_dummy_d1;
assign dma_rd_req_addr = {req_addr_d1[58:0], 5'b0};
assign dma_rd_req_size = {{10{1'b0}}, req_size_out_d1};
assign dma_rd_req_type = reg2dp_datain_ram_type;
assign dma_rd_rsp_rdy = ~dma_blocking;

always @(
  dma_rsp_blocking
  ) begin
    dma_blocking = dma_rsp_blocking;
end


NV_NVDLA_CDMA_IMG_fifo u_NV_NVDLA_CDMA_IMG_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (dma_req_fifo_ready)      //|> w
  ,.wr_req              (dma_req_fifo_req)        //|< r
  ,.wr_data             (dma_req_fifo_data[10:0]) //|< r
  ,.rd_ready            (dma_rsp_fifo_ready)      //|< r
  ,.rd_req              (dma_rsp_fifo_req)        //|> w
  ,.rd_data             (dma_rsp_fifo_data[10:0]) //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

always @(
  req_valid_d1
  or is_cbuf_ready
  or dma_rd_req_rdy
  or req_is_dummy_d1
  ) begin
    dma_req_fifo_req = req_valid_d1 & is_cbuf_ready & (dma_rd_req_rdy | req_is_dummy_d1) ;
end

always @(
  req_planar_d1
  or req_end_d1
  or req_line_end_d1
  or req_bundle_end_d1
  or req_line_st_d1
  or req_is_dummy_d1
  or req_size_d1
  ) begin
    dma_req_fifo_data = {req_planar_d1,
                         req_end_d1,
                         req_line_end_d1,
                         req_bundle_end_d1,
                         req_line_st_d1,
                         req_is_dummy_d1,
                         req_size_d1};
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Receive input data when not busy")      zzz_assert_never_53x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & ~is_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA IMG read response logic                                      //
////////////////////////////////////////////////////////////////////////



// PKT_UNPACK_WIRE( dma_read_data , dma_rd_rsp_ , dma_rd_rsp_pd )
assign       dma_rd_rsp_data[511:0] =    dma_rd_rsp_pd[511:0];
assign       dma_rd_rsp_mask[1:0] =    dma_rd_rsp_pd[513:512];

always @(
  dma_rsp_fifo_data
  ) begin
    {dma_rsp_planar,
     dma_rsp_end,
     dma_rsp_line_end,
     dma_rsp_bundle_end,
     dma_rsp_line_st,
     dma_rsp_dummy,
     dma_rsp_size} = dma_rsp_fifo_data;
end


always @(
  dma_rsp_fifo_req
  or dma_rsp_dummy
  ) begin
    dma_rsp_blocking = (dma_rsp_fifo_req & dma_rsp_dummy);
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  or dma_rd_rsp_mask
  ) begin
    dma_rsp_mask[0] = (~dma_rsp_fifo_req) ? 1'b0 :
                      ~dma_rsp_dummy ? (dma_rd_rsp_vld & dma_rd_rsp_mask[0]) :
                      1'b1;
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  or dma_rd_rsp_mask
  or dma_rsp_size
  or dma_rsp_size_cnt
  ) begin
    dma_rsp_mask[1] = (~dma_rsp_fifo_req) ? 1'b0 :
                      ~dma_rsp_dummy ? (dma_rd_rsp_vld & dma_rd_rsp_mask[1]) :
                      (dma_rsp_size[4:1] == dma_rsp_size_cnt[4:1]) ? 1'b0 :
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
    dma_rsp_size_cnt_w = (dma_rsp_size_cnt_inc == dma_rsp_size) ? 5'b0 :
                         dma_rsp_size_cnt_inc;
end

always @(
  dma_rsp_fifo_req
  or dma_rsp_dummy
  or dma_rd_rsp_vld
  ) begin
    dma_rsp_vld = dma_rsp_fifo_req & (dma_rsp_dummy | dma_rd_rsp_vld);
end

always @(
  dma_rsp_vld
  or dma_rsp_size_cnt_inc
  or dma_rsp_size
  ) begin
    dma_rsp_fifo_ready = (dma_rsp_vld & (dma_rsp_size_cnt_inc == dma_rsp_size));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_rsp_size_cnt <= {5{1'b0}};
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_rsp_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response fifo pop error")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_fifo_ready & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response fifo idle when data return")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (dma_rd_rsp_vld & ~dma_rsp_fifo_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"response size mismatch")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > dma_rsp_size)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is overflow")      zzz_assert_never_58x (nvdla_core_clk, `ASSERT_RESET, (mon_dma_rsp_size_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! dma_rsp_size_cnt_inc is out of range")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (dma_rsp_size_cnt_inc > 6'h30)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! Data input when idle!")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, (~is_running & dma_rd_rsp_vld)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA pixel data response logic stage 1                            //
////////////////////////////////////////////////////////////////////////


always @(
  dma_rsp_vld
  ) begin
    rsp_img_vld_w = dma_rsp_vld;
end

always @(
  dma_rsp_mask
  ) begin
    rsp_img_p0_vld_w = dma_rsp_mask[0];
end

always @(
  dma_rsp_mask
  ) begin
    rsp_img_p1_vld_w = dma_rsp_mask[1];
end

assign rsp_dat = dma_rd_rsp_data;

//10'h1     ABGR, VU, single, unchange
//10'h2     ARGB, AYUV, 8bpp
//10'h4     ARGB, AYUV, 16bpp
//10'h8     BGRA, VUYA, 8bpp
//10'h10    BGRA, VUYA, 16bpp
//10'h20    RGBA, YUVA, 8bpp
//10'h40    ARGB, AYUV, packed_10b
//10'h80    BGRA, YUVA, packed_10b
//10'h100   RGBA, packed_10b
//10'h200   UV, 8bpp
//10'h400   UV, 16bpp

always @(
  pixel_order
  or dma_rsp_planar
  or pixel_planar
  ) begin
    rsp_img_sel[0] = pixel_order[0] | (~dma_rsp_planar & pixel_planar);
    rsp_img_sel[1] = pixel_order[1];
    rsp_img_sel[2] = pixel_order[2];
    rsp_img_sel[3] = pixel_order[3];
    rsp_img_sel[4] = pixel_order[4];
    rsp_img_sel[5] = pixel_order[5];
    rsp_img_sel[6] = pixel_order[6];
    rsp_img_sel[7] = pixel_order[7];
    rsp_img_sel[8] = pixel_order[8];
    rsp_img_sel[9] = pixel_order[9] & dma_rsp_planar;
    rsp_img_sel[10] = pixel_order[10] & dma_rsp_planar;
end

//////// reordering ////////
assign rsp_img_data_sw_o0 = rsp_dat;
assign rsp_img_data_sw_o1 = {rsp_dat[15*32+31:15*32+24], rsp_dat[15*32+7:15*32], rsp_dat[15*32+15:15*32+8], rsp_dat[15*32+23:15*32+16], rsp_dat[14*32+31:14*32+24], rsp_dat[14*32+7:14*32], rsp_dat[14*32+15:14*32+8], rsp_dat[14*32+23:14*32+16], rsp_dat[13*32+31:13*32+24], rsp_dat[13*32+7:13*32], rsp_dat[13*32+15:13*32+8], rsp_dat[13*32+23:13*32+16], rsp_dat[12*32+31:12*32+24], rsp_dat[12*32+7:12*32], rsp_dat[12*32+15:12*32+8], rsp_dat[12*32+23:12*32+16], rsp_dat[11*32+31:11*32+24], rsp_dat[11*32+7:11*32], rsp_dat[11*32+15:11*32+8], rsp_dat[11*32+23:11*32+16], rsp_dat[10*32+31:10*32+24], rsp_dat[10*32+7:10*32], rsp_dat[10*32+15:10*32+8], rsp_dat[10*32+23:10*32+16], rsp_dat[9*32+31:9*32+24], rsp_dat[9*32+7:9*32], rsp_dat[9*32+15:9*32+8], rsp_dat[9*32+23:9*32+16], rsp_dat[8*32+31:8*32+24], rsp_dat[8*32+7:8*32], rsp_dat[8*32+15:8*32+8], rsp_dat[8*32+23:8*32+16], rsp_dat[7*32+31:7*32+24], rsp_dat[7*32+7:7*32], rsp_dat[7*32+15:7*32+8], rsp_dat[7*32+23:7*32+16], rsp_dat[6*32+31:6*32+24], rsp_dat[6*32+7:6*32], rsp_dat[6*32+15:6*32+8], rsp_dat[6*32+23:6*32+16], rsp_dat[5*32+31:5*32+24], rsp_dat[5*32+7:5*32], rsp_dat[5*32+15:5*32+8], rsp_dat[5*32+23:5*32+16], rsp_dat[4*32+31:4*32+24], rsp_dat[4*32+7:4*32], rsp_dat[4*32+15:4*32+8], rsp_dat[4*32+23:4*32+16], rsp_dat[3*32+31:3*32+24], rsp_dat[3*32+7:3*32], rsp_dat[3*32+15:3*32+8], rsp_dat[3*32+23:3*32+16], rsp_dat[2*32+31:2*32+24], rsp_dat[2*32+7:2*32], rsp_dat[2*32+15:2*32+8], rsp_dat[2*32+23:2*32+16], rsp_dat[1*32+31:1*32+24], rsp_dat[1*32+7:1*32], rsp_dat[1*32+15:1*32+8], rsp_dat[1*32+23:1*32+16], rsp_dat[0*32+31:0*32+24], rsp_dat[0*32+7:0*32], rsp_dat[0*32+15:0*32+8], rsp_dat[0*32+23:0*32+16]};
assign rsp_img_data_sw_o2 = {rsp_dat[7*64+63:7*64+48], rsp_dat[7*64+15:7*64], rsp_dat[7*64+31:7*64+16], rsp_dat[7*64+47:7*64+32], rsp_dat[6*64+63:6*64+48], rsp_dat[6*64+15:6*64], rsp_dat[6*64+31:6*64+16], rsp_dat[6*64+47:6*64+32], rsp_dat[5*64+63:5*64+48], rsp_dat[5*64+15:5*64], rsp_dat[5*64+31:5*64+16], rsp_dat[5*64+47:5*64+32], rsp_dat[4*64+63:4*64+48], rsp_dat[4*64+15:4*64], rsp_dat[4*64+31:4*64+16], rsp_dat[4*64+47:4*64+32], rsp_dat[3*64+63:3*64+48], rsp_dat[3*64+15:3*64], rsp_dat[3*64+31:3*64+16], rsp_dat[3*64+47:3*64+32], rsp_dat[2*64+63:2*64+48], rsp_dat[2*64+15:2*64], rsp_dat[2*64+31:2*64+16], rsp_dat[2*64+47:2*64+32], rsp_dat[1*64+63:1*64+48], rsp_dat[1*64+15:1*64], rsp_dat[1*64+31:1*64+16], rsp_dat[1*64+47:1*64+32], rsp_dat[0*64+63:0*64+48], rsp_dat[0*64+15:0*64], rsp_dat[0*64+31:0*64+16], rsp_dat[0*64+47:0*64+32]};
assign rsp_img_data_sw_o3 = {rsp_dat[15*32+7:15*32], rsp_dat[15*32+31:15*32+24], rsp_dat[15*32+23:15*32+16], rsp_dat[15*32+15:15*32+8], rsp_dat[14*32+7:14*32], rsp_dat[14*32+31:14*32+24], rsp_dat[14*32+23:14*32+16], rsp_dat[14*32+15:14*32+8], rsp_dat[13*32+7:13*32], rsp_dat[13*32+31:13*32+24], rsp_dat[13*32+23:13*32+16], rsp_dat[13*32+15:13*32+8], rsp_dat[12*32+7:12*32], rsp_dat[12*32+31:12*32+24], rsp_dat[12*32+23:12*32+16], rsp_dat[12*32+15:12*32+8], rsp_dat[11*32+7:11*32], rsp_dat[11*32+31:11*32+24], rsp_dat[11*32+23:11*32+16], rsp_dat[11*32+15:11*32+8], rsp_dat[10*32+7:10*32], rsp_dat[10*32+31:10*32+24], rsp_dat[10*32+23:10*32+16], rsp_dat[10*32+15:10*32+8], rsp_dat[9*32+7:9*32], rsp_dat[9*32+31:9*32+24], rsp_dat[9*32+23:9*32+16], rsp_dat[9*32+15:9*32+8], rsp_dat[8*32+7:8*32], rsp_dat[8*32+31:8*32+24], rsp_dat[8*32+23:8*32+16], rsp_dat[8*32+15:8*32+8], rsp_dat[7*32+7:7*32], rsp_dat[7*32+31:7*32+24], rsp_dat[7*32+23:7*32+16], rsp_dat[7*32+15:7*32+8], rsp_dat[6*32+7:6*32], rsp_dat[6*32+31:6*32+24], rsp_dat[6*32+23:6*32+16], rsp_dat[6*32+15:6*32+8], rsp_dat[5*32+7:5*32], rsp_dat[5*32+31:5*32+24], rsp_dat[5*32+23:5*32+16], rsp_dat[5*32+15:5*32+8], rsp_dat[4*32+7:4*32], rsp_dat[4*32+31:4*32+24], rsp_dat[4*32+23:4*32+16], rsp_dat[4*32+15:4*32+8], rsp_dat[3*32+7:3*32], rsp_dat[3*32+31:3*32+24], rsp_dat[3*32+23:3*32+16], rsp_dat[3*32+15:3*32+8], rsp_dat[2*32+7:2*32], rsp_dat[2*32+31:2*32+24], rsp_dat[2*32+23:2*32+16], rsp_dat[2*32+15:2*32+8], rsp_dat[1*32+7:1*32], rsp_dat[1*32+31:1*32+24], rsp_dat[1*32+23:1*32+16], rsp_dat[1*32+15:1*32+8], rsp_dat[0*32+7:0*32], rsp_dat[0*32+31:0*32+24], rsp_dat[0*32+23:0*32+16], rsp_dat[0*32+15:0*32+8]};
assign rsp_img_data_sw_o4 = {rsp_dat[7*64+15:7*64], rsp_dat[7*64+63:7*64+48], rsp_dat[7*64+47:7*64+32], rsp_dat[7*64+31:7*64+16], rsp_dat[6*64+15:6*64], rsp_dat[6*64+63:6*64+48], rsp_dat[6*64+47:6*64+32], rsp_dat[6*64+31:6*64+16], rsp_dat[5*64+15:5*64], rsp_dat[5*64+63:5*64+48], rsp_dat[5*64+47:5*64+32], rsp_dat[5*64+31:5*64+16], rsp_dat[4*64+15:4*64], rsp_dat[4*64+63:4*64+48], rsp_dat[4*64+47:4*64+32], rsp_dat[4*64+31:4*64+16], rsp_dat[3*64+15:3*64], rsp_dat[3*64+63:3*64+48], rsp_dat[3*64+47:3*64+32], rsp_dat[3*64+31:3*64+16], rsp_dat[2*64+15:2*64], rsp_dat[2*64+63:2*64+48], rsp_dat[2*64+47:2*64+32], rsp_dat[2*64+31:2*64+16], rsp_dat[1*64+15:1*64], rsp_dat[1*64+63:1*64+48], rsp_dat[1*64+47:1*64+32], rsp_dat[1*64+31:1*64+16], rsp_dat[0*64+15:0*64], rsp_dat[0*64+63:0*64+48], rsp_dat[0*64+47:0*64+32], rsp_dat[0*64+31:0*64+16]};
assign rsp_img_data_sw_o5 = {rsp_dat[15*32+7:15*32], rsp_dat[15*32+15:15*32+8], rsp_dat[15*32+23:15*32+16], rsp_dat[15*32+31:15*32+24], rsp_dat[14*32+7:14*32], rsp_dat[14*32+15:14*32+8], rsp_dat[14*32+23:14*32+16], rsp_dat[14*32+31:14*32+24], rsp_dat[13*32+7:13*32], rsp_dat[13*32+15:13*32+8], rsp_dat[13*32+23:13*32+16], rsp_dat[13*32+31:13*32+24], rsp_dat[12*32+7:12*32], rsp_dat[12*32+15:12*32+8], rsp_dat[12*32+23:12*32+16], rsp_dat[12*32+31:12*32+24], rsp_dat[11*32+7:11*32], rsp_dat[11*32+15:11*32+8], rsp_dat[11*32+23:11*32+16], rsp_dat[11*32+31:11*32+24], rsp_dat[10*32+7:10*32], rsp_dat[10*32+15:10*32+8], rsp_dat[10*32+23:10*32+16], rsp_dat[10*32+31:10*32+24], rsp_dat[9*32+7:9*32], rsp_dat[9*32+15:9*32+8], rsp_dat[9*32+23:9*32+16], rsp_dat[9*32+31:9*32+24], rsp_dat[8*32+7:8*32], rsp_dat[8*32+15:8*32+8], rsp_dat[8*32+23:8*32+16], rsp_dat[8*32+31:8*32+24], rsp_dat[7*32+7:7*32], rsp_dat[7*32+15:7*32+8], rsp_dat[7*32+23:7*32+16], rsp_dat[7*32+31:7*32+24], rsp_dat[6*32+7:6*32], rsp_dat[6*32+15:6*32+8], rsp_dat[6*32+23:6*32+16], rsp_dat[6*32+31:6*32+24], rsp_dat[5*32+7:5*32], rsp_dat[5*32+15:5*32+8], rsp_dat[5*32+23:5*32+16], rsp_dat[5*32+31:5*32+24], rsp_dat[4*32+7:4*32], rsp_dat[4*32+15:4*32+8], rsp_dat[4*32+23:4*32+16], rsp_dat[4*32+31:4*32+24], rsp_dat[3*32+7:3*32], rsp_dat[3*32+15:3*32+8], rsp_dat[3*32+23:3*32+16], rsp_dat[3*32+31:3*32+24], rsp_dat[2*32+7:2*32], rsp_dat[2*32+15:2*32+8], rsp_dat[2*32+23:2*32+16], rsp_dat[2*32+31:2*32+24], rsp_dat[1*32+7:1*32], rsp_dat[1*32+15:1*32+8], rsp_dat[1*32+23:1*32+16], rsp_dat[1*32+31:1*32+24], rsp_dat[0*32+7:0*32], rsp_dat[0*32+15:0*32+8], rsp_dat[0*32+23:0*32+16], rsp_dat[0*32+31:0*32+24]};
assign rsp_img_data_sw_o6 = {rsp_dat[15*32+31:15*32+30], rsp_dat[15*32+9:15*32], rsp_dat[15*32+19:15*32+10], rsp_dat[15*32+29:15*32+20], rsp_dat[14*32+31:14*32+30], rsp_dat[14*32+9:14*32], rsp_dat[14*32+19:14*32+10], rsp_dat[14*32+29:14*32+20], rsp_dat[13*32+31:13*32+30], rsp_dat[13*32+9:13*32], rsp_dat[13*32+19:13*32+10], rsp_dat[13*32+29:13*32+20], rsp_dat[12*32+31:12*32+30], rsp_dat[12*32+9:12*32], rsp_dat[12*32+19:12*32+10], rsp_dat[12*32+29:12*32+20], rsp_dat[11*32+31:11*32+30], rsp_dat[11*32+9:11*32], rsp_dat[11*32+19:11*32+10], rsp_dat[11*32+29:11*32+20], rsp_dat[10*32+31:10*32+30], rsp_dat[10*32+9:10*32], rsp_dat[10*32+19:10*32+10], rsp_dat[10*32+29:10*32+20], rsp_dat[9*32+31:9*32+30], rsp_dat[9*32+9:9*32], rsp_dat[9*32+19:9*32+10], rsp_dat[9*32+29:9*32+20], rsp_dat[8*32+31:8*32+30], rsp_dat[8*32+9:8*32], rsp_dat[8*32+19:8*32+10], rsp_dat[8*32+29:8*32+20], rsp_dat[7*32+31:7*32+30], rsp_dat[7*32+9:7*32], rsp_dat[7*32+19:7*32+10], rsp_dat[7*32+29:7*32+20], rsp_dat[6*32+31:6*32+30], rsp_dat[6*32+9:6*32], rsp_dat[6*32+19:6*32+10], rsp_dat[6*32+29:6*32+20], rsp_dat[5*32+31:5*32+30], rsp_dat[5*32+9:5*32], rsp_dat[5*32+19:5*32+10], rsp_dat[5*32+29:5*32+20], rsp_dat[4*32+31:4*32+30], rsp_dat[4*32+9:4*32], rsp_dat[4*32+19:4*32+10], rsp_dat[4*32+29:4*32+20], rsp_dat[3*32+31:3*32+30], rsp_dat[3*32+9:3*32], rsp_dat[3*32+19:3*32+10], rsp_dat[3*32+29:3*32+20], rsp_dat[2*32+31:2*32+30], rsp_dat[2*32+9:2*32], rsp_dat[2*32+19:2*32+10], rsp_dat[2*32+29:2*32+20], rsp_dat[1*32+31:1*32+30], rsp_dat[1*32+9:1*32], rsp_dat[1*32+19:1*32+10], rsp_dat[1*32+29:1*32+20], rsp_dat[0*32+31:0*32+30], rsp_dat[0*32+9:0*32], rsp_dat[0*32+19:0*32+10], rsp_dat[0*32+29:0*32+20]};
assign rsp_img_data_sw_o7 = {rsp_dat[15*32+1:15*32], rsp_dat[15*32+31:15*32+22], rsp_dat[15*32+21:15*32+12], rsp_dat[15*32+11:15*32+2], rsp_dat[14*32+1:14*32], rsp_dat[14*32+31:14*32+22], rsp_dat[14*32+21:14*32+12], rsp_dat[14*32+11:14*32+2], rsp_dat[13*32+1:13*32], rsp_dat[13*32+31:13*32+22], rsp_dat[13*32+21:13*32+12], rsp_dat[13*32+11:13*32+2], rsp_dat[12*32+1:12*32], rsp_dat[12*32+31:12*32+22], rsp_dat[12*32+21:12*32+12], rsp_dat[12*32+11:12*32+2], rsp_dat[11*32+1:11*32], rsp_dat[11*32+31:11*32+22], rsp_dat[11*32+21:11*32+12], rsp_dat[11*32+11:11*32+2], rsp_dat[10*32+1:10*32], rsp_dat[10*32+31:10*32+22], rsp_dat[10*32+21:10*32+12], rsp_dat[10*32+11:10*32+2], rsp_dat[9*32+1:9*32], rsp_dat[9*32+31:9*32+22], rsp_dat[9*32+21:9*32+12], rsp_dat[9*32+11:9*32+2], rsp_dat[8*32+1:8*32], rsp_dat[8*32+31:8*32+22], rsp_dat[8*32+21:8*32+12], rsp_dat[8*32+11:8*32+2], rsp_dat[7*32+1:7*32], rsp_dat[7*32+31:7*32+22], rsp_dat[7*32+21:7*32+12], rsp_dat[7*32+11:7*32+2], rsp_dat[6*32+1:6*32], rsp_dat[6*32+31:6*32+22], rsp_dat[6*32+21:6*32+12], rsp_dat[6*32+11:6*32+2], rsp_dat[5*32+1:5*32], rsp_dat[5*32+31:5*32+22], rsp_dat[5*32+21:5*32+12], rsp_dat[5*32+11:5*32+2], rsp_dat[4*32+1:4*32], rsp_dat[4*32+31:4*32+22], rsp_dat[4*32+21:4*32+12], rsp_dat[4*32+11:4*32+2], rsp_dat[3*32+1:3*32], rsp_dat[3*32+31:3*32+22], rsp_dat[3*32+21:3*32+12], rsp_dat[3*32+11:3*32+2], rsp_dat[2*32+1:2*32], rsp_dat[2*32+31:2*32+22], rsp_dat[2*32+21:2*32+12], rsp_dat[2*32+11:2*32+2], rsp_dat[1*32+1:1*32], rsp_dat[1*32+31:1*32+22], rsp_dat[1*32+21:1*32+12], rsp_dat[1*32+11:1*32+2], rsp_dat[0*32+1:0*32], rsp_dat[0*32+31:0*32+22], rsp_dat[0*32+21:0*32+12], rsp_dat[0*32+11:0*32+2]};
assign rsp_img_data_sw_o8 = {rsp_dat[15*32+1:15*32], rsp_dat[15*32+11:15*32+2], rsp_dat[15*32+21:15*32+12], rsp_dat[15*32+31:15*32+22], rsp_dat[14*32+1:14*32], rsp_dat[14*32+11:14*32+2], rsp_dat[14*32+21:14*32+12], rsp_dat[14*32+31:14*32+22], rsp_dat[13*32+1:13*32], rsp_dat[13*32+11:13*32+2], rsp_dat[13*32+21:13*32+12], rsp_dat[13*32+31:13*32+22], rsp_dat[12*32+1:12*32], rsp_dat[12*32+11:12*32+2], rsp_dat[12*32+21:12*32+12], rsp_dat[12*32+31:12*32+22], rsp_dat[11*32+1:11*32], rsp_dat[11*32+11:11*32+2], rsp_dat[11*32+21:11*32+12], rsp_dat[11*32+31:11*32+22], rsp_dat[10*32+1:10*32], rsp_dat[10*32+11:10*32+2], rsp_dat[10*32+21:10*32+12], rsp_dat[10*32+31:10*32+22], rsp_dat[9*32+1:9*32], rsp_dat[9*32+11:9*32+2], rsp_dat[9*32+21:9*32+12], rsp_dat[9*32+31:9*32+22], rsp_dat[8*32+1:8*32], rsp_dat[8*32+11:8*32+2], rsp_dat[8*32+21:8*32+12], rsp_dat[8*32+31:8*32+22], rsp_dat[7*32+1:7*32], rsp_dat[7*32+11:7*32+2], rsp_dat[7*32+21:7*32+12], rsp_dat[7*32+31:7*32+22], rsp_dat[6*32+1:6*32], rsp_dat[6*32+11:6*32+2], rsp_dat[6*32+21:6*32+12], rsp_dat[6*32+31:6*32+22], rsp_dat[5*32+1:5*32], rsp_dat[5*32+11:5*32+2], rsp_dat[5*32+21:5*32+12], rsp_dat[5*32+31:5*32+22], rsp_dat[4*32+1:4*32], rsp_dat[4*32+11:4*32+2], rsp_dat[4*32+21:4*32+12], rsp_dat[4*32+31:4*32+22], rsp_dat[3*32+1:3*32], rsp_dat[3*32+11:3*32+2], rsp_dat[3*32+21:3*32+12], rsp_dat[3*32+31:3*32+22], rsp_dat[2*32+1:2*32], rsp_dat[2*32+11:2*32+2], rsp_dat[2*32+21:2*32+12], rsp_dat[2*32+31:2*32+22], rsp_dat[1*32+1:1*32], rsp_dat[1*32+11:1*32+2], rsp_dat[1*32+21:1*32+12], rsp_dat[1*32+31:1*32+22], rsp_dat[0*32+1:0*32], rsp_dat[0*32+11:0*32+2], rsp_dat[0*32+21:0*32+12], rsp_dat[0*32+31:0*32+22]};
assign rsp_img_data_sw_o9 = {rsp_dat[31*16+7:31*16], rsp_dat[31*16+15:31*16+8], rsp_dat[30*16+7:30*16], rsp_dat[30*16+15:30*16+8], rsp_dat[29*16+7:29*16], rsp_dat[29*16+15:29*16+8], rsp_dat[28*16+7:28*16], rsp_dat[28*16+15:28*16+8], rsp_dat[27*16+7:27*16], rsp_dat[27*16+15:27*16+8], rsp_dat[26*16+7:26*16], rsp_dat[26*16+15:26*16+8], rsp_dat[25*16+7:25*16], rsp_dat[25*16+15:25*16+8], rsp_dat[24*16+7:24*16], rsp_dat[24*16+15:24*16+8], rsp_dat[23*16+7:23*16], rsp_dat[23*16+15:23*16+8], rsp_dat[22*16+7:22*16], rsp_dat[22*16+15:22*16+8], rsp_dat[21*16+7:21*16], rsp_dat[21*16+15:21*16+8], rsp_dat[20*16+7:20*16], rsp_dat[20*16+15:20*16+8], rsp_dat[19*16+7:19*16], rsp_dat[19*16+15:19*16+8], rsp_dat[18*16+7:18*16], rsp_dat[18*16+15:18*16+8], rsp_dat[17*16+7:17*16], rsp_dat[17*16+15:17*16+8], rsp_dat[16*16+7:16*16], rsp_dat[16*16+15:16*16+8], rsp_dat[15*16+7:15*16], rsp_dat[15*16+15:15*16+8], rsp_dat[14*16+7:14*16], rsp_dat[14*16+15:14*16+8], rsp_dat[13*16+7:13*16], rsp_dat[13*16+15:13*16+8], rsp_dat[12*16+7:12*16], rsp_dat[12*16+15:12*16+8], rsp_dat[11*16+7:11*16], rsp_dat[11*16+15:11*16+8], rsp_dat[10*16+7:10*16], rsp_dat[10*16+15:10*16+8], rsp_dat[9*16+7:9*16], rsp_dat[9*16+15:9*16+8], rsp_dat[8*16+7:8*16], rsp_dat[8*16+15:8*16+8], rsp_dat[7*16+7:7*16], rsp_dat[7*16+15:7*16+8], rsp_dat[6*16+7:6*16], rsp_dat[6*16+15:6*16+8], rsp_dat[5*16+7:5*16], rsp_dat[5*16+15:5*16+8], rsp_dat[4*16+7:4*16], rsp_dat[4*16+15:4*16+8], rsp_dat[3*16+7:3*16], rsp_dat[3*16+15:3*16+8], rsp_dat[2*16+7:2*16], rsp_dat[2*16+15:2*16+8], rsp_dat[1*16+7:1*16], rsp_dat[1*16+15:1*16+8], rsp_dat[0*16+7:0*16], rsp_dat[0*16+15:0*16+8]};
assign rsp_img_data_sw_o10 = {rsp_dat[15*32+15:15*32], rsp_dat[15*32+31:15*32+16], rsp_dat[14*32+15:14*32], rsp_dat[14*32+31:14*32+16], rsp_dat[13*32+15:13*32], rsp_dat[13*32+31:13*32+16], rsp_dat[12*32+15:12*32], rsp_dat[12*32+31:12*32+16], rsp_dat[11*32+15:11*32], rsp_dat[11*32+31:11*32+16], rsp_dat[10*32+15:10*32], rsp_dat[10*32+31:10*32+16], rsp_dat[9*32+15:9*32], rsp_dat[9*32+31:9*32+16], rsp_dat[8*32+15:8*32], rsp_dat[8*32+31:8*32+16], rsp_dat[7*32+15:7*32], rsp_dat[7*32+31:7*32+16], rsp_dat[6*32+15:6*32], rsp_dat[6*32+31:6*32+16], rsp_dat[5*32+15:5*32], rsp_dat[5*32+31:5*32+16], rsp_dat[4*32+15:4*32], rsp_dat[4*32+31:4*32+16], rsp_dat[3*32+15:3*32], rsp_dat[3*32+31:3*32+16], rsp_dat[2*32+15:2*32], rsp_dat[2*32+31:2*32+16], rsp_dat[1*32+15:1*32], rsp_dat[1*32+31:1*32+16], rsp_dat[0*32+15:0*32], rsp_dat[0*32+31:0*32+16]};

always @(
  rsp_img_sel
  or rsp_img_data_sw_o0
  or rsp_img_data_sw_o1
  or rsp_img_data_sw_o2
  or rsp_img_data_sw_o3
  or rsp_img_data_sw_o4
  or rsp_img_data_sw_o5
  or rsp_img_data_sw_o6
  or rsp_img_data_sw_o7
  or rsp_img_data_sw_o8
  or rsp_img_data_sw_o9
  or rsp_img_data_sw_o10
  ) begin
    {rsp_img_p1_data_w,
     rsp_img_p0_data_w} = ({512  {rsp_img_sel[0]}} & rsp_img_data_sw_o0) |
                          ({512  {rsp_img_sel[1]}} & rsp_img_data_sw_o1) |
                          ({512  {rsp_img_sel[2]}} & rsp_img_data_sw_o2) |
                          ({512  {rsp_img_sel[3]}} & rsp_img_data_sw_o3) |
                          ({512  {rsp_img_sel[4]}} & rsp_img_data_sw_o4) |
                          ({512  {rsp_img_sel[5]}} & rsp_img_data_sw_o5) |
                          ({512  {rsp_img_sel[6]}} & rsp_img_data_sw_o6) |
                          ({512  {rsp_img_sel[7]}} & rsp_img_data_sw_o7) |
                          ({512  {rsp_img_sel[8]}} & rsp_img_data_sw_o8) |
                          ({512  {rsp_img_sel[9]}} & rsp_img_data_sw_o9) |
                          ({512  {rsp_img_sel[10]}} & rsp_img_data_sw_o10);
end

assign dma_rsp_w_burst_size = dma_rsp_size;
assign rsp_img_1st_burst_w = dma_rsp_line_st & (dma_rsp_size_cnt == 5'h0);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_vld <= 1'b0;
  end else begin
  rsp_img_vld <= rsp_img_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_vld <= 1'b0;
  end else begin
  rsp_img_p0_vld <= rsp_img_p0_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_vld <= 1'b0;
  end else begin
  rsp_img_p1_vld <= rsp_img_p1_vld_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_img_p0_vld_w) == 1'b1) begin
    rsp_img_p0_data <= rsp_img_p0_data_w;
  // VCS coverage off
  end else if ((rsp_img_p0_vld_w) == 1'b0) begin
  end else begin
    rsp_img_p0_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_img_p1_vld_w) == 1'b1) begin
    rsp_img_p1_data <= rsp_img_p1_data_w;
  // VCS coverage off
  end else if ((rsp_img_p1_vld_w) == 1'b0) begin
  end else begin
    rsp_img_p1_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_planar <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_planar <= dma_rsp_planar;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_planar <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_1st_burst <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_1st_burst <= rsp_img_1st_burst_w;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_1st_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_line_st <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_line_st <= dma_rsp_line_st;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_line_st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_req_end <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_req_end <= dma_rsp_fifo_ready;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_req_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_w_burst_size <= {5{1'b0}};
  end else begin
  if ((rsp_img_vld_w & dma_rsp_fifo_ready) == 1'b1) begin
    rsp_img_w_burst_size <= dma_rsp_w_burst_size;
  // VCS coverage off
  end else if ((rsp_img_vld_w & dma_rsp_fifo_ready) == 1'b0) begin
  end else begin
    rsp_img_w_burst_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w & dma_rsp_fifo_ready))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_line_end <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_line_end <= dma_rsp_line_end & dma_rsp_fifo_ready;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_line_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_bundle_end <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_bundle_end <= dma_rsp_bundle_end & dma_rsp_fifo_ready;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_bundle_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_end <= 1'b0;
  end else begin
  if ((rsp_img_vld_w) == 1'b1) begin
    rsp_img_end <= dma_rsp_end & dma_rsp_fifo_ready;
  // VCS coverage off
  end else if ((rsp_img_vld_w) == 1'b0) begin
  end else begin
    rsp_img_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  CDMA pixel data response logic stage 2: cache and sbuf write      //
////////////////////////////////////////////////////////////////////////
//////// cache line control ////////
always @(
  rsp_img_planar
  ) begin
    rsp_img_c0l0_wr_sel = ~rsp_img_planar;
end

always @(
  rsp_img_planar
  ) begin
    rsp_img_c1l0_wr_sel = rsp_img_planar;
end

always @(
  rsp_img_p0_vld
  or rsp_img_c0l0_wr_sel
  ) begin
    rsp_img_c0l0_wr_en = (rsp_img_p0_vld & rsp_img_c0l0_wr_sel);
end

always @(
  rsp_img_p0_vld
  or rsp_img_c1l0_wr_sel
  ) begin
    rsp_img_c1l0_wr_en = (rsp_img_p0_vld & rsp_img_c1l0_wr_sel);
end

always @(
  rsp_img_p1_vld
  or rsp_img_p1_data
  or rsp_img_p0_data
  ) begin
    rsp_img_l0_data = rsp_img_p1_vld ? rsp_img_p1_data : rsp_img_p0_data;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_c0l0 <= {256{1'b0}};
  end else begin
  if ((rsp_img_c0l0_wr_en) == 1'b1) begin
    rsp_img_c0l0 <= rsp_img_l0_data;
  // VCS coverage off
  end else if ((rsp_img_c0l0_wr_en) == 1'b0) begin
  end else begin
    rsp_img_c0l0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_c0l0_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_c1l0 <= {256{1'b0}};
  end else begin
  if ((rsp_img_c1l0_wr_en) == 1'b1) begin
    rsp_img_c1l0 <= rsp_img_l0_data;
  // VCS coverage off
  end else if ((rsp_img_c1l0_wr_en) == 1'b0) begin
  end else begin
    rsp_img_c1l0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_c1l0_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////// data write control logic: normal write back ////////

always @(
  rsp_img_c0l0_wr_sel
  or rsp_img_c0l0
  or rsp_img_c1l0_wr_sel
  or rsp_img_c1l0
  ) begin
    rsp_img_p0_cache_data = ({256 {rsp_img_c0l0_wr_sel}} & rsp_img_c0l0) |
                            ({256 {rsp_img_c1l0_wr_sel}} & rsp_img_c1l0);
end

always @(
  rsp_img_p0_vld
  or rsp_img_1st_burst
  or rsp_img_p1_vld
  ) begin
    rsp_img_p0_vld_d1_w = rsp_img_p0_vld & (~rsp_img_1st_burst | rsp_img_p1_vld);
    rsp_img_p1_vld_d1_w = rsp_img_p1_vld & ~rsp_img_1st_burst;
end

always @(
  rsp_img_1st_burst
  or rsp_img_p0_data
  or rsp_img_p0_cache_data
  or rsp_img_p1_data
  ) begin
    rsp_img_p0_data_lo = rsp_img_1st_burst ? rsp_img_p0_data : rsp_img_p0_cache_data;
    rsp_img_p0_data_hi = rsp_img_1st_burst ? rsp_img_p1_data : rsp_img_p0_data;
end

always @(
  rsp_img_p0_data
  or rsp_img_p1_data
  ) begin
    rsp_img_p1_data_lo = rsp_img_p0_data;
    rsp_img_p1_data_hi = rsp_img_p1_data; 
end


always @(
  rsp_img_planar
  or pixel_planar1_byte_sft
  or pixel_planar0_byte_sft
  ) begin
    rsp_img_sft = rsp_img_planar ? pixel_planar1_byte_sft : pixel_planar0_byte_sft;
end

always @(
  rsp_img_p0_data_hi
  or rsp_img_p0_data_lo
  or rsp_img_sft
  ) begin
    {mon_rsp_img_p0_data_d1_w,
     rsp_img_p0_data_d1_w} = ({rsp_img_p0_data_hi, rsp_img_p0_data_lo} >> {rsp_img_sft, 3'b0});
end

always @(
  rsp_img_p1_data_hi
  or rsp_img_p1_data_lo
  or rsp_img_sft
  ) begin
    {mon_rsp_img_p1_data_d1_w,
     rsp_img_p1_data_d1_w} = ({rsp_img_p1_data_hi, rsp_img_p1_data_lo} >> {rsp_img_sft, 3'b0});
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_vld_d1 <= 1'b0;
  end else begin
  rsp_img_p0_vld_d1 <= rsp_img_p0_vld_d1_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_vld_d1 <= 1'b0;
  end else begin
  rsp_img_p1_vld_d1 <= rsp_img_p1_vld_d1_w;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_img_p0_vld_d1_w) == 1'b1) begin
    rsp_img_p0_data_d1 <= rsp_img_p0_data_d1_w;
  // VCS coverage off
  end else if ((rsp_img_p0_vld_d1_w) == 1'b0) begin
  end else begin
    rsp_img_p0_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_img_p1_vld_d1_w) == 1'b1) begin
    rsp_img_p1_data_d1 <= rsp_img_p1_data_d1_w;
  // VCS coverage off
  end else if ((rsp_img_p1_vld_d1_w) == 1'b0) begin
  end else begin
    rsp_img_p1_data_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_never #(0,0,"Error! rsp_img_p1_vld_d1 valid when rsp_img_p0_vld_d1 not!")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (~rsp_img_p0_vld_d1 & rsp_img_p1_vld_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////// data write control logic: normal write back ////////

always @(
  rsp_img_p1_vld_d1_w
  ) begin
    rsp_img_planar_idx_add = (rsp_img_p1_vld_d1_w) ? 2'h2 : 2'h1;
end

always @(
  rsp_img_p0_planar0_idx
  or rsp_img_planar_idx_add
  or rsp_img_p1_planar0_idx
  or rsp_img_p0_planar1_idx
  or rsp_img_p1_planar1_idx
  ) begin
    rsp_img_p0_planar0_idx_inc = rsp_img_p0_planar0_idx + rsp_img_planar_idx_add;
    rsp_img_p1_planar0_idx_inc = rsp_img_p1_planar0_idx + rsp_img_planar_idx_add;
    rsp_img_p0_planar1_idx_inc = rsp_img_p0_planar1_idx + rsp_img_planar_idx_add;
    rsp_img_p1_planar1_idx_inc = rsp_img_p1_planar1_idx + rsp_img_planar_idx_add;
end

always @(
  is_first_running
  or rsp_img_p0_planar0_idx_inc
  or rsp_img_p1_planar0_idx_inc
  ) begin
    rsp_img_p0_planar0_idx_w = is_first_running ? 7'b0 :
                               rsp_img_p0_planar0_idx_inc[8 -2:0];
    rsp_img_p1_planar0_idx_w = is_first_running ? 7'b1 :
                               rsp_img_p1_planar0_idx_inc[8 -2:0];
end

always @(
  is_first_running
  or rsp_img_p0_planar1_idx_inc
  or rsp_img_p1_planar1_idx_inc
  ) begin
    rsp_img_p0_planar1_idx_w = is_first_running ? 7'b0 :
                               rsp_img_p0_planar1_idx_inc[8 -2:0];
    rsp_img_p1_planar1_idx_w = is_first_running ? 7'b1 :
                               rsp_img_p1_planar1_idx_inc[8 -2:0];
end

always @(
  is_first_running
  or rsp_img_p0_vld_d1_w
  or rsp_img_planar
  ) begin
    rsp_img_p0_planar0_en = is_first_running | (rsp_img_p0_vld_d1_w & ~rsp_img_planar);
    rsp_img_p0_planar1_en = is_first_running | (rsp_img_p0_vld_d1_w & rsp_img_planar);
    rsp_img_p1_planar0_en = is_first_running | (rsp_img_p0_vld_d1_w & ~rsp_img_planar);
    rsp_img_p1_planar1_en = is_first_running | (rsp_img_p0_vld_d1_w & rsp_img_planar);
end

always @(
  rsp_img_planar
  or rsp_img_p0_planar0_idx
  or rsp_img_p0_planar1_idx
  ) begin
    rsp_img_p0_addr = (~rsp_img_planar) ? {1'b0, rsp_img_p0_planar0_idx[0], rsp_img_p0_planar0_idx[8 -2:1]} :
                      {1'b1, rsp_img_p0_planar1_idx[0], rsp_img_p0_planar1_idx[8 -2:1]};
end

always @(
  rsp_img_planar
  or rsp_img_p1_planar0_idx
  or rsp_img_p1_planar1_idx
  ) begin
    rsp_img_p1_addr = (~rsp_img_planar) ? {1'b0, rsp_img_p1_planar0_idx[0], rsp_img_p1_planar0_idx[8 -2:1]} :
                      {1'b1, rsp_img_p1_planar1_idx[0], rsp_img_p1_planar1_idx[8 -2:1]};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_planar0_idx <= {7{1'b0}};
  end else begin
  if ((rsp_img_p0_planar0_en) == 1'b1) begin
    rsp_img_p0_planar0_idx <= rsp_img_p0_planar0_idx_w;
  // VCS coverage off
  end else if ((rsp_img_p0_planar0_en) == 1'b0) begin
  end else begin
    rsp_img_p0_planar0_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p0_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_planar1_idx <= {7{1'b0}};
  end else begin
  if ((rsp_img_p0_planar1_en) == 1'b1) begin
    rsp_img_p0_planar1_idx <= rsp_img_p0_planar1_idx_w;
  // VCS coverage off
  end else if ((rsp_img_p0_planar1_en) == 1'b0) begin
  end else begin
    rsp_img_p0_planar1_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p0_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_planar0_idx <= {7{1'b0}};
  end else begin
  if ((rsp_img_p1_planar0_en) == 1'b1) begin
    rsp_img_p1_planar0_idx <= rsp_img_p1_planar0_idx_w;
  // VCS coverage off
  end else if ((rsp_img_p1_planar0_en) == 1'b0) begin
  end else begin
    rsp_img_p1_planar0_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p1_planar0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_planar1_idx <= {7{1'b0}};
  end else begin
  if ((rsp_img_p1_planar1_en) == 1'b1) begin
    rsp_img_p1_planar1_idx <= rsp_img_p1_planar1_idx_w;
  // VCS coverage off
  end else if ((rsp_img_p1_planar1_en) == 1'b0) begin
  end else begin
    rsp_img_p1_planar1_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p1_planar1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_addr_d1 <= {8{1'b0}};
  end else begin
  if ((rsp_img_p0_vld_d1_w) == 1'b1) begin
    rsp_img_p0_addr_d1 <= rsp_img_p0_addr;
  // VCS coverage off
  end else if ((rsp_img_p0_vld_d1_w) == 1'b0) begin
  end else begin
    rsp_img_p0_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p0_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_addr_d1 <= {8{1'b0}};
  end else begin
  if ((rsp_img_p1_vld_d1_w) == 1'b1) begin
    rsp_img_p1_addr_d1 <= rsp_img_p1_addr;
  // VCS coverage off
  end else if ((rsp_img_p1_vld_d1_w) == 1'b0) begin
  end else begin
    rsp_img_p1_addr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p1_vld_d1_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////// data write control logic: MISC output ////////

always @(
  rsp_img_p0_burst_cnt
  or rsp_img_w_burst_size
  or rsp_img_line_st
  ) begin
    {mon_rsp_img_p0_burst_cnt_inc,
     rsp_img_p0_burst_cnt_inc} = rsp_img_p0_burst_cnt + rsp_img_w_burst_size[3:0] - rsp_img_line_st;
end

always @(
  rsp_img_p1_burst_cnt
  or rsp_img_w_burst_size
  or rsp_img_line_st
  ) begin
    {mon_rsp_img_p1_burst_cnt_inc,
     rsp_img_p1_burst_cnt_inc} = rsp_img_p1_burst_cnt + rsp_img_w_burst_size - rsp_img_line_st;
end

always @(
  is_first_running
  or rsp_img_vld
  or rsp_img_bundle_end
  or rsp_img_planar
  or rsp_img_p0_burst_cnt_inc
  or rsp_img_p0_burst_cnt
  ) begin
    rsp_img_p0_burst_cnt_w = is_first_running ? 4'b0 :
                             (rsp_img_vld & rsp_img_bundle_end) ? 4'b0 :
                             (~rsp_img_planar) ? rsp_img_p0_burst_cnt_inc :
                             rsp_img_p0_burst_cnt;
end

always @(
  is_first_running
  or rsp_img_vld
  or rsp_img_bundle_end
  or rsp_img_planar
  or rsp_img_p1_burst_cnt_inc
  or rsp_img_p1_burst_cnt
  ) begin
    rsp_img_p1_burst_cnt_w = is_first_running ? 5'b0 :
                             (rsp_img_vld & rsp_img_bundle_end) ? 5'b0 :
                             (rsp_img_planar) ? rsp_img_p1_burst_cnt_inc :
                             rsp_img_p1_burst_cnt;
end

always @(
  rsp_img_vld
  or rsp_img_bundle_end
  ) begin
    rsp_img_bundle_done = (rsp_img_vld & rsp_img_bundle_end);
end

always @(
  rsp_img_planar
  or rsp_img_p0_burst_cnt_inc
  or rsp_img_p0_burst_cnt
  or rsp_img_p1_burst_cnt_inc
  ) begin
    rsp_img_p0_burst_size_w = ~rsp_img_planar ? rsp_img_p0_burst_cnt_inc : rsp_img_p0_burst_cnt;
    rsp_img_p1_burst_size_w = rsp_img_p1_burst_cnt_inc;
end

always @(
  is_first_running
  or rsp_img_vld
  or rsp_img_req_end
  or pixel_planar
  ) begin
    rsp_img_p0_burst_cnt_en = is_first_running | (rsp_img_vld & rsp_img_req_end);
    rsp_img_p1_burst_cnt_en = is_first_running | (rsp_img_vld & rsp_img_req_end & pixel_planar);
end

always @(
  is_first_running
  or rsp_img_vld
  or rsp_img_bundle_end
  or pixel_planar
  ) begin
    rsp_img_p0_burst_size_en = is_first_running | (rsp_img_vld & rsp_img_bundle_end);
    rsp_img_p1_burst_size_en = is_first_running | (rsp_img_vld & rsp_img_bundle_end & pixel_planar);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_burst_cnt <= {4{1'b0}};
  end else begin
  if ((rsp_img_p0_burst_cnt_en) == 1'b1) begin
    rsp_img_p0_burst_cnt <= rsp_img_p0_burst_cnt_w;
  // VCS coverage off
  end else if ((rsp_img_p0_burst_cnt_en) == 1'b0) begin
  end else begin
    rsp_img_p0_burst_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p0_burst_cnt_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_burst_cnt <= {5{1'b0}};
  end else begin
  if ((rsp_img_p1_burst_cnt_en) == 1'b1) begin
    rsp_img_p1_burst_cnt <= rsp_img_p1_burst_cnt_w;
  // VCS coverage off
  end else if ((rsp_img_p1_burst_cnt_en) == 1'b0) begin
  end else begin
    rsp_img_p1_burst_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p1_burst_cnt_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p0_burst_size_d1 <= {4{1'b0}};
  end else begin
  if ((rsp_img_p0_burst_size_en) == 1'b1) begin
    rsp_img_p0_burst_size_d1 <= rsp_img_p0_burst_size_w;
  // VCS coverage off
  end else if ((rsp_img_p0_burst_size_en) == 1'b0) begin
  end else begin
    rsp_img_p0_burst_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p0_burst_size_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_p1_burst_size_d1 <= {5{1'b0}};
  end else begin
  if ((rsp_img_p1_burst_size_en) == 1'b1) begin
    rsp_img_p1_burst_size_d1 <= rsp_img_p1_burst_size_w;
  // VCS coverage off
  end else if ((rsp_img_p1_burst_size_en) == 1'b0) begin
  end else begin
    rsp_img_p1_burst_size_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_p1_burst_size_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_bundle_done_d1 <= 1'b0;
  end else begin
  rsp_img_bundle_done_d1 <= rsp_img_bundle_done;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_line_end_d1 <= 1'b0;
  end else begin
  if ((rsp_img_bundle_done) == 1'b1) begin
    rsp_img_line_end_d1 <= rsp_img_line_end;
  // VCS coverage off
  end else if ((rsp_img_bundle_done) == 1'b0) begin
  end else begin
    rsp_img_line_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_bundle_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_layer_end_d1 <= 1'b0;
  end else begin
  if ((rsp_img_bundle_done) == 1'b1) begin
    rsp_img_layer_end_d1 <= rsp_img_end;
  // VCS coverage off
  end else if ((rsp_img_bundle_done) == 1'b0) begin
  end else begin
    rsp_img_layer_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_img_bundle_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_img_p0_burst_cnt_inc is overflow!")      zzz_assert_never_84x (nvdla_core_clk, `ASSERT_RESET, (rsp_img_p0_burst_cnt_en & mon_rsp_img_p0_burst_cnt_inc & ~rsp_img_planar)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_img_p1_burst_cnt_inc is overflow!")      zzz_assert_never_85x (nvdla_core_clk, `ASSERT_RESET, (rsp_img_p1_burst_cnt_en & mon_rsp_img_p1_burst_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_img_w_burst_size is out of range when planar0!")      zzz_assert_never_86x (nvdla_core_clk, `ASSERT_RESET, (rsp_img_p0_burst_cnt_en & rsp_img_w_burst_size[4] & ~rsp_img_planar)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//////// data write control logic: status ////////
always @(
  is_first_running
  or rsp_img_end
  or rsp_img_line_end
  or rsp_img_is_done
  ) begin
    rsp_img_is_done_w = is_first_running ? 1'b0 :
                        (rsp_img_end & rsp_img_line_end) ? 1'b1 :
                        rsp_img_is_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_img_is_done <= 1'b1;
  end else begin
  if ((is_running) == 1'b1) begin
    rsp_img_is_done <= rsp_img_is_done_w;
  // VCS coverage off
  end else if ((is_running) == 1'b0) begin
  end else begin
    rsp_img_is_done <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! rsp_img_is_done is 0 when not busy!")      zzz_assert_never_88x (nvdla_core_clk, `ASSERT_RESET, (~is_running & ~rsp_img_is_done)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
assign img2sbuf_p0_wr_en = rsp_img_p0_vld_d1;
assign img2sbuf_p1_wr_en = rsp_img_p1_vld_d1;
assign img2sbuf_p0_wr_addr = rsp_img_p0_addr_d1;
assign img2sbuf_p1_wr_addr = rsp_img_p1_addr_d1;
assign img2sbuf_p0_wr_data = rsp_img_p0_data_d1;
assign img2sbuf_p1_wr_data = rsp_img_p1_data_d1;

////////////////////////////////////////////////////////////////////////
//  Signal from SG to PACK                                            //
////////////////////////////////////////////////////////////////////////
assign sg2pack_img_line_end = rsp_img_line_end_d1;
assign sg2pack_img_layer_end = rsp_img_layer_end_d1;
assign sg2pack_img_p0_burst = rsp_img_p0_burst_size_d1;
assign sg2pack_img_p1_burst = rsp_img_p1_burst_size_d1;


// PKT_PACK_WIRE( sg2pack_info ,  sg2pack_img_  ,  sg2pack_push_data )
assign       sg2pack_push_data[3:0] =     sg2pack_img_p0_burst[3:0];
assign       sg2pack_push_data[8:4] =     sg2pack_img_p1_burst[4:0];
assign       sg2pack_push_data[9] =     sg2pack_img_line_end ;
assign       sg2pack_push_data[10] =     sg2pack_img_layer_end ;

assign sg2pack_push_req = rsp_img_bundle_done_d1;
assign sg2pack_img_pvld = sg2pack_pop_req;
assign sg2pack_img_pd = sg2pack_pop_data;
assign sg2pack_pop_ready = sg2pack_img_prdy;

NV_NVDLA_CDMA_IMG_sg2pack_fifo u_NV_NVDLA_CDMA_IMG_sg2pack_fifo (
   .clk                 (nvdla_core_clk)          //|< i
  ,.reset_              (nvdla_core_rstn)         //|< i
  ,.wr_ready            (sg2pack_push_ready)      //|> w *
  ,.wr_req              (sg2pack_push_req)        //|< w
  ,.wr_data             (sg2pack_push_data[10:0]) //|< w
  ,.rd_ready            (sg2pack_pop_ready)       //|< w
  ,.rd_req              (sg2pack_pop_req)         //|> w
  ,.rd_data             (sg2pack_pop_data[10:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign sg2pack_height_total = height_cnt_total;
assign sg2pack_mn_enable = mn_enable_d1;
assign sg2pack_data_entries = data_entries;
assign sg2pack_entry_st =  pre_entry_st_d1;
assign sg2pack_entry_mid = pre_entry_mid_d1;
assign sg2pack_entry_end = pre_entry_end_d1;
assign sg2pack_sub_h_st =  pre_sub_h_st_d1;
assign sg2pack_sub_h_mid = pre_sub_h_mid_d1;
assign sg2pack_sub_h_end = pre_sub_h_end_d1;

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! sg2pack_fifo push block!")      zzz_assert_never_89x (nvdla_core_clk, `ASSERT_RESET, (sg2pack_push_req & ~sg2pack_push_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sg2pack_fifo pop invalid!")      zzz_assert_never_90x (nvdla_core_clk, `ASSERT_RESET, (~sg2pack_pop_req & sg2pack_pop_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
//  Global status                                                     //
////////////////////////////////////////////////////////////////////////

always @(
  is_first_running
  or req_is_done
  or rsp_img_is_done
  ) begin
    sg_is_done_w = ~is_first_running & req_is_done & rsp_img_is_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg_is_done <= 1'b1;
  end else begin
  if ((is_running) == 1'b1) begin
    sg_is_done <= sg_is_done_w;
  // VCS coverage off
  end else if ((is_running) == 1'b0) begin
  end else begin
    sg_is_done <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_running))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sg_is_done is 0 when not busy!")      zzz_assert_never_92x (nvdla_core_clk, `ASSERT_RESET, (~is_running & ~sg_is_done)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    img_rd_stall_inc <= 1'b0;
  end else begin
  img_rd_stall_inc <= dma_rd_req_vld & ~dma_rd_req_rdy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_stall_clr <= 1'b0;
  end else begin
  img_rd_stall_clr <= status2dma_fsm_switch & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_stall_cen <= 1'b0;
  end else begin
  img_rd_stall_cen <= reg2dp_op_en & reg2dp_dma_en;
  end
end




    assign dp2reg_img_rd_stall_dec = 1'b0;

    // stl adv logic

    always @(
      img_rd_stall_inc
      or dp2reg_img_rd_stall_dec
      ) begin
      stl_adv = img_rd_stall_inc ^ dp2reg_img_rd_stall_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or img_rd_stall_inc
      or dp2reg_img_rd_stall_dec
      or stl_adv
      or img_rd_stall_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (img_rd_stall_inc && !dp2reg_img_rd_stall_dec)? stl_cnt_inc : (!img_rd_stall_inc && dp2reg_img_rd_stall_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (img_rd_stall_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (img_rd_stall_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      dp2reg_img_rd_stall[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_latency_inc <= 1'b0;
  end else begin
  img_rd_latency_inc <= dma_rd_req_vld & dma_rd_req_rdy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_latency_dec <= 1'b0;
  end else begin
  img_rd_latency_dec <= dma_rsp_fifo_ready & ~dma_rsp_dummy & reg2dp_dma_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_latency_clr <= 1'b0;
  end else begin
  img_rd_latency_clr <= status2dma_fsm_switch;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img_rd_latency_cen <= 1'b0;
  end else begin
  img_rd_latency_cen <= reg2dp_op_en & reg2dp_dma_en;
  end
end




    // 
    assign ltc_1_inc = (outs_dp2reg_img_rd_latency!=511) & img_rd_latency_inc;
    assign ltc_1_dec = (outs_dp2reg_img_rd_latency!=511) & img_rd_latency_dec;

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
      or img_rd_latency_clr
      ) begin
      // VCS sop_coverage_off start
      ltc_1_cnt_ext[10:0] = {1'b0, 1'b0, ltc_1_cnt_cur};
      ltc_1_cnt_inc[10:0] = ltc_1_cnt_cur + 1'b1; // spyglass disable W164b
      ltc_1_cnt_dec[10:0] = ltc_1_cnt_cur - 1'b1; // spyglass disable W164b
      ltc_1_cnt_mod[10:0] = (ltc_1_inc && !ltc_1_dec)? ltc_1_cnt_inc : (!ltc_1_inc && ltc_1_dec)? ltc_1_cnt_dec : ltc_1_cnt_ext;
      ltc_1_cnt_new[10:0] = (ltc_1_adv)? ltc_1_cnt_mod[10:0] : ltc_1_cnt_ext[10:0];
      ltc_1_cnt_nxt[10:0] = (img_rd_latency_clr)? 11'd0 : ltc_1_cnt_new[10:0];
      // VCS sop_coverage_off end
    end

    // ltc_1 flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        ltc_1_cnt_cur[8:0] <= 0;
      end else begin
      if (img_rd_latency_cen) begin
      ltc_1_cnt_cur[8:0] <= ltc_1_cnt_nxt[8:0];
      end
      end
    end

    // ltc_1 output logic

    always @(
      ltc_1_cnt_cur
      ) begin
      outs_dp2reg_img_rd_latency[8:0] = ltc_1_cnt_cur[8:0];
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
      nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_93x (nvdla_core_clk, `ASSERT_RESET, (ltc_1_cnt_nxt > 511 && img_rd_latency_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

      
    //assign dp2reg_img_rd_latency_sub = 1'b0;
    assign ltc_2_dec = 1'b0;
    assign ltc_2_inc = (~&dp2reg_img_rd_latency) & (|outs_dp2reg_img_rd_latency);

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
      or img_rd_latency_clr
      ) begin
      // VCS sop_coverage_off start
      ltc_2_cnt_ext[33:0] = {1'b0, 1'b0, ltc_2_cnt_cur};
      ltc_2_cnt_inc[33:0] = ltc_2_cnt_cur + 1'b1; // spyglass disable W164b
      ltc_2_cnt_dec[33:0] = ltc_2_cnt_cur - 1'b1; // spyglass disable W164b
      ltc_2_cnt_mod[33:0] = (ltc_2_inc && !ltc_2_dec)? ltc_2_cnt_inc : (!ltc_2_inc && ltc_2_dec)? ltc_2_cnt_dec : ltc_2_cnt_ext;
      ltc_2_cnt_new[33:0] = (ltc_2_adv)? ltc_2_cnt_mod[33:0] : ltc_2_cnt_ext[33:0];
      ltc_2_cnt_nxt[33:0] = (img_rd_latency_clr)? 34'd0 : ltc_2_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // ltc_2 flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        ltc_2_cnt_cur[31:0] <= 0;
      end else begin
      if (img_rd_latency_cen) begin
      ltc_2_cnt_cur[31:0] <= ltc_2_cnt_nxt[31:0];
      end
      end
    end

    // ltc_2 output logic

    always @(
      ltc_2_cnt_cur
      ) begin
      dp2reg_img_rd_latency[31:0] = ltc_2_cnt_cur[31:0];
    end
        
      

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// &Force output sg_is_done;
// 
// assign obs_bus_cdma_img_dma_rd_req_vld      = dma_rd_req_vld;
// assign obs_bus_cdma_img_dma_rd_req_rdy      = dma_rd_req_rdy;
// assign obs_bus_cdma_img_dma_req_fifo_req    = dma_req_fifo_req;
// assign obs_bus_cdma_img_dma_req_fifo_ready  = dma_req_fifo_ready;
// assign obs_bus_cdma_img_req_size_out_d1     = req_size_out_d1[3:0];
// assign obs_bus_cdma_img_req_addr_d1_lo      = req_addr_d1[15:0];
// assign obs_bus_cdma_img_req_is_dummy_d1     = req_is_dummy_d1;
// assign obs_bus_cdma_img_dma_rd_rsp_vld      = dma_rd_rsp_vld;
// assign obs_bus_cdma_img_dma_rd_rsp_rdy      = dma_rd_rsp_rdy;
// assign obs_bus_cdma_img_dma_rd_rsp_mask     = dma_rd_rsp_mask;
// assign obs_bus_cdma_img_dma_rsp_fifo_req    = dma_rsp_fifo_req;
// assign obs_bus_cdma_img_dma_rsp_fifo_ready  = dma_rsp_fifo_ready;
// assign obs_bus_cdma_img_sg_is_done          = sg_is_done;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           req_img_p1_sec_cnt
//                           {req_valid,req_valid_d1}
//                           {req_bundle_end_d1,req_line_st_d1}
//                           {req_grant_end_d1,req_is_dummy_d1}
//                           {is_cbuf_ready,req_is_done}
//                           dma_rsp_size_cnt[1:0]
//                           {rsp_img_p0_vld,rsp_img_p1_vld}
//                           rsp_img_wr_h_cnt
//                           rsp_img_p0_addr_d1[1:0]
//                           rsp_img_p1_addr_d1[1:0];

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

    property cdma_img_sg__img_read_response_block__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dma_rd_rsp_vld & ~dma_rd_rsp_rdy);
    endproperty
    // Cover 0 : "(dma_rd_rsp_vld & ~dma_rd_rsp_rdy)"
    FUNCPOINT_cdma_img_sg__img_read_response_block__0_COV : cover property (cdma_img_sg__img_read_response_block__0_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDMA_IMG_sg



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_IMG_SG_pipe_p1 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_94x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_95x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_IMG_SG_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDMA_IMG_SG_pipe_p2 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_97x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_IMG_SG_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_IMG_SG_pipe_p3 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_99x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_IMG_SG_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_CDMA_IMG_SG_pipe_p4 (
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
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDMA_IMG_sg_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_101x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CDMA_IMG_SG_pipe_p4


