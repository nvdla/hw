// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_cal2d.v

#include "NV_NVDLA_PDP_define.h"

module NV_NVDLA_PDP_CORE_cal2d (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,padding_v_cfg                  //|< i
  ,pdp_dp2wdma_ready              //|< i
  ,pdp_op_start                   //|< i
  ,pooling1d_pd                   //|< i
  ,pooling1d_pvld                 //|< i
  ,pooling_channel_cfg            //|< i
  ,pooling_out_fwidth_cfg         //|< i
  ,pooling_out_lwidth_cfg         //|< i
  ,pooling_out_mwidth_cfg         //|< i
  ,pooling_size_v_cfg             //|< i
  ,pooling_splitw_num_cfg         //|< i
  ,pooling_stride_v_cfg           //|< i
  ,pooling_type_cfg               //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_cube_in_height          //|< i
  ,reg2dp_cube_out_width          //|< i
  //,reg2dp_input_data              //|< i
  //,reg2dp_int16_en                //|< i
  //,reg2dp_int8_en                 //|< i
  ,reg2dp_kernel_height           //|< i
  ,reg2dp_kernel_width            //|< i
  ,reg2dp_pad_bottom_cfg          //|< i
  ,reg2dp_pad_top                 //|< i
  ,reg2dp_pad_value_1x_cfg        //|< i
  ,reg2dp_pad_value_2x_cfg        //|< i
  ,reg2dp_pad_value_3x_cfg        //|< i
  ,reg2dp_pad_value_4x_cfg        //|< i
  ,reg2dp_pad_value_5x_cfg        //|< i
  ,reg2dp_pad_value_6x_cfg        //|< i
  ,reg2dp_pad_value_7x_cfg        //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_recip_height_cfg        //|< i
  ,reg2dp_recip_width_cfg         //|< i
  ,pdp_dp2wdma_pd                 //|> o
  ,pdp_dp2wdma_valid              //|> o
  ,pooling1d_prdy                 //|> o
  );
/////////////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input    [2:0] padding_v_cfg;
input          pdp_dp2wdma_ready;
input          pdp_op_start;
//: my $m = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6);
//: print " input [$m-1:0] pooling1d_pd; \n";
input          pooling1d_pvld;
input   [12:0] pooling_channel_cfg;
input    [9:0] pooling_out_fwidth_cfg;
input    [9:0] pooling_out_lwidth_cfg;
input    [9:0] pooling_out_mwidth_cfg;
input    [2:0] pooling_size_v_cfg;
input    [7:0] pooling_splitw_num_cfg;
input    [3:0] pooling_stride_v_cfg;
input    [1:0] pooling_type_cfg;
input   [31:0] pwrbus_ram_pd;
input   [12:0] reg2dp_cube_in_height;
input   [12:0] reg2dp_cube_out_width;
//input    [1:0] reg2dp_input_data;
//input          reg2dp_int16_en;
//input          reg2dp_int8_en;
input    [2:0] reg2dp_kernel_height;
input    [2:0] reg2dp_kernel_width;
input    [2:0] reg2dp_pad_bottom_cfg;
input    [2:0] reg2dp_pad_top;
input   [18:0] reg2dp_pad_value_1x_cfg;
input   [18:0] reg2dp_pad_value_2x_cfg;
input   [18:0] reg2dp_pad_value_3x_cfg;
input   [18:0] reg2dp_pad_value_4x_cfg;
input   [18:0] reg2dp_pad_value_5x_cfg;
input   [18:0] reg2dp_pad_value_6x_cfg;
input   [18:0] reg2dp_pad_value_7x_cfg;
input    [9:0] reg2dp_partial_width_out_first;
input    [9:0] reg2dp_partial_width_out_last;
input    [9:0] reg2dp_partial_width_out_mid;
input   [16:0] reg2dp_recip_height_cfg;
input   [16:0] reg2dp_recip_width_cfg;
//: my $m = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;
//: print "output  [${m}-1:0] pdp_dp2wdma_pd; \n";
output         pdp_dp2wdma_valid;
output         pooling1d_prdy;
/////////////////////////////////////////////////////////////////////////
wire     [8:0] BANK_DEPTH;
wire           active_last_line;
wire           average_pooling_en;
wire           bubble_en_end;
wire     [2:0] bubble_num_dec;
wire     [3:0] buffer_lines_0;
wire     [3:0] buffer_lines_1;
wire     [3:0] buffer_lines_2;
wire     [3:0] buffer_lines_3;
wire     [3:0] cube_in_height_cfg;
wire           cur_datin_disable_2d_sync;
wire           data_c_end;
wire     [3:0] first_out_num;
wire     [2:0] first_out_num_dec2;
wire           first_splitw;
wire     [2:0] flush_in_next_surf;
wire     [2:0] flush_num_dec1;
wire           flush_read_en;
wire     [3:0] h_pt;
wire     [4:0] h_pt_pb;
wire           init_cnt;
wire     [7:0] init_unit2d_set;
wire    [NVDLA_PDP_THROUGHPUT*NVDLA_BPE-1:0] int_dp2wdma_pd;
wire           int_dp2wdma_valid;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+2:0] int_pout_mem_data;
wire     [3:0] kernel_width_cfg;
wire           last_c;
wire           last_line_in;
wire           last_out_done;
wire           last_pooling_flag;
wire           last_splitw;
wire           last_sub_lbuf_done;
wire           line_end;
wire           load_din;
wire           load_din_all;
wire           load_wr_stage1;
wire           load_wr_stage1_all;
wire           load_wr_stage2;
wire           load_wr_stage2_all;
wire           load_wr_stage3;
wire           load_wr_stage3_all;
wire     [7:0] mem_data_valid;
wire     [8:0] mem_raddr;
wire     [5:0] mem_raddr_2d_sync;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_0;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_1;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_2;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_3;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_4;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_5;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_6;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+3:0] mem_rdata_7;
wire     [7:0] mem_re;
wire     [7:0] mem_re1;
wire     [7:0] mem_re1_1st;
wire     [7:0] mem_re2;
wire     [7:0] mem_re2_1st;
wire     [7:0] mem_re2_last;
wire     [7:0] mem_re3;
wire     [7:0] mem_re3_1st;
wire     [7:0] mem_re3_last;
wire     [7:0] mem_re4;
wire     [7:0] mem_re4_1st;
wire     [7:0] mem_re4_last;
wire     [7:0] mem_re_1st;
wire     [7:0] mem_re_1st_2d_sync;
wire     [7:0] mem_re_2d_sync;
wire     [7:0] mem_re_last;
wire     [8:0] mem_waddr_0;
wire     [8:0] mem_waddr_1;
wire     [8:0] mem_waddr_2;
wire     [8:0] mem_waddr_3;
wire     [8:0] mem_waddr_4;
wire     [8:0] mem_waddr_5;
wire     [8:0] mem_waddr_6;
wire     [8:0] mem_waddr_7;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_0;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_1;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_2;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_3;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_4;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_5;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_6;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] mem_wdata_7;
wire     [7:0] mem_we;
wire           middle_surface_trig;
wire     [0:0] mon_first_out_num;
wire           mon_flush_in_next_surf;
wire           mon_flush_num_dec1;
wire     [0:0] mon_pad_table_index;
wire           mon_pad_value;
wire     [1:0] mon_pooling_size_minus_sride;
wire           mon_rest_height;
wire     [5:0] mon_strip_ycnt_offset;
wire     [1:0] mon_unit2d_cnt_pooling_max;
wire           need_flush;
wire           one_width_bubble_end;
wire           one_width_disable_2d_sync;
wire           one_width_norm_rdy;
wire     [2:0] pad_l;
wire    [16:0] pad_line_sum;
wire           pad_line_sum_prdy;
wire           pad_line_sum_pvld;
wire     [2:0] pad_r;
wire     [2:0] pad_table_index;
wire    [21:0] pad_value;
wire           padding_here;
wire     [2:0] padding_stride1_num;
wire     [2:0] padding_stride2_num;
wire     [2:0] padding_stride3_num;
wire     [2:0] padding_stride4_num;
wire           pooling1d_norm_rdy;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling1d_pd_use;
wire           pooling1d_prdy_use;
wire           pooling1d_pvld_use;
wire           pooling1d_vld_rebuild;
wire    [31:0] pooling_2d_info;
wire     [3:0] pooling_2d_info_0;
wire     [3:0] pooling_2d_info_1;
wire     [3:0] pooling_2d_info_2;
wire     [3:0] pooling_2d_info_3;
wire     [3:0] pooling_2d_info_4;
wire     [3:0] pooling_2d_info_5;
wire     [3:0] pooling_2d_info_6;
wire     [3:0] pooling_2d_info_7;
wire    [31:0] pooling_2d_info_sync;
wire           pooling_2d_rdy;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_0;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_1;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_2;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_3;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_4;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_5;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_6;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_2d_result_7;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_datin;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] pooling_datin_ext;
wire     [3:0] pooling_size;
wire     [2:0] pooling_size_minus_sride;
wire     [3:0] pooling_size_v;
wire           pooling_stride_big;
wire     [4:0] pooling_stride_v;
wire           pout_data_stage0_prdy;
wire           pout_data_stage1_prdy;
wire           pout_data_stage2_prdy;
wire           pout_data_stage3_prdy;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] pout_mem_data;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] pout_mem_data_last;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] pout_mem_data_last_sync;
wire     [7:0] pout_mem_data_sel;
wire     [7:0] pout_mem_data_sel_0;
wire     [7:0] pout_mem_data_sel_1;
wire     [7:0] pout_mem_data_sel_1_last;
wire     [7:0] pout_mem_data_sel_2;
wire     [7:0] pout_mem_data_sel_2_last;
wire     [7:0] pout_mem_data_sel_3;
wire     [7:0] pout_mem_data_sel_3_last;
wire     [7:0] pout_mem_data_sel_last;
wire     [7:0] pout_mem_data_sel_last_sync;
wire     [7:0] pout_mem_data_sel_sync;
wire     [2:0] pout_mem_size_v_use;
wire    [12:0] pout_width_cur;
wire           rd_comb_lbuf_end;
wire           rd_lbuf_end;
wire           rd_line_out;
wire           rd_line_out_done;
wire           rd_pout_data_en;
wire           rd_pout_data_stage0;
wire           rd_pout_data_stage1;
wire           rd_pout_data_stage1_all;
wire           rd_pout_data_stage2;
wire           rd_pout_data_stage2_all;
wire           rd_sub_lbuf_end;
wire    [12:0] rest_height;
wire    [13:0] rest_height_use;
wire           small_active;
wire           splitw_enable;
wire     [4:0] stride;
wire     [4:0] stride_1x;
wire     [5:0] stride_2x;
wire     [6:0] stride_3x;
wire     [6:0] stride_4x;
wire     [7:0] stride_5x;
wire     [7:0] stride_6x;
wire     [7:0] stride_7x;
wire           stride_end;
wire           stride_trig_end;
wire     [2:0] strip_ycnt_offset;
wire           stripe_receive_done;
wire           sub_lbuf_dout_done;
//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int(log($m)/log(2));
//: print "wire     [12-${k}:0] surface_num; \n";
//: print "reg     [12-${k}:0] surface_cnt_rd; \n";
//wire     [9:0] surface_num_0;
//wire     [9:0] surface_num_1;
wire     [7:0] unit2d_clr;
wire     [3:0] unit2d_cnt_pooling_a1;
wire     [3:0] unit2d_cnt_pooling_a2;
wire     [3:0] unit2d_cnt_pooling_a3;
wire     [3:0] unit2d_cnt_pooling_a4;
wire     [3:0] unit2d_cnt_pooling_a5;
wire     [3:0] unit2d_cnt_pooling_a6;
wire     [3:0] unit2d_cnt_pooling_a7;
wire           unit2d_cnt_pooling_end;
wire           unit2d_cnt_pooling_last_end;
wire     [2:0] unit2d_cnt_pooling_max;
wire     [7:0] unit2d_en_last;
wire     [7:0] unit2d_set;
wire     [7:0] unit2d_set_trig;
wire     [2:0] unit2d_vsize1_0;
wire     [2:0] unit2d_vsize1_1;
wire     [2:0] unit2d_vsize1_2;
wire     [2:0] unit2d_vsize1_3;
wire     [2:0] unit2d_vsize1_4;
wire     [2:0] unit2d_vsize1_5;
wire     [2:0] unit2d_vsize1_6;
wire     [2:0] unit2d_vsize1_7;
wire     [2:0] unit2d_vsize2_0;
wire     [2:0] unit2d_vsize2_1;
wire     [2:0] unit2d_vsize2_2;
wire     [2:0] unit2d_vsize2_3;
wire     [2:0] unit2d_vsize2_4;
wire     [2:0] unit2d_vsize2_5;
wire     [2:0] unit2d_vsize2_6;
wire     [2:0] unit2d_vsize2_7;
wire     [2:0] unit2d_vsize3_0;
wire     [2:0] unit2d_vsize3_1;
wire     [2:0] unit2d_vsize3_2;
wire     [2:0] unit2d_vsize3_3;
wire     [2:0] unit2d_vsize3_4;
wire     [2:0] unit2d_vsize3_5;
wire     [2:0] unit2d_vsize3_6;
wire     [2:0] unit2d_vsize3_7;
wire     [2:0] unit2d_vsize4_0;
wire     [2:0] unit2d_vsize4_1;
wire     [2:0] unit2d_vsize4_2;
wire     [2:0] unit2d_vsize4_3;
wire     [2:0] unit2d_vsize4_4;
wire     [2:0] unit2d_vsize4_5;
wire     [2:0] unit2d_vsize4_6;
wire     [2:0] unit2d_vsize4_7;
wire     [2:0] unit2d_vsize_0;
wire     [2:0] unit2d_vsize_1;
wire     [2:0] unit2d_vsize_2;
wire     [2:0] unit2d_vsize_3;
wire     [2:0] unit2d_vsize_4;
wire     [2:0] unit2d_vsize_5;
wire     [2:0] unit2d_vsize_6;
wire     [2:0] unit2d_vsize_7;
wire     [2:0] up_pnum0;
wire           wr_data_stage0_prdy;
wire           wr_data_stage1_prdy;
wire           wr_line_dat_done;
wire           wr_subcube_dat_done;
wire           wr_surface_dat_done;
wire           wr_total_cube_done;
reg      [3:0] bank_merge_num;
reg      [2:0] bubble_add;
reg      [2:0] bubble_cnt;
reg      [2:0] bubble_num;
reg      [2:0] bubble_num_use;
reg      [3:0] buffer_lines_num;
reg      [4:0] c_cnt;
reg      [4:0] channel_cnt;
reg            cube_end_flag;
reg            cur_datin_disable;
reg            cur_datin_disable_2d;
reg            cur_datin_disable_3d;
reg            cur_datin_disable_d;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] datin_buf;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0] datin_buf_2d;
reg      [2:0] flush_num;
reg      [2:0] flush_num_cal;
reg            flush_read_en_d;
reg      [8:0] int_mem_waddr;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_0;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_1;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_2;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_3;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_4;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_5;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_6;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3:0] int_mem_wdata_7;
reg      [7:0] int_mem_we;
reg            is_one_width_in;
reg            last_active_line_2d;
reg            last_active_line_d;
reg      [2:0] last_out_cnt;
reg            last_out_en;
reg     [12:0] line_cnt;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data0;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data0_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data1;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data1_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data2;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data2_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data3;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data3_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data4;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data4_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data5;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data5_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data6;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data6_lst;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data7;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] mem_data7_lst;
reg      [8:0] mem_raddr_2d;
reg      [8:0] mem_raddr_d;
reg            mem_re1_sel;
reg            mem_re2_sel;
reg            mem_re2_sel_last;
reg            mem_re3_sel;
reg            mem_re3_sel_last;
reg            mem_re4_sel;
reg            mem_re4_sel_last;
reg      [7:0] mem_re_1st_2d;
reg      [7:0] mem_re_1st_d;
reg      [7:0] mem_re_2d;
reg      [7:0] mem_re_d;
reg      [7:0] mem_re_last_2d;
reg      [7:0] mem_re_last_d;
reg            need_bubble;
reg      [2:0] next2_0;
reg      [2:0] next2_1;
reg      [2:0] next3_0;
reg      [2:0] next3_1;
reg      [2:0] next3_2;
reg      [2:0] next4_0;
reg      [2:0] next4_1;
reg      [2:0] next4_2;
reg      [2:0] next4_3;
reg      [2:0] next5_0;
reg      [2:0] next5_1;
reg      [2:0] next5_2;
reg      [2:0] next5_3;
reg      [2:0] next5_4;
reg      [2:0] next6_0;
reg      [2:0] next6_1;
reg      [2:0] next6_2;
reg      [2:0] next6_3;
reg      [2:0] next6_4;
reg      [2:0] next6_5;
reg      [2:0] next7_0;
reg      [2:0] next7_1;
reg      [2:0] next7_2;
reg      [2:0] next7_3;
reg      [2:0] next7_4;
reg      [2:0] next7_5;
reg      [2:0] next7_6;
reg      [2:0] one_width_bubble_cnt;
reg            one_width_disable;
reg            one_width_disable_2d;
reg            one_width_disable_3d;
reg            one_width_disable_d;
reg      [5:0] pad_r_remain;
reg     [18:0] pad_table_out;
reg      [2:0] padding_stride_num;
reg      [2:0] pnum_flush0;
reg      [2:0] pnum_flush1;
reg      [2:0] pnum_flush2;
reg      [2:0] pnum_flush3;
reg      [2:0] pnum_flush4;
reg      [2:0] pnum_flush5;
reg      [2:0] pnum_flush6;
reg            pout_data_stage1_vld;
reg            pout_data_stage2_vld;
reg            pout_data_stage3_vld;
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $x = NVDLA_PDP_BWPE;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:   print qq(
//:     reg     [${m}-1:0] pout_mem_data_$i;
//:   //  wire    [${m}-1:0] pout_mem_data$i; 
//:     wire    [${m}:0] data_8bit_${i};
//:     wire    [${m}:0] data_8bit_${i}_ff;
//:     wire           mon_data_8bit_${i};
//:     wire           mon_data_8bit_${i}_ff;
//:     reg     [${m}:0] pout_data_0_${i};
//:     wire    [${m}+16:0] data_hmult_8bit_${i}_ext_ff;
//:     wire    [${m}+16:0] data_hmult_8bit_${i}_ext;
//:     wire           i8_less_neg_0_5_${i};
//:     wire           i8_more_neg_0_5_${i};
//:     wire           mon_i8_neg_add1_${i};
//:     wire    [${j}-1:0] i8_neg_add1_${i};
//:     wire    [${j}-1:0] hmult_8bit_${i};
//:     wire    [${j}-1:0] data_hmult_8bit_${i};
//:     wire    [${j}-1:0] data_hmult_stage0_in$i;
//:     reg     [${j}-1:0] pout_data_stage0_$i;
//:     wire    [${j}+16:0] data_vmult_8bit_${i}_ext_ff;
//:     wire    [${j}+16:0] data_vmult_8bit_${i}_ext;
//:     wire           i8_vless_neg_0_5_${i};
//:     wire           i8_vmore_neg_0_5_${i};
//:     wire           mon_i8_neg_vadd1_${i};
//:     wire     [${x}-1:0] i8_neg_vadd1_${i};
//:     wire     [${x}-1:0] vmult_8bit_${i};
//:     wire    [${x}-1:0] data_vmult_8bit_${i};
//:     wire    [${x}-1:0] data_mult_stage1_in${i};
//:     reg     [${x}-1:0] pout_data_stage1_${i};
//:   );
//: }
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0] pout_mem_data_act;
reg      [2:0] pout_mem_size_v;
reg     [12:0] pout_width_cur_latch;
reg      [2:0] rd_comb_lbuf_cnt;
reg      [8:0] rd_line_out_cnt;
reg            rd_pout_data_en_2d;
reg            rd_pout_data_en_3d;
reg            rd_pout_data_en_4d;
reg            rd_pout_data_en_d;
reg      [2:0] rd_sub_lbuf_cnt;
reg     [16:0] reg2dp_recip_height_use;
reg     [16:0] reg2dp_recip_width_use;
reg      [2:0] samllH_flush_num;
reg      [2:0] strip_ycnt_psize;
reg      [3:0] strip_ycnt_stride;
reg      [3:0] strip_ycnt_stride_f;
reg      [8:0] sub_lbuf_dout_cnt;
reg            subend_need_flush_flg;
reg            surfend_need_bubble_flg;
reg      [2:0] unit2d_cnt_pooling;
reg      [2:0] unit2d_cnt_pooling_last;
reg      [2:0] unit2d_cnt_pooling_last_2d;
reg      [2:0] unit2d_cnt_pooling_last_d;
reg      [2:0] unit2d_cnt_stride;
reg      [7:0] unit2d_en;
reg      [7:0] unit2d_mem_1strd;
reg      [2:0] unit2d_vsize_cnt_0;
reg      [2:0] unit2d_vsize_cnt_0_d;
reg      [2:0] unit2d_vsize_cnt_1;
reg      [2:0] unit2d_vsize_cnt_1_d;
reg      [2:0] unit2d_vsize_cnt_2;
reg      [2:0] unit2d_vsize_cnt_2_d;
reg      [2:0] unit2d_vsize_cnt_3;
reg      [2:0] unit2d_vsize_cnt_3_d;
reg      [2:0] unit2d_vsize_cnt_4;
reg      [2:0] unit2d_vsize_cnt_4_d;
reg      [2:0] unit2d_vsize_cnt_5;
reg      [2:0] unit2d_vsize_cnt_5_d;
reg      [2:0] unit2d_vsize_cnt_6;
reg      [2:0] unit2d_vsize_cnt_6_d;
reg      [2:0] unit2d_vsize_cnt_7;
reg      [2:0] unit2d_vsize_cnt_7_d;
reg            up_pnum1;
reg      [1:0] up_pnum2;
reg      [1:0] up_pnum3;
reg      [2:0] up_pnum4;
reg      [2:0] up_pnum5;
reg            wr_data_stage0_vld;
reg            wr_data_stage1_vld;
reg            wr_data_stage2_vld;
reg     [12:0] wr_line_dat_cnt;
reg            wr_line_end_2d;
reg            wr_line_end_buf;
reg      [7:0] wr_splitc_cnt;
reg      [2:0] wr_sub_lbuf_cnt;
reg     [12:0] wr_surface_dat_cnt;
reg            wr_surface_dat_done_2d;
reg            wr_surface_dat_done_buf;
/////////////////////////////////////////////////////////////////////////////////////////
//==============================================================
////pdp cube_out_width setting

//////////////////////////////
//pdp cube_out_width setting, limited by line buffer size
//////////////////////////////
//non-split mode
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd127) & (bank_merge_num==4'd8)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd63)  & (bank_merge_num==4'd4)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd31)  & (bank_merge_num==4'd2)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"PDP cube_out_width setting out of range")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, load_din &(pout_width_cur > 13'd15)  & (bank_merge_num==4'd1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============================================================
//bank depth follows rule of 16 elements in width in worst case
//it's 64 in t194
//--------------------------------------------------------------
//: my $depth = (NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_THROUGHPUT)*16-1;
//: print " assign BANK_DEPTH = 9'd${depth};  \n";

//==============================================================
// buffer the input data from pooling 1D unit
// calculate the data postion in input-data-cube
//
//--------------------------------------------------------------
assign pooling1d_prdy = pooling1d_prdy_use;
assign pooling1d_pvld_use = pooling1d_pvld;
assign pooling1d_pd_use = pooling1d_pd;

assign pooling1d_prdy_use = one_width_norm_rdy & (~cur_datin_disable);
assign one_width_norm_rdy = pooling1d_norm_rdy & (~one_width_disable);
//////////////////////////////////////////////////////////////////////////////////////
assign load_din         = pooling1d_prdy_use & pooling1d_pvld_use; 
assign stripe_receive_done = load_din & data_c_end;

assign average_pooling_en = (pooling_type_cfg== 2'h0 );
//assign int8_en = (reg2dp_input_data[1:0] == 2'h0 );
//assign int16_en = (reg2dp_input_data[1:0] == 2'h1 );
//////////////////////////////////////////////////////////////////////////////////////
//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = int($m / $k);
//: print "assign data_c_end = (c_cnt == 5'd${j}-1); \n";
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    c_cnt[4:0] <= 0;
  end else if(load_din) begin
    if(data_c_end)
        c_cnt[4:0] <= 0;
    else
        c_cnt[4:0] <= c_cnt + 1'b1;
  end
end
//end of line
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_dat_cnt[12:0] <= {13{1'b0}};
  end else begin
    if(wr_line_dat_done)
        wr_line_dat_cnt[12:0] <= 0;
    else if(stripe_receive_done)
        wr_line_dat_cnt[12:0] <= wr_line_dat_cnt + 1;
  end
end
assign wr_line_dat_done  = (wr_line_dat_cnt==pout_width_cur) & stripe_receive_done;

//end of surface
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_surface_dat_cnt <= {13{1'b0}};
  end else begin
   if(wr_surface_dat_done)
       wr_surface_dat_cnt <= 13'd0;
   else if(wr_line_dat_done)
       wr_surface_dat_cnt <= wr_surface_dat_cnt + 13'd1;
  end
end
assign last_line_in = ( wr_surface_dat_cnt==reg2dp_cube_in_height[12:0]);
assign wr_surface_dat_done = wr_line_dat_done & last_line_in;

//end of splitw
//assign cube_out_channel[13:0]= pooling_channel_cfg[12:0] + 1'b1;
//////16bits: INT16 or FP16
////assign {mon_surface_num_0,surface_num_0[9:0]} = cube_out_channel[13:4] + {9'd0,(|cube_out_channel[3:0])};
//////8bits: INT8
////assign surface_num_1[9:0] = {1'b0,cube_out_channel[13:5]} + (|cube_out_channel[4:0]);
////assign surface_num        = int8_en ? surface_num_1 : surface_num_0;

//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int(log($m)/log(2));
//: print "assign surface_num = pooling_channel_cfg[12:${k}]; \n";

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surface_cnt_rd <= 0;
  end else begin
  if(wr_subcube_dat_done)
       surface_cnt_rd <=  0;
  else if(wr_surface_dat_done)
       surface_cnt_rd <= surface_cnt_rd + 1;
  end
end
assign wr_subcube_dat_done = (surface_num==surface_cnt_rd) & wr_surface_dat_done;

//total cube done
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_splitc_cnt[7:0] <= {8{1'b0}};
  end else begin
    if(wr_total_cube_done)
        wr_splitc_cnt[7:0] <= 8'd0;
    else if(wr_subcube_dat_done)
        wr_splitc_cnt[7:0] <= wr_splitc_cnt + 1;
  end
end
assign wr_total_cube_done = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & wr_subcube_dat_done;
//////////////////////////////////////////////////////////////////////////////////////

//split width selection 
assign splitw_enable = (pooling_splitw_num_cfg!=8'd0);
assign last_splitw   = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & splitw_enable;
assign first_splitw  = (wr_splitc_cnt==8'd0) & splitw_enable;

assign pout_width_cur[12:0]= (~splitw_enable) ? reg2dp_cube_out_width[12:0] : 
                            (last_splitw  ? {3'd0,pooling_out_lwidth_cfg[9:0]} : 
                             first_splitw ? {3'd0,pooling_out_fwidth_cfg[9:0]} : 
                                            {3'd0,pooling_out_mwidth_cfg[9:0]});
/////////////////////////////////////////////////////////////////////////////////////   
// assign data_posinfo = wr_line_dat_done;
//=============================================================
// physical memory bank 8
// 8 memory banks are used to load maximum 8 pooling output lines
//
//-------------------------------------------------------------

//maximum pooling output lines  need to be  buffer
//stride 1
assign buffer_lines_0[3:0] = pooling_size_v[3:0];  
//stride 2
assign buffer_lines_1[3:0] = {1'd0,pooling_size_v[3:1]} + pooling_size_v[0];
//stride 3
assign buffer_lines_2[3:0] = (3'd5>= pooling_size_v_cfg[2:0] ) ? 4'd2: 4'd3; 
//stride 4 5 6 7
assign buffer_lines_3 = 4'd2;

assign pooling_stride_big =  (pooling_stride_v_cfg>={1'b0,pooling_size_v_cfg[2:0]});

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_lines_num <= {4{1'b0}};
  end else begin
  if(pdp_op_start) begin
    if(pooling_stride_big)
        buffer_lines_num <= 4'd1;
    else begin
        case(pooling_stride_v_cfg)
            4'd0:    buffer_lines_num <= buffer_lines_0;  
            4'd1:    buffer_lines_num <= buffer_lines_1;
            4'd2:    buffer_lines_num <= buffer_lines_2;
            default: buffer_lines_num <= buffer_lines_3;
        endcase
    end
  end
  end
end

//memory bank merge num
always @(
  buffer_lines_num
  ) begin
   case(buffer_lines_num)
       4'd1:      bank_merge_num = 4'd8;
       4'd2:      bank_merge_num = 4'd4;
       4'd4,4'd3: bank_merge_num = 4'd2;
       default  : bank_merge_num = 4'd1;
   endcase
end
//==========================================================
//bank active enable signal 
//
//----------------------------------------------------------
//stride intial data

//stride ==1 
assign padding_stride1_num[2:0] = padding_v_cfg[2:0];
//stride ==2
assign padding_stride2_num[2:0] = {1'b0,padding_v_cfg[2:1]};
//stride ==3
assign padding_stride3_num[2:0]= (padding_v_cfg[2:0]>=3'd6) ? 3'd2 :
                                 (padding_v_cfg[2:0]>=3'd3) ? 3'd1 : 3'd0;
//stride==4 5 6 7
assign padding_stride4_num[2:0]= ({1'b0,padding_v_cfg[2:0]}>pooling_stride_v_cfg) ? 3'd1:3'd0;

assign pooling_stride_v[4:0] = pooling_stride_v_cfg[3:0] + 1;
//real num-1
always @(
  pooling_stride_v_cfg
  or padding_stride1_num
  or padding_stride2_num
  or padding_stride3_num
  or padding_stride4_num
  ) begin
 case(pooling_stride_v_cfg[3:0])
         4'd0: padding_stride_num = padding_stride1_num;
         4'd1: padding_stride_num = padding_stride2_num;
         4'd2: padding_stride_num = padding_stride3_num;
         default:padding_stride_num=padding_stride4_num;
 endcase
end

assign   {mon_strip_ycnt_offset[5:0],strip_ycnt_offset[2:0]} = {5'd0,padding_v_cfg} - padding_stride_num * pooling_stride_v;
/////////////////////////////////////////////////////////////////////////////////
assign middle_surface_trig = wr_surface_dat_done & (~wr_total_cube_done);
assign stride_end       = wr_line_dat_done & (strip_ycnt_stride== pooling_stride_v_cfg);      
assign init_cnt         = middle_surface_trig | pdp_op_start;

//pooling stride in vertical direction
always @(
  init_cnt
  or strip_ycnt_offset
  or stride_end
  or wr_line_dat_done
  or strip_ycnt_stride
  ) begin
     if(init_cnt)
         strip_ycnt_stride_f[3:0] = {1'b0,strip_ycnt_offset};
     else if(stride_end)
         strip_ycnt_stride_f[3:0] = 4'd0;
     else if(wr_line_dat_done)
         strip_ycnt_stride_f[3:0] = strip_ycnt_stride + 1;
     else
         strip_ycnt_stride_f[3:0] = strip_ycnt_stride;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_ycnt_stride[3:0] <= {4{1'b0}};
  end else begin
  if ((init_cnt | stride_end | wr_line_dat_done) == 1'b1) begin
    strip_ycnt_stride[3:0] <= strip_ycnt_stride_f;
  // VCS coverage off
  end else if ((init_cnt | stride_end | wr_line_dat_done) == 1'b0) begin
  end else begin
    strip_ycnt_stride[3:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(init_cnt | stride_end | wr_line_dat_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//2D pooling result ready
assign {mon_pooling_size_minus_sride[1:0],pooling_size_minus_sride[2:0]} = {1'b0,pooling_size_v_cfg[2:0]} - pooling_stride_v_cfg[3:0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_ycnt_psize <= {3{1'b0}};
  end else begin
   if(init_cnt)
        strip_ycnt_psize[2:0] <= padding_v_cfg[2:0];
   else if({1'b0,pooling_size_v_cfg} >= pooling_stride_v_cfg) begin
       if(pooling_2d_rdy)
            strip_ycnt_psize <= pooling_size_minus_sride[2:0];
       else if(wr_line_dat_done)
            strip_ycnt_psize <= strip_ycnt_psize + 1;
   end else begin // pooling_size < stride
       if(strip_ycnt_stride_f <= {1'b0,pooling_size_v_cfg})
            strip_ycnt_psize <= strip_ycnt_stride_f[2:0];
       else
            strip_ycnt_psize <= 3'd0;
   end
  end
end

//=====================================================================
assign pooling_size_v[3:0] = pooling_size_v_cfg[2:0] + 1;

assign pooling_size[3:0] = pooling_size_v;
assign stride[4:0] = pooling_stride_v;
assign pad_l[2:0] = padding_v_cfg;
assign pad_r = reg2dp_pad_bottom_cfg[2:0];//3'd1;

//active_data_num_last_pooling = (pad_l + width) % stride;
//assign {mon_active_data_num_last_pooling[1:0],active_data_num_last_pooling[2:0]} = pooling_size - pad_r;

//line num need flush at surface end
always @(
  pad_r
  or stride_1x
  or stride_2x
  or stride_3x
  or stride_4x
  or stride_5x
  or stride_6x
  or stride_7x
  ) begin
    if({2'd0,pad_r} < stride_1x[4:0])
        flush_num_cal = 3'd0;
    else if({3'd0,pad_r} < stride_2x[5:0])
        flush_num_cal = 3'd1;
    else if({4'd0,pad_r} < stride_3x[6:0])
        flush_num_cal = 3'd2;
    else if({4'd0,pad_r} < stride_4x[6:0])
        flush_num_cal = 3'd3;
    else if({5'd0,pad_r} < stride_5x[7:0])
        flush_num_cal = 3'd4;
    else if({5'd0,pad_r} < stride_6x[7:0])
        flush_num_cal = 3'd5;
    else if({5'd0,pad_r} < stride_7x[7:0])
        flush_num_cal = 3'd6;
    else// if({5'd0,pad_r} = stride_7x[7:0])
        flush_num_cal = 3'd7;
end

//small input detect
assign small_active = ((~(|reg2dp_cube_in_height[12:3])) & ((reg2dp_cube_in_height[2:0] + reg2dp_pad_top[2:0]) < {1'b0,reg2dp_kernel_height[2:0]}));
//non-split mode cube_width + pad_left + pad_right
assign h_pt[3:0] = reg2dp_cube_in_height[2:0] + reg2dp_pad_top[2:0];
assign h_pt_pb[4:0] = h_pt[3:0] + {1'b0,pad_r};

//pad_right remain afrer 1st kernel pooling
always @(
  small_active
  or h_pt_pb
  or reg2dp_kernel_height
  ) begin
    if(small_active)
        pad_r_remain[5:0] = h_pt_pb[4:0] - {2'd0,reg2dp_kernel_height[2:0]} ;
    else
        pad_r_remain[5:0] = 6'd0 ;
end
//how many need bubble after 1st kernel pooling
always @(
  pad_r_remain
  or stride_6x
  or stride_5x
  or stride_4x
  or stride_3x
  or stride_2x
  or stride_1x
  ) begin
    if({2'd0,pad_r_remain} == stride_6x[7:0])
        samllH_flush_num = 3'd6;
    else if({2'd0,pad_r_remain} == stride_5x[7:0])
        samllH_flush_num = 3'd5;
    else if({1'b0,pad_r_remain} == stride_4x[6:0])
        samllH_flush_num = 3'd4;
    else if({1'b0,pad_r_remain} == stride_3x[6:0])
        samllH_flush_num = 3'd3;
    else if(pad_r_remain == stride_2x[5:0])
        samllH_flush_num = 3'd2;
    else if(pad_r_remain == {1'b0,stride_1x[4:0]})
        samllH_flush_num = 3'd1;
    else// if(pad_r_remain == 8'd0)
        samllH_flush_num = 3'd0;
end

//flush num calc
always @(
  flush_num_cal
  or small_active
  or samllH_flush_num
  ) begin
    if(flush_num_cal==3'd0)
         flush_num[2:0] = 3'd0;
    else if(small_active)
         flush_num[2:0] = samllH_flush_num;
    else
        flush_num[2:0] = flush_num_cal[2:0];
end

assign need_flush = (flush_num != 3'd0);

assign stride_1x[4:0] =   stride[4:0];
assign stride_2x[5:0] =  {stride[4:0],1'b0};
assign stride_3x[6:0] = ( stride_2x+{1'b0,stride[4:0]});
assign stride_4x[6:0] =  {stride[4:0],2'b0}; 
assign stride_5x[7:0] = ( stride_4x+{2'd0,stride[4:0]});
assign stride_6x[7:0] = ( stride_3x+stride_3x);
assign stride_7x[7:0] = ( stride_4x+stride_3x);

//the 1st element/line num need output data
//assign {mon_first_out_num[0],first_out_num[3:0]} = small_active ? {2'd0,reg2dp_cube_in_height[2:0]} : (pooling_size - pad_l);
assign cube_in_height_cfg[3:0] = reg2dp_cube_in_height[2:0] + 3'd1;
assign {mon_first_out_num[0],first_out_num[3:0]} = small_active ? {1'd0,cube_in_height_cfg[3:0]} : (pooling_size - pad_l);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    need_bubble <= 1'b0;
    bubble_num_use[2:0] <= {3{1'b0}};
  end else begin
    //if(wr_total_cube_done) begin
    if(wr_subcube_dat_done) begin
        if(need_flush) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= flush_num;
        end else begin
            need_bubble <= 1'b0;
            bubble_num_use[2:0]  <= 3'd0;
        end
    end else if(last_line_in) begin
        if({1'b0,flush_num} >= first_out_num) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= flush_num - first_out_num[2:0] + 1'b1 + bubble_add;
        end else if(|bubble_add) begin
            need_bubble <= 1'b1;
            bubble_num_use[2:0]  <= bubble_add;
        end else begin
            need_bubble <= 1'b0;
            bubble_num_use[2:0]  <= 3'd0;
        end
    end
  end
end

///////////////////////////////////////////////////////////////////////
//bubble control when next surface comming .  Beginning
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_num[2:0] <= {3{1'b0}};
  end else begin
    if(pdp_op_start) begin
        if({1'b0,flush_num} >= first_out_num) begin
            bubble_num[2:0]  <= flush_num - first_out_num[2:0] + 1'b1;
        end else begin
            bubble_num[2:0]  <= 3'd0;
        end
    end
  end
end
assign {mon_flush_in_next_surf,flush_in_next_surf[2:0]} = flush_num[2:0] - bubble_num[2:0];
///////////////
always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush1
  or pnum_flush0
  or pnum_flush2
  or pnum_flush3
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd2) begin
        if(bubble_num == 3'd0) begin
            next2_1 = pnum_flush1;
            next2_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next2_1 = pnum_flush2;
            next2_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next2_1 = pnum_flush3;
            next2_0 = pnum_flush2;
        end else if(bubble_num == 3'd3) begin
            next2_1 = pnum_flush4;
            next2_0 = pnum_flush3;
        end else if(bubble_num == 3'd4) begin
            next2_1 = pnum_flush5;
            next2_0 = pnum_flush4;
        end else begin// else if(bubble_num == 3'd4) begin
            next2_1 = pnum_flush6;
            next2_0 = pnum_flush5;
        end
    end else begin
            next2_1 = 3'd0;
            next2_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush3
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd3) begin
        if(bubble_num == 3'd0) begin
            next3_2 = pnum_flush2;
            next3_1 = pnum_flush1;
            next3_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next3_2 = pnum_flush3;
            next3_1 = pnum_flush2;
            next3_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next3_2 = pnum_flush4;
            next3_1 = pnum_flush3;
            next3_0 = pnum_flush2;
        end else if(bubble_num == 3'd3) begin
            next3_2 = pnum_flush5;
            next3_1 = pnum_flush4;
            next3_0 = pnum_flush3;
        end else begin// else if(bubble_num == 3'd4) begin
            next3_2 = pnum_flush6;
            next3_1 = pnum_flush5;
            next3_0 = pnum_flush4;
        end
    end else begin
            next3_2 = 3'd0;
            next3_1 = 3'd0;
            next3_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush4
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd4) begin
        if(bubble_num == 3'd0) begin
            next4_3 = pnum_flush3;
            next4_2 = pnum_flush2;
            next4_1 = pnum_flush1;
            next4_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next4_3 = pnum_flush4;
            next4_2 = pnum_flush3;
            next4_1 = pnum_flush2;
            next4_0 = pnum_flush1;
        end else if(bubble_num == 3'd2) begin
            next4_3 = pnum_flush5;
            next4_2 = pnum_flush4;
            next4_1 = pnum_flush3;
            next4_0 = pnum_flush2;
        end else begin//else if(bubble_num == 3'd3) begin
            next4_3 = pnum_flush6;
            next4_2 = pnum_flush5;
            next4_1 = pnum_flush4;
            next4_0 = pnum_flush3;
        end
    end else begin
            next4_3 = 3'd0;
            next4_2 = 3'd0;
            next4_1 = 3'd0;
            next4_0 = 3'd0;
    end
end

always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush5
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd5) begin
        if(bubble_num == 3'd0) begin
            next5_4 = pnum_flush4;
            next5_3 = pnum_flush3;
            next5_2 = pnum_flush2;
            next5_1 = pnum_flush1;
            next5_0 = pnum_flush0;
        end else if(bubble_num == 3'd1) begin
            next5_4 = pnum_flush5;
            next5_3 = pnum_flush4;
            next5_2 = pnum_flush3;
            next5_1 = pnum_flush2;
            next5_0 = pnum_flush1;
        end else begin //else if(bubble_num == 3'd2) begin
            next5_4 = pnum_flush6;
            next5_3 = pnum_flush5;
            next5_2 = pnum_flush4;
            next5_1 = pnum_flush3;
            next5_0 = pnum_flush2;
        end
    end else begin
            next5_4 = 3'd0;
            next5_3 = 3'd0;
            next5_2 = 3'd0;
            next5_1 = 3'd0;
            next5_0 = 3'd0;
    end
end
always @(
  flush_in_next_surf
  or bubble_num
  or pnum_flush5
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  or pnum_flush6
  ) begin
    if(flush_in_next_surf == 4'd6) begin
        if(bubble_num == 3'd0) begin
            next6_5 = pnum_flush5;
            next6_4 = pnum_flush4;
            next6_3 = pnum_flush3;
            next6_2 = pnum_flush2;
            next6_1 = pnum_flush1;
            next6_0 = pnum_flush0;
        end else begin//else if(bubble_num == 3'd1) begin
            next6_5 = pnum_flush6;
            next6_4 = pnum_flush5;
            next6_3 = pnum_flush4;
            next6_2 = pnum_flush3;
            next6_1 = pnum_flush2;
            next6_0 = pnum_flush1;
        end
    end else begin
            next6_5 = 3'd0;
            next6_4 = 3'd0;
            next6_3 = 3'd0;
            next6_2 = 3'd0;
            next6_1 = 3'd0;
            next6_0 = 3'd0;
    end
end
always @(
  flush_in_next_surf
  or pnum_flush6
  or pnum_flush5
  or pnum_flush4
  or pnum_flush3
  or pnum_flush2
  or pnum_flush1
  or pnum_flush0
  ) begin
    if(flush_in_next_surf == 4'd7) begin
            next7_6 = pnum_flush6;
            next7_5 = pnum_flush5;
            next7_4 = pnum_flush4;
            next7_3 = pnum_flush3;
            next7_2 = pnum_flush2;
            next7_1 = pnum_flush1;
            next7_0 = pnum_flush0;
    end else begin
            next7_6 = 3'd0;
            next7_5 = 3'd0;
            next7_4 = 3'd0;
            next7_3 = 3'd0;
            next7_2 = 3'd0;
            next7_1 = 3'd0;
            next7_0 = 3'd0;
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_add <= {3{1'b0}};
  end else begin
    if(flush_in_next_surf == 4'd2) begin
            if((up_pnum0 == next2_1)|({2'd0,up_pnum1} == next2_1)|({1'b0,up_pnum2} == next2_1)|({1'b0,up_pnum3} == next2_1)|(up_pnum4 == next2_1)|(up_pnum5 == next2_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next2_0)|({2'd0,up_pnum1} == next2_0)|({1'b0,up_pnum2} == next2_0)|({1'b0,up_pnum3} == next2_0)|(up_pnum4 == next2_0)|(up_pnum5 == next2_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd3) begin
            if(     (up_pnum0 == next3_2)|({2'd0,up_pnum1} == next3_2)|({1'b0,up_pnum2} == next3_2)|({1'b0,up_pnum3} == next3_2)|(up_pnum4 == next3_2)|(up_pnum5 == next3_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next3_1)|({2'd0,up_pnum1} == next3_1)|({1'b0,up_pnum2} == next3_1)|({1'b0,up_pnum3} == next3_1)|(up_pnum4 == next3_1)|(up_pnum5 == next3_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next3_0)|({2'd0,up_pnum1} == next3_0)|({1'b0,up_pnum2} == next3_0)|({1'b0,up_pnum3} == next3_0)|(up_pnum4 == next3_0)|(up_pnum5 == next3_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd4) begin
            if(     (up_pnum0 == next4_3)|({2'd0,up_pnum1} == next4_3)|({1'b0,up_pnum2} == next4_3)|({1'b0,up_pnum3} == next4_3)|(up_pnum4 == next4_3)|(up_pnum5 == next4_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next4_2)|({2'd0,up_pnum1} == next4_2)|({1'b0,up_pnum2} == next4_2)|({1'b0,up_pnum3} == next4_2)|(up_pnum4 == next4_2)|(up_pnum5 == next4_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next4_1)|({2'd0,up_pnum1} == next4_1)|({1'b0,up_pnum2} == next4_1)|({1'b0,up_pnum3} == next4_1)|(up_pnum4 == next4_1)|(up_pnum5 == next4_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next4_0)|({2'd0,up_pnum1} == next4_0)|({1'b0,up_pnum2} == next4_0)|({1'b0,up_pnum3} == next4_0)|(up_pnum4 == next4_0)|(up_pnum5 == next4_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd5) begin
            if(     (up_pnum0 == next5_4)|({2'd0,up_pnum1} == next5_4)|({1'b0,up_pnum2} == next5_4)|({1'b0,up_pnum3} == next5_4)|(up_pnum4 == next5_4)|(up_pnum5 == next5_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next5_3)|({2'd0,up_pnum1} == next5_3)|({1'b0,up_pnum2} == next5_3)|({1'b0,up_pnum3} == next5_3)|(up_pnum4 == next5_3)|(up_pnum5 == next5_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next5_2)|({2'd0,up_pnum1} == next5_2)|({1'b0,up_pnum2} == next5_2)|({1'b0,up_pnum3} == next5_2)|(up_pnum4 == next5_2)|(up_pnum5 == next5_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next5_1)|({2'd0,up_pnum1} == next5_1)|({1'b0,up_pnum2} == next5_1)|({1'b0,up_pnum3} == next5_1)|(up_pnum4 == next5_1)|(up_pnum5 == next5_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next5_0)|({2'd0,up_pnum1} == next5_0)|({1'b0,up_pnum2} == next5_0)|({1'b0,up_pnum3} == next5_0)|(up_pnum4 == next5_0)|(up_pnum5 == next5_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd6) begin
            if(     (up_pnum0 == next6_5)|({2'd0,up_pnum1} == next6_5)|({1'b0,up_pnum2} == next6_5)|({1'b0,up_pnum3} == next6_5)|(up_pnum4 == next6_5)|(up_pnum5 == next6_5))
                bubble_add <= 3'd6;
            else if((up_pnum0 == next6_4)|({2'd0,up_pnum1} == next6_4)|({1'b0,up_pnum2} == next6_4)|({1'b0,up_pnum3} == next6_4)|(up_pnum4 == next6_4)|(up_pnum5 == next6_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next6_3)|({2'd0,up_pnum1} == next6_3)|({1'b0,up_pnum2} == next6_3)|({1'b0,up_pnum3} == next6_3)|(up_pnum4 == next6_3)|(up_pnum5 == next6_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next6_2)|({2'd0,up_pnum1} == next6_2)|({1'b0,up_pnum2} == next6_2)|({1'b0,up_pnum3} == next6_2)|(up_pnum4 == next6_2)|(up_pnum5 == next6_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next6_1)|({2'd0,up_pnum1} == next6_1)|({1'b0,up_pnum2} == next6_1)|({1'b0,up_pnum3} == next6_1)|(up_pnum4 == next6_1)|(up_pnum5 == next6_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next6_0)|({2'd0,up_pnum1} == next6_0)|({1'b0,up_pnum2} == next6_0)|({1'b0,up_pnum3} == next6_0)|(up_pnum4 == next6_0)|(up_pnum5 == next6_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else if(flush_in_next_surf == 4'd7) begin
            if(     (up_pnum0 == next7_6)|({2'd0,up_pnum1} == next7_6)|({1'b0,up_pnum2} == next7_6)|({1'b0,up_pnum3} == next7_6)|(up_pnum4 == next7_6)|(up_pnum5 == next7_6))
                bubble_add <= 3'd7;
            else if((up_pnum0 == next7_5)|({2'd0,up_pnum1} == next7_5)|({1'b0,up_pnum2} == next7_5)|({1'b0,up_pnum3} == next7_5)|(up_pnum4 == next7_5)|(up_pnum5 == next7_5))
                bubble_add <= 3'd6;
            else if((up_pnum0 == next7_4)|({2'd0,up_pnum1} == next7_4)|({1'b0,up_pnum2} == next7_4)|({1'b0,up_pnum3} == next7_4)|(up_pnum4 == next7_4)|(up_pnum5 == next7_4))
                bubble_add <= 3'd5;
            else if((up_pnum0 == next7_3)|({2'd0,up_pnum1} == next7_3)|({1'b0,up_pnum2} == next7_3)|({1'b0,up_pnum3} == next7_3)|(up_pnum4 == next7_3)|(up_pnum5 == next7_3))
                bubble_add <= 3'd4;
            else if((up_pnum0 == next7_2)|({2'd0,up_pnum1} == next7_2)|({1'b0,up_pnum2} == next7_2)|({1'b0,up_pnum3} == next7_2)|(up_pnum4 == next7_2)|(up_pnum5 == next7_2))
                bubble_add <= 3'd3;
            else if((up_pnum0 == next7_1)|({2'd0,up_pnum1} == next7_1)|({1'b0,up_pnum2} == next7_1)|({1'b0,up_pnum3} == next7_1)|(up_pnum4 == next7_1)|(up_pnum5 == next7_1))
                bubble_add <= 3'd2;
            else if((up_pnum0 == next7_0)|({2'd0,up_pnum1} == next7_0)|({1'b0,up_pnum2} == next7_0)|({1'b0,up_pnum3} == next7_0)|(up_pnum4 == next7_0)|(up_pnum5 == next7_0))
                bubble_add <= 3'd1;
            else
                bubble_add <= 3'd0;
    end else begin
        bubble_add <= 3'd0;
    end
  end
end
//-------------------------
assign unit2d_cnt_pooling_a1[3:0] = unit2d_cnt_pooling[2:0] + 3'd1;
assign unit2d_cnt_pooling_a2[3:0] = unit2d_cnt_pooling[2:0] + 3'd2;
assign unit2d_cnt_pooling_a3[3:0] = unit2d_cnt_pooling[2:0] + 3'd3;
assign unit2d_cnt_pooling_a4[3:0] = unit2d_cnt_pooling[2:0] + 3'd4;
assign unit2d_cnt_pooling_a5[3:0] = unit2d_cnt_pooling[2:0] + 3'd5;
assign unit2d_cnt_pooling_a6[3:0] = unit2d_cnt_pooling[2:0] + 3'd6;
assign unit2d_cnt_pooling_a7[3:0] = unit2d_cnt_pooling[2:0] + 3'd7;

//pooling No. in flush time
always @(posedge nvdla_core_clk) begin
    //if(wr_surface_dat_done) begin
    if(last_line_in) begin
        if(unit2d_cnt_pooling[2:0] == unit2d_cnt_pooling_max) begin
            pnum_flush0 <= 3'd0;
            pnum_flush1 <= 3'd1;
            pnum_flush2 <= 3'd2;
            pnum_flush3 <= 3'd3;
            pnum_flush4 <= 3'd4;
            pnum_flush5 <= 3'd5;
            pnum_flush6 <= 3'd6;
        end else if(unit2d_cnt_pooling_a1 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling_max;
            pnum_flush1 <= 3'd0;
            pnum_flush2 <= 3'd1;
            pnum_flush3 <= 3'd2;
            pnum_flush4 <= 3'd3;
            pnum_flush5 <= 3'd4;
            pnum_flush6 <= 3'd5;
        end else if(unit2d_cnt_pooling_a2 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'b1;
            pnum_flush1 <= unit2d_cnt_pooling_max;
            pnum_flush2 <= 3'd0;
            pnum_flush3 <= 3'd1;
            pnum_flush4 <= 3'd2;
            pnum_flush5 <= 3'd3;
            pnum_flush6 <= 3'd4;
        end else if(unit2d_cnt_pooling_a3 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling_max;
            pnum_flush3 <= 3'd0;
            pnum_flush4 <= 3'd1;
            pnum_flush5 <= 3'd2;
            pnum_flush6 <= 3'd3;
        end else if(unit2d_cnt_pooling_a4 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling_max;
            pnum_flush4 <= 3'd0;
            pnum_flush5 <= 3'd1;
            pnum_flush6 <= 3'd2;
        end else if(unit2d_cnt_pooling_a5 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling_max;
            pnum_flush5 <= 3'd0;
            pnum_flush6 <= 3'd1;
        end else if(unit2d_cnt_pooling_a6 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling + 3'd5;
            pnum_flush5 <= unit2d_cnt_pooling_max;
            pnum_flush6 <= 3'd0;
        end else if(unit2d_cnt_pooling_a7 == {1'b0,unit2d_cnt_pooling_max}) begin
            pnum_flush0 <= unit2d_cnt_pooling + 1'd1;
            pnum_flush1 <= unit2d_cnt_pooling + 2'd2;
            pnum_flush2 <= unit2d_cnt_pooling + 2'd3;
            pnum_flush3 <= unit2d_cnt_pooling + 3'd4;
            pnum_flush4 <= unit2d_cnt_pooling + 3'd5;
            pnum_flush5 <= unit2d_cnt_pooling + 3'd6;
            pnum_flush6 <= unit2d_cnt_pooling_max;
        end
    end
end

//-------------------------
//update pooling No. in line2 of next surface
//-------------------------
assign up_pnum0 = 3'd0;
always @(posedge nvdla_core_clk) begin
    if(padding_v_cfg[2:0] == 3'd0) begin
        up_pnum1 <= 1'd0;
        up_pnum2 <= 2'd0;
        up_pnum3 <= 2'd0;
        up_pnum4 <= 3'd0;
        up_pnum5 <= 3'd0;
    end else if(padding_v_cfg[2:0] == 3'd1) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd2) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd3) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd2)|(stride[4:0]==5'd3)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd4) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd4;
            up_pnum5 <= 3'd0;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd3)|(stride[4:0]==5'd4)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end else if(padding_v_cfg[2:0] == 3'd5) begin
        if(stride[4:0]==5'd1) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd3;
            up_pnum4 <= 3'd4;
            up_pnum5 <= 3'd5;
        end else if(stride[4:0]==5'd2) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd2;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else if((stride[4:0]==5'd3)|(stride[4:0]==5'd4)|(stride[4:0]==5'd5)) begin
            up_pnum1 <= 1'd1;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end else begin
            up_pnum1 <= 1'd0;
            up_pnum2 <= 2'd0;
            up_pnum3 <= 2'd0;
            up_pnum4 <= 3'd0;
            up_pnum5 <= 3'd0;
        end
    end
end

///////////////////////////////////////////////////////////////////////
//bubble control when next surface comming .  Ending
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    subend_need_flush_flg <= 1'b0;
  end else begin
    if(wr_subcube_dat_done & need_flush & is_one_width_in)
        subend_need_flush_flg <= 1'b1;
    else if(one_width_bubble_end)
        subend_need_flush_flg <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surfend_need_bubble_flg <= 1'b0;
  end else begin
    if(wr_surface_dat_done & need_bubble & is_one_width_in)
        surfend_need_bubble_flg <= 1'b1;
    else if(one_width_bubble_end)
        surfend_need_bubble_flg <= 1'b0;
  end
end

/////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable <= 1'b0;
  end else begin
    if((wr_subcube_dat_done & need_flush & (~is_one_width_in)) | (subend_need_flush_flg & one_width_bubble_end))
        cur_datin_disable <= 1'b1;
    else if((wr_surface_dat_done & need_bubble & (~is_one_width_in)) | (surfend_need_bubble_flg & one_width_bubble_end))
        cur_datin_disable <= 1'b1;
    else if(bubble_en_end)
        cur_datin_disable <= 1'b0;
  end
end
/////////////////////////////////////////
//&Always posedge;
//    if(wr_subcube_dat_done & need_flush)
//        cur_datin_disable <0= 1'b1;
//    else if(wr_surface_dat_done & need_bubble)
//        cur_datin_disable <0= 1'b1;
//    else if(bubble_en_end)
//        cur_datin_disable <0= 1'b0;
//&End;
///////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_width_cur_latch <= {13{1'b0}};
  end else begin
    if((wr_subcube_dat_done & need_flush) || (wr_surface_dat_done & need_bubble))
        pout_width_cur_latch <= pout_width_cur;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    channel_cnt <= 0;
  end else begin
    if(cur_datin_disable) begin
        if(last_c)
            channel_cnt <= 0;
        else if(one_width_norm_rdy)
            channel_cnt <= channel_cnt + 1'b1;
    end else
            channel_cnt <= 0;
  end
end
//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = int($m / $k);
//: print "assign last_c = (channel_cnt==5'd${j}-1) & one_width_norm_rdy; \n";

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    line_cnt <= {13{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(line_end)
            line_cnt <= 13'd0;
        else if(last_c)
            line_cnt <= line_cnt + 1'b1;
    end else
            line_cnt <= 13'd0;
  end
end
assign line_end = (line_cnt==pout_width_cur_latch) & last_c;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_cnt <= {3{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(bubble_en_end)
            bubble_cnt <= 3'd0;
        else if(line_end)
            bubble_cnt <= bubble_cnt + 1'b1;
    end else
            bubble_cnt <= 3'd0;
  end
end
assign bubble_en_end = (bubble_cnt == bubble_num_dec) & line_end;
assign bubble_num_dec[2:0] = (bubble_num_use-1'b1);

//////////////////////////////////////////////////////
//last lines output en during new lines comming
//----------------------------------------------------
//cube end flag for last_out_en control in the cube end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cube_end_flag <= 1'b0;
  end else begin
    if(wr_subcube_dat_done)
        cube_end_flag <= 1'b1;
    else if(load_din)
        cube_end_flag <= 1'b0;
  end
end

//assign {mon_first_out_num_dec1[1:0],first_out_num_dec1[2:0]} = first_out_num - 4'd1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_en <= 1'b0;
  end else begin
    if(first_out_num != 3'd1) begin
        if((need_bubble & bubble_en_end & (~cube_end_flag) & (bubble_add < flush_in_next_surf)) | (~need_bubble & need_flush & wr_surface_dat_done & (~wr_subcube_dat_done)))
            last_out_en <= 1'b1;
        else if(last_out_done)
            last_out_en <= 1'b0;
    end else
            last_out_en <= 1'b0;
  end
end

assign first_out_num_dec2[2:0] = flush_num - bubble_num_use - 1'b1;//first_out_num - 2'd2;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_cnt <= {3{1'b0}};
  end else begin
    if(last_out_en) begin
        if(wr_line_dat_done) begin
            if(((last_out_cnt == first_out_num_dec2) & need_bubble) | (~need_bubble & (last_out_cnt == flush_num_dec1)))
                last_out_cnt <= 3'd0;
            else
                last_out_cnt <= last_out_cnt + 1'b1;
        end
    end else
        last_out_cnt <= 3'd0;
  end
end
assign {mon_flush_num_dec1,flush_num_dec1[2:0]} = flush_num - 3'd1;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP cal2d datin_disable: no overflow is allowed")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, mon_flush_num_dec1 & wr_line_dat_done & last_out_en); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign last_out_done = (((last_out_cnt == first_out_num_dec2) & need_bubble) | (~need_bubble & (last_out_cnt == flush_num_dec1))) & wr_line_dat_done & last_out_en;

///////////////////////////////////////////////////////////////////////
//bubble control when input width is only 1 element in width
///////////////////////////////////////////////////////////////////////
always @(
  splitw_enable
  or reg2dp_cube_out_width
  or first_splitw
  or reg2dp_partial_width_out_first
  or last_splitw
  or reg2dp_partial_width_out_last
  or pooling_splitw_num_cfg
  or reg2dp_partial_width_out_mid
  ) begin
    if(~splitw_enable)
        is_one_width_in = (reg2dp_cube_out_width[12:0] == 13'd0);
    else if(first_splitw)
        is_one_width_in = (reg2dp_partial_width_out_first[9:0] == 10'd0);
    else if(last_splitw)
        is_one_width_in = (reg2dp_partial_width_out_last[9:0] == 10'd0);
    else
        is_one_width_in = (pooling_splitw_num_cfg > 8'd1)? (reg2dp_partial_width_out_mid[9:0] == 10'd0) : 1'b0;
end
/////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_disable <= 1'b0;
  end else begin
    if(wr_line_dat_done & is_one_width_in)
        one_width_disable <= 1'b1;
    else if(one_width_bubble_end)
        one_width_disable <= 1'b0;
  end
end
/////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_bubble_cnt <= {3{1'b0}};
  end else begin
    if(one_width_disable) begin
        if(one_width_bubble_end)
            one_width_bubble_cnt <= 3'd0;
        else if(pooling1d_norm_rdy)
            one_width_bubble_cnt <= one_width_bubble_cnt + 1'b1;
    end else
            one_width_bubble_cnt <= 3'd0;
  end
end
assign one_width_bubble_end = (one_width_bubble_cnt == (4 -2'd2)) & pooling1d_norm_rdy;

//////////////////////////////////////////////////////

assign  pooling_2d_rdy      = wr_line_dat_done & (strip_ycnt_psize ==pooling_size_v_cfg[2:0])  ;
//=====================================================================
//pooling 2D unit counter
//
//---------------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_stride[2:0] <= {3{1'b0}};
  end else begin
    if(init_cnt)
       unit2d_cnt_stride[2:0] <= padding_stride_num;
    else if(stride_end) begin
       if(stride_trig_end)
          unit2d_cnt_stride[2:0] <= 3'd0;
       else
          unit2d_cnt_stride[2:0] <= unit2d_cnt_stride + 1;
    end
  end
end
assign stride_trig_end = (unit2d_cnt_pooling_max==unit2d_cnt_stride);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling <= {3{1'b0}};
  end else begin
    if(init_cnt)
         unit2d_cnt_pooling <= 3'd0;
    else if(pooling_2d_rdy | wr_surface_dat_done) begin
      if(unit2d_cnt_pooling_end)
           unit2d_cnt_pooling <= 3'd0;
      else
           unit2d_cnt_pooling[2:0] <= unit2d_cnt_pooling + 1;
    end
  end
end
assign unit2d_cnt_pooling_end = (unit2d_cnt_pooling == unit2d_cnt_pooling_max);

assign {mon_unit2d_cnt_pooling_max[1:0],unit2d_cnt_pooling_max[2:0]} = buffer_lines_num - 4'd1;
//-------------------------
//flag the last one pooling in height direction
//-------------------------
assign {mon_rest_height,rest_height[12:0]} = reg2dp_cube_in_height - wr_surface_dat_cnt;
assign rest_height_use[13:0] = rest_height + {10'd0,reg2dp_pad_bottom_cfg};
assign last_pooling_flag = rest_height_use[13:0] <= {11'd0,pooling_size_v_cfg};
//======================================================================

//unit2d pooling enable         
//: foreach my $i (0..7) {
//: my $j=$i-1;
//:     print "assign init_unit2d_set[$i] = init_cnt & (padding_stride_num>=${i}); \n";
//:     if($i == 0) {
//:         print "assign unit2d_set_trig[${i}] = stride_end & stride_trig_end & (~last_pooling_flag);\n";
//:     } else {
//:         print "assign unit2d_set_trig[${i}] = stride_end & (unit2d_cnt_stride == 3'd${j}) & (~stride_trig_end) & (~last_pooling_flag);\n";
//:     }
//:     print qq(
//:             assign unit2d_set[${i}] = unit2d_set_trig[${i}] | init_unit2d_set[${i}]; 
//:             assign unit2d_clr[${i}] = (pooling_2d_rdy & (unit2d_cnt_pooling == 3'd${i})) | wr_surface_dat_done; 
//:             always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:               if (!nvdla_core_rstn)
//:                    unit2d_en[$i] <= 1'b0;
//:               else if(wr_total_cube_done)
//:                    unit2d_en[$i] <= 1'b0;
//:               else if(unit2d_set[${i}])
//:                    unit2d_en[$i] <= 1'b1;
//:               else if(unit2d_clr[${i}])
//:                    unit2d_en[$i] <= 1'b0;
//:             end
//:     );
//: }

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datin_buf <= 0;
  end else begin
  if ((load_din) == 1'b1) begin
    datin_buf <= pooling1d_pd_use;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_end_buf <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    wr_line_end_buf <= wr_line_dat_done;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_surface_dat_done_buf <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    wr_surface_dat_done_buf <= wr_surface_dat_done;
  end
  end
end

//////////////////////////////////////////////////////////////////////
//calculate the real pooling size within one poooling 
//PerBeg
//: foreach my $i (0..7){
//: print qq(
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:       if (!nvdla_core_rstn)
//:         unit2d_vsize_cnt_$i <= {3{1'b0}};
//:       else if(unit2d_set[$i])
//:           unit2d_vsize_cnt_${i}[2:0] <= 3'd0;
//:       else if(unit2d_en[$i] & wr_line_dat_done)
//:           unit2d_vsize_cnt_${i}[2:0] <= unit2d_vsize_cnt_${i}[2:0] + 3'd1;      
//:     end
//: );
//: }

//line buffer number 1
assign unit2d_vsize1_0 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_1 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_2 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_3 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_4 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_5 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_6 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize1_7 = mem_re1_sel? unit2d_vsize_cnt_0 : 3'd0;

//line buffer number 2
assign unit2d_vsize2_0 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_1 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_2 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_3 = mem_re2_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize2_4 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_5 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_6 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize2_7 = mem_re2_sel? unit2d_vsize_cnt_1 : 3'd0;

//line buffer number 3 4
assign unit2d_vsize3_0 = mem_re3_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize3_1 = mem_re3_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize3_2 = mem_re3_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize3_3 = mem_re3_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize3_4 = mem_re3_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize3_5 = mem_re3_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize3_6 = mem_re3_sel? unit2d_vsize_cnt_3 : 3'd0;
assign unit2d_vsize3_7 = mem_re3_sel? unit2d_vsize_cnt_3 : 3'd0;

//line buffer 5 6 7 8
assign unit2d_vsize4_0 = mem_re4_sel? unit2d_vsize_cnt_0 : 3'd0;
assign unit2d_vsize4_1 = mem_re4_sel? unit2d_vsize_cnt_1 : 3'd0;
assign unit2d_vsize4_2 = mem_re4_sel? unit2d_vsize_cnt_2 : 3'd0;
assign unit2d_vsize4_3 = mem_re4_sel? unit2d_vsize_cnt_3 : 3'd0;
assign unit2d_vsize4_4 = mem_re4_sel? unit2d_vsize_cnt_4 : 3'd0;
assign unit2d_vsize4_5 = mem_re4_sel? unit2d_vsize_cnt_5 : 3'd0;
assign unit2d_vsize4_6 = mem_re4_sel? unit2d_vsize_cnt_6 : 3'd0;
assign unit2d_vsize4_7 = mem_re4_sel? unit2d_vsize_cnt_7 : 3'd0;

assign unit2d_vsize_0 = unit2d_vsize1_0 | unit2d_vsize2_0 | unit2d_vsize3_0 | unit2d_vsize4_0;
assign unit2d_vsize_1 = unit2d_vsize1_1 | unit2d_vsize2_1 | unit2d_vsize3_1 | unit2d_vsize4_1;
assign unit2d_vsize_2 = unit2d_vsize1_2 | unit2d_vsize2_2 | unit2d_vsize3_2 | unit2d_vsize4_2;
assign unit2d_vsize_3 = unit2d_vsize1_3 | unit2d_vsize2_3 | unit2d_vsize3_3 | unit2d_vsize4_3;
assign unit2d_vsize_4 = unit2d_vsize1_4 | unit2d_vsize2_4 | unit2d_vsize3_4 | unit2d_vsize4_4;
assign unit2d_vsize_5 = unit2d_vsize1_5 | unit2d_vsize2_5 | unit2d_vsize3_5 | unit2d_vsize4_5;
assign unit2d_vsize_6 = unit2d_vsize1_6 | unit2d_vsize2_6 | unit2d_vsize3_6 | unit2d_vsize4_6;
assign unit2d_vsize_7 = unit2d_vsize1_7 | unit2d_vsize2_7 | unit2d_vsize3_7 | unit2d_vsize4_7;

//: foreach my $i (0..7) {
//: print qq(
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:       if (!nvdla_core_rstn)
//:         unit2d_vsize_cnt_${i}_d <= {3{1'b0}};
//:       else if (load_din)
//:         unit2d_vsize_cnt_${i}_d <= unit2d_vsize_$i;
//:     end
//: );
//: }

//============================================================

assign active_last_line = (strip_ycnt_psize == pooling_size_v_cfg) | last_line_in;
//============================================================
//memory bank read/write controller
//
//------------------------------------------------------------
//memory read
//mem bank0 enable
//

//memory first read
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[0] <= 1'b0;
  end else begin
  unit2d_mem_1strd[0] <= unit2d_set[0] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[0]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[1] <= 1'b0;
  end else begin
  unit2d_mem_1strd[1] <= unit2d_set[1] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[1]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[2] <= 1'b0;
  end else begin
  unit2d_mem_1strd[2] <= unit2d_set[2] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[2]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[3] <= 1'b0;
  end else begin
  unit2d_mem_1strd[3] <= unit2d_set[3] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[3]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[4] <= 1'b0;
  end else begin
  unit2d_mem_1strd[4] <= unit2d_set[4] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[4]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[5] <= 1'b0;
  end else begin
  unit2d_mem_1strd[5] <= unit2d_set[5] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[5]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[6] <= 1'b0;
  end else begin
  unit2d_mem_1strd[6] <= unit2d_set[6] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[6]);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_mem_1strd[7] <= 1'b0;
  end else begin
  unit2d_mem_1strd[7] <= unit2d_set[7] ? 1'b1 : (wr_line_dat_done ? 1'b0 :  unit2d_mem_1strd[7]);
  end
end
 
//line buffer number 1
assign mem_re1[0] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re1_sel;
assign mem_re1[1] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re1_sel;
assign mem_re1[2] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re1_sel;
assign mem_re1[3] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re1_sel;
assign mem_re1[4] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd4) & mem_re1_sel;
assign mem_re1[5] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd5) & mem_re1_sel;
assign mem_re1[6] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd6) & mem_re1_sel;
assign mem_re1[7] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd7) & mem_re1_sel;
assign mem_re1_1st[0] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[1] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[2] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[3] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[4] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[5] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[6] =  unit2d_mem_1strd[0] & mem_re1_sel;
assign mem_re1_1st[7] =  unit2d_mem_1strd[0] & mem_re1_sel;

//line buffer number 2
//4 bank read enable
//mem_read
assign mem_re2[0] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel;
assign mem_re2[1] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel; 
assign mem_re2[2] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel;
assign mem_re2[3] = unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel;
assign mem_re2[4] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel;
assign mem_re2[5] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel;
assign mem_re2[6] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel;
assign mem_re2[7] = unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel;
assign mem_re2_1st[0] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[1] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[2] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[3] =  unit2d_mem_1strd[0] & mem_re2_sel;
assign mem_re2_1st[4] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[5] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[6] =  unit2d_mem_1strd[1] & mem_re2_sel;
assign mem_re2_1st[7] =  unit2d_mem_1strd[1] & mem_re2_sel;

//line buffer number 3 4
assign mem_re3[0] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[1] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[2] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[3] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[4] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[5] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3[6] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel;
assign mem_re3[7] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel;
assign mem_re3_1st[0] =  unit2d_mem_1strd[0] & mem_re3_sel;
assign mem_re3_1st[1] =  unit2d_mem_1strd[0] & mem_re3_sel;
assign mem_re3_1st[2] =  unit2d_mem_1strd[1] & mem_re3_sel;
assign mem_re3_1st[3] =  unit2d_mem_1strd[1] & mem_re3_sel;
assign mem_re3_1st[4] =  unit2d_mem_1strd[2] & mem_re3_sel;
assign mem_re3_1st[5] =  unit2d_mem_1strd[2] & mem_re3_sel;
assign mem_re3_1st[6] =  unit2d_mem_1strd[3] & mem_re3_sel;
assign mem_re3_1st[7] =  unit2d_mem_1strd[3] & mem_re3_sel;

//line buffer 5 6 7 8
assign mem_re4[0] =  unit2d_en[0] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[1] =  unit2d_en[1] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[2] =  unit2d_en[2] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[3] =  unit2d_en[3] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[4] =  unit2d_en[4] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[5] =  unit2d_en[5] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[6] =  unit2d_en[6] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4[7] =  unit2d_en[7] & load_din & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel;
assign mem_re4_1st[0] =  unit2d_mem_1strd[0] & mem_re4_sel;
assign mem_re4_1st[1] =  unit2d_mem_1strd[1] & mem_re4_sel;
assign mem_re4_1st[2] =  unit2d_mem_1strd[2] & mem_re4_sel;
assign mem_re4_1st[3] =  unit2d_mem_1strd[3] & mem_re4_sel;
assign mem_re4_1st[4] =  unit2d_mem_1strd[4] & mem_re4_sel;
assign mem_re4_1st[5] =  unit2d_mem_1strd[5] & mem_re4_sel;
assign mem_re4_1st[6] =  unit2d_mem_1strd[6] & mem_re4_sel;
assign mem_re4_1st[7] =  unit2d_mem_1strd[7] & mem_re4_sel;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re1_sel <= 1'b0;
    mem_re2_sel <= 1'b0;
    mem_re3_sel <= 1'b0;
    mem_re4_sel <= 1'b0;
  end else begin
 mem_re1_sel  <= (buffer_lines_num==4'd1);
 mem_re2_sel  <= (buffer_lines_num==4'd2);
 mem_re3_sel  <= (buffer_lines_num==4'd3) | (buffer_lines_num==4'd4);
 mem_re4_sel  <= (buffer_lines_num >=4'd5);
  end
end

///////////////////////////
//shouldn't read data from mem for the first pooling line
///////////////////////////
assign mem_re       = mem_re1 |  mem_re2 | mem_re3 | mem_re4;
assign mem_re_1st   = mem_re1_1st | mem_re2_1st | mem_re3_1st | mem_re4_1st;
assign mem_raddr    = sub_lbuf_dout_cnt;

//line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_sub_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
    if(wr_line_dat_done | last_sub_lbuf_done | line_end)
          wr_sub_lbuf_cnt[2:0] <= 3'd0;
    else if(sub_lbuf_dout_done)
          wr_sub_lbuf_cnt[2:0] <= wr_sub_lbuf_cnt + 1;
  end
end
assign last_sub_lbuf_done = ((bank_merge_num-1) =={2'd0,wr_sub_lbuf_cnt}) & sub_lbuf_dout_done;
//--------------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_lbuf_dout_cnt <= {9{1'b0}};
  end else begin
    if(sub_lbuf_dout_done | wr_line_dat_done | line_end)
          sub_lbuf_dout_cnt <= 9'd0;
    else if(load_din | (cur_datin_disable & one_width_norm_rdy))
          sub_lbuf_dout_cnt <= sub_lbuf_dout_cnt+ 1'd1;
  end
end
assign sub_lbuf_dout_done  = (sub_lbuf_dout_cnt==BANK_DEPTH) & (load_din | (cur_datin_disable & one_width_norm_rdy));
//==============================================================================================
//buffer the data from memory  and from UNIT1D
//
//----------------------------------------------------------------------------------------------
 //=========================================================
 //POOLING FUNCTION DEFINITION
 //
 //---- -----------------------------------------------------

//: my $m = (NVDLA_PDP_BWPE+6);
//: print qq(
//:     function[${m}-1:0] pooling_MIN; 
//:        input        data0_valid;
//:        input[${m}-1:0]  data0;
//:        input[${m}-1:0]  data1;
//: );
   reg        min_int_ff;
  begin
      min_int_ff   = ($signed(data1)>  $signed(data0)) ;
      pooling_MIN  = (min_int_ff    & data0_valid) ? data0 : data1;
  end
 endfunction

//: my $m = (NVDLA_PDP_BWPE+6);
//: print qq(
//:     function[${m}-1:0] pooling_MAX; 
//:        input        data0_valid;
//:        input[${m}-1:0]  data0;
//:        input[${m}-1:0]  data1;
//: );
   reg        max_int_ff;
   begin
      max_int_ff    = ($signed(data0)>  $signed(data1))       ;
      pooling_MAX   = (max_int_ff    & data0_valid) ? data0 : data1;
  end
 endfunction

//: my $m = (NVDLA_PDP_BWPE+6);
//: print qq(
//:     function[${m}-1:0] pooling_SUM; 
//:        input        data0_valid;
//:        input[${m}-1:0]  data0;
//:        input[${m}-1:0]  data1;
//: );
   begin
      //spyglass disable_block W484
      pooling_SUM =  ($signed(data1) + $signed(data0))        ; 
      //spyglass enable_block W484
  end
 endfunction

 //pooling result
//: my $m = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6);
//: print qq(
//:     function[${m}-1:0] pooling_fun; 
//:        input[1:0]  pooling_type;
//:        input        data0_valid;
//:        input[${m}-1:0]  data0_in;
//:        input[${m}-1:0]  data1_in;
//: );
  reg    min_pooling;
  reg    max_pooling;
  reg    mean_pooling;
  begin
     min_pooling = (pooling_type== 2'h2 );
     max_pooling = (pooling_type== 2'h1 );
     mean_pooling = (pooling_type== 2'h0 );

//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = (NVDLA_PDP_BWPE+6);
//: foreach my $i (0..$k-1) {
//:     print qq(
//:         pooling_fun[${m}*${i}+${m}-1:${m}*${i}]  = mean_pooling?  pooling_SUM(data0_valid,data0_in[${m}*${i}+${m}-1:${m}*${i}],data1_in[${m}*${i}+${m}-1:${m}*${i}]) :
//:                                                    min_pooling ? (pooling_MIN(data0_valid,data0_in[${m}*${i}+${m}-1:${m}*${i}],data1_in[${m}*${i}+${m}-1:${m}*${i}])) :
//:                                                    max_pooling ? (pooling_MAX(data0_valid,data0_in[${m}*${i}+${m}-1:${m}*${i}],data1_in[${m}*${i}+${m}-1:${m}*${i}])) : 0;
//:     );
//: }
  end
endfunction
 
 //write memory 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_data0_lst <= 0;
    mem_data1_lst <= 0;
    mem_data2_lst <= 0;
    mem_data3_lst <= 0;
    mem_data4_lst <= 0;
    mem_data5_lst <= 0;
    mem_data6_lst <= 0;
    mem_data7_lst <= 0;
  end else begin
     if(flush_read_en_d & wr_data_stage0_prdy) begin
             mem_data0_lst <= {mem_rdata_0[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data1_lst <= {mem_rdata_1[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data2_lst <= {mem_rdata_2[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data3_lst <= {mem_rdata_3[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data4_lst <= {mem_rdata_4[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data5_lst <= {mem_rdata_5[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data6_lst <= {mem_rdata_6[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
             mem_data7_lst <= {mem_rdata_7[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:0]};
     end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_data0 <= 0;
    mem_data1 <= 0;
    mem_data2 <= 0;
    mem_data3 <= 0;
    mem_data4 <= 0;
    mem_data5 <= 0;
    mem_data6 <= 0;
    mem_data7 <= 0;
  end else begin
     if(load_wr_stage1) begin//one cycle delay than pooling1d input
             mem_data0 <= mem_re_1st_d[0]? {unit2d_vsize_cnt_0_d, datin_buf}: { unit2d_vsize_cnt_0_d,mem_rdata_0[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data1 <= mem_re_1st_d[1]? {unit2d_vsize_cnt_1_d, datin_buf}: { unit2d_vsize_cnt_1_d,mem_rdata_1[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data2 <= mem_re_1st_d[2]? {unit2d_vsize_cnt_2_d, datin_buf}: { unit2d_vsize_cnt_2_d,mem_rdata_2[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data3 <= mem_re_1st_d[3]? {unit2d_vsize_cnt_3_d, datin_buf}: { unit2d_vsize_cnt_3_d,mem_rdata_3[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data4 <= mem_re_1st_d[4]? {unit2d_vsize_cnt_4_d, datin_buf}: { unit2d_vsize_cnt_4_d,mem_rdata_4[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data5 <= mem_re_1st_d[5]? {unit2d_vsize_cnt_5_d, datin_buf}: { unit2d_vsize_cnt_5_d,mem_rdata_5[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data6 <= mem_re_1st_d[6]? {unit2d_vsize_cnt_6_d, datin_buf}: { unit2d_vsize_cnt_6_d,mem_rdata_6[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
             mem_data7 <= mem_re_1st_d[7]? {unit2d_vsize_cnt_7_d, datin_buf}: { unit2d_vsize_cnt_7_d,mem_rdata_7[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0]};
     end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datin_buf_2d <= 0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    datin_buf_2d <= datin_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    datin_buf_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_end_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    wr_line_end_2d <= wr_line_end_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    wr_line_end_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_raddr_2d <= {9{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_raddr_2d <= mem_raddr_d;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_surface_dat_done_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    wr_surface_dat_done_2d <= wr_surface_dat_done_buf;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    wr_surface_dat_done_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_active_line_d <= 1'b0;
  end else begin
  if ((load_din) == 1'b1) begin
    last_active_line_d <= active_last_line;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    last_active_line_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_active_line_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    last_active_line_2d <= last_active_line_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    last_active_line_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_1st_d <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    mem_re_1st_d <= mem_re_1st;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    mem_re_1st_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_1st_2d <= {8{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_re_1st_2d <= mem_re_1st_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    mem_re_1st_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_raddr_d <= {9{1'b0}};
  end else begin
  if (((|mem_re) | (flush_read_en & one_width_norm_rdy)) == 1'b1) begin
    mem_raddr_d <= mem_raddr;
  end
  end
end
//=========================== 
//8bits mem_re two cycle delay
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_d <= {8{1'b0}};
  end else begin
  if ((load_din) == 1'b1) begin
    mem_re_d <= mem_re;
  // VCS coverage off
  end else if ((load_din) == 1'b0) begin
  end else begin
    mem_re_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_2d <= {8{1'b0}};
  end else begin
  if ((load_wr_stage1) == 1'b1) begin
    mem_re_2d <= mem_re_d;
  // VCS coverage off
  end else if ((load_wr_stage1) == 1'b0) begin
  end else begin
    mem_re_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//write stage0
assign pooling1d_norm_rdy = ~wr_data_stage0_vld | wr_data_stage0_prdy;
//rebuild valid signal with cur_datin_disable control
//assign pooling1d_vld_rebuild = cur_datin_disable ? 1'b1 : pooling1d_pvld_use;
assign pooling1d_vld_rebuild = (one_width_disable | cur_datin_disable) ? 1'b1 : pooling1d_pvld_use;
assign load_din_all     = pooling1d_norm_rdy & pooling1d_vld_rebuild; 
//pipe delay
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage0_vld <= 1'b0;
  end else begin
    //if(|mem_re) 
    if(pooling1d_vld_rebuild) 
        wr_data_stage0_vld <= 1'b1;
    else if(wr_data_stage0_prdy)
        wr_data_stage0_vld <= 1'b0;
  end
end

assign wr_data_stage0_prdy = ~wr_data_stage1_vld | wr_data_stage1_prdy;
//write  stage1
assign load_wr_stage1_all = wr_data_stage0_vld & wr_data_stage0_prdy;
//assign load_wr_stage1 = wr_data_stage0_vld & wr_data_stage0_prdy & (~cur_datin_disable_d);
assign load_wr_stage1 = wr_data_stage0_vld & wr_data_stage0_prdy & (~cur_datin_disable_d) & (~one_width_disable_d);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage1_vld <= 1'b0;
  end else begin
     if(wr_data_stage0_vld)
           wr_data_stage1_vld <= 1'b1;
     else if(wr_data_stage1_prdy)
           wr_data_stage1_vld <= 1'b0;
  end
end

//write stage2
assign load_wr_stage2_all   = wr_data_stage1_vld & wr_data_stage1_prdy;
assign load_wr_stage2   = wr_data_stage1_vld & wr_data_stage1_prdy & (~cur_datin_disable_2d) & (~one_width_disable_2d);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_stage2_vld <= 1'b0;
  end else begin
    //if(wr_data_stage1_vld)
    if(wr_data_stage1_vld )
        wr_data_stage2_vld <= 1'b1;
    else if(pout_data_stage0_prdy)
        wr_data_stage2_vld <= 1'b0;
  end
end
assign load_wr_stage3_all = wr_data_stage2_vld & pout_data_stage0_prdy;
assign load_wr_stage3 = wr_data_stage2_vld & pout_data_stage0_prdy & (~cur_datin_disable_3d) & (~one_width_disable_3d);
//====================================================================
// pooling data calculation and write back
//
//--------------------------------------------------------------------
assign pooling_datin = datin_buf_2d;
//read from memory
assign  mem_data_valid = load_wr_stage2 ? mem_re_2d : 8'h00;
assign pooling_2d_result_0  =  mem_re_1st_2d[0] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[0],pooling_datin,mem_data0[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_1  =  mem_re_1st_2d[1] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[1],pooling_datin,mem_data1[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_2  =  mem_re_1st_2d[2] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[2],pooling_datin,mem_data2[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_3  =  mem_re_1st_2d[3] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[3],pooling_datin,mem_data3[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_4  =  mem_re_1st_2d[4] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[4],pooling_datin,mem_data4[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_5  =  mem_re_1st_2d[5] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[5],pooling_datin,mem_data5[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_6  =  mem_re_1st_2d[6] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[6],pooling_datin,mem_data6[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_result_7  =  mem_re_1st_2d[7] ? pooling_datin : pooling_fun(pooling_type_cfg[1:0],mem_data_valid[7],pooling_datin,mem_data7[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)-1:0]);
assign pooling_2d_info_0    =  {wr_line_end_2d,mem_data0[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_1    =  {wr_line_end_2d,mem_data1[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_2    =  {wr_line_end_2d,mem_data2[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]}; 
assign pooling_2d_info_3    =  {wr_line_end_2d,mem_data3[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_4    =  {wr_line_end_2d,mem_data4[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_5    =  {wr_line_end_2d,mem_data5[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_6    =  {wr_line_end_2d,mem_data6[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};
assign pooling_2d_info_7    =  {wr_line_end_2d,mem_data7[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)]};

//memory write data
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+4;
//: foreach my $i (0..7){
//: print "    int_mem_wdata_$i <= ${k}'d0; \n";
//: }
  end else begin
    if(load_wr_stage2) begin
//: my $k = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+4;
//: foreach my $i (0..7){
//: print "    int_mem_wdata_$i <= {pooling_2d_info_${i},pooling_2d_result_$i}; \n";
//: }
     end
  end
end

//write enabel signal
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mem_we <= {8{1'b0}};
  end else begin
  if ((load_wr_stage2) == 1'b1) begin
    int_mem_we <= mem_re_2d;
  // VCS coverage off
  end else if ((load_wr_stage2) == 1'b0) begin
  end else begin
    int_mem_we <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int_mem_waddr <= {9{1'b0}};
  end else begin
  if ((load_wr_stage2) == 1'b1) begin
    int_mem_waddr <= mem_raddr_2d;
  end
  end
end

//memory write select 
assign mem_wdata_0 = int_mem_wdata_0;
assign mem_wdata_1 = int_mem_wdata_1;
assign mem_wdata_2 = int_mem_wdata_2;
assign mem_wdata_3 = int_mem_wdata_3;
assign mem_wdata_4 = int_mem_wdata_4;
assign mem_wdata_5 = int_mem_wdata_5;
assign mem_wdata_6 = int_mem_wdata_6;
assign mem_wdata_7 = int_mem_wdata_7;
assign mem_we      = (int_mem_we & {8{load_wr_stage3}});
assign mem_waddr_0 = int_mem_waddr;
assign mem_waddr_1 = int_mem_waddr;
assign mem_waddr_2 = int_mem_waddr;
assign mem_waddr_3 = int_mem_waddr;
assign mem_waddr_4 = int_mem_waddr;
assign mem_waddr_5 = int_mem_waddr;
assign mem_waddr_6 = int_mem_waddr;
assign mem_waddr_7 = int_mem_waddr;

//=============================================================================
//memory line buffer instance
// 
//-----------------------------------------------------------------------------

//: my $depth = int(16*(NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_THROUGHPUT));
//: my $depth_bw = int( log($depth)/log(2) );
//: my $width = (NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)+4);
//: foreach my $i (0..7) {
//:     print qq(
//:         nv_ram_rws_${depth}x${width} bank${i}_uram_0 (
//:            .clk                         (nvdla_core_clk)              
//:           ,.ra                          (mem_raddr[${depth_bw}-1:0])                   
//:           ,.re                          (mem_re[$i] | mem_re_last[$i])
//:           ,.dout                        (mem_rdata_$i)          
//:           ,.wa                          (mem_waddr_${i}[${depth_bw}-1:0])            
//:           ,.we                          (mem_we[$i])                   
//:           ,.di                          (mem_wdata_$i)          
//:           ,.pwrbus_ram_pd               (pwrbus_ram_pd)         
//:           );
//:     );
//: }


`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram0 read and write same addr simultaneously")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (mem_we[0] & ( mem_re[0] | mem_re_last[0])) & (mem_raddr == mem_waddr_0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram1 read and write same addr simultaneously")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (mem_we[1] & ( mem_re[1] | mem_re_last[1])) & (mem_raddr == mem_waddr_1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram2 read and write same addr simultaneously")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (mem_we[2] & ( mem_re[2] | mem_re_last[2])) & (mem_raddr == mem_waddr_2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram3 read and write same addr simultaneously")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (mem_we[3] & ( mem_re[3] | mem_re_last[3])) & (mem_raddr == mem_waddr_3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram4 read and write same addr simultaneously")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (mem_we[4] & ( mem_re[4] | mem_re_last[4])) & (mem_raddr == mem_waddr_4)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram5 read and write same addr simultaneously")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (mem_we[5] & ( mem_re[5] | mem_re_last[5])) & (mem_raddr == mem_waddr_5)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram6 read and write same addr simultaneously")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (mem_we[6] & ( mem_re[6] | mem_re_last[6])) & (mem_raddr == mem_waddr_6)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDP Cal2d line buffer 2port-ram7 read and write same addr simultaneously")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (mem_we[7] & ( mem_re[7] | mem_re_last[7])) & (mem_raddr == mem_waddr_7)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============================================================================
//data reading control during datin_disable time
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//data reading from buffer for datin_disable bubble part and last_out during the next surface coming
//cur_datin_disable means bubble part, need disable input data prdy
//in the end of total layer, if have data need flushed, will also bubble input
//last_out_en flush the last lines during the next surface data coming
/////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling_last <= {3{1'b0}};
    mem_re2_sel_last <= 1'b0;
    mem_re3_sel_last <= 1'b0;
    mem_re4_sel_last <= 1'b0;
  end else begin
    if(wr_surface_dat_done) begin
        unit2d_cnt_pooling_last <= (unit2d_cnt_pooling == unit2d_cnt_pooling_max) ? 3'd0 : (unit2d_cnt_pooling + 1'b1);
        mem_re2_sel_last        <= mem_re2_sel;
        mem_re3_sel_last        <= mem_re3_sel;
        mem_re4_sel_last        <= mem_re4_sel;
    end else if(((line_end & cur_datin_disable) | (wr_line_dat_done & last_out_en)) & one_width_norm_rdy) begin
        if(unit2d_cnt_pooling_last_end)
            unit2d_cnt_pooling_last <= 3'd0;
        else
            unit2d_cnt_pooling_last <= unit2d_cnt_pooling_last + 1'b1;
    end
  end
end
assign unit2d_cnt_pooling_last_end = (unit2d_cnt_pooling_last == unit2d_cnt_pooling_max);

assign flush_read_en = (cur_datin_disable | last_out_en) & one_width_norm_rdy;

assign unit2d_en_last[0] = flush_read_en & (unit2d_cnt_pooling_last == 3'd0);
assign unit2d_en_last[1] = flush_read_en & (unit2d_cnt_pooling_last == 3'd1);
assign unit2d_en_last[2] = flush_read_en & (unit2d_cnt_pooling_last == 3'd2);
assign unit2d_en_last[3] = flush_read_en & (unit2d_cnt_pooling_last == 3'd3);
assign unit2d_en_last[4] = flush_read_en & (unit2d_cnt_pooling_last == 3'd4);
assign unit2d_en_last[5] = flush_read_en & (unit2d_cnt_pooling_last == 3'd5);
assign unit2d_en_last[6] = flush_read_en & (unit2d_cnt_pooling_last == 3'd6);
assign unit2d_en_last[7] = flush_read_en & (unit2d_cnt_pooling_last == 3'd7);

assign mem_re2_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel_last;
assign mem_re2_last[1] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel_last;
assign mem_re2_last[2] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel_last;
assign mem_re2_last[3] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel_last;
assign mem_re2_last[4] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re2_sel_last;
assign mem_re2_last[5] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd1) & mem_re2_sel_last;
assign mem_re2_last[6] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd2) & mem_re2_sel_last;
assign mem_re2_last[7] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd3) & mem_re2_sel_last;

assign mem_re3_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[1] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[2] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[3] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[4] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[5] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;
assign mem_re3_last[6] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd0) & mem_re3_sel_last;
assign mem_re3_last[7] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd1) & mem_re3_sel_last;

assign mem_re4_last[0] =  unit2d_en_last[0] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[1] =  unit2d_en_last[1] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[2] =  unit2d_en_last[2] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[3] =  unit2d_en_last[3] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[4] =  unit2d_en_last[4] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[5] =  unit2d_en_last[5] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[6] =  unit2d_en_last[6] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;
assign mem_re4_last[7] =  unit2d_en_last[7] & (wr_sub_lbuf_cnt==3'd0) & mem_re4_sel_last;

assign mem_re_last = mem_re2_last | mem_re3_last | mem_re4_last;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    flush_read_en_d <= 1'b0;
  end else begin
  if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    flush_read_en_d <= flush_read_en;
  // VCS coverage off
  end else if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    flush_read_en_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_last_d <= {8{1'b0}};
  end else begin
  if (((load_din                 ) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    mem_re_last_d <= mem_re_last;
  // VCS coverage off
  end else if (((load_din                 ) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    mem_re_last_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din                 ) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling_last_d <= {3{1'b0}};
  end else begin
  if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b1) begin
    unit2d_cnt_pooling_last_d <= unit2d_cnt_pooling_last;
  // VCS coverage off
  end else if (((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy/*pooling1d_norm_rdy*/)) == 1'b0) begin
  end else begin
    unit2d_cnt_pooling_last_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_din & (|mem_re_last)) | (cur_datin_disable & one_width_norm_rdy )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable_d <= 1'b0;
  end else begin
  if ((load_din_all) == 1'b1) begin
    cur_datin_disable_d <= cur_datin_disable;
  // VCS coverage off
  end else if ((load_din_all) == 1'b0) begin
  end else begin
    cur_datin_disable_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_disable_d <= 1'b0;
  end else begin
  if ((load_din_all) == 1'b1) begin
    one_width_disable_d <= one_width_disable;
  // VCS coverage off
  end else if ((load_din_all) == 1'b0) begin
  end else begin
    one_width_disable_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mem_re_last_2d <= {8{1'b0}};
  end else begin
  if (( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b1) begin
    mem_re_last_2d <= mem_re_last_d;
  // VCS coverage off
  end else if (( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b0) begin
  end else begin
    mem_re_last_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^( load_wr_stage1                  | (cur_datin_disable_d & wr_data_stage0_prdy)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit2d_cnt_pooling_last_2d <= {3{1'b0}};
  end else begin
  if (((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b1) begin
    unit2d_cnt_pooling_last_2d <= unit2d_cnt_pooling_last_d;
  // VCS coverage off
  end else if (((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)) == 1'b0) begin
  end else begin
    unit2d_cnt_pooling_last_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_45x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((load_wr_stage1 & (|mem_re_last_d)) | (cur_datin_disable_d & wr_data_stage0_prdy)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//&Always posedge;
//    if(cur_datin_disable_d)
//        cur_datin_disable_2d <0= 1'b1;
//    else if(wr_data_stage1_prdy)
//        cur_datin_disable_2d <0= 1'b0;
//&End;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1_all) == 1'b1) begin
    cur_datin_disable_2d <= cur_datin_disable_d;
  // VCS coverage off
  end else if ((load_wr_stage1_all) == 1'b0) begin
  end else begin
    cur_datin_disable_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_disable_2d <= 1'b0;
  end else begin
  if ((load_wr_stage1_all) == 1'b1) begin
    one_width_disable_2d <= one_width_disable_d;
  // VCS coverage off
  end else if ((load_wr_stage1_all) == 1'b0) begin
  end else begin
    one_width_disable_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable_3d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    cur_datin_disable_3d <= cur_datin_disable_2d;
  // VCS coverage off
  end else if ((load_wr_stage2_all) == 1'b0) begin
  end else begin
    cur_datin_disable_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    one_width_disable_3d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    one_width_disable_3d <= one_width_disable_2d;
  // VCS coverage off
  end else if ((load_wr_stage2_all) == 1'b0) begin
  end else begin
    one_width_disable_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//line buffer2
assign pout_mem_data_sel_1_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re2_sel;
assign pout_mem_data_sel_1_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;
assign pout_mem_data_sel_1_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re2_sel;

//line buffer3,4
assign pout_mem_data_sel_2_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re3_sel;
assign pout_mem_data_sel_2_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re3_sel;
assign pout_mem_data_sel_2_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re3_sel;
assign pout_mem_data_sel_2_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re3_sel;
assign pout_mem_data_sel_2_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re3_sel;
assign pout_mem_data_sel_2_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re3_sel;
assign pout_mem_data_sel_2_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re3_sel;
assign pout_mem_data_sel_2_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re3_sel;

//line buffer 5,6,7,8
assign pout_mem_data_sel_3_last[0] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[0] & (unit2d_cnt_pooling_last_2d==3'd0) & mem_re4_sel;
assign pout_mem_data_sel_3_last[1] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[1] & (unit2d_cnt_pooling_last_2d==3'd1) & mem_re4_sel;
assign pout_mem_data_sel_3_last[2] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[2] & (unit2d_cnt_pooling_last_2d==3'd2) & mem_re4_sel;
assign pout_mem_data_sel_3_last[3] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[3] & (unit2d_cnt_pooling_last_2d==3'd3) & mem_re4_sel;
assign pout_mem_data_sel_3_last[4] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[4] & (unit2d_cnt_pooling_last_2d==3'd4) & mem_re4_sel;
assign pout_mem_data_sel_3_last[5] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[5] & (unit2d_cnt_pooling_last_2d==3'd5) & mem_re4_sel;
assign pout_mem_data_sel_3_last[6] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[6] & (unit2d_cnt_pooling_last_2d==3'd6) & mem_re4_sel;
assign pout_mem_data_sel_3_last[7] = (load_wr_stage2 | (cur_datin_disable_2d & wr_data_stage1_prdy)) & mem_re_last_2d[7] & (unit2d_cnt_pooling_last_2d==3'd7) & mem_re4_sel;
 
assign pout_mem_data_sel_last = pout_mem_data_sel_3_last | pout_mem_data_sel_2_last | pout_mem_data_sel_1_last;

//: my $k=NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3;
//: print qq(
//:     assign pout_mem_data_last = (mem_data0_lst & {${k}{pout_mem_data_sel_last[0]}}) |
//:                                 (mem_data1_lst & {${k}{pout_mem_data_sel_last[1]}}) |
//:                                 (mem_data2_lst & {${k}{pout_mem_data_sel_last[2]}}) |
//:                                 (mem_data3_lst & {${k}{pout_mem_data_sel_last[3]}}) |
//:                                 (mem_data4_lst & {${k}{pout_mem_data_sel_last[4]}}) |
//:                                 (mem_data5_lst & {${k}{pout_mem_data_sel_last[5]}}) |
//:                                 (mem_data6_lst & {${k}{pout_mem_data_sel_last[6]}}) |
//:                                 (mem_data7_lst & {${k}{pout_mem_data_sel_last[7]}}) ;
//: );
//==============================================================================
//unit2d pooling data read out
//
//
//------------------------------------------------------------------------------
//data count in sub line 
assign rd_line_out_done = wr_line_end_2d & rd_line_out;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_line_out_cnt <= {9{1'b0}};
  end else begin
   if(rd_line_out_done | rd_sub_lbuf_end)
        rd_line_out_cnt <= 9'd0;
   else if(rd_line_out)
        rd_line_out_cnt <= rd_line_out_cnt + 1'd1;
  end
end
assign  rd_sub_lbuf_end =((rd_line_out & (rd_line_out_cnt==BANK_DEPTH)) | rd_line_out_done); 

//sub line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_sub_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
     if(rd_comb_lbuf_end)
         rd_sub_lbuf_cnt[2:0] <= 3'd0;  
    else if(rd_sub_lbuf_end)
         rd_sub_lbuf_cnt[2:0] <= rd_sub_lbuf_cnt +1;
  end
end
assign rd_comb_lbuf_end = (rd_sub_lbuf_end & ({2'd0,rd_sub_lbuf_cnt}==(bank_merge_num -1))) | rd_line_out_done;

//combine line buffer counter
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_comb_lbuf_cnt[2:0] <= {3{1'b0}};
  end else begin
    //if(rd_lbuf_end | wr_surface_dat_done_2d)
    if(rd_lbuf_end | (wr_surface_dat_done_2d & load_wr_stage2))
        rd_comb_lbuf_cnt[2:0] <= 3'd0;  
    else if(rd_comb_lbuf_end & last_active_line_2d)
        rd_comb_lbuf_cnt[2:0] <= rd_comb_lbuf_cnt + 1;
  end
end
assign rd_lbuf_end = ({2'd0,rd_comb_lbuf_cnt}==(buffer_lines_num-1)) & rd_comb_lbuf_end & last_active_line_2d;
////////////////////////////////////////////////////////////////////////////////////////////////////
//unit2d_data_rdy need two active delays as load_wr_stage2
assign rd_line_out = |pout_mem_data_sel;
assign rd_pout_data_en = (rd_line_out | ((load_wr_stage2 & (|mem_re_last_2d))| (cur_datin_disable_2d & wr_data_stage1_prdy)));

//read output stage
assign wr_data_stage1_prdy = (~wr_data_stage2_vld | pout_data_stage0_prdy);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_d <= 1'b0;
  end else begin
  if ((load_wr_stage2_all) == 1'b1) begin
    rd_pout_data_en_d <= rd_pout_data_en;
  end
  end
end
assign rd_pout_data_stage0 = load_wr_stage3_all & rd_pout_data_en_d;

assign pout_data_stage0_prdy = ~pout_data_stage1_vld | pout_data_stage1_prdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage1_vld <= 1'b0;
  end else begin
   if(wr_data_stage2_vld)
      pout_data_stage1_vld <= 1'b1;
   else if(pout_data_stage1_prdy)
      pout_data_stage1_vld <= 1'b0;
  end
end

assign pout_data_stage1_prdy = ~pout_data_stage2_vld | pout_data_stage2_prdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_2d <= 1'b0;
  end else begin
  if ((load_wr_stage3_all) == 1'b1) begin
    rd_pout_data_en_2d <= rd_pout_data_en_d;
  // VCS coverage off
  end else if ((load_wr_stage3_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_2d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_wr_stage3_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
assign rd_pout_data_stage1_all = pout_data_stage1_vld & pout_data_stage1_prdy;
assign rd_pout_data_stage1 = pout_data_stage1_vld & pout_data_stage1_prdy & rd_pout_data_en_2d;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage2_vld <= 1'b0;
  end else begin
   if(pout_data_stage1_vld)
      pout_data_stage2_vld <= 1'b1;
   else if(pout_data_stage2_prdy)
      pout_data_stage2_vld <= 1'b0;
  end
end

assign pout_data_stage2_prdy = ~pout_data_stage3_vld | pout_data_stage3_prdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_3d <= 1'b0;
  end else begin
  if ((rd_pout_data_stage1_all) == 1'b1) begin
    rd_pout_data_en_3d <= rd_pout_data_en_2d;
  // VCS coverage off
  end else if ((rd_pout_data_stage1_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_3d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pout_data_stage1_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
assign rd_pout_data_stage2_all = pout_data_stage2_vld & pout_data_stage2_prdy;
assign rd_pout_data_stage2 = pout_data_stage2_vld & pout_data_stage2_prdy & rd_pout_data_en_3d;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_pout_data_en_4d <= 1'b0;
  end else begin
  if ((rd_pout_data_stage2_all) == 1'b1) begin
    rd_pout_data_en_4d <= rd_pout_data_en_3d;
  // VCS coverage off
  end else if ((rd_pout_data_stage2_all) == 1'b0) begin
  end else begin
    rd_pout_data_en_4d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rd_pout_data_stage2_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pout_data_stage3_vld <= 1'b0;
  end else begin
   if(pout_data_stage2_vld)
      pout_data_stage3_vld <= 1'b1;
   else if(pout_data_stage3_prdy)
      pout_data_stage3_vld <= 1'b0;
  end
end
/////////////////////////////////////////////////////////
//line buffer1 
assign pout_mem_data_sel_0    = mem_re_2d & {8{load_wr_stage2}} & {8{ mem_re1_sel}} & {8{last_active_line_2d}};

//line buffer2
assign pout_mem_data_sel_1[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;
assign pout_mem_data_sel_1[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re2_sel;

//line buffer3,4
assign pout_mem_data_sel_2[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re3_sel;
assign pout_mem_data_sel_2[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re3_sel;

//line buffer 5,6,7,8
assign pout_mem_data_sel_3[0] = mem_re_2d[0] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd0) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[1] = mem_re_2d[1] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd1) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[2] = mem_re_2d[2] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd2) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[3] = mem_re_2d[3] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd3) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[4] = mem_re_2d[4] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd4) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[5] = mem_re_2d[5] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd5) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[6] = mem_re_2d[6] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd6) & last_active_line_2d & mem_re4_sel;
assign pout_mem_data_sel_3[7] = mem_re_2d[7] & load_wr_stage2 & (rd_comb_lbuf_cnt==3'd7) & last_active_line_2d & mem_re4_sel;

assign pout_mem_data_sel = (pout_mem_data_sel_3 | pout_mem_data_sel_2 | pout_mem_data_sel_1 | pout_mem_data_sel_0);

always @(*) begin
    case(pout_mem_data_sel[7:0])
      8'h01: pout_mem_data_act = {pooling_2d_info_0[2:0],pooling_2d_result_0};
      8'h02: pout_mem_data_act = {pooling_2d_info_1[2:0],pooling_2d_result_1};
      8'h04: pout_mem_data_act = {pooling_2d_info_2[2:0],pooling_2d_result_2};
      8'h08: pout_mem_data_act = {pooling_2d_info_3[2:0],pooling_2d_result_3};
      8'h10: pout_mem_data_act = {pooling_2d_info_4[2:0],pooling_2d_result_4};
      8'h20: pout_mem_data_act = {pooling_2d_info_5[2:0],pooling_2d_result_5};
      8'h40: pout_mem_data_act = {pooling_2d_info_6[2:0],pooling_2d_result_6};
      8'h80: pout_mem_data_act = {pooling_2d_info_7[2:0],pooling_2d_result_7};
    default: pout_mem_data_act = {(NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+6)+3){1'd0}};
    endcase
end

assign int_pout_mem_data = pout_mem_data_act | pout_mem_data_last;
assign pout_mem_data = int_pout_mem_data;
//=============================================================
//pooling output data to DMA
//
//-------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_mem_data_$i <= {${m}{1'b0}}; \n";
//: }
    pout_mem_size_v <= {3{1'b0}};
  end else begin
    if(rd_pout_data_en) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_mem_data_$i <= pout_mem_data[${m}*${i}+${m}-1:${m}*$i]; \n";
//: }
//: print "        pout_mem_size_v <= pout_mem_data[${k}*${m}+2:${k}*${m}]; \n";
    end
  end
end

//===========================================================
//adding pad value in v direction
//-----------------------------------------------------------
//padding value 1x,2x,3x,4x,5x,6x,7x table
assign pout_mem_size_v_use =  pout_mem_size_v;
assign padding_here = average_pooling_en & (pout_mem_size_v_use != pooling_size_v_cfg);
assign {mon_pad_table_index[0],pad_table_index[2:0]} = pooling_size_v_cfg - pout_mem_size_v_use;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"PDPCore cal2d: pooling size should not less than active num")      zzz_assert_never_54x (nvdla_core_clk, `ASSERT_RESET, ((rd_pout_data_stage0) & mon_pad_table_index & reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(*) begin
    case(pad_table_index)
       3'd1: pad_table_out = reg2dp_pad_value_1x_cfg[18:0]; //1x  
       3'd2: pad_table_out = reg2dp_pad_value_2x_cfg[18:0]; //2x
       3'd3: pad_table_out = reg2dp_pad_value_3x_cfg[18:0]; //3x
       3'd4: pad_table_out = reg2dp_pad_value_4x_cfg[18:0]; //4x
       3'd5: pad_table_out = reg2dp_pad_value_5x_cfg[18:0]; //5x
       3'd6: pad_table_out = reg2dp_pad_value_6x_cfg[18:0]; //6x
       3'd7: pad_table_out = reg2dp_pad_value_7x_cfg[18:0]; //7x
       default:pad_table_out = 19'd0; //1x;
    endcase
end

assign kernel_width_cfg[3:0] = reg2dp_kernel_width[2:0]+3'd1;
assign {mon_pad_value,pad_value[21:0]} = $signed(pad_table_out) * $signed({{1{1'b0}}, kernel_width_cfg});
// //: my $k = NVDLA_PDP_THROUGHPUT;
// //: foreach my $i (0..$k-1) {
// //: print qq(
// //:     assign pout_mem_data$i = pout_mem_data_$i;
// //: );
// //: }

//: my $s = "\$signed";
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//: print qq(
//:     assign {mon_data_8bit_${i}_ff ,data_8bit_${i}_ff} = $s({pout_mem_data_${i}[${m}-1],pout_mem_data_$i}) + $s({pad_value[${m}-1], pad_value[${m}-1:0]});
//:     assign {mon_data_8bit_${i} ,data_8bit_${i}}  = padding_here ? {mon_data_8bit_${i}_ff ,data_8bit_${i}_ff} : {{2{pout_mem_data_${i}[${m}-1]}},pout_mem_data_${i}[${m}-1:0] };
//: );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_0_$i <= {${m}{1'b0}}; \n";
//: }
  end else begin
   if(average_pooling_en) begin
        if(rd_pout_data_stage0) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_0_$i <= data_8bit_$i; \n";
//: }
        end
   end else if(rd_pout_data_stage0)begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_0_$i <= {pout_mem_data_${i}[${m}-1],pout_mem_data_${i}}; \n";
//: }
   end
  end
end

//===========================================================
//stage1: (* /kernel_width)
//stage1 : calcate pooling data based on real pooling size --- (* 1/kernel_width)
//-----------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_recip_width_use[16:0] <= {17{1'b0}};
  end else begin
  reg2dp_recip_width_use[16:0] <= reg2dp_recip_width_cfg[16:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_recip_height_use[16:0] <= {17{1'b0}};
  end else begin
  reg2dp_recip_height_use[16:0] <= reg2dp_recip_height_cfg[16:0];
  end
end

//8bits
//: my $s = "\$signed";
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:   print qq(
//:     assign data_hmult_8bit_${i}_ext_ff = $s(pout_data_0_${i})* $s({1'b0,reg2dp_recip_width_use[16:0]});
//:     assign data_hmult_8bit_${i}_ext = average_pooling_en ? data_hmult_8bit_${i}_ext_ff : {pout_data_0_${i}[${m}-1],pout_data_0_${i}[${m}-1:0] ,16'd0};
//:     assign i8_less_neg_0_5_${i} = data_hmult_8bit_${i}_ext[${m}+16] & ((data_hmult_8bit_${i}_ext[15] & (~(|data_hmult_8bit_${i}_ext[14:0]))) | (~data_hmult_8bit_${i}_ext[15]));
//:     assign i8_more_neg_0_5_${i} = data_hmult_8bit_${i}_ext[${m}+16] & data_hmult_8bit_${i}_ext[15] & (|data_hmult_8bit_${i}_ext[14:0]);
//:     assign {mon_i8_neg_add1_${i},i8_neg_add1_${i}} = data_hmult_8bit_${i}_ext[$j+16-1:16]+${j}'d1; 
//:     assign hmult_8bit_${i} = (i8_less_neg_0_5_${i})? data_hmult_8bit_${i}_ext[$j+16-1:16] : (i8_more_neg_0_5_${i})? i8_neg_add1_${i} : (data_hmult_8bit_${i}_ext[$j+16-2:16]+data_hmult_8bit_${i}_ext[15]);//rounding 0.5=1, -0.5=-1
//:     assign data_hmult_8bit_$i  = hmult_8bit_$i;
//:     assign data_hmult_stage0_in${i} = data_hmult_8bit_$i;
//:   );
//:   print qq(
//:     //  &eperl::assert("-type never  -desc 'PDPCore cal2d: the MSB bits should be all same as signed bit' -expr '(rd_pout_data_stage1 & ((&data_hmult_8bit_${i}_ext[${m}+16:$j+16]) != (|data_hmult_8bit_0_ext[${m}+16:$j+16])))' "); 
//:   );
//: }

//load data to stage0
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage0_$i <= {${j}{1'b0}}; \n";
//: }
  end else begin
   if(average_pooling_en) begin
       if(rd_pout_data_stage1) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage0_$i <= data_hmult_stage0_in$i; \n";
//: }
       end
   end else if(rd_pout_data_stage1)begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage0_$i <= pout_data_0_${i}[${j}-1:0]; \n";
//: }
   end
  end
end

//===========================================================
//stage1: (* /kernel_height)
//8bits
//: my $s = "\$signed";
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $x = NVDLA_PDP_BWPE;
//: my $j = NVDLA_PDP_BWPE+3;
//: my $m = NVDLA_PDP_BWPE+6;
//: foreach my $i (0..$k-1) {
//:   print qq(
//:     assign data_vmult_8bit_${i}_ext_ff = $s(pout_data_stage0_${i})  * $s({1'b0,reg2dp_recip_height_use[16:0]});
//:     assign data_vmult_8bit_${i}_ext = average_pooling_en ? data_vmult_8bit_${i}_ext_ff : {pout_data_stage0_${i}[${j}-1],pout_data_stage0_${i} ,16'd0};
//:     assign i8_vless_neg_0_5_$i = data_vmult_8bit_${i}_ext[${j}+16] & ((data_vmult_8bit_${i}_ext[15] & (~(|data_vmult_8bit_${i}_ext[14:0]))) | (~data_vmult_8bit_${i}_ext[15]));
//:     assign i8_vmore_neg_0_5_$i = data_vmult_8bit_${i}_ext[${j}+16] & data_vmult_8bit_${i}_ext[15] & (|data_vmult_8bit_${i}_ext[14:0]);
//:     assign {mon_i8_neg_vadd1_${i},i8_neg_vadd1_${i}[${x}-1:0]} = data_vmult_8bit_${i}_ext[${x}+16-1:16]+ ${x}'d1; 
//:     assign vmult_8bit_${i}  = (i8_vless_neg_0_5_$i)? data_vmult_8bit_${i}_ext[${x}+16-1:16] : (i8_vmore_neg_0_5_$i)? i8_neg_vadd1_$i : (data_vmult_8bit_${i}_ext[${x}+16-2:16]+data_vmult_8bit_${i}_ext[15]);//rounding 0.5=1, -0.5=-1
//:     assign data_vmult_8bit_$i = vmult_8bit_$i;
//:     assign data_mult_stage1_in$i = data_vmult_8bit_$i;
//:   );
//:   print qq(
//:     //  &eperl::assert("-type never  -desc 'PDPCore cal2d: the MSB 4bits should be all same as signed bit' -expr '(rd_pout_data_stage1 & ((&data_vmult_8bit_${i}_ext[${j}+16:${x}+16-1]) != (|data_vmult_8bit_${i}_ext[${j}+16:${x}+16-1])))' "); 
//:   );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $x = NVDLA_PDP_BWPE;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage1_$i <= {${x}{1'b0}}; \n";
//: }
  end else begin
   if(average_pooling_en) begin
       if(rd_pout_data_stage2) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $x = NVDLA_PDP_BWPE;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage1_$i <= data_mult_stage1_in$i; \n";
//: }
       end
   end else if(rd_pout_data_stage2) begin
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $x = NVDLA_PDP_BWPE;
//: foreach my $i (0..$k-1) {
//:     print "    pout_data_stage1_$i <= pout_data_stage0_${i}[${x}-1:0]; \n";
//: }
   end
  end
end

assign int_dp2wdma_pd = {
//: my $k = NVDLA_PDP_THROUGHPUT;
//: if($k > 1) {
//:     foreach my $i (0..$k-2) {
//:         my $j = $k -$i -1;
//:         print "pout_data_stage1_${j}, \n";
//:     }
//: }
pout_data_stage1_0};
assign int_dp2wdma_valid = pout_data_stage3_vld & rd_pout_data_en_4d;
assign pout_data_stage3_prdy =  pdp_dp2wdma_ready;

//=============================

//======================================
//interface between POOLING data and DMA
assign pdp_dp2wdma_pd    =  int_dp2wdma_pd;
assign pdp_dp2wdma_valid  = int_dp2wdma_valid;
//==============
//function points
//==============

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

    property PDP_line_buf_busy__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        &unit2d_en & (pout_width_cur==13'hf);
    endproperty
    // Cover 0 : "&unit2d_en & (pout_width_cur==13'hf)"
    FUNCPOINT_PDP_line_buf_busy__0_COV : cover property (PDP_line_buf_busy__0_cov);

  `endif
`endif
//VCS coverage on


////==============
////OBS signals
////==============
//assign obs_bus_pdp_cal2d_unit_en = unit2d_en[7:0];
//assign obs_bus_pdp_cal2d_bank_we = mem_we[7:0];
//assign obs_bus_pdp_cal2d_bank_re = mem_re[7:0] | mem_re_last[7:0];
//assign obs_bus_pdp_cal2d_bubble  = cur_datin_disable;

endmodule // NV_NVDLA_PDP_CORE_cal2d


