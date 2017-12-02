// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_BRDMA_eg.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_BRDMA_eg (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,cq2eg_pd                       //|< i
  ,cq2eg_pvld                     //|< i
  ,cvif2sdp_b_rd_rsp_pd           //|< i
  ,cvif2sdp_b_rd_rsp_valid        //|< i
  ,mcif2sdp_b_rd_rsp_pd           //|< i
  ,mcif2sdp_b_rd_rsp_valid        //|< i
  ,op_load                        //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_batch_number            //|< i
  ,reg2dp_brdma_data_mode         //|< i
  ,reg2dp_brdma_data_size         //|< i
  ,reg2dp_brdma_data_use          //|< i
  ,reg2dp_brdma_ram_type          //|< i
  ,reg2dp_channel                 //|< i
  ,reg2dp_height                  //|< i
  ,reg2dp_out_precision           //|< i
  ,reg2dp_proc_precision          //|< i
  ,reg2dp_width                   //|< i
  ,sdp_brdma2dp_alu_ready         //|< i
  ,sdp_brdma2dp_mul_ready         //|< i
  ,cq2eg_prdy                     //|> o
  ,cvif2sdp_b_rd_rsp_ready        //|> o
  ,eg_done                        //|> o
  ,mcif2sdp_b_rd_rsp_ready        //|> o
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_brdma2dp_alu_pd            //|> o
  ,sdp_brdma2dp_alu_valid         //|> o
  ,sdp_brdma2dp_mul_pd            //|> o
  ,sdp_brdma2dp_mul_valid         //|> o
  );
//
// NV_NVDLA_SDP_BRDMA_eg_ports.v
//
input  nvdla_core_clk;   /* mcif2sdp_b_rd_rsp, cvif2sdp_b_rd_rsp, sdp_b2mcif_rd_cdt, sdp_b2cvif_rd_cdt, cq2eg, sdp_brdma2dp_alu, sdp_brdma2dp_mul */
input  nvdla_core_rstn;  /* mcif2sdp_b_rd_rsp, cvif2sdp_b_rd_rsp, sdp_b2mcif_rd_cdt, sdp_b2cvif_rd_cdt, cq2eg, sdp_brdma2dp_alu, sdp_brdma2dp_mul */

input          mcif2sdp_b_rd_rsp_valid;  /* data valid */
output         mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_b_rd_rsp_pd;

input          cvif2sdp_b_rd_rsp_valid;  /* data valid */
output         cvif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_b_rd_rsp_pd;

output  sdp_b2mcif_rd_cdt_lat_fifo_pop;

output  sdp_b2cvif_rd_cdt_lat_fifo_pop;

input         cq2eg_pvld;  /* data valid */
output        cq2eg_prdy;  /* data return handshake */
input  [15:0] cq2eg_pd;

input [31:0] pwrbus_ram_pd;

output         sdp_brdma2dp_alu_valid;  /* data valid */
input          sdp_brdma2dp_alu_ready;  /* data return handshake */
output [256:0] sdp_brdma2dp_alu_pd;

output         sdp_brdma2dp_mul_valid;  /* data valid */
input          sdp_brdma2dp_mul_ready;  /* data return handshake */
output [256:0] sdp_brdma2dp_mul_pd;

input    [4:0] reg2dp_batch_number;
input          reg2dp_brdma_data_mode;
input          reg2dp_brdma_data_size;
input    [1:0] reg2dp_brdma_data_use;
input          reg2dp_brdma_ram_type;
input   [12:0] reg2dp_channel;
input   [12:0] reg2dp_height;
input    [1:0] reg2dp_out_precision;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
input op_load;
output eg_done;
reg            alu_layer_done;
reg            alu_roc_en;
reg      [1:0] alu_roc_size;
reg    [255:0] alu_rod0_pd;
reg    [255:0] alu_rod1_pd;
reg    [255:0] alu_rod2_pd;
reg    [255:0] alu_rod3_pd;
reg      [3:0] alu_rod_mask;
reg     [13:0] beat_count;
reg            eg_done;
reg            lat_ecc_rd_prdy;
reg      [0:0] mode_1bytex1_cnt;
reg      [3:0] mode_1bytex1_mask;
reg      [0:0] mode_1bytex2_cnt;
reg      [3:0] mode_1bytex2_mask;
reg      [0:0] mode_2bytex1_cnt;
reg      [3:0] mode_2bytex1_mask;
reg      [1:0] mode_2bytex2_cnt;
reg      [3:0] mode_2bytex2_mask;
reg            mul_layer_done;
reg            mul_roc_en;
reg      [1:0] mul_roc_size;
reg    [255:0] mul_rod0_pd;
reg    [255:0] mul_rod1_pd;
reg    [255:0] mul_rod2_pd;
reg    [255:0] mul_rod3_pd;
reg      [3:0] mul_rod_mask;
reg            sdp_b2cvif_rd_cdt_lat_fifo_pop;
reg            sdp_b2mcif_rd_cdt_lat_fifo_pop;
wire           alu_layer_end;
wire           alu_roc_half;
wire     [3:0] alu_roc_pd;
wire           alu_roc_rdy;
wire           alu_roc_vld;
wire           alu_rod_rdy;
wire           alu_rod_vld;
wire    [13:0] beat_size;
wire           both_rod_rdy;
wire           cfg_alu_en;
wire           cfg_data_size_1byte;
wire           cfg_data_size_2byte;
wire           cfg_do_8;
wire           cfg_dp_8;
wire           cfg_mode_1bytex1;
wire           cfg_mode_1bytex2;
wire           cfg_mode_2bytex1;
wire           cfg_mode_2bytex2;
wire           cfg_mode_alu_only;
wire           cfg_mode_both;
wire           cfg_mode_mul_only;
wire           cfg_mode_multi_batch;
wire           cfg_mode_per_element;
wire           cfg_mode_single;
wire           cfg_mul_en;
wire   [513:0] cv_dma_rd_rsp_pd;
wire           cv_dma_rd_rsp_vld;
wire   [513:0] cv_int_rd_rsp_pd;
wire           cv_int_rd_rsp_ready;
wire           cv_int_rd_rsp_valid;
wire   [513:0] cvif2sdp_b_rd_rsp_pd_d0;
wire   [513:0] cvif2sdp_b_rd_rsp_pd_d1;
wire           cvif2sdp_b_rd_rsp_ready_d0;
wire           cvif2sdp_b_rd_rsp_ready_d1;
wire           cvif2sdp_b_rd_rsp_valid_d0;
wire           cvif2sdp_b_rd_rsp_valid_d1;
wire           dma_rd_cdt_lat_fifo_pop;
wire   [513:0] dma_rd_rsp_pd;
wire           dma_rd_rsp_ram_type;
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire           ig2eg_cube_end;
wire    [14:0] ig2eg_size;
wire           is_2bytex2_int8_2nd_last_beat;
wire           is_any_rod_accept;
wire           is_cube_last;
wire           is_data_half;
wire           is_last_beat;
wire   [511:0] lat_ecc_rd_data;
wire     [1:0] lat_ecc_rd_mask;
wire   [513:0] lat_ecc_rd_pd;
wire           lat_ecc_rd_pvld;
wire           layer_done;
wire   [513:0] mc_dma_rd_rsp_pd;
wire           mc_dma_rd_rsp_vld;
wire   [513:0] mc_int_rd_rsp_pd;
wire           mc_int_rd_rsp_ready;
wire           mc_int_rd_rsp_valid;
wire   [513:0] mcif2sdp_b_rd_rsp_pd_d0;
wire   [513:0] mcif2sdp_b_rd_rsp_pd_d1;
wire           mcif2sdp_b_rd_rsp_ready_d0;
wire           mcif2sdp_b_rd_rsp_ready_d1;
wire           mcif2sdp_b_rd_rsp_valid_d0;
wire           mcif2sdp_b_rd_rsp_valid_d1;
wire     [3:0] mode_1bytex1_alu_mask;
wire   [255:0] mode_1bytex1_alu_rod0_pd;
wire   [255:0] mode_1bytex1_alu_rod1_pd;
wire   [255:0] mode_1bytex1_alu_rod2_pd;
wire   [255:0] mode_1bytex1_alu_rod3_pd;
wire     [3:0] mode_1bytex1_mul_mask;
wire   [255:0] mode_1bytex1_mul_rod0_pd;
wire   [255:0] mode_1bytex1_mul_rod1_pd;
wire   [255:0] mode_1bytex1_mul_rod2_pd;
wire   [255:0] mode_1bytex1_mul_rod3_pd;
wire     [7:0] mode_1bytex1_rod0_data0;
wire    [15:0] mode_1bytex1_rod0_data0_ext;
wire     [7:0] mode_1bytex1_rod0_data1;
wire     [7:0] mode_1bytex1_rod0_data10;
wire    [15:0] mode_1bytex1_rod0_data10_ext;
wire     [7:0] mode_1bytex1_rod0_data11;
wire    [15:0] mode_1bytex1_rod0_data11_ext;
wire     [7:0] mode_1bytex1_rod0_data12;
wire    [15:0] mode_1bytex1_rod0_data12_ext;
wire     [7:0] mode_1bytex1_rod0_data13;
wire    [15:0] mode_1bytex1_rod0_data13_ext;
wire     [7:0] mode_1bytex1_rod0_data14;
wire    [15:0] mode_1bytex1_rod0_data14_ext;
wire     [7:0] mode_1bytex1_rod0_data15;
wire    [15:0] mode_1bytex1_rod0_data15_ext;
wire    [15:0] mode_1bytex1_rod0_data1_ext;
wire     [7:0] mode_1bytex1_rod0_data2;
wire    [15:0] mode_1bytex1_rod0_data2_ext;
wire     [7:0] mode_1bytex1_rod0_data3;
wire    [15:0] mode_1bytex1_rod0_data3_ext;
wire     [7:0] mode_1bytex1_rod0_data4;
wire    [15:0] mode_1bytex1_rod0_data4_ext;
wire     [7:0] mode_1bytex1_rod0_data5;
wire    [15:0] mode_1bytex1_rod0_data5_ext;
wire     [7:0] mode_1bytex1_rod0_data6;
wire    [15:0] mode_1bytex1_rod0_data6_ext;
wire     [7:0] mode_1bytex1_rod0_data7;
wire    [15:0] mode_1bytex1_rod0_data7_ext;
wire     [7:0] mode_1bytex1_rod0_data8;
wire    [15:0] mode_1bytex1_rod0_data8_ext;
wire     [7:0] mode_1bytex1_rod0_data9;
wire    [15:0] mode_1bytex1_rod0_data9_ext;
wire   [255:0] mode_1bytex1_rod0_pd;
wire     [7:0] mode_1bytex1_rod1_data0;
wire    [15:0] mode_1bytex1_rod1_data0_ext;
wire     [7:0] mode_1bytex1_rod1_data1;
wire     [7:0] mode_1bytex1_rod1_data10;
wire    [15:0] mode_1bytex1_rod1_data10_ext;
wire     [7:0] mode_1bytex1_rod1_data11;
wire    [15:0] mode_1bytex1_rod1_data11_ext;
wire     [7:0] mode_1bytex1_rod1_data12;
wire    [15:0] mode_1bytex1_rod1_data12_ext;
wire     [7:0] mode_1bytex1_rod1_data13;
wire    [15:0] mode_1bytex1_rod1_data13_ext;
wire     [7:0] mode_1bytex1_rod1_data14;
wire    [15:0] mode_1bytex1_rod1_data14_ext;
wire     [7:0] mode_1bytex1_rod1_data15;
wire    [15:0] mode_1bytex1_rod1_data15_ext;
wire    [15:0] mode_1bytex1_rod1_data1_ext;
wire     [7:0] mode_1bytex1_rod1_data2;
wire    [15:0] mode_1bytex1_rod1_data2_ext;
wire     [7:0] mode_1bytex1_rod1_data3;
wire    [15:0] mode_1bytex1_rod1_data3_ext;
wire     [7:0] mode_1bytex1_rod1_data4;
wire    [15:0] mode_1bytex1_rod1_data4_ext;
wire     [7:0] mode_1bytex1_rod1_data5;
wire    [15:0] mode_1bytex1_rod1_data5_ext;
wire     [7:0] mode_1bytex1_rod1_data6;
wire    [15:0] mode_1bytex1_rod1_data6_ext;
wire     [7:0] mode_1bytex1_rod1_data7;
wire    [15:0] mode_1bytex1_rod1_data7_ext;
wire     [7:0] mode_1bytex1_rod1_data8;
wire    [15:0] mode_1bytex1_rod1_data8_ext;
wire     [7:0] mode_1bytex1_rod1_data9;
wire    [15:0] mode_1bytex1_rod1_data9_ext;
wire   [255:0] mode_1bytex1_rod1_pd;
wire     [7:0] mode_1bytex1_rod2_data0;
wire    [15:0] mode_1bytex1_rod2_data0_ext;
wire     [7:0] mode_1bytex1_rod2_data1;
wire     [7:0] mode_1bytex1_rod2_data10;
wire    [15:0] mode_1bytex1_rod2_data10_ext;
wire     [7:0] mode_1bytex1_rod2_data11;
wire    [15:0] mode_1bytex1_rod2_data11_ext;
wire     [7:0] mode_1bytex1_rod2_data12;
wire    [15:0] mode_1bytex1_rod2_data12_ext;
wire     [7:0] mode_1bytex1_rod2_data13;
wire    [15:0] mode_1bytex1_rod2_data13_ext;
wire     [7:0] mode_1bytex1_rod2_data14;
wire    [15:0] mode_1bytex1_rod2_data14_ext;
wire     [7:0] mode_1bytex1_rod2_data15;
wire    [15:0] mode_1bytex1_rod2_data15_ext;
wire    [15:0] mode_1bytex1_rod2_data1_ext;
wire     [7:0] mode_1bytex1_rod2_data2;
wire    [15:0] mode_1bytex1_rod2_data2_ext;
wire     [7:0] mode_1bytex1_rod2_data3;
wire    [15:0] mode_1bytex1_rod2_data3_ext;
wire     [7:0] mode_1bytex1_rod2_data4;
wire    [15:0] mode_1bytex1_rod2_data4_ext;
wire     [7:0] mode_1bytex1_rod2_data5;
wire    [15:0] mode_1bytex1_rod2_data5_ext;
wire     [7:0] mode_1bytex1_rod2_data6;
wire    [15:0] mode_1bytex1_rod2_data6_ext;
wire     [7:0] mode_1bytex1_rod2_data7;
wire    [15:0] mode_1bytex1_rod2_data7_ext;
wire     [7:0] mode_1bytex1_rod2_data8;
wire    [15:0] mode_1bytex1_rod2_data8_ext;
wire     [7:0] mode_1bytex1_rod2_data9;
wire    [15:0] mode_1bytex1_rod2_data9_ext;
wire   [255:0] mode_1bytex1_rod2_pd;
wire     [7:0] mode_1bytex1_rod3_data0;
wire    [15:0] mode_1bytex1_rod3_data0_ext;
wire     [7:0] mode_1bytex1_rod3_data1;
wire     [7:0] mode_1bytex1_rod3_data10;
wire    [15:0] mode_1bytex1_rod3_data10_ext;
wire     [7:0] mode_1bytex1_rod3_data11;
wire    [15:0] mode_1bytex1_rod3_data11_ext;
wire     [7:0] mode_1bytex1_rod3_data12;
wire    [15:0] mode_1bytex1_rod3_data12_ext;
wire     [7:0] mode_1bytex1_rod3_data13;
wire    [15:0] mode_1bytex1_rod3_data13_ext;
wire     [7:0] mode_1bytex1_rod3_data14;
wire    [15:0] mode_1bytex1_rod3_data14_ext;
wire     [7:0] mode_1bytex1_rod3_data15;
wire    [15:0] mode_1bytex1_rod3_data15_ext;
wire    [15:0] mode_1bytex1_rod3_data1_ext;
wire     [7:0] mode_1bytex1_rod3_data2;
wire    [15:0] mode_1bytex1_rod3_data2_ext;
wire     [7:0] mode_1bytex1_rod3_data3;
wire    [15:0] mode_1bytex1_rod3_data3_ext;
wire     [7:0] mode_1bytex1_rod3_data4;
wire    [15:0] mode_1bytex1_rod3_data4_ext;
wire     [7:0] mode_1bytex1_rod3_data5;
wire    [15:0] mode_1bytex1_rod3_data5_ext;
wire     [7:0] mode_1bytex1_rod3_data6;
wire    [15:0] mode_1bytex1_rod3_data6_ext;
wire     [7:0] mode_1bytex1_rod3_data7;
wire    [15:0] mode_1bytex1_rod3_data7_ext;
wire     [7:0] mode_1bytex1_rod3_data8;
wire    [15:0] mode_1bytex1_rod3_data8_ext;
wire     [7:0] mode_1bytex1_rod3_data9;
wire    [15:0] mode_1bytex1_rod3_data9_ext;
wire   [255:0] mode_1bytex1_rod3_pd;
wire     [3:0] mode_1bytex2_alu_mask;
wire     [7:0] mode_1bytex2_alu_rod0_data0;
wire    [15:0] mode_1bytex2_alu_rod0_data0_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data1;
wire     [7:0] mode_1bytex2_alu_rod0_data10;
wire    [15:0] mode_1bytex2_alu_rod0_data10_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data11;
wire    [15:0] mode_1bytex2_alu_rod0_data11_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data12;
wire    [15:0] mode_1bytex2_alu_rod0_data12_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data13;
wire    [15:0] mode_1bytex2_alu_rod0_data13_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data14;
wire    [15:0] mode_1bytex2_alu_rod0_data14_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data15;
wire    [15:0] mode_1bytex2_alu_rod0_data15_ext;
wire    [15:0] mode_1bytex2_alu_rod0_data1_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data2;
wire    [15:0] mode_1bytex2_alu_rod0_data2_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data3;
wire    [15:0] mode_1bytex2_alu_rod0_data3_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data4;
wire    [15:0] mode_1bytex2_alu_rod0_data4_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data5;
wire    [15:0] mode_1bytex2_alu_rod0_data5_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data6;
wire    [15:0] mode_1bytex2_alu_rod0_data6_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data7;
wire    [15:0] mode_1bytex2_alu_rod0_data7_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data8;
wire    [15:0] mode_1bytex2_alu_rod0_data8_ext;
wire     [7:0] mode_1bytex2_alu_rod0_data9;
wire    [15:0] mode_1bytex2_alu_rod0_data9_ext;
wire   [255:0] mode_1bytex2_alu_rod0_pd;
wire     [7:0] mode_1bytex2_alu_rod1_data0;
wire    [15:0] mode_1bytex2_alu_rod1_data0_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data1;
wire     [7:0] mode_1bytex2_alu_rod1_data10;
wire    [15:0] mode_1bytex2_alu_rod1_data10_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data11;
wire    [15:0] mode_1bytex2_alu_rod1_data11_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data12;
wire    [15:0] mode_1bytex2_alu_rod1_data12_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data13;
wire    [15:0] mode_1bytex2_alu_rod1_data13_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data14;
wire    [15:0] mode_1bytex2_alu_rod1_data14_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data15;
wire    [15:0] mode_1bytex2_alu_rod1_data15_ext;
wire    [15:0] mode_1bytex2_alu_rod1_data1_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data2;
wire    [15:0] mode_1bytex2_alu_rod1_data2_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data3;
wire    [15:0] mode_1bytex2_alu_rod1_data3_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data4;
wire    [15:0] mode_1bytex2_alu_rod1_data4_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data5;
wire    [15:0] mode_1bytex2_alu_rod1_data5_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data6;
wire    [15:0] mode_1bytex2_alu_rod1_data6_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data7;
wire    [15:0] mode_1bytex2_alu_rod1_data7_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data8;
wire    [15:0] mode_1bytex2_alu_rod1_data8_ext;
wire     [7:0] mode_1bytex2_alu_rod1_data9;
wire    [15:0] mode_1bytex2_alu_rod1_data9_ext;
wire   [255:0] mode_1bytex2_alu_rod1_pd;
wire     [7:0] mode_1bytex2_alu_rod2_data0;
wire    [15:0] mode_1bytex2_alu_rod2_data0_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data1;
wire     [7:0] mode_1bytex2_alu_rod2_data10;
wire    [15:0] mode_1bytex2_alu_rod2_data10_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data11;
wire    [15:0] mode_1bytex2_alu_rod2_data11_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data12;
wire    [15:0] mode_1bytex2_alu_rod2_data12_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data13;
wire    [15:0] mode_1bytex2_alu_rod2_data13_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data14;
wire    [15:0] mode_1bytex2_alu_rod2_data14_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data15;
wire    [15:0] mode_1bytex2_alu_rod2_data15_ext;
wire    [15:0] mode_1bytex2_alu_rod2_data1_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data2;
wire    [15:0] mode_1bytex2_alu_rod2_data2_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data3;
wire    [15:0] mode_1bytex2_alu_rod2_data3_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data4;
wire    [15:0] mode_1bytex2_alu_rod2_data4_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data5;
wire    [15:0] mode_1bytex2_alu_rod2_data5_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data6;
wire    [15:0] mode_1bytex2_alu_rod2_data6_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data7;
wire    [15:0] mode_1bytex2_alu_rod2_data7_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data8;
wire    [15:0] mode_1bytex2_alu_rod2_data8_ext;
wire     [7:0] mode_1bytex2_alu_rod2_data9;
wire    [15:0] mode_1bytex2_alu_rod2_data9_ext;
wire   [255:0] mode_1bytex2_alu_rod2_pd;
wire     [7:0] mode_1bytex2_alu_rod3_data0;
wire    [15:0] mode_1bytex2_alu_rod3_data0_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data1;
wire     [7:0] mode_1bytex2_alu_rod3_data10;
wire    [15:0] mode_1bytex2_alu_rod3_data10_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data11;
wire    [15:0] mode_1bytex2_alu_rod3_data11_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data12;
wire    [15:0] mode_1bytex2_alu_rod3_data12_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data13;
wire    [15:0] mode_1bytex2_alu_rod3_data13_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data14;
wire    [15:0] mode_1bytex2_alu_rod3_data14_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data15;
wire    [15:0] mode_1bytex2_alu_rod3_data15_ext;
wire    [15:0] mode_1bytex2_alu_rod3_data1_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data2;
wire    [15:0] mode_1bytex2_alu_rod3_data2_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data3;
wire    [15:0] mode_1bytex2_alu_rod3_data3_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data4;
wire    [15:0] mode_1bytex2_alu_rod3_data4_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data5;
wire    [15:0] mode_1bytex2_alu_rod3_data5_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data6;
wire    [15:0] mode_1bytex2_alu_rod3_data6_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data7;
wire    [15:0] mode_1bytex2_alu_rod3_data7_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data8;
wire    [15:0] mode_1bytex2_alu_rod3_data8_ext;
wire     [7:0] mode_1bytex2_alu_rod3_data9;
wire    [15:0] mode_1bytex2_alu_rod3_data9_ext;
wire   [255:0] mode_1bytex2_alu_rod3_pd;
wire     [3:0] mode_1bytex2_mul_mask;
wire     [7:0] mode_1bytex2_mul_rod0_data0;
wire    [15:0] mode_1bytex2_mul_rod0_data0_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data1;
wire     [7:0] mode_1bytex2_mul_rod0_data10;
wire    [15:0] mode_1bytex2_mul_rod0_data10_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data11;
wire    [15:0] mode_1bytex2_mul_rod0_data11_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data12;
wire    [15:0] mode_1bytex2_mul_rod0_data12_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data13;
wire    [15:0] mode_1bytex2_mul_rod0_data13_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data14;
wire    [15:0] mode_1bytex2_mul_rod0_data14_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data15;
wire    [15:0] mode_1bytex2_mul_rod0_data15_ext;
wire    [15:0] mode_1bytex2_mul_rod0_data1_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data2;
wire    [15:0] mode_1bytex2_mul_rod0_data2_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data3;
wire    [15:0] mode_1bytex2_mul_rod0_data3_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data4;
wire    [15:0] mode_1bytex2_mul_rod0_data4_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data5;
wire    [15:0] mode_1bytex2_mul_rod0_data5_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data6;
wire    [15:0] mode_1bytex2_mul_rod0_data6_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data7;
wire    [15:0] mode_1bytex2_mul_rod0_data7_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data8;
wire    [15:0] mode_1bytex2_mul_rod0_data8_ext;
wire     [7:0] mode_1bytex2_mul_rod0_data9;
wire    [15:0] mode_1bytex2_mul_rod0_data9_ext;
wire   [255:0] mode_1bytex2_mul_rod0_pd;
wire     [7:0] mode_1bytex2_mul_rod1_data0;
wire    [15:0] mode_1bytex2_mul_rod1_data0_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data1;
wire     [7:0] mode_1bytex2_mul_rod1_data10;
wire    [15:0] mode_1bytex2_mul_rod1_data10_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data11;
wire    [15:0] mode_1bytex2_mul_rod1_data11_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data12;
wire    [15:0] mode_1bytex2_mul_rod1_data12_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data13;
wire    [15:0] mode_1bytex2_mul_rod1_data13_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data14;
wire    [15:0] mode_1bytex2_mul_rod1_data14_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data15;
wire    [15:0] mode_1bytex2_mul_rod1_data15_ext;
wire    [15:0] mode_1bytex2_mul_rod1_data1_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data2;
wire    [15:0] mode_1bytex2_mul_rod1_data2_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data3;
wire    [15:0] mode_1bytex2_mul_rod1_data3_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data4;
wire    [15:0] mode_1bytex2_mul_rod1_data4_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data5;
wire    [15:0] mode_1bytex2_mul_rod1_data5_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data6;
wire    [15:0] mode_1bytex2_mul_rod1_data6_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data7;
wire    [15:0] mode_1bytex2_mul_rod1_data7_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data8;
wire    [15:0] mode_1bytex2_mul_rod1_data8_ext;
wire     [7:0] mode_1bytex2_mul_rod1_data9;
wire    [15:0] mode_1bytex2_mul_rod1_data9_ext;
wire   [255:0] mode_1bytex2_mul_rod1_pd;
wire     [7:0] mode_1bytex2_mul_rod2_data0;
wire    [15:0] mode_1bytex2_mul_rod2_data0_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data1;
wire     [7:0] mode_1bytex2_mul_rod2_data10;
wire    [15:0] mode_1bytex2_mul_rod2_data10_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data11;
wire    [15:0] mode_1bytex2_mul_rod2_data11_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data12;
wire    [15:0] mode_1bytex2_mul_rod2_data12_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data13;
wire    [15:0] mode_1bytex2_mul_rod2_data13_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data14;
wire    [15:0] mode_1bytex2_mul_rod2_data14_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data15;
wire    [15:0] mode_1bytex2_mul_rod2_data15_ext;
wire    [15:0] mode_1bytex2_mul_rod2_data1_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data2;
wire    [15:0] mode_1bytex2_mul_rod2_data2_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data3;
wire    [15:0] mode_1bytex2_mul_rod2_data3_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data4;
wire    [15:0] mode_1bytex2_mul_rod2_data4_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data5;
wire    [15:0] mode_1bytex2_mul_rod2_data5_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data6;
wire    [15:0] mode_1bytex2_mul_rod2_data6_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data7;
wire    [15:0] mode_1bytex2_mul_rod2_data7_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data8;
wire    [15:0] mode_1bytex2_mul_rod2_data8_ext;
wire     [7:0] mode_1bytex2_mul_rod2_data9;
wire    [15:0] mode_1bytex2_mul_rod2_data9_ext;
wire   [255:0] mode_1bytex2_mul_rod2_pd;
wire     [7:0] mode_1bytex2_mul_rod3_data0;
wire    [15:0] mode_1bytex2_mul_rod3_data0_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data1;
wire     [7:0] mode_1bytex2_mul_rod3_data10;
wire    [15:0] mode_1bytex2_mul_rod3_data10_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data11;
wire    [15:0] mode_1bytex2_mul_rod3_data11_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data12;
wire    [15:0] mode_1bytex2_mul_rod3_data12_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data13;
wire    [15:0] mode_1bytex2_mul_rod3_data13_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data14;
wire    [15:0] mode_1bytex2_mul_rod3_data14_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data15;
wire    [15:0] mode_1bytex2_mul_rod3_data15_ext;
wire    [15:0] mode_1bytex2_mul_rod3_data1_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data2;
wire    [15:0] mode_1bytex2_mul_rod3_data2_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data3;
wire    [15:0] mode_1bytex2_mul_rod3_data3_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data4;
wire    [15:0] mode_1bytex2_mul_rod3_data4_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data5;
wire    [15:0] mode_1bytex2_mul_rod3_data5_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data6;
wire    [15:0] mode_1bytex2_mul_rod3_data6_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data7;
wire    [15:0] mode_1bytex2_mul_rod3_data7_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data8;
wire    [15:0] mode_1bytex2_mul_rod3_data8_ext;
wire     [7:0] mode_1bytex2_mul_rod3_data9;
wire    [15:0] mode_1bytex2_mul_rod3_data9_ext;
wire   [255:0] mode_1bytex2_mul_rod3_pd;
wire     [3:0] mode_2bytex1_alu_mask;
wire   [255:0] mode_2bytex1_alu_rod0_pd;
wire   [255:0] mode_2bytex1_alu_rod1_pd;
wire   [255:0] mode_2bytex1_alu_rod2_pd;
wire   [255:0] mode_2bytex1_alu_rod3_pd;
wire     [3:0] mode_2bytex1_mul_mask;
wire   [255:0] mode_2bytex1_mul_rod0_pd;
wire   [255:0] mode_2bytex1_mul_rod1_pd;
wire   [255:0] mode_2bytex1_mul_rod2_pd;
wire   [255:0] mode_2bytex1_mul_rod3_pd;
wire    [15:0] mode_2bytex1_rod0_data0;
wire    [15:0] mode_2bytex1_rod0_data1;
wire    [15:0] mode_2bytex1_rod0_data10;
wire    [15:0] mode_2bytex1_rod0_data11;
wire    [15:0] mode_2bytex1_rod0_data12;
wire    [15:0] mode_2bytex1_rod0_data13;
wire    [15:0] mode_2bytex1_rod0_data14;
wire    [15:0] mode_2bytex1_rod0_data15;
wire    [15:0] mode_2bytex1_rod0_data2;
wire    [15:0] mode_2bytex1_rod0_data3;
wire    [15:0] mode_2bytex1_rod0_data4;
wire    [15:0] mode_2bytex1_rod0_data5;
wire    [15:0] mode_2bytex1_rod0_data6;
wire    [15:0] mode_2bytex1_rod0_data7;
wire    [15:0] mode_2bytex1_rod0_data8;
wire    [15:0] mode_2bytex1_rod0_data9;
wire   [255:0] mode_2bytex1_rod0_pd;
wire    [15:0] mode_2bytex1_rod1_data0;
wire    [15:0] mode_2bytex1_rod1_data1;
wire    [15:0] mode_2bytex1_rod1_data10;
wire    [15:0] mode_2bytex1_rod1_data11;
wire    [15:0] mode_2bytex1_rod1_data12;
wire    [15:0] mode_2bytex1_rod1_data13;
wire    [15:0] mode_2bytex1_rod1_data14;
wire    [15:0] mode_2bytex1_rod1_data15;
wire    [15:0] mode_2bytex1_rod1_data2;
wire    [15:0] mode_2bytex1_rod1_data3;
wire    [15:0] mode_2bytex1_rod1_data4;
wire    [15:0] mode_2bytex1_rod1_data5;
wire    [15:0] mode_2bytex1_rod1_data6;
wire    [15:0] mode_2bytex1_rod1_data7;
wire    [15:0] mode_2bytex1_rod1_data8;
wire    [15:0] mode_2bytex1_rod1_data9;
wire   [255:0] mode_2bytex1_rod1_pd;
wire    [15:0] mode_2bytex1_rod2_data0;
wire    [15:0] mode_2bytex1_rod2_data1;
wire    [15:0] mode_2bytex1_rod2_data10;
wire    [15:0] mode_2bytex1_rod2_data11;
wire    [15:0] mode_2bytex1_rod2_data12;
wire    [15:0] mode_2bytex1_rod2_data13;
wire    [15:0] mode_2bytex1_rod2_data14;
wire    [15:0] mode_2bytex1_rod2_data15;
wire    [15:0] mode_2bytex1_rod2_data2;
wire    [15:0] mode_2bytex1_rod2_data3;
wire    [15:0] mode_2bytex1_rod2_data4;
wire    [15:0] mode_2bytex1_rod2_data5;
wire    [15:0] mode_2bytex1_rod2_data6;
wire    [15:0] mode_2bytex1_rod2_data7;
wire    [15:0] mode_2bytex1_rod2_data8;
wire    [15:0] mode_2bytex1_rod2_data9;
wire   [255:0] mode_2bytex1_rod2_pd;
wire    [15:0] mode_2bytex1_rod3_data0;
wire    [15:0] mode_2bytex1_rod3_data1;
wire    [15:0] mode_2bytex1_rod3_data10;
wire    [15:0] mode_2bytex1_rod3_data11;
wire    [15:0] mode_2bytex1_rod3_data12;
wire    [15:0] mode_2bytex1_rod3_data13;
wire    [15:0] mode_2bytex1_rod3_data14;
wire    [15:0] mode_2bytex1_rod3_data15;
wire    [15:0] mode_2bytex1_rod3_data2;
wire    [15:0] mode_2bytex1_rod3_data3;
wire    [15:0] mode_2bytex1_rod3_data4;
wire    [15:0] mode_2bytex1_rod3_data5;
wire    [15:0] mode_2bytex1_rod3_data6;
wire    [15:0] mode_2bytex1_rod3_data7;
wire    [15:0] mode_2bytex1_rod3_data8;
wire    [15:0] mode_2bytex1_rod3_data9;
wire   [255:0] mode_2bytex1_rod3_pd;
wire     [3:0] mode_2bytex2_alu_mask;
wire    [15:0] mode_2bytex2_alu_rod0_data0;
wire    [15:0] mode_2bytex2_alu_rod0_data1;
wire    [15:0] mode_2bytex2_alu_rod0_data10;
wire    [15:0] mode_2bytex2_alu_rod0_data11;
wire    [15:0] mode_2bytex2_alu_rod0_data12;
wire    [15:0] mode_2bytex2_alu_rod0_data13;
wire    [15:0] mode_2bytex2_alu_rod0_data14;
wire    [15:0] mode_2bytex2_alu_rod0_data15;
wire    [15:0] mode_2bytex2_alu_rod0_data2;
wire    [15:0] mode_2bytex2_alu_rod0_data3;
wire    [15:0] mode_2bytex2_alu_rod0_data4;
wire    [15:0] mode_2bytex2_alu_rod0_data5;
wire    [15:0] mode_2bytex2_alu_rod0_data6;
wire    [15:0] mode_2bytex2_alu_rod0_data7;
wire    [15:0] mode_2bytex2_alu_rod0_data8;
wire    [15:0] mode_2bytex2_alu_rod0_data9;
wire   [255:0] mode_2bytex2_alu_rod0_pd;
wire    [15:0] mode_2bytex2_alu_rod1_data0;
wire    [15:0] mode_2bytex2_alu_rod1_data1;
wire    [15:0] mode_2bytex2_alu_rod1_data10;
wire    [15:0] mode_2bytex2_alu_rod1_data11;
wire    [15:0] mode_2bytex2_alu_rod1_data12;
wire    [15:0] mode_2bytex2_alu_rod1_data13;
wire    [15:0] mode_2bytex2_alu_rod1_data14;
wire    [15:0] mode_2bytex2_alu_rod1_data15;
wire    [15:0] mode_2bytex2_alu_rod1_data2;
wire    [15:0] mode_2bytex2_alu_rod1_data3;
wire    [15:0] mode_2bytex2_alu_rod1_data4;
wire    [15:0] mode_2bytex2_alu_rod1_data5;
wire    [15:0] mode_2bytex2_alu_rod1_data6;
wire    [15:0] mode_2bytex2_alu_rod1_data7;
wire    [15:0] mode_2bytex2_alu_rod1_data8;
wire    [15:0] mode_2bytex2_alu_rod1_data9;
wire   [255:0] mode_2bytex2_alu_rod1_pd;
wire    [15:0] mode_2bytex2_alu_rod2_data0;
wire    [15:0] mode_2bytex2_alu_rod2_data1;
wire    [15:0] mode_2bytex2_alu_rod2_data10;
wire    [15:0] mode_2bytex2_alu_rod2_data11;
wire    [15:0] mode_2bytex2_alu_rod2_data12;
wire    [15:0] mode_2bytex2_alu_rod2_data13;
wire    [15:0] mode_2bytex2_alu_rod2_data14;
wire    [15:0] mode_2bytex2_alu_rod2_data15;
wire    [15:0] mode_2bytex2_alu_rod2_data2;
wire    [15:0] mode_2bytex2_alu_rod2_data3;
wire    [15:0] mode_2bytex2_alu_rod2_data4;
wire    [15:0] mode_2bytex2_alu_rod2_data5;
wire    [15:0] mode_2bytex2_alu_rod2_data6;
wire    [15:0] mode_2bytex2_alu_rod2_data7;
wire    [15:0] mode_2bytex2_alu_rod2_data8;
wire    [15:0] mode_2bytex2_alu_rod2_data9;
wire   [255:0] mode_2bytex2_alu_rod2_pd;
wire    [15:0] mode_2bytex2_alu_rod3_data0;
wire    [15:0] mode_2bytex2_alu_rod3_data1;
wire    [15:0] mode_2bytex2_alu_rod3_data10;
wire    [15:0] mode_2bytex2_alu_rod3_data11;
wire    [15:0] mode_2bytex2_alu_rod3_data12;
wire    [15:0] mode_2bytex2_alu_rod3_data13;
wire    [15:0] mode_2bytex2_alu_rod3_data14;
wire    [15:0] mode_2bytex2_alu_rod3_data15;
wire    [15:0] mode_2bytex2_alu_rod3_data2;
wire    [15:0] mode_2bytex2_alu_rod3_data3;
wire    [15:0] mode_2bytex2_alu_rod3_data4;
wire    [15:0] mode_2bytex2_alu_rod3_data5;
wire    [15:0] mode_2bytex2_alu_rod3_data6;
wire    [15:0] mode_2bytex2_alu_rod3_data7;
wire    [15:0] mode_2bytex2_alu_rod3_data8;
wire    [15:0] mode_2bytex2_alu_rod3_data9;
wire   [255:0] mode_2bytex2_alu_rod3_pd;
wire     [3:0] mode_2bytex2_mul_mask;
wire    [15:0] mode_2bytex2_mul_rod0_data0;
wire    [15:0] mode_2bytex2_mul_rod0_data1;
wire    [15:0] mode_2bytex2_mul_rod0_data10;
wire    [15:0] mode_2bytex2_mul_rod0_data11;
wire    [15:0] mode_2bytex2_mul_rod0_data12;
wire    [15:0] mode_2bytex2_mul_rod0_data13;
wire    [15:0] mode_2bytex2_mul_rod0_data14;
wire    [15:0] mode_2bytex2_mul_rod0_data15;
wire    [15:0] mode_2bytex2_mul_rod0_data2;
wire    [15:0] mode_2bytex2_mul_rod0_data3;
wire    [15:0] mode_2bytex2_mul_rod0_data4;
wire    [15:0] mode_2bytex2_mul_rod0_data5;
wire    [15:0] mode_2bytex2_mul_rod0_data6;
wire    [15:0] mode_2bytex2_mul_rod0_data7;
wire    [15:0] mode_2bytex2_mul_rod0_data8;
wire    [15:0] mode_2bytex2_mul_rod0_data9;
wire   [255:0] mode_2bytex2_mul_rod0_pd;
wire    [15:0] mode_2bytex2_mul_rod1_data0;
wire    [15:0] mode_2bytex2_mul_rod1_data1;
wire    [15:0] mode_2bytex2_mul_rod1_data10;
wire    [15:0] mode_2bytex2_mul_rod1_data11;
wire    [15:0] mode_2bytex2_mul_rod1_data12;
wire    [15:0] mode_2bytex2_mul_rod1_data13;
wire    [15:0] mode_2bytex2_mul_rod1_data14;
wire    [15:0] mode_2bytex2_mul_rod1_data15;
wire    [15:0] mode_2bytex2_mul_rod1_data2;
wire    [15:0] mode_2bytex2_mul_rod1_data3;
wire    [15:0] mode_2bytex2_mul_rod1_data4;
wire    [15:0] mode_2bytex2_mul_rod1_data5;
wire    [15:0] mode_2bytex2_mul_rod1_data6;
wire    [15:0] mode_2bytex2_mul_rod1_data7;
wire    [15:0] mode_2bytex2_mul_rod1_data8;
wire    [15:0] mode_2bytex2_mul_rod1_data9;
wire   [255:0] mode_2bytex2_mul_rod1_pd;
wire    [15:0] mode_2bytex2_mul_rod2_data0;
wire    [15:0] mode_2bytex2_mul_rod2_data1;
wire    [15:0] mode_2bytex2_mul_rod2_data10;
wire    [15:0] mode_2bytex2_mul_rod2_data11;
wire    [15:0] mode_2bytex2_mul_rod2_data12;
wire    [15:0] mode_2bytex2_mul_rod2_data13;
wire    [15:0] mode_2bytex2_mul_rod2_data14;
wire    [15:0] mode_2bytex2_mul_rod2_data15;
wire    [15:0] mode_2bytex2_mul_rod2_data2;
wire    [15:0] mode_2bytex2_mul_rod2_data3;
wire    [15:0] mode_2bytex2_mul_rod2_data4;
wire    [15:0] mode_2bytex2_mul_rod2_data5;
wire    [15:0] mode_2bytex2_mul_rod2_data6;
wire    [15:0] mode_2bytex2_mul_rod2_data7;
wire    [15:0] mode_2bytex2_mul_rod2_data8;
wire    [15:0] mode_2bytex2_mul_rod2_data9;
wire   [255:0] mode_2bytex2_mul_rod2_pd;
wire    [15:0] mode_2bytex2_mul_rod3_data0;
wire    [15:0] mode_2bytex2_mul_rod3_data1;
wire    [15:0] mode_2bytex2_mul_rod3_data10;
wire    [15:0] mode_2bytex2_mul_rod3_data11;
wire    [15:0] mode_2bytex2_mul_rod3_data12;
wire    [15:0] mode_2bytex2_mul_rod3_data13;
wire    [15:0] mode_2bytex2_mul_rod3_data14;
wire    [15:0] mode_2bytex2_mul_rod3_data15;
wire    [15:0] mode_2bytex2_mul_rod3_data2;
wire    [15:0] mode_2bytex2_mul_rod3_data3;
wire    [15:0] mode_2bytex2_mul_rod3_data4;
wire    [15:0] mode_2bytex2_mul_rod3_data5;
wire    [15:0] mode_2bytex2_mul_rod3_data6;
wire    [15:0] mode_2bytex2_mul_rod3_data7;
wire    [15:0] mode_2bytex2_mul_rod3_data8;
wire    [15:0] mode_2bytex2_mul_rod3_data9;
wire   [255:0] mode_2bytex2_mul_rod3_pd;
wire           mode_2bytex2_sel;
wire           mon_both_roc_rdy;
wire           mon_cq2eg_pvld;
wire           mul_layer_end;
wire           mul_roc_half;
wire     [3:0] mul_roc_pd;
wire           mul_roc_rdy;
wire           mul_roc_vld;
wire           mul_rod_rdy;
wire           mul_rod_vld;
wire           need_extra_rod;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// Status Generation: idle/busy/process/done/etc
//==============

//==============
// CFG REG
//==============
//assign cfg_data_type_int8  = reg2dp_brdma_data_type == NVDLA_GENERIC_PRECISION_ENUM_INT8;
//assign cfg_data_type_int16 = reg2dp_brdma_data_type == NVDLA_GENERIC_PRECISION_ENUM_INT16;


assign cfg_data_size_1byte = reg2dp_brdma_data_size == 1'h0 ;
assign cfg_data_size_2byte = reg2dp_brdma_data_size == 1'h1 ;

//assign cfg_mode_disable   = reg2dp_brdma_disable == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DISABLE_YES;

//assign cfg_proc_int16     = reg2dp_proc_precision == NVDLA_GENERIC_PRECISION_ENUM_INT16;

assign cfg_mode_mul_only  = reg2dp_brdma_data_use == 2'h0 ;
assign cfg_mode_alu_only  = reg2dp_brdma_data_use == 2'h1 ;
assign cfg_mode_both      = reg2dp_brdma_data_use == 2'h2 ;
assign cfg_mode_per_element  = reg2dp_brdma_data_mode == 1'h1 ;
//assign cfg_mode_per_kernel  = reg2dp_brdma_data_mode == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL;
//assign cfg_mode_per_kernel  = reg2dp_brdma_data_mode == NVDLA_SDP_RDMA_D_BRDMA_CFG_0_BRDMA_DATA_MODE_PER_KERNEL;

assign cfg_mode_single = cfg_mode_mul_only || cfg_mode_alu_only;

assign cfg_mode_1bytex1 = cfg_data_size_1byte & cfg_mode_single;
assign cfg_mode_2bytex1 = cfg_data_size_2byte & cfg_mode_single;
assign cfg_mode_1bytex2 = cfg_data_size_1byte & cfg_mode_both;
assign cfg_mode_2bytex2 = cfg_data_size_2byte & cfg_mode_both;

assign cfg_mode_multi_batch = reg2dp_batch_number!=0;
//assign cfg_di_8 = reg2dp_in_precision==NVDLA_GENERIC_PRECISION_ENUM_INT8;
assign cfg_dp_8 = reg2dp_proc_precision== 0 ;
assign cfg_do_8 = reg2dp_out_precision== 0 ;

assign cfg_alu_en = cfg_mode_alu_only || cfg_mode_both;
assign cfg_mul_en = cfg_mode_mul_only || cfg_mode_both;

// (size,both) : 0,0->1 | 0,1->2 | 1,0->2 | 1,1->4

//==============
// DMA Interface
//==============
assign dma_rd_rsp_ram_type     = reg2dp_brdma_ram_type;
assign dma_rd_cdt_lat_fifo_pop = lat_ecc_rd_pvld & lat_ecc_rd_prdy;
// rd Channel: Response

assign mcif2sdp_b_rd_rsp_valid_d0 = mcif2sdp_b_rd_rsp_valid;
assign mcif2sdp_b_rd_rsp_ready = mcif2sdp_b_rd_rsp_ready_d0;
assign mcif2sdp_b_rd_rsp_pd_d0[513:0] = mcif2sdp_b_rd_rsp_pd[513:0];
NV_NVDLA_SDP_BRDMA_EG_pipe_p1 pipe_p1 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.mcif2sdp_b_rd_rsp_pd_d0    (mcif2sdp_b_rd_rsp_pd_d0[513:0]) //|< w
  ,.mcif2sdp_b_rd_rsp_ready_d1 (mcif2sdp_b_rd_rsp_ready_d1)     //|< w
  ,.mcif2sdp_b_rd_rsp_valid_d0 (mcif2sdp_b_rd_rsp_valid_d0)     //|< w
  ,.mcif2sdp_b_rd_rsp_pd_d1    (mcif2sdp_b_rd_rsp_pd_d1[513:0]) //|> w
  ,.mcif2sdp_b_rd_rsp_ready_d0 (mcif2sdp_b_rd_rsp_ready_d0)     //|> w
  ,.mcif2sdp_b_rd_rsp_valid_d1 (mcif2sdp_b_rd_rsp_valid_d1)     //|> w
  );
assign mc_int_rd_rsp_valid = mcif2sdp_b_rd_rsp_valid_d1;
assign mcif2sdp_b_rd_rsp_ready_d1 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2sdp_b_rd_rsp_pd_d1[513:0];


assign cvif2sdp_b_rd_rsp_valid_d0 = cvif2sdp_b_rd_rsp_valid;
assign cvif2sdp_b_rd_rsp_ready = cvif2sdp_b_rd_rsp_ready_d0;
assign cvif2sdp_b_rd_rsp_pd_d0[513:0] = cvif2sdp_b_rd_rsp_pd[513:0];
NV_NVDLA_SDP_BRDMA_EG_pipe_p2 pipe_p2 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.cvif2sdp_b_rd_rsp_pd_d0    (cvif2sdp_b_rd_rsp_pd_d0[513:0]) //|< w
  ,.cvif2sdp_b_rd_rsp_ready_d1 (cvif2sdp_b_rd_rsp_ready_d1)     //|< w
  ,.cvif2sdp_b_rd_rsp_valid_d0 (cvif2sdp_b_rd_rsp_valid_d0)     //|< w
  ,.cvif2sdp_b_rd_rsp_pd_d1    (cvif2sdp_b_rd_rsp_pd_d1[513:0]) //|> w
  ,.cvif2sdp_b_rd_rsp_ready_d0 (cvif2sdp_b_rd_rsp_ready_d0)     //|> w
  ,.cvif2sdp_b_rd_rsp_valid_d1 (cvif2sdp_b_rd_rsp_valid_d1)     //|> w
  );
assign cv_int_rd_rsp_valid = cvif2sdp_b_rd_rsp_valid_d1;
assign cvif2sdp_b_rd_rsp_ready_d1 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2sdp_b_rd_rsp_pd_d1[513:0];

NV_NVDLA_SDP_BRDMA_EG_pipe_p3 pipe_p3 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.dma_rd_rsp_rdy             (dma_rd_rsp_rdy)                 //|< w
  ,.mc_int_rd_rsp_pd           (mc_int_rd_rsp_pd[513:0])        //|< w
  ,.mc_int_rd_rsp_valid        (mc_int_rd_rsp_valid)            //|< w
  ,.mc_dma_rd_rsp_pd           (mc_dma_rd_rsp_pd[513:0])        //|> w
  ,.mc_dma_rd_rsp_vld          (mc_dma_rd_rsp_vld)              //|> w
  ,.mc_int_rd_rsp_ready        (mc_int_rd_rsp_ready)            //|> w
  );
NV_NVDLA_SDP_BRDMA_EG_pipe_p4 pipe_p4 (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.cv_int_rd_rsp_pd           (cv_int_rd_rsp_pd[513:0])        //|< w
  ,.cv_int_rd_rsp_valid        (cv_int_rd_rsp_valid)            //|< w
  ,.dma_rd_rsp_rdy             (dma_rd_rsp_rdy)                 //|< w
  ,.cv_dma_rd_rsp_pd           (cv_dma_rd_rsp_pd[513:0])        //|> w
  ,.cv_dma_rd_rsp_vld          (cv_dma_rd_rsp_vld)              //|> w
  ,.cv_int_rd_rsp_ready        (cv_int_rd_rsp_ready)            //|> w
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
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_b2mcif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp_b2mcif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b1);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp_b2cvif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp_b2cvif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b0);
  end
end

//==============
// Latency FIFO to buffer return DATA
//==============
assign need_extra_rod = cfg_mode_multi_batch & cfg_do_8;
assign is_data_half = lat_ecc_rd_pvld & (lat_ecc_rd_mask[1]==0);
always @(
  cfg_mode_1bytex1
  or need_extra_rod
  or both_rod_rdy
  or mode_1bytex1_cnt
  or is_data_half
  or cfg_mode_2bytex1
  or mode_2bytex1_cnt
  or cfg_mode_1bytex2
  or mode_1bytex2_cnt
  or cfg_mode_2bytex2
  or mode_2bytex2_sel
  ) begin
    if (cfg_mode_1bytex1) begin
        if (need_extra_rod) begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end else begin
            lat_ecc_rd_prdy = both_rod_rdy & (mode_1bytex1_cnt || is_data_half);
        end
    end else if (cfg_mode_2bytex1) begin
        if (mode_2bytex1_cnt==0) begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end else begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end
    end else if (cfg_mode_1bytex2) begin
        if (mode_1bytex2_cnt==0) begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end else begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end
    end else if (cfg_mode_2bytex2) begin
        if (mode_2bytex2_sel==0) begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end else begin
            lat_ecc_rd_prdy = both_rod_rdy;
        end
    end else begin
        lat_ecc_rd_prdy = both_rod_rdy;
    end
end


    NV_NVDLA_SDP_BRDMA_EG_lat_fifo u_lat_fifo (
       .nvdla_core_clk             (nvdla_core_clk)                 //|< i
      ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
      ,.lat_wr_prdy                (dma_rd_rsp_rdy)                 //|> w
      ,.lat_wr_pvld                (dma_rd_rsp_vld)                 //|< w
      ,.lat_wr_pd                  (dma_rd_rsp_pd[513:0])           //|< w
      ,.lat_rd_prdy                (lat_ecc_rd_prdy)                //|< r
      ,.lat_rd_pvld                (lat_ecc_rd_pvld)                //|> w
      ,.lat_rd_pd                  (lat_ecc_rd_pd[513:0])           //|> w
      ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
      );


//==================================

// PKT_UNPACK_WIRE( dma_read_data , lat_ecc_rd_ , lat_ecc_rd_pd )
assign       lat_ecc_rd_data[511:0] =    lat_ecc_rd_pd[511:0];
assign       lat_ecc_rd_mask[1:0] =    lat_ecc_rd_pd[513:512];
// lat_ecc_rd_mask | lat_ecc_rd_data 
// only care the rdy of ro-fifo which mask bit indidates
// when also need send to other group of ro-fif, need clamp the vld if others are not ready

//==============
// Re-Order FIFO to send data to SDP-core
//==============
//      |----------------------------------------------------|
//      |    16B     |    16B     |    16B     |     16B     |
// MODE |----------------------------------------------------|
//      |     0            1            2            3       |
// 1Bx1 | ALU or MUL | ALU or MUL | ALU or MUL or ALU or MUL |
//      |----------------------------------------------------|
//      |            0            |            1             |
// 2Bx1 |        ALU or MUL       |        ALU or MUL        |
//      |====================================================|
//      |            0            |            1             |
// 1Bx2 |    ALU     |    MUL     |    ALU     |     MUL     |
//      |----------------------------------------------------|
//      |            0            |            1             |
// 2Bx1 |           ALU           |           MUL            |
//      |----------------------------------------------------|

//      |----------------------------------------------------|
//==================================
//roc_size: beat_cnt
//() is used for multi-batch
//[] is mean next cycle
// INT 8: 
//          | 1Bx1| 2Bx1| 1Bx2| 2Bx2
//  rod0  : |  02 |  0  |  0  |  0
//  rod1  : |  13 |  1  |  1  | [1]
//----------------------------------
//  rod2  : | (2) | (2) | (2) | (2)
//  rod3  : | (3) | (3) | (3) | (3)

// INT16: () is used for multi-batch
//          | 1Bx1| 2Bx1| 1Bx2| 2Bx2
//  rod0  : |  0  |  0  |  0  |  0
//  rod1  : |  1  |  1  |  1  | (1)
//----------------------------------
//  rod2  : | (2) | (2) | (2) | (2)
//  rod3  : | (3) | (3) | (3) | (3)

// 1Bx1
 assign mode_1bytex1_rod0_data0 = {lat_ecc_rd_data[((8*0) + 8 - 1):8*0]};
 assign mode_1bytex1_rod0_data1 = {lat_ecc_rd_data[((8*1) + 8 - 1):8*1]};
 assign mode_1bytex1_rod0_data2 = {lat_ecc_rd_data[((8*2) + 8 - 1):8*2]};
 assign mode_1bytex1_rod0_data3 = {lat_ecc_rd_data[((8*3) + 8 - 1):8*3]};
 assign mode_1bytex1_rod0_data4 = {lat_ecc_rd_data[((8*4) + 8 - 1):8*4]};
 assign mode_1bytex1_rod0_data5 = {lat_ecc_rd_data[((8*5) + 8 - 1):8*5]};
 assign mode_1bytex1_rod0_data6 = {lat_ecc_rd_data[((8*6) + 8 - 1):8*6]};
 assign mode_1bytex1_rod0_data7 = {lat_ecc_rd_data[((8*7) + 8 - 1):8*7]};
 assign mode_1bytex1_rod0_data8 = {lat_ecc_rd_data[((8*8) + 8 - 1):8*8]};
 assign mode_1bytex1_rod0_data9 = {lat_ecc_rd_data[((8*9) + 8 - 1):8*9]};
 assign mode_1bytex1_rod0_data10 = {lat_ecc_rd_data[((8*10) + 8 - 1):8*10]};
 assign mode_1bytex1_rod0_data11 = {lat_ecc_rd_data[((8*11) + 8 - 1):8*11]};
 assign mode_1bytex1_rod0_data12 = {lat_ecc_rd_data[((8*12) + 8 - 1):8*12]};
 assign mode_1bytex1_rod0_data13 = {lat_ecc_rd_data[((8*13) + 8 - 1):8*13]};
 assign mode_1bytex1_rod0_data14 = {lat_ecc_rd_data[((8*14) + 8 - 1):8*14]};
 assign mode_1bytex1_rod0_data15 = {lat_ecc_rd_data[((8*15) + 8 - 1):8*15]};
 assign mode_1bytex1_rod1_data0 = {lat_ecc_rd_data[((8*16) + 8 - 1):8*16]};
 assign mode_1bytex1_rod1_data1 = {lat_ecc_rd_data[((8*17) + 8 - 1):8*17]};
 assign mode_1bytex1_rod1_data2 = {lat_ecc_rd_data[((8*18) + 8 - 1):8*18]};
 assign mode_1bytex1_rod1_data3 = {lat_ecc_rd_data[((8*19) + 8 - 1):8*19]};
 assign mode_1bytex1_rod1_data4 = {lat_ecc_rd_data[((8*20) + 8 - 1):8*20]};
 assign mode_1bytex1_rod1_data5 = {lat_ecc_rd_data[((8*21) + 8 - 1):8*21]};
 assign mode_1bytex1_rod1_data6 = {lat_ecc_rd_data[((8*22) + 8 - 1):8*22]};
 assign mode_1bytex1_rod1_data7 = {lat_ecc_rd_data[((8*23) + 8 - 1):8*23]};
 assign mode_1bytex1_rod1_data8 = {lat_ecc_rd_data[((8*24) + 8 - 1):8*24]};
 assign mode_1bytex1_rod1_data9 = {lat_ecc_rd_data[((8*25) + 8 - 1):8*25]};
 assign mode_1bytex1_rod1_data10 = {lat_ecc_rd_data[((8*26) + 8 - 1):8*26]};
 assign mode_1bytex1_rod1_data11 = {lat_ecc_rd_data[((8*27) + 8 - 1):8*27]};
 assign mode_1bytex1_rod1_data12 = {lat_ecc_rd_data[((8*28) + 8 - 1):8*28]};
 assign mode_1bytex1_rod1_data13 = {lat_ecc_rd_data[((8*29) + 8 - 1):8*29]};
 assign mode_1bytex1_rod1_data14 = {lat_ecc_rd_data[((8*30) + 8 - 1):8*30]};
 assign mode_1bytex1_rod1_data15 = {lat_ecc_rd_data[((8*31) + 8 - 1):8*31]};
 assign mode_1bytex1_rod2_data0 = {lat_ecc_rd_data[((8*32) + 8 - 1):8*32]};
 assign mode_1bytex1_rod2_data1 = {lat_ecc_rd_data[((8*33) + 8 - 1):8*33]};
 assign mode_1bytex1_rod2_data2 = {lat_ecc_rd_data[((8*34) + 8 - 1):8*34]};
 assign mode_1bytex1_rod2_data3 = {lat_ecc_rd_data[((8*35) + 8 - 1):8*35]};
 assign mode_1bytex1_rod2_data4 = {lat_ecc_rd_data[((8*36) + 8 - 1):8*36]};
 assign mode_1bytex1_rod2_data5 = {lat_ecc_rd_data[((8*37) + 8 - 1):8*37]};
 assign mode_1bytex1_rod2_data6 = {lat_ecc_rd_data[((8*38) + 8 - 1):8*38]};
 assign mode_1bytex1_rod2_data7 = {lat_ecc_rd_data[((8*39) + 8 - 1):8*39]};
 assign mode_1bytex1_rod2_data8 = {lat_ecc_rd_data[((8*40) + 8 - 1):8*40]};
 assign mode_1bytex1_rod2_data9 = {lat_ecc_rd_data[((8*41) + 8 - 1):8*41]};
 assign mode_1bytex1_rod2_data10 = {lat_ecc_rd_data[((8*42) + 8 - 1):8*42]};
 assign mode_1bytex1_rod2_data11 = {lat_ecc_rd_data[((8*43) + 8 - 1):8*43]};
 assign mode_1bytex1_rod2_data12 = {lat_ecc_rd_data[((8*44) + 8 - 1):8*44]};
 assign mode_1bytex1_rod2_data13 = {lat_ecc_rd_data[((8*45) + 8 - 1):8*45]};
 assign mode_1bytex1_rod2_data14 = {lat_ecc_rd_data[((8*46) + 8 - 1):8*46]};
 assign mode_1bytex1_rod2_data15 = {lat_ecc_rd_data[((8*47) + 8 - 1):8*47]};
 assign mode_1bytex1_rod3_data0 = {lat_ecc_rd_data[((8*48) + 8 - 1):8*48]};
 assign mode_1bytex1_rod3_data1 = {lat_ecc_rd_data[((8*49) + 8 - 1):8*49]};
 assign mode_1bytex1_rod3_data2 = {lat_ecc_rd_data[((8*50) + 8 - 1):8*50]};
 assign mode_1bytex1_rod3_data3 = {lat_ecc_rd_data[((8*51) + 8 - 1):8*51]};
 assign mode_1bytex1_rod3_data4 = {lat_ecc_rd_data[((8*52) + 8 - 1):8*52]};
 assign mode_1bytex1_rod3_data5 = {lat_ecc_rd_data[((8*53) + 8 - 1):8*53]};
 assign mode_1bytex1_rod3_data6 = {lat_ecc_rd_data[((8*54) + 8 - 1):8*54]};
 assign mode_1bytex1_rod3_data7 = {lat_ecc_rd_data[((8*55) + 8 - 1):8*55]};
 assign mode_1bytex1_rod3_data8 = {lat_ecc_rd_data[((8*56) + 8 - 1):8*56]};
 assign mode_1bytex1_rod3_data9 = {lat_ecc_rd_data[((8*57) + 8 - 1):8*57]};
 assign mode_1bytex1_rod3_data10 = {lat_ecc_rd_data[((8*58) + 8 - 1):8*58]};
 assign mode_1bytex1_rod3_data11 = {lat_ecc_rd_data[((8*59) + 8 - 1):8*59]};
 assign mode_1bytex1_rod3_data12 = {lat_ecc_rd_data[((8*60) + 8 - 1):8*60]};
 assign mode_1bytex1_rod3_data13 = {lat_ecc_rd_data[((8*61) + 8 - 1):8*61]};
 assign mode_1bytex1_rod3_data14 = {lat_ecc_rd_data[((8*62) + 8 - 1):8*62]};
 assign mode_1bytex1_rod3_data15 = {lat_ecc_rd_data[((8*63) + 8 - 1):8*63]};
 assign mode_1bytex1_rod0_data0_ext = {{8{mode_1bytex1_rod0_data0[7]}}, mode_1bytex1_rod0_data0[7:0]};
 assign mode_1bytex1_rod0_data1_ext = {{8{mode_1bytex1_rod0_data1[7]}}, mode_1bytex1_rod0_data1[7:0]};
 assign mode_1bytex1_rod0_data2_ext = {{8{mode_1bytex1_rod0_data2[7]}}, mode_1bytex1_rod0_data2[7:0]};
 assign mode_1bytex1_rod0_data3_ext = {{8{mode_1bytex1_rod0_data3[7]}}, mode_1bytex1_rod0_data3[7:0]};
 assign mode_1bytex1_rod0_data4_ext = {{8{mode_1bytex1_rod0_data4[7]}}, mode_1bytex1_rod0_data4[7:0]};
 assign mode_1bytex1_rod0_data5_ext = {{8{mode_1bytex1_rod0_data5[7]}}, mode_1bytex1_rod0_data5[7:0]};
 assign mode_1bytex1_rod0_data6_ext = {{8{mode_1bytex1_rod0_data6[7]}}, mode_1bytex1_rod0_data6[7:0]};
 assign mode_1bytex1_rod0_data7_ext = {{8{mode_1bytex1_rod0_data7[7]}}, mode_1bytex1_rod0_data7[7:0]};
 assign mode_1bytex1_rod0_data8_ext = {{8{mode_1bytex1_rod0_data8[7]}}, mode_1bytex1_rod0_data8[7:0]};
 assign mode_1bytex1_rod0_data9_ext = {{8{mode_1bytex1_rod0_data9[7]}}, mode_1bytex1_rod0_data9[7:0]};
 assign mode_1bytex1_rod0_data10_ext = {{8{mode_1bytex1_rod0_data10[7]}}, mode_1bytex1_rod0_data10[7:0]};
 assign mode_1bytex1_rod0_data11_ext = {{8{mode_1bytex1_rod0_data11[7]}}, mode_1bytex1_rod0_data11[7:0]};
 assign mode_1bytex1_rod0_data12_ext = {{8{mode_1bytex1_rod0_data12[7]}}, mode_1bytex1_rod0_data12[7:0]};
 assign mode_1bytex1_rod0_data13_ext = {{8{mode_1bytex1_rod0_data13[7]}}, mode_1bytex1_rod0_data13[7:0]};
 assign mode_1bytex1_rod0_data14_ext = {{8{mode_1bytex1_rod0_data14[7]}}, mode_1bytex1_rod0_data14[7:0]};
 assign mode_1bytex1_rod0_data15_ext = {{8{mode_1bytex1_rod0_data15[7]}}, mode_1bytex1_rod0_data15[7:0]};
 assign mode_1bytex1_rod1_data0_ext = {{8{mode_1bytex1_rod1_data0[7]}}, mode_1bytex1_rod1_data0[7:0]};
 assign mode_1bytex1_rod1_data1_ext = {{8{mode_1bytex1_rod1_data1[7]}}, mode_1bytex1_rod1_data1[7:0]};
 assign mode_1bytex1_rod1_data2_ext = {{8{mode_1bytex1_rod1_data2[7]}}, mode_1bytex1_rod1_data2[7:0]};
 assign mode_1bytex1_rod1_data3_ext = {{8{mode_1bytex1_rod1_data3[7]}}, mode_1bytex1_rod1_data3[7:0]};
 assign mode_1bytex1_rod1_data4_ext = {{8{mode_1bytex1_rod1_data4[7]}}, mode_1bytex1_rod1_data4[7:0]};
 assign mode_1bytex1_rod1_data5_ext = {{8{mode_1bytex1_rod1_data5[7]}}, mode_1bytex1_rod1_data5[7:0]};
 assign mode_1bytex1_rod1_data6_ext = {{8{mode_1bytex1_rod1_data6[7]}}, mode_1bytex1_rod1_data6[7:0]};
 assign mode_1bytex1_rod1_data7_ext = {{8{mode_1bytex1_rod1_data7[7]}}, mode_1bytex1_rod1_data7[7:0]};
 assign mode_1bytex1_rod1_data8_ext = {{8{mode_1bytex1_rod1_data8[7]}}, mode_1bytex1_rod1_data8[7:0]};
 assign mode_1bytex1_rod1_data9_ext = {{8{mode_1bytex1_rod1_data9[7]}}, mode_1bytex1_rod1_data9[7:0]};
 assign mode_1bytex1_rod1_data10_ext = {{8{mode_1bytex1_rod1_data10[7]}}, mode_1bytex1_rod1_data10[7:0]};
 assign mode_1bytex1_rod1_data11_ext = {{8{mode_1bytex1_rod1_data11[7]}}, mode_1bytex1_rod1_data11[7:0]};
 assign mode_1bytex1_rod1_data12_ext = {{8{mode_1bytex1_rod1_data12[7]}}, mode_1bytex1_rod1_data12[7:0]};
 assign mode_1bytex1_rod1_data13_ext = {{8{mode_1bytex1_rod1_data13[7]}}, mode_1bytex1_rod1_data13[7:0]};
 assign mode_1bytex1_rod1_data14_ext = {{8{mode_1bytex1_rod1_data14[7]}}, mode_1bytex1_rod1_data14[7:0]};
 assign mode_1bytex1_rod1_data15_ext = {{8{mode_1bytex1_rod1_data15[7]}}, mode_1bytex1_rod1_data15[7:0]};
 assign mode_1bytex1_rod2_data0_ext = {{8{mode_1bytex1_rod2_data0[7]}}, mode_1bytex1_rod2_data0[7:0]};
 assign mode_1bytex1_rod2_data1_ext = {{8{mode_1bytex1_rod2_data1[7]}}, mode_1bytex1_rod2_data1[7:0]};
 assign mode_1bytex1_rod2_data2_ext = {{8{mode_1bytex1_rod2_data2[7]}}, mode_1bytex1_rod2_data2[7:0]};
 assign mode_1bytex1_rod2_data3_ext = {{8{mode_1bytex1_rod2_data3[7]}}, mode_1bytex1_rod2_data3[7:0]};
 assign mode_1bytex1_rod2_data4_ext = {{8{mode_1bytex1_rod2_data4[7]}}, mode_1bytex1_rod2_data4[7:0]};
 assign mode_1bytex1_rod2_data5_ext = {{8{mode_1bytex1_rod2_data5[7]}}, mode_1bytex1_rod2_data5[7:0]};
 assign mode_1bytex1_rod2_data6_ext = {{8{mode_1bytex1_rod2_data6[7]}}, mode_1bytex1_rod2_data6[7:0]};
 assign mode_1bytex1_rod2_data7_ext = {{8{mode_1bytex1_rod2_data7[7]}}, mode_1bytex1_rod2_data7[7:0]};
 assign mode_1bytex1_rod2_data8_ext = {{8{mode_1bytex1_rod2_data8[7]}}, mode_1bytex1_rod2_data8[7:0]};
 assign mode_1bytex1_rod2_data9_ext = {{8{mode_1bytex1_rod2_data9[7]}}, mode_1bytex1_rod2_data9[7:0]};
 assign mode_1bytex1_rod2_data10_ext = {{8{mode_1bytex1_rod2_data10[7]}}, mode_1bytex1_rod2_data10[7:0]};
 assign mode_1bytex1_rod2_data11_ext = {{8{mode_1bytex1_rod2_data11[7]}}, mode_1bytex1_rod2_data11[7:0]};
 assign mode_1bytex1_rod2_data12_ext = {{8{mode_1bytex1_rod2_data12[7]}}, mode_1bytex1_rod2_data12[7:0]};
 assign mode_1bytex1_rod2_data13_ext = {{8{mode_1bytex1_rod2_data13[7]}}, mode_1bytex1_rod2_data13[7:0]};
 assign mode_1bytex1_rod2_data14_ext = {{8{mode_1bytex1_rod2_data14[7]}}, mode_1bytex1_rod2_data14[7:0]};
 assign mode_1bytex1_rod2_data15_ext = {{8{mode_1bytex1_rod2_data15[7]}}, mode_1bytex1_rod2_data15[7:0]};
 assign mode_1bytex1_rod3_data0_ext = {{8{mode_1bytex1_rod3_data0[7]}}, mode_1bytex1_rod3_data0[7:0]};
 assign mode_1bytex1_rod3_data1_ext = {{8{mode_1bytex1_rod3_data1[7]}}, mode_1bytex1_rod3_data1[7:0]};
 assign mode_1bytex1_rod3_data2_ext = {{8{mode_1bytex1_rod3_data2[7]}}, mode_1bytex1_rod3_data2[7:0]};
 assign mode_1bytex1_rod3_data3_ext = {{8{mode_1bytex1_rod3_data3[7]}}, mode_1bytex1_rod3_data3[7:0]};
 assign mode_1bytex1_rod3_data4_ext = {{8{mode_1bytex1_rod3_data4[7]}}, mode_1bytex1_rod3_data4[7:0]};
 assign mode_1bytex1_rod3_data5_ext = {{8{mode_1bytex1_rod3_data5[7]}}, mode_1bytex1_rod3_data5[7:0]};
 assign mode_1bytex1_rod3_data6_ext = {{8{mode_1bytex1_rod3_data6[7]}}, mode_1bytex1_rod3_data6[7:0]};
 assign mode_1bytex1_rod3_data7_ext = {{8{mode_1bytex1_rod3_data7[7]}}, mode_1bytex1_rod3_data7[7:0]};
 assign mode_1bytex1_rod3_data8_ext = {{8{mode_1bytex1_rod3_data8[7]}}, mode_1bytex1_rod3_data8[7:0]};
 assign mode_1bytex1_rod3_data9_ext = {{8{mode_1bytex1_rod3_data9[7]}}, mode_1bytex1_rod3_data9[7:0]};
 assign mode_1bytex1_rod3_data10_ext = {{8{mode_1bytex1_rod3_data10[7]}}, mode_1bytex1_rod3_data10[7:0]};
 assign mode_1bytex1_rod3_data11_ext = {{8{mode_1bytex1_rod3_data11[7]}}, mode_1bytex1_rod3_data11[7:0]};
 assign mode_1bytex1_rod3_data12_ext = {{8{mode_1bytex1_rod3_data12[7]}}, mode_1bytex1_rod3_data12[7:0]};
 assign mode_1bytex1_rod3_data13_ext = {{8{mode_1bytex1_rod3_data13[7]}}, mode_1bytex1_rod3_data13[7:0]};
 assign mode_1bytex1_rod3_data14_ext = {{8{mode_1bytex1_rod3_data14[7]}}, mode_1bytex1_rod3_data14[7:0]};
 assign mode_1bytex1_rod3_data15_ext = {{8{mode_1bytex1_rod3_data15[7]}}, mode_1bytex1_rod3_data15[7:0]};
assign mode_1bytex1_rod0_pd = {mode_1bytex1_rod0_data15_ext,mode_1bytex1_rod0_data14_ext,mode_1bytex1_rod0_data13_ext,mode_1bytex1_rod0_data12_ext,mode_1bytex1_rod0_data11_ext,mode_1bytex1_rod0_data10_ext,mode_1bytex1_rod0_data9_ext,mode_1bytex1_rod0_data8_ext,mode_1bytex1_rod0_data7_ext,mode_1bytex1_rod0_data6_ext,mode_1bytex1_rod0_data5_ext,mode_1bytex1_rod0_data4_ext,mode_1bytex1_rod0_data3_ext,mode_1bytex1_rod0_data2_ext,mode_1bytex1_rod0_data1_ext,mode_1bytex1_rod0_data0_ext};
assign mode_1bytex1_rod1_pd = {mode_1bytex1_rod1_data15_ext,mode_1bytex1_rod1_data14_ext,mode_1bytex1_rod1_data13_ext,mode_1bytex1_rod1_data12_ext,mode_1bytex1_rod1_data11_ext,mode_1bytex1_rod1_data10_ext,mode_1bytex1_rod1_data9_ext,mode_1bytex1_rod1_data8_ext,mode_1bytex1_rod1_data7_ext,mode_1bytex1_rod1_data6_ext,mode_1bytex1_rod1_data5_ext,mode_1bytex1_rod1_data4_ext,mode_1bytex1_rod1_data3_ext,mode_1bytex1_rod1_data2_ext,mode_1bytex1_rod1_data1_ext,mode_1bytex1_rod1_data0_ext};
assign mode_1bytex1_rod2_pd = {mode_1bytex1_rod2_data15_ext,mode_1bytex1_rod2_data14_ext,mode_1bytex1_rod2_data13_ext,mode_1bytex1_rod2_data12_ext,mode_1bytex1_rod2_data11_ext,mode_1bytex1_rod2_data10_ext,mode_1bytex1_rod2_data9_ext,mode_1bytex1_rod2_data8_ext,mode_1bytex1_rod2_data7_ext,mode_1bytex1_rod2_data6_ext,mode_1bytex1_rod2_data5_ext,mode_1bytex1_rod2_data4_ext,mode_1bytex1_rod2_data3_ext,mode_1bytex1_rod2_data2_ext,mode_1bytex1_rod2_data1_ext,mode_1bytex1_rod2_data0_ext};
assign mode_1bytex1_rod3_pd = {mode_1bytex1_rod3_data15_ext,mode_1bytex1_rod3_data14_ext,mode_1bytex1_rod3_data13_ext,mode_1bytex1_rod3_data12_ext,mode_1bytex1_rod3_data11_ext,mode_1bytex1_rod3_data10_ext,mode_1bytex1_rod3_data9_ext,mode_1bytex1_rod3_data8_ext,mode_1bytex1_rod3_data7_ext,mode_1bytex1_rod3_data6_ext,mode_1bytex1_rod3_data5_ext,mode_1bytex1_rod3_data4_ext,mode_1bytex1_rod3_data3_ext,mode_1bytex1_rod3_data2_ext,mode_1bytex1_rod3_data1_ext,mode_1bytex1_rod3_data0_ext};

assign mode_1bytex1_alu_rod0_pd = mode_1bytex1_cnt==0 ? mode_1bytex1_rod0_pd : mode_1bytex1_rod2_pd;
assign mode_1bytex1_alu_rod1_pd = mode_1bytex1_cnt==0 ? mode_1bytex1_rod1_pd : mode_1bytex1_rod3_pd;
assign mode_1bytex1_alu_rod2_pd = mode_1bytex1_rod2_pd;
assign mode_1bytex1_alu_rod3_pd = mode_1bytex1_rod3_pd;
assign mode_1bytex1_mul_rod0_pd = mode_1bytex1_cnt==0 ? mode_1bytex1_rod0_pd : mode_1bytex1_rod2_pd;
assign mode_1bytex1_mul_rod1_pd = mode_1bytex1_cnt==0 ? mode_1bytex1_rod1_pd : mode_1bytex1_rod3_pd;
assign mode_1bytex1_mul_rod2_pd = mode_1bytex1_rod2_pd;
assign mode_1bytex1_mul_rod3_pd = mode_1bytex1_rod3_pd;

always @(
  need_extra_rod
  or lat_ecc_rd_mask
  ) begin
    if (need_extra_rod) begin
        mode_1bytex1_mask[1:0] = {2{lat_ecc_rd_mask[0]}};
        mode_1bytex1_mask[3:2] = {2{lat_ecc_rd_mask[1]}};
    end else begin
        mode_1bytex1_mask[1:0] = 2'b11;
        mode_1bytex1_mask[3:2] = 2'b00;
    end
end
assign mode_1bytex1_alu_mask = mode_1bytex1_mask;
assign mode_1bytex1_mul_mask = mode_1bytex1_mask;

// 2Bx1
 assign mode_2bytex1_rod0_data0 = {lat_ecc_rd_data[((16*0) + 16 - 1):16*0]};
 assign mode_2bytex1_rod0_data1 = {lat_ecc_rd_data[((16*1) + 16 - 1):16*1]};
 assign mode_2bytex1_rod0_data2 = {lat_ecc_rd_data[((16*2) + 16 - 1):16*2]};
 assign mode_2bytex1_rod0_data3 = {lat_ecc_rd_data[((16*3) + 16 - 1):16*3]};
 assign mode_2bytex1_rod0_data4 = {lat_ecc_rd_data[((16*4) + 16 - 1):16*4]};
 assign mode_2bytex1_rod0_data5 = {lat_ecc_rd_data[((16*5) + 16 - 1):16*5]};
 assign mode_2bytex1_rod0_data6 = {lat_ecc_rd_data[((16*6) + 16 - 1):16*6]};
 assign mode_2bytex1_rod0_data7 = {lat_ecc_rd_data[((16*7) + 16 - 1):16*7]};
 assign mode_2bytex1_rod0_data8 = {lat_ecc_rd_data[((16*8) + 16 - 1):16*8]};
 assign mode_2bytex1_rod0_data9 = {lat_ecc_rd_data[((16*9) + 16 - 1):16*9]};
 assign mode_2bytex1_rod0_data10 = {lat_ecc_rd_data[((16*10) + 16 - 1):16*10]};
 assign mode_2bytex1_rod0_data11 = {lat_ecc_rd_data[((16*11) + 16 - 1):16*11]};
 assign mode_2bytex1_rod0_data12 = {lat_ecc_rd_data[((16*12) + 16 - 1):16*12]};
 assign mode_2bytex1_rod0_data13 = {lat_ecc_rd_data[((16*13) + 16 - 1):16*13]};
 assign mode_2bytex1_rod0_data14 = {lat_ecc_rd_data[((16*14) + 16 - 1):16*14]};
 assign mode_2bytex1_rod0_data15 = {lat_ecc_rd_data[((16*15) + 16 - 1):16*15]};
 assign mode_2bytex1_rod1_data0 = {lat_ecc_rd_data[((16*16) + 16 - 1):16*16]};
 assign mode_2bytex1_rod1_data1 = {lat_ecc_rd_data[((16*17) + 16 - 1):16*17]};
 assign mode_2bytex1_rod1_data2 = {lat_ecc_rd_data[((16*18) + 16 - 1):16*18]};
 assign mode_2bytex1_rod1_data3 = {lat_ecc_rd_data[((16*19) + 16 - 1):16*19]};
 assign mode_2bytex1_rod1_data4 = {lat_ecc_rd_data[((16*20) + 16 - 1):16*20]};
 assign mode_2bytex1_rod1_data5 = {lat_ecc_rd_data[((16*21) + 16 - 1):16*21]};
 assign mode_2bytex1_rod1_data6 = {lat_ecc_rd_data[((16*22) + 16 - 1):16*22]};
 assign mode_2bytex1_rod1_data7 = {lat_ecc_rd_data[((16*23) + 16 - 1):16*23]};
 assign mode_2bytex1_rod1_data8 = {lat_ecc_rd_data[((16*24) + 16 - 1):16*24]};
 assign mode_2bytex1_rod1_data9 = {lat_ecc_rd_data[((16*25) + 16 - 1):16*25]};
 assign mode_2bytex1_rod1_data10 = {lat_ecc_rd_data[((16*26) + 16 - 1):16*26]};
 assign mode_2bytex1_rod1_data11 = {lat_ecc_rd_data[((16*27) + 16 - 1):16*27]};
 assign mode_2bytex1_rod1_data12 = {lat_ecc_rd_data[((16*28) + 16 - 1):16*28]};
 assign mode_2bytex1_rod1_data13 = {lat_ecc_rd_data[((16*29) + 16 - 1):16*29]};
 assign mode_2bytex1_rod1_data14 = {lat_ecc_rd_data[((16*30) + 16 - 1):16*30]};
 assign mode_2bytex1_rod1_data15 = {lat_ecc_rd_data[((16*31) + 16 - 1):16*31]};
 assign mode_2bytex1_rod2_data0 = {lat_ecc_rd_data[((16*0) + 16 - 1):16*0]};
 assign mode_2bytex1_rod2_data1 = {lat_ecc_rd_data[((16*1) + 16 - 1):16*1]};
 assign mode_2bytex1_rod2_data2 = {lat_ecc_rd_data[((16*2) + 16 - 1):16*2]};
 assign mode_2bytex1_rod2_data3 = {lat_ecc_rd_data[((16*3) + 16 - 1):16*3]};
 assign mode_2bytex1_rod2_data4 = {lat_ecc_rd_data[((16*4) + 16 - 1):16*4]};
 assign mode_2bytex1_rod2_data5 = {lat_ecc_rd_data[((16*5) + 16 - 1):16*5]};
 assign mode_2bytex1_rod2_data6 = {lat_ecc_rd_data[((16*6) + 16 - 1):16*6]};
 assign mode_2bytex1_rod2_data7 = {lat_ecc_rd_data[((16*7) + 16 - 1):16*7]};
 assign mode_2bytex1_rod2_data8 = {lat_ecc_rd_data[((16*8) + 16 - 1):16*8]};
 assign mode_2bytex1_rod2_data9 = {lat_ecc_rd_data[((16*9) + 16 - 1):16*9]};
 assign mode_2bytex1_rod2_data10 = {lat_ecc_rd_data[((16*10) + 16 - 1):16*10]};
 assign mode_2bytex1_rod2_data11 = {lat_ecc_rd_data[((16*11) + 16 - 1):16*11]};
 assign mode_2bytex1_rod2_data12 = {lat_ecc_rd_data[((16*12) + 16 - 1):16*12]};
 assign mode_2bytex1_rod2_data13 = {lat_ecc_rd_data[((16*13) + 16 - 1):16*13]};
 assign mode_2bytex1_rod2_data14 = {lat_ecc_rd_data[((16*14) + 16 - 1):16*14]};
 assign mode_2bytex1_rod2_data15 = {lat_ecc_rd_data[((16*15) + 16 - 1):16*15]};
 assign mode_2bytex1_rod3_data0 = {lat_ecc_rd_data[((16*16) + 16 - 1):16*16]};
 assign mode_2bytex1_rod3_data1 = {lat_ecc_rd_data[((16*17) + 16 - 1):16*17]};
 assign mode_2bytex1_rod3_data2 = {lat_ecc_rd_data[((16*18) + 16 - 1):16*18]};
 assign mode_2bytex1_rod3_data3 = {lat_ecc_rd_data[((16*19) + 16 - 1):16*19]};
 assign mode_2bytex1_rod3_data4 = {lat_ecc_rd_data[((16*20) + 16 - 1):16*20]};
 assign mode_2bytex1_rod3_data5 = {lat_ecc_rd_data[((16*21) + 16 - 1):16*21]};
 assign mode_2bytex1_rod3_data6 = {lat_ecc_rd_data[((16*22) + 16 - 1):16*22]};
 assign mode_2bytex1_rod3_data7 = {lat_ecc_rd_data[((16*23) + 16 - 1):16*23]};
 assign mode_2bytex1_rod3_data8 = {lat_ecc_rd_data[((16*24) + 16 - 1):16*24]};
 assign mode_2bytex1_rod3_data9 = {lat_ecc_rd_data[((16*25) + 16 - 1):16*25]};
 assign mode_2bytex1_rod3_data10 = {lat_ecc_rd_data[((16*26) + 16 - 1):16*26]};
 assign mode_2bytex1_rod3_data11 = {lat_ecc_rd_data[((16*27) + 16 - 1):16*27]};
 assign mode_2bytex1_rod3_data12 = {lat_ecc_rd_data[((16*28) + 16 - 1):16*28]};
 assign mode_2bytex1_rod3_data13 = {lat_ecc_rd_data[((16*29) + 16 - 1):16*29]};
 assign mode_2bytex1_rod3_data14 = {lat_ecc_rd_data[((16*30) + 16 - 1):16*30]};
 assign mode_2bytex1_rod3_data15 = {lat_ecc_rd_data[((16*31) + 16 - 1):16*31]};
assign mode_2bytex1_rod0_pd = {mode_2bytex1_rod0_data15,mode_2bytex1_rod0_data14,mode_2bytex1_rod0_data13,mode_2bytex1_rod0_data12,mode_2bytex1_rod0_data11,mode_2bytex1_rod0_data10,mode_2bytex1_rod0_data9,mode_2bytex1_rod0_data8,mode_2bytex1_rod0_data7,mode_2bytex1_rod0_data6,mode_2bytex1_rod0_data5,mode_2bytex1_rod0_data4,mode_2bytex1_rod0_data3,mode_2bytex1_rod0_data2,mode_2bytex1_rod0_data1,mode_2bytex1_rod0_data0};
assign mode_2bytex1_rod1_pd = {mode_2bytex1_rod1_data15,mode_2bytex1_rod1_data14,mode_2bytex1_rod1_data13,mode_2bytex1_rod1_data12,mode_2bytex1_rod1_data11,mode_2bytex1_rod1_data10,mode_2bytex1_rod1_data9,mode_2bytex1_rod1_data8,mode_2bytex1_rod1_data7,mode_2bytex1_rod1_data6,mode_2bytex1_rod1_data5,mode_2bytex1_rod1_data4,mode_2bytex1_rod1_data3,mode_2bytex1_rod1_data2,mode_2bytex1_rod1_data1,mode_2bytex1_rod1_data0};
assign mode_2bytex1_rod2_pd = {mode_2bytex1_rod2_data15,mode_2bytex1_rod2_data14,mode_2bytex1_rod2_data13,mode_2bytex1_rod2_data12,mode_2bytex1_rod2_data11,mode_2bytex1_rod2_data10,mode_2bytex1_rod2_data9,mode_2bytex1_rod2_data8,mode_2bytex1_rod2_data7,mode_2bytex1_rod2_data6,mode_2bytex1_rod2_data5,mode_2bytex1_rod2_data4,mode_2bytex1_rod2_data3,mode_2bytex1_rod2_data2,mode_2bytex1_rod2_data1,mode_2bytex1_rod2_data0};
assign mode_2bytex1_rod3_pd = {mode_2bytex1_rod3_data15,mode_2bytex1_rod3_data14,mode_2bytex1_rod3_data13,mode_2bytex1_rod3_data12,mode_2bytex1_rod3_data11,mode_2bytex1_rod3_data10,mode_2bytex1_rod3_data9,mode_2bytex1_rod3_data8,mode_2bytex1_rod3_data7,mode_2bytex1_rod3_data6,mode_2bytex1_rod3_data5,mode_2bytex1_rod3_data4,mode_2bytex1_rod3_data3,mode_2bytex1_rod3_data2,mode_2bytex1_rod3_data1,mode_2bytex1_rod3_data0};

assign mode_2bytex1_alu_rod0_pd = mode_2bytex1_rod0_pd;
assign mode_2bytex1_alu_rod1_pd = mode_2bytex1_rod1_pd;
assign mode_2bytex1_alu_rod2_pd = mode_2bytex1_rod2_pd;
assign mode_2bytex1_alu_rod3_pd = mode_2bytex1_rod3_pd;
assign mode_2bytex1_mul_rod0_pd = mode_2bytex1_rod0_pd;
assign mode_2bytex1_mul_rod1_pd = mode_2bytex1_rod1_pd;
assign mode_2bytex1_mul_rod2_pd = mode_2bytex1_rod2_pd;
assign mode_2bytex1_mul_rod3_pd = mode_2bytex1_rod3_pd;

always @(
  cfg_mode_multi_batch
  or cfg_do_8
  or mode_2bytex1_cnt
  or lat_ecc_rd_mask
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            mode_2bytex1_mask[1:0] = mode_2bytex1_cnt==0 ? lat_ecc_rd_mask : 2'd0;
            mode_2bytex1_mask[3:2] = mode_2bytex1_cnt==1 ? lat_ecc_rd_mask : 2'd0;
        end else begin
            mode_2bytex1_mask[1:0] = lat_ecc_rd_mask;
            mode_2bytex1_mask[3:2] = 2'b00;
        end
    end else begin
        mode_2bytex1_mask[1:0] = lat_ecc_rd_mask;
        mode_2bytex1_mask[3:2] = 2'b00;
    end
end
assign mode_2bytex1_alu_mask = mode_2bytex1_mask;
assign mode_2bytex1_mul_mask = mode_2bytex1_mask;

// 1Bx2: (ALU,MUL)x16 -> (ALUx16,MULx16)
 assign mode_1bytex2_alu_rod0_data0 = {lat_ecc_rd_data[((16*0) + 8 - 1):16*0]};
 assign mode_1bytex2_alu_rod0_data1 = {lat_ecc_rd_data[((16*1) + 8 - 1):16*1]};
 assign mode_1bytex2_alu_rod0_data2 = {lat_ecc_rd_data[((16*2) + 8 - 1):16*2]};
 assign mode_1bytex2_alu_rod0_data3 = {lat_ecc_rd_data[((16*3) + 8 - 1):16*3]};
 assign mode_1bytex2_alu_rod0_data4 = {lat_ecc_rd_data[((16*4) + 8 - 1):16*4]};
 assign mode_1bytex2_alu_rod0_data5 = {lat_ecc_rd_data[((16*5) + 8 - 1):16*5]};
 assign mode_1bytex2_alu_rod0_data6 = {lat_ecc_rd_data[((16*6) + 8 - 1):16*6]};
 assign mode_1bytex2_alu_rod0_data7 = {lat_ecc_rd_data[((16*7) + 8 - 1):16*7]};
 assign mode_1bytex2_alu_rod0_data8 = {lat_ecc_rd_data[((16*8) + 8 - 1):16*8]};
 assign mode_1bytex2_alu_rod0_data9 = {lat_ecc_rd_data[((16*9) + 8 - 1):16*9]};
 assign mode_1bytex2_alu_rod0_data10 = {lat_ecc_rd_data[((16*10) + 8 - 1):16*10]};
 assign mode_1bytex2_alu_rod0_data11 = {lat_ecc_rd_data[((16*11) + 8 - 1):16*11]};
 assign mode_1bytex2_alu_rod0_data12 = {lat_ecc_rd_data[((16*12) + 8 - 1):16*12]};
 assign mode_1bytex2_alu_rod0_data13 = {lat_ecc_rd_data[((16*13) + 8 - 1):16*13]};
 assign mode_1bytex2_alu_rod0_data14 = {lat_ecc_rd_data[((16*14) + 8 - 1):16*14]};
 assign mode_1bytex2_alu_rod0_data15 = {lat_ecc_rd_data[((16*15) + 8 - 1):16*15]};
 assign mode_1bytex2_alu_rod1_data0 = {lat_ecc_rd_data[((16*16) + 8 - 1):16*16]};
 assign mode_1bytex2_alu_rod1_data1 = {lat_ecc_rd_data[((16*17) + 8 - 1):16*17]};
 assign mode_1bytex2_alu_rod1_data2 = {lat_ecc_rd_data[((16*18) + 8 - 1):16*18]};
 assign mode_1bytex2_alu_rod1_data3 = {lat_ecc_rd_data[((16*19) + 8 - 1):16*19]};
 assign mode_1bytex2_alu_rod1_data4 = {lat_ecc_rd_data[((16*20) + 8 - 1):16*20]};
 assign mode_1bytex2_alu_rod1_data5 = {lat_ecc_rd_data[((16*21) + 8 - 1):16*21]};
 assign mode_1bytex2_alu_rod1_data6 = {lat_ecc_rd_data[((16*22) + 8 - 1):16*22]};
 assign mode_1bytex2_alu_rod1_data7 = {lat_ecc_rd_data[((16*23) + 8 - 1):16*23]};
 assign mode_1bytex2_alu_rod1_data8 = {lat_ecc_rd_data[((16*24) + 8 - 1):16*24]};
 assign mode_1bytex2_alu_rod1_data9 = {lat_ecc_rd_data[((16*25) + 8 - 1):16*25]};
 assign mode_1bytex2_alu_rod1_data10 = {lat_ecc_rd_data[((16*26) + 8 - 1):16*26]};
 assign mode_1bytex2_alu_rod1_data11 = {lat_ecc_rd_data[((16*27) + 8 - 1):16*27]};
 assign mode_1bytex2_alu_rod1_data12 = {lat_ecc_rd_data[((16*28) + 8 - 1):16*28]};
 assign mode_1bytex2_alu_rod1_data13 = {lat_ecc_rd_data[((16*29) + 8 - 1):16*29]};
 assign mode_1bytex2_alu_rod1_data14 = {lat_ecc_rd_data[((16*30) + 8 - 1):16*30]};
 assign mode_1bytex2_alu_rod1_data15 = {lat_ecc_rd_data[((16*31) + 8 - 1):16*31]};
 assign mode_1bytex2_alu_rod2_data0 = {lat_ecc_rd_data[((16*0) + 8 - 1):16*0]};
 assign mode_1bytex2_alu_rod2_data1 = {lat_ecc_rd_data[((16*1) + 8 - 1):16*1]};
 assign mode_1bytex2_alu_rod2_data2 = {lat_ecc_rd_data[((16*2) + 8 - 1):16*2]};
 assign mode_1bytex2_alu_rod2_data3 = {lat_ecc_rd_data[((16*3) + 8 - 1):16*3]};
 assign mode_1bytex2_alu_rod2_data4 = {lat_ecc_rd_data[((16*4) + 8 - 1):16*4]};
 assign mode_1bytex2_alu_rod2_data5 = {lat_ecc_rd_data[((16*5) + 8 - 1):16*5]};
 assign mode_1bytex2_alu_rod2_data6 = {lat_ecc_rd_data[((16*6) + 8 - 1):16*6]};
 assign mode_1bytex2_alu_rod2_data7 = {lat_ecc_rd_data[((16*7) + 8 - 1):16*7]};
 assign mode_1bytex2_alu_rod2_data8 = {lat_ecc_rd_data[((16*8) + 8 - 1):16*8]};
 assign mode_1bytex2_alu_rod2_data9 = {lat_ecc_rd_data[((16*9) + 8 - 1):16*9]};
 assign mode_1bytex2_alu_rod2_data10 = {lat_ecc_rd_data[((16*10) + 8 - 1):16*10]};
 assign mode_1bytex2_alu_rod2_data11 = {lat_ecc_rd_data[((16*11) + 8 - 1):16*11]};
 assign mode_1bytex2_alu_rod2_data12 = {lat_ecc_rd_data[((16*12) + 8 - 1):16*12]};
 assign mode_1bytex2_alu_rod2_data13 = {lat_ecc_rd_data[((16*13) + 8 - 1):16*13]};
 assign mode_1bytex2_alu_rod2_data14 = {lat_ecc_rd_data[((16*14) + 8 - 1):16*14]};
 assign mode_1bytex2_alu_rod2_data15 = {lat_ecc_rd_data[((16*15) + 8 - 1):16*15]};
 assign mode_1bytex2_alu_rod3_data0 = {lat_ecc_rd_data[((16*16) + 8 - 1):16*16]};
 assign mode_1bytex2_alu_rod3_data1 = {lat_ecc_rd_data[((16*17) + 8 - 1):16*17]};
 assign mode_1bytex2_alu_rod3_data2 = {lat_ecc_rd_data[((16*18) + 8 - 1):16*18]};
 assign mode_1bytex2_alu_rod3_data3 = {lat_ecc_rd_data[((16*19) + 8 - 1):16*19]};
 assign mode_1bytex2_alu_rod3_data4 = {lat_ecc_rd_data[((16*20) + 8 - 1):16*20]};
 assign mode_1bytex2_alu_rod3_data5 = {lat_ecc_rd_data[((16*21) + 8 - 1):16*21]};
 assign mode_1bytex2_alu_rod3_data6 = {lat_ecc_rd_data[((16*22) + 8 - 1):16*22]};
 assign mode_1bytex2_alu_rod3_data7 = {lat_ecc_rd_data[((16*23) + 8 - 1):16*23]};
 assign mode_1bytex2_alu_rod3_data8 = {lat_ecc_rd_data[((16*24) + 8 - 1):16*24]};
 assign mode_1bytex2_alu_rod3_data9 = {lat_ecc_rd_data[((16*25) + 8 - 1):16*25]};
 assign mode_1bytex2_alu_rod3_data10 = {lat_ecc_rd_data[((16*26) + 8 - 1):16*26]};
 assign mode_1bytex2_alu_rod3_data11 = {lat_ecc_rd_data[((16*27) + 8 - 1):16*27]};
 assign mode_1bytex2_alu_rod3_data12 = {lat_ecc_rd_data[((16*28) + 8 - 1):16*28]};
 assign mode_1bytex2_alu_rod3_data13 = {lat_ecc_rd_data[((16*29) + 8 - 1):16*29]};
 assign mode_1bytex2_alu_rod3_data14 = {lat_ecc_rd_data[((16*30) + 8 - 1):16*30]};
 assign mode_1bytex2_alu_rod3_data15 = {lat_ecc_rd_data[((16*31) + 8 - 1):16*31]};

 assign mode_1bytex2_alu_rod0_data0_ext = {{8{mode_1bytex2_alu_rod0_data0[7]}}, mode_1bytex2_alu_rod0_data0[7:0]};
 assign mode_1bytex2_alu_rod0_data1_ext = {{8{mode_1bytex2_alu_rod0_data1[7]}}, mode_1bytex2_alu_rod0_data1[7:0]};
 assign mode_1bytex2_alu_rod0_data2_ext = {{8{mode_1bytex2_alu_rod0_data2[7]}}, mode_1bytex2_alu_rod0_data2[7:0]};
 assign mode_1bytex2_alu_rod0_data3_ext = {{8{mode_1bytex2_alu_rod0_data3[7]}}, mode_1bytex2_alu_rod0_data3[7:0]};
 assign mode_1bytex2_alu_rod0_data4_ext = {{8{mode_1bytex2_alu_rod0_data4[7]}}, mode_1bytex2_alu_rod0_data4[7:0]};
 assign mode_1bytex2_alu_rod0_data5_ext = {{8{mode_1bytex2_alu_rod0_data5[7]}}, mode_1bytex2_alu_rod0_data5[7:0]};
 assign mode_1bytex2_alu_rod0_data6_ext = {{8{mode_1bytex2_alu_rod0_data6[7]}}, mode_1bytex2_alu_rod0_data6[7:0]};
 assign mode_1bytex2_alu_rod0_data7_ext = {{8{mode_1bytex2_alu_rod0_data7[7]}}, mode_1bytex2_alu_rod0_data7[7:0]};
 assign mode_1bytex2_alu_rod0_data8_ext = {{8{mode_1bytex2_alu_rod0_data8[7]}}, mode_1bytex2_alu_rod0_data8[7:0]};
 assign mode_1bytex2_alu_rod0_data9_ext = {{8{mode_1bytex2_alu_rod0_data9[7]}}, mode_1bytex2_alu_rod0_data9[7:0]};
 assign mode_1bytex2_alu_rod0_data10_ext = {{8{mode_1bytex2_alu_rod0_data10[7]}}, mode_1bytex2_alu_rod0_data10[7:0]};
 assign mode_1bytex2_alu_rod0_data11_ext = {{8{mode_1bytex2_alu_rod0_data11[7]}}, mode_1bytex2_alu_rod0_data11[7:0]};
 assign mode_1bytex2_alu_rod0_data12_ext = {{8{mode_1bytex2_alu_rod0_data12[7]}}, mode_1bytex2_alu_rod0_data12[7:0]};
 assign mode_1bytex2_alu_rod0_data13_ext = {{8{mode_1bytex2_alu_rod0_data13[7]}}, mode_1bytex2_alu_rod0_data13[7:0]};
 assign mode_1bytex2_alu_rod0_data14_ext = {{8{mode_1bytex2_alu_rod0_data14[7]}}, mode_1bytex2_alu_rod0_data14[7:0]};
 assign mode_1bytex2_alu_rod0_data15_ext = {{8{mode_1bytex2_alu_rod0_data15[7]}}, mode_1bytex2_alu_rod0_data15[7:0]};
 assign mode_1bytex2_alu_rod1_data0_ext = {{8{mode_1bytex2_alu_rod1_data0[7]}}, mode_1bytex2_alu_rod1_data0[7:0]};
 assign mode_1bytex2_alu_rod1_data1_ext = {{8{mode_1bytex2_alu_rod1_data1[7]}}, mode_1bytex2_alu_rod1_data1[7:0]};
 assign mode_1bytex2_alu_rod1_data2_ext = {{8{mode_1bytex2_alu_rod1_data2[7]}}, mode_1bytex2_alu_rod1_data2[7:0]};
 assign mode_1bytex2_alu_rod1_data3_ext = {{8{mode_1bytex2_alu_rod1_data3[7]}}, mode_1bytex2_alu_rod1_data3[7:0]};
 assign mode_1bytex2_alu_rod1_data4_ext = {{8{mode_1bytex2_alu_rod1_data4[7]}}, mode_1bytex2_alu_rod1_data4[7:0]};
 assign mode_1bytex2_alu_rod1_data5_ext = {{8{mode_1bytex2_alu_rod1_data5[7]}}, mode_1bytex2_alu_rod1_data5[7:0]};
 assign mode_1bytex2_alu_rod1_data6_ext = {{8{mode_1bytex2_alu_rod1_data6[7]}}, mode_1bytex2_alu_rod1_data6[7:0]};
 assign mode_1bytex2_alu_rod1_data7_ext = {{8{mode_1bytex2_alu_rod1_data7[7]}}, mode_1bytex2_alu_rod1_data7[7:0]};
 assign mode_1bytex2_alu_rod1_data8_ext = {{8{mode_1bytex2_alu_rod1_data8[7]}}, mode_1bytex2_alu_rod1_data8[7:0]};
 assign mode_1bytex2_alu_rod1_data9_ext = {{8{mode_1bytex2_alu_rod1_data9[7]}}, mode_1bytex2_alu_rod1_data9[7:0]};
 assign mode_1bytex2_alu_rod1_data10_ext = {{8{mode_1bytex2_alu_rod1_data10[7]}}, mode_1bytex2_alu_rod1_data10[7:0]};
 assign mode_1bytex2_alu_rod1_data11_ext = {{8{mode_1bytex2_alu_rod1_data11[7]}}, mode_1bytex2_alu_rod1_data11[7:0]};
 assign mode_1bytex2_alu_rod1_data12_ext = {{8{mode_1bytex2_alu_rod1_data12[7]}}, mode_1bytex2_alu_rod1_data12[7:0]};
 assign mode_1bytex2_alu_rod1_data13_ext = {{8{mode_1bytex2_alu_rod1_data13[7]}}, mode_1bytex2_alu_rod1_data13[7:0]};
 assign mode_1bytex2_alu_rod1_data14_ext = {{8{mode_1bytex2_alu_rod1_data14[7]}}, mode_1bytex2_alu_rod1_data14[7:0]};
 assign mode_1bytex2_alu_rod1_data15_ext = {{8{mode_1bytex2_alu_rod1_data15[7]}}, mode_1bytex2_alu_rod1_data15[7:0]};
 assign mode_1bytex2_alu_rod2_data0_ext = {{8{mode_1bytex2_alu_rod2_data0[7]}}, mode_1bytex2_alu_rod2_data0[7:0]};
 assign mode_1bytex2_alu_rod2_data1_ext = {{8{mode_1bytex2_alu_rod2_data1[7]}}, mode_1bytex2_alu_rod2_data1[7:0]};
 assign mode_1bytex2_alu_rod2_data2_ext = {{8{mode_1bytex2_alu_rod2_data2[7]}}, mode_1bytex2_alu_rod2_data2[7:0]};
 assign mode_1bytex2_alu_rod2_data3_ext = {{8{mode_1bytex2_alu_rod2_data3[7]}}, mode_1bytex2_alu_rod2_data3[7:0]};
 assign mode_1bytex2_alu_rod2_data4_ext = {{8{mode_1bytex2_alu_rod2_data4[7]}}, mode_1bytex2_alu_rod2_data4[7:0]};
 assign mode_1bytex2_alu_rod2_data5_ext = {{8{mode_1bytex2_alu_rod2_data5[7]}}, mode_1bytex2_alu_rod2_data5[7:0]};
 assign mode_1bytex2_alu_rod2_data6_ext = {{8{mode_1bytex2_alu_rod2_data6[7]}}, mode_1bytex2_alu_rod2_data6[7:0]};
 assign mode_1bytex2_alu_rod2_data7_ext = {{8{mode_1bytex2_alu_rod2_data7[7]}}, mode_1bytex2_alu_rod2_data7[7:0]};
 assign mode_1bytex2_alu_rod2_data8_ext = {{8{mode_1bytex2_alu_rod2_data8[7]}}, mode_1bytex2_alu_rod2_data8[7:0]};
 assign mode_1bytex2_alu_rod2_data9_ext = {{8{mode_1bytex2_alu_rod2_data9[7]}}, mode_1bytex2_alu_rod2_data9[7:0]};
 assign mode_1bytex2_alu_rod2_data10_ext = {{8{mode_1bytex2_alu_rod2_data10[7]}}, mode_1bytex2_alu_rod2_data10[7:0]};
 assign mode_1bytex2_alu_rod2_data11_ext = {{8{mode_1bytex2_alu_rod2_data11[7]}}, mode_1bytex2_alu_rod2_data11[7:0]};
 assign mode_1bytex2_alu_rod2_data12_ext = {{8{mode_1bytex2_alu_rod2_data12[7]}}, mode_1bytex2_alu_rod2_data12[7:0]};
 assign mode_1bytex2_alu_rod2_data13_ext = {{8{mode_1bytex2_alu_rod2_data13[7]}}, mode_1bytex2_alu_rod2_data13[7:0]};
 assign mode_1bytex2_alu_rod2_data14_ext = {{8{mode_1bytex2_alu_rod2_data14[7]}}, mode_1bytex2_alu_rod2_data14[7:0]};
 assign mode_1bytex2_alu_rod2_data15_ext = {{8{mode_1bytex2_alu_rod2_data15[7]}}, mode_1bytex2_alu_rod2_data15[7:0]};
 assign mode_1bytex2_alu_rod3_data0_ext = {{8{mode_1bytex2_alu_rod3_data0[7]}}, mode_1bytex2_alu_rod3_data0[7:0]};
 assign mode_1bytex2_alu_rod3_data1_ext = {{8{mode_1bytex2_alu_rod3_data1[7]}}, mode_1bytex2_alu_rod3_data1[7:0]};
 assign mode_1bytex2_alu_rod3_data2_ext = {{8{mode_1bytex2_alu_rod3_data2[7]}}, mode_1bytex2_alu_rod3_data2[7:0]};
 assign mode_1bytex2_alu_rod3_data3_ext = {{8{mode_1bytex2_alu_rod3_data3[7]}}, mode_1bytex2_alu_rod3_data3[7:0]};
 assign mode_1bytex2_alu_rod3_data4_ext = {{8{mode_1bytex2_alu_rod3_data4[7]}}, mode_1bytex2_alu_rod3_data4[7:0]};
 assign mode_1bytex2_alu_rod3_data5_ext = {{8{mode_1bytex2_alu_rod3_data5[7]}}, mode_1bytex2_alu_rod3_data5[7:0]};
 assign mode_1bytex2_alu_rod3_data6_ext = {{8{mode_1bytex2_alu_rod3_data6[7]}}, mode_1bytex2_alu_rod3_data6[7:0]};
 assign mode_1bytex2_alu_rod3_data7_ext = {{8{mode_1bytex2_alu_rod3_data7[7]}}, mode_1bytex2_alu_rod3_data7[7:0]};
 assign mode_1bytex2_alu_rod3_data8_ext = {{8{mode_1bytex2_alu_rod3_data8[7]}}, mode_1bytex2_alu_rod3_data8[7:0]};
 assign mode_1bytex2_alu_rod3_data9_ext = {{8{mode_1bytex2_alu_rod3_data9[7]}}, mode_1bytex2_alu_rod3_data9[7:0]};
 assign mode_1bytex2_alu_rod3_data10_ext = {{8{mode_1bytex2_alu_rod3_data10[7]}}, mode_1bytex2_alu_rod3_data10[7:0]};
 assign mode_1bytex2_alu_rod3_data11_ext = {{8{mode_1bytex2_alu_rod3_data11[7]}}, mode_1bytex2_alu_rod3_data11[7:0]};
 assign mode_1bytex2_alu_rod3_data12_ext = {{8{mode_1bytex2_alu_rod3_data12[7]}}, mode_1bytex2_alu_rod3_data12[7:0]};
 assign mode_1bytex2_alu_rod3_data13_ext = {{8{mode_1bytex2_alu_rod3_data13[7]}}, mode_1bytex2_alu_rod3_data13[7:0]};
 assign mode_1bytex2_alu_rod3_data14_ext = {{8{mode_1bytex2_alu_rod3_data14[7]}}, mode_1bytex2_alu_rod3_data14[7:0]};
 assign mode_1bytex2_alu_rod3_data15_ext = {{8{mode_1bytex2_alu_rod3_data15[7]}}, mode_1bytex2_alu_rod3_data15[7:0]};

 assign mode_1bytex2_mul_rod0_data0 = {lat_ecc_rd_data[((16*0+8) + 8 - 1):16*0+8]};
 assign mode_1bytex2_mul_rod0_data1 = {lat_ecc_rd_data[((16*1+8) + 8 - 1):16*1+8]};
 assign mode_1bytex2_mul_rod0_data2 = {lat_ecc_rd_data[((16*2+8) + 8 - 1):16*2+8]};
 assign mode_1bytex2_mul_rod0_data3 = {lat_ecc_rd_data[((16*3+8) + 8 - 1):16*3+8]};
 assign mode_1bytex2_mul_rod0_data4 = {lat_ecc_rd_data[((16*4+8) + 8 - 1):16*4+8]};
 assign mode_1bytex2_mul_rod0_data5 = {lat_ecc_rd_data[((16*5+8) + 8 - 1):16*5+8]};
 assign mode_1bytex2_mul_rod0_data6 = {lat_ecc_rd_data[((16*6+8) + 8 - 1):16*6+8]};
 assign mode_1bytex2_mul_rod0_data7 = {lat_ecc_rd_data[((16*7+8) + 8 - 1):16*7+8]};
 assign mode_1bytex2_mul_rod0_data8 = {lat_ecc_rd_data[((16*8+8) + 8 - 1):16*8+8]};
 assign mode_1bytex2_mul_rod0_data9 = {lat_ecc_rd_data[((16*9+8) + 8 - 1):16*9+8]};
 assign mode_1bytex2_mul_rod0_data10 = {lat_ecc_rd_data[((16*10+8) + 8 - 1):16*10+8]};
 assign mode_1bytex2_mul_rod0_data11 = {lat_ecc_rd_data[((16*11+8) + 8 - 1):16*11+8]};
 assign mode_1bytex2_mul_rod0_data12 = {lat_ecc_rd_data[((16*12+8) + 8 - 1):16*12+8]};
 assign mode_1bytex2_mul_rod0_data13 = {lat_ecc_rd_data[((16*13+8) + 8 - 1):16*13+8]};
 assign mode_1bytex2_mul_rod0_data14 = {lat_ecc_rd_data[((16*14+8) + 8 - 1):16*14+8]};
 assign mode_1bytex2_mul_rod0_data15 = {lat_ecc_rd_data[((16*15+8) + 8 - 1):16*15+8]};
 assign mode_1bytex2_mul_rod1_data0 = {lat_ecc_rd_data[((16*16+8) + 8 - 1):16*16+8]};
 assign mode_1bytex2_mul_rod1_data1 = {lat_ecc_rd_data[((16*17+8) + 8 - 1):16*17+8]};
 assign mode_1bytex2_mul_rod1_data2 = {lat_ecc_rd_data[((16*18+8) + 8 - 1):16*18+8]};
 assign mode_1bytex2_mul_rod1_data3 = {lat_ecc_rd_data[((16*19+8) + 8 - 1):16*19+8]};
 assign mode_1bytex2_mul_rod1_data4 = {lat_ecc_rd_data[((16*20+8) + 8 - 1):16*20+8]};
 assign mode_1bytex2_mul_rod1_data5 = {lat_ecc_rd_data[((16*21+8) + 8 - 1):16*21+8]};
 assign mode_1bytex2_mul_rod1_data6 = {lat_ecc_rd_data[((16*22+8) + 8 - 1):16*22+8]};
 assign mode_1bytex2_mul_rod1_data7 = {lat_ecc_rd_data[((16*23+8) + 8 - 1):16*23+8]};
 assign mode_1bytex2_mul_rod1_data8 = {lat_ecc_rd_data[((16*24+8) + 8 - 1):16*24+8]};
 assign mode_1bytex2_mul_rod1_data9 = {lat_ecc_rd_data[((16*25+8) + 8 - 1):16*25+8]};
 assign mode_1bytex2_mul_rod1_data10 = {lat_ecc_rd_data[((16*26+8) + 8 - 1):16*26+8]};
 assign mode_1bytex2_mul_rod1_data11 = {lat_ecc_rd_data[((16*27+8) + 8 - 1):16*27+8]};
 assign mode_1bytex2_mul_rod1_data12 = {lat_ecc_rd_data[((16*28+8) + 8 - 1):16*28+8]};
 assign mode_1bytex2_mul_rod1_data13 = {lat_ecc_rd_data[((16*29+8) + 8 - 1):16*29+8]};
 assign mode_1bytex2_mul_rod1_data14 = {lat_ecc_rd_data[((16*30+8) + 8 - 1):16*30+8]};
 assign mode_1bytex2_mul_rod1_data15 = {lat_ecc_rd_data[((16*31+8) + 8 - 1):16*31+8]};
 assign mode_1bytex2_mul_rod2_data0 = {lat_ecc_rd_data[((16*0+8) + 8 - 1):16*0+8]};
 assign mode_1bytex2_mul_rod2_data1 = {lat_ecc_rd_data[((16*1+8) + 8 - 1):16*1+8]};
 assign mode_1bytex2_mul_rod2_data2 = {lat_ecc_rd_data[((16*2+8) + 8 - 1):16*2+8]};
 assign mode_1bytex2_mul_rod2_data3 = {lat_ecc_rd_data[((16*3+8) + 8 - 1):16*3+8]};
 assign mode_1bytex2_mul_rod2_data4 = {lat_ecc_rd_data[((16*4+8) + 8 - 1):16*4+8]};
 assign mode_1bytex2_mul_rod2_data5 = {lat_ecc_rd_data[((16*5+8) + 8 - 1):16*5+8]};
 assign mode_1bytex2_mul_rod2_data6 = {lat_ecc_rd_data[((16*6+8) + 8 - 1):16*6+8]};
 assign mode_1bytex2_mul_rod2_data7 = {lat_ecc_rd_data[((16*7+8) + 8 - 1):16*7+8]};
 assign mode_1bytex2_mul_rod2_data8 = {lat_ecc_rd_data[((16*8+8) + 8 - 1):16*8+8]};
 assign mode_1bytex2_mul_rod2_data9 = {lat_ecc_rd_data[((16*9+8) + 8 - 1):16*9+8]};
 assign mode_1bytex2_mul_rod2_data10 = {lat_ecc_rd_data[((16*10+8) + 8 - 1):16*10+8]};
 assign mode_1bytex2_mul_rod2_data11 = {lat_ecc_rd_data[((16*11+8) + 8 - 1):16*11+8]};
 assign mode_1bytex2_mul_rod2_data12 = {lat_ecc_rd_data[((16*12+8) + 8 - 1):16*12+8]};
 assign mode_1bytex2_mul_rod2_data13 = {lat_ecc_rd_data[((16*13+8) + 8 - 1):16*13+8]};
 assign mode_1bytex2_mul_rod2_data14 = {lat_ecc_rd_data[((16*14+8) + 8 - 1):16*14+8]};
 assign mode_1bytex2_mul_rod2_data15 = {lat_ecc_rd_data[((16*15+8) + 8 - 1):16*15+8]};
 assign mode_1bytex2_mul_rod3_data0 = {lat_ecc_rd_data[((16*16+8) + 8 - 1):16*16+8]};
 assign mode_1bytex2_mul_rod3_data1 = {lat_ecc_rd_data[((16*17+8) + 8 - 1):16*17+8]};
 assign mode_1bytex2_mul_rod3_data2 = {lat_ecc_rd_data[((16*18+8) + 8 - 1):16*18+8]};
 assign mode_1bytex2_mul_rod3_data3 = {lat_ecc_rd_data[((16*19+8) + 8 - 1):16*19+8]};
 assign mode_1bytex2_mul_rod3_data4 = {lat_ecc_rd_data[((16*20+8) + 8 - 1):16*20+8]};
 assign mode_1bytex2_mul_rod3_data5 = {lat_ecc_rd_data[((16*21+8) + 8 - 1):16*21+8]};
 assign mode_1bytex2_mul_rod3_data6 = {lat_ecc_rd_data[((16*22+8) + 8 - 1):16*22+8]};
 assign mode_1bytex2_mul_rod3_data7 = {lat_ecc_rd_data[((16*23+8) + 8 - 1):16*23+8]};
 assign mode_1bytex2_mul_rod3_data8 = {lat_ecc_rd_data[((16*24+8) + 8 - 1):16*24+8]};
 assign mode_1bytex2_mul_rod3_data9 = {lat_ecc_rd_data[((16*25+8) + 8 - 1):16*25+8]};
 assign mode_1bytex2_mul_rod3_data10 = {lat_ecc_rd_data[((16*26+8) + 8 - 1):16*26+8]};
 assign mode_1bytex2_mul_rod3_data11 = {lat_ecc_rd_data[((16*27+8) + 8 - 1):16*27+8]};
 assign mode_1bytex2_mul_rod3_data12 = {lat_ecc_rd_data[((16*28+8) + 8 - 1):16*28+8]};
 assign mode_1bytex2_mul_rod3_data13 = {lat_ecc_rd_data[((16*29+8) + 8 - 1):16*29+8]};
 assign mode_1bytex2_mul_rod3_data14 = {lat_ecc_rd_data[((16*30+8) + 8 - 1):16*30+8]};
 assign mode_1bytex2_mul_rod3_data15 = {lat_ecc_rd_data[((16*31+8) + 8 - 1):16*31+8]};

 assign mode_1bytex2_mul_rod0_data0_ext = {{8{mode_1bytex2_mul_rod0_data0[7]}}, mode_1bytex2_mul_rod0_data0[7:0]};
 assign mode_1bytex2_mul_rod0_data1_ext = {{8{mode_1bytex2_mul_rod0_data1[7]}}, mode_1bytex2_mul_rod0_data1[7:0]};
 assign mode_1bytex2_mul_rod0_data2_ext = {{8{mode_1bytex2_mul_rod0_data2[7]}}, mode_1bytex2_mul_rod0_data2[7:0]};
 assign mode_1bytex2_mul_rod0_data3_ext = {{8{mode_1bytex2_mul_rod0_data3[7]}}, mode_1bytex2_mul_rod0_data3[7:0]};
 assign mode_1bytex2_mul_rod0_data4_ext = {{8{mode_1bytex2_mul_rod0_data4[7]}}, mode_1bytex2_mul_rod0_data4[7:0]};
 assign mode_1bytex2_mul_rod0_data5_ext = {{8{mode_1bytex2_mul_rod0_data5[7]}}, mode_1bytex2_mul_rod0_data5[7:0]};
 assign mode_1bytex2_mul_rod0_data6_ext = {{8{mode_1bytex2_mul_rod0_data6[7]}}, mode_1bytex2_mul_rod0_data6[7:0]};
 assign mode_1bytex2_mul_rod0_data7_ext = {{8{mode_1bytex2_mul_rod0_data7[7]}}, mode_1bytex2_mul_rod0_data7[7:0]};
 assign mode_1bytex2_mul_rod0_data8_ext = {{8{mode_1bytex2_mul_rod0_data8[7]}}, mode_1bytex2_mul_rod0_data8[7:0]};
 assign mode_1bytex2_mul_rod0_data9_ext = {{8{mode_1bytex2_mul_rod0_data9[7]}}, mode_1bytex2_mul_rod0_data9[7:0]};
 assign mode_1bytex2_mul_rod0_data10_ext = {{8{mode_1bytex2_mul_rod0_data10[7]}}, mode_1bytex2_mul_rod0_data10[7:0]};
 assign mode_1bytex2_mul_rod0_data11_ext = {{8{mode_1bytex2_mul_rod0_data11[7]}}, mode_1bytex2_mul_rod0_data11[7:0]};
 assign mode_1bytex2_mul_rod0_data12_ext = {{8{mode_1bytex2_mul_rod0_data12[7]}}, mode_1bytex2_mul_rod0_data12[7:0]};
 assign mode_1bytex2_mul_rod0_data13_ext = {{8{mode_1bytex2_mul_rod0_data13[7]}}, mode_1bytex2_mul_rod0_data13[7:0]};
 assign mode_1bytex2_mul_rod0_data14_ext = {{8{mode_1bytex2_mul_rod0_data14[7]}}, mode_1bytex2_mul_rod0_data14[7:0]};
 assign mode_1bytex2_mul_rod0_data15_ext = {{8{mode_1bytex2_mul_rod0_data15[7]}}, mode_1bytex2_mul_rod0_data15[7:0]};
 assign mode_1bytex2_mul_rod1_data0_ext = {{8{mode_1bytex2_mul_rod1_data0[7]}}, mode_1bytex2_mul_rod1_data0[7:0]};
 assign mode_1bytex2_mul_rod1_data1_ext = {{8{mode_1bytex2_mul_rod1_data1[7]}}, mode_1bytex2_mul_rod1_data1[7:0]};
 assign mode_1bytex2_mul_rod1_data2_ext = {{8{mode_1bytex2_mul_rod1_data2[7]}}, mode_1bytex2_mul_rod1_data2[7:0]};
 assign mode_1bytex2_mul_rod1_data3_ext = {{8{mode_1bytex2_mul_rod1_data3[7]}}, mode_1bytex2_mul_rod1_data3[7:0]};
 assign mode_1bytex2_mul_rod1_data4_ext = {{8{mode_1bytex2_mul_rod1_data4[7]}}, mode_1bytex2_mul_rod1_data4[7:0]};
 assign mode_1bytex2_mul_rod1_data5_ext = {{8{mode_1bytex2_mul_rod1_data5[7]}}, mode_1bytex2_mul_rod1_data5[7:0]};
 assign mode_1bytex2_mul_rod1_data6_ext = {{8{mode_1bytex2_mul_rod1_data6[7]}}, mode_1bytex2_mul_rod1_data6[7:0]};
 assign mode_1bytex2_mul_rod1_data7_ext = {{8{mode_1bytex2_mul_rod1_data7[7]}}, mode_1bytex2_mul_rod1_data7[7:0]};
 assign mode_1bytex2_mul_rod1_data8_ext = {{8{mode_1bytex2_mul_rod1_data8[7]}}, mode_1bytex2_mul_rod1_data8[7:0]};
 assign mode_1bytex2_mul_rod1_data9_ext = {{8{mode_1bytex2_mul_rod1_data9[7]}}, mode_1bytex2_mul_rod1_data9[7:0]};
 assign mode_1bytex2_mul_rod1_data10_ext = {{8{mode_1bytex2_mul_rod1_data10[7]}}, mode_1bytex2_mul_rod1_data10[7:0]};
 assign mode_1bytex2_mul_rod1_data11_ext = {{8{mode_1bytex2_mul_rod1_data11[7]}}, mode_1bytex2_mul_rod1_data11[7:0]};
 assign mode_1bytex2_mul_rod1_data12_ext = {{8{mode_1bytex2_mul_rod1_data12[7]}}, mode_1bytex2_mul_rod1_data12[7:0]};
 assign mode_1bytex2_mul_rod1_data13_ext = {{8{mode_1bytex2_mul_rod1_data13[7]}}, mode_1bytex2_mul_rod1_data13[7:0]};
 assign mode_1bytex2_mul_rod1_data14_ext = {{8{mode_1bytex2_mul_rod1_data14[7]}}, mode_1bytex2_mul_rod1_data14[7:0]};
 assign mode_1bytex2_mul_rod1_data15_ext = {{8{mode_1bytex2_mul_rod1_data15[7]}}, mode_1bytex2_mul_rod1_data15[7:0]};
 assign mode_1bytex2_mul_rod2_data0_ext = {{8{mode_1bytex2_mul_rod2_data0[7]}}, mode_1bytex2_mul_rod2_data0[7:0]};
 assign mode_1bytex2_mul_rod2_data1_ext = {{8{mode_1bytex2_mul_rod2_data1[7]}}, mode_1bytex2_mul_rod2_data1[7:0]};
 assign mode_1bytex2_mul_rod2_data2_ext = {{8{mode_1bytex2_mul_rod2_data2[7]}}, mode_1bytex2_mul_rod2_data2[7:0]};
 assign mode_1bytex2_mul_rod2_data3_ext = {{8{mode_1bytex2_mul_rod2_data3[7]}}, mode_1bytex2_mul_rod2_data3[7:0]};
 assign mode_1bytex2_mul_rod2_data4_ext = {{8{mode_1bytex2_mul_rod2_data4[7]}}, mode_1bytex2_mul_rod2_data4[7:0]};
 assign mode_1bytex2_mul_rod2_data5_ext = {{8{mode_1bytex2_mul_rod2_data5[7]}}, mode_1bytex2_mul_rod2_data5[7:0]};
 assign mode_1bytex2_mul_rod2_data6_ext = {{8{mode_1bytex2_mul_rod2_data6[7]}}, mode_1bytex2_mul_rod2_data6[7:0]};
 assign mode_1bytex2_mul_rod2_data7_ext = {{8{mode_1bytex2_mul_rod2_data7[7]}}, mode_1bytex2_mul_rod2_data7[7:0]};
 assign mode_1bytex2_mul_rod2_data8_ext = {{8{mode_1bytex2_mul_rod2_data8[7]}}, mode_1bytex2_mul_rod2_data8[7:0]};
 assign mode_1bytex2_mul_rod2_data9_ext = {{8{mode_1bytex2_mul_rod2_data9[7]}}, mode_1bytex2_mul_rod2_data9[7:0]};
 assign mode_1bytex2_mul_rod2_data10_ext = {{8{mode_1bytex2_mul_rod2_data10[7]}}, mode_1bytex2_mul_rod2_data10[7:0]};
 assign mode_1bytex2_mul_rod2_data11_ext = {{8{mode_1bytex2_mul_rod2_data11[7]}}, mode_1bytex2_mul_rod2_data11[7:0]};
 assign mode_1bytex2_mul_rod2_data12_ext = {{8{mode_1bytex2_mul_rod2_data12[7]}}, mode_1bytex2_mul_rod2_data12[7:0]};
 assign mode_1bytex2_mul_rod2_data13_ext = {{8{mode_1bytex2_mul_rod2_data13[7]}}, mode_1bytex2_mul_rod2_data13[7:0]};
 assign mode_1bytex2_mul_rod2_data14_ext = {{8{mode_1bytex2_mul_rod2_data14[7]}}, mode_1bytex2_mul_rod2_data14[7:0]};
 assign mode_1bytex2_mul_rod2_data15_ext = {{8{mode_1bytex2_mul_rod2_data15[7]}}, mode_1bytex2_mul_rod2_data15[7:0]};
 assign mode_1bytex2_mul_rod3_data0_ext = {{8{mode_1bytex2_mul_rod3_data0[7]}}, mode_1bytex2_mul_rod3_data0[7:0]};
 assign mode_1bytex2_mul_rod3_data1_ext = {{8{mode_1bytex2_mul_rod3_data1[7]}}, mode_1bytex2_mul_rod3_data1[7:0]};
 assign mode_1bytex2_mul_rod3_data2_ext = {{8{mode_1bytex2_mul_rod3_data2[7]}}, mode_1bytex2_mul_rod3_data2[7:0]};
 assign mode_1bytex2_mul_rod3_data3_ext = {{8{mode_1bytex2_mul_rod3_data3[7]}}, mode_1bytex2_mul_rod3_data3[7:0]};
 assign mode_1bytex2_mul_rod3_data4_ext = {{8{mode_1bytex2_mul_rod3_data4[7]}}, mode_1bytex2_mul_rod3_data4[7:0]};
 assign mode_1bytex2_mul_rod3_data5_ext = {{8{mode_1bytex2_mul_rod3_data5[7]}}, mode_1bytex2_mul_rod3_data5[7:0]};
 assign mode_1bytex2_mul_rod3_data6_ext = {{8{mode_1bytex2_mul_rod3_data6[7]}}, mode_1bytex2_mul_rod3_data6[7:0]};
 assign mode_1bytex2_mul_rod3_data7_ext = {{8{mode_1bytex2_mul_rod3_data7[7]}}, mode_1bytex2_mul_rod3_data7[7:0]};
 assign mode_1bytex2_mul_rod3_data8_ext = {{8{mode_1bytex2_mul_rod3_data8[7]}}, mode_1bytex2_mul_rod3_data8[7:0]};
 assign mode_1bytex2_mul_rod3_data9_ext = {{8{mode_1bytex2_mul_rod3_data9[7]}}, mode_1bytex2_mul_rod3_data9[7:0]};
 assign mode_1bytex2_mul_rod3_data10_ext = {{8{mode_1bytex2_mul_rod3_data10[7]}}, mode_1bytex2_mul_rod3_data10[7:0]};
 assign mode_1bytex2_mul_rod3_data11_ext = {{8{mode_1bytex2_mul_rod3_data11[7]}}, mode_1bytex2_mul_rod3_data11[7:0]};
 assign mode_1bytex2_mul_rod3_data12_ext = {{8{mode_1bytex2_mul_rod3_data12[7]}}, mode_1bytex2_mul_rod3_data12[7:0]};
 assign mode_1bytex2_mul_rod3_data13_ext = {{8{mode_1bytex2_mul_rod3_data13[7]}}, mode_1bytex2_mul_rod3_data13[7:0]};
 assign mode_1bytex2_mul_rod3_data14_ext = {{8{mode_1bytex2_mul_rod3_data14[7]}}, mode_1bytex2_mul_rod3_data14[7:0]};
 assign mode_1bytex2_mul_rod3_data15_ext = {{8{mode_1bytex2_mul_rod3_data15[7]}}, mode_1bytex2_mul_rod3_data15[7:0]};

assign mode_1bytex2_alu_rod0_pd = {mode_1bytex2_alu_rod0_data15_ext,mode_1bytex2_alu_rod0_data14_ext,mode_1bytex2_alu_rod0_data13_ext,mode_1bytex2_alu_rod0_data12_ext,mode_1bytex2_alu_rod0_data11_ext,mode_1bytex2_alu_rod0_data10_ext,mode_1bytex2_alu_rod0_data9_ext,mode_1bytex2_alu_rod0_data8_ext,mode_1bytex2_alu_rod0_data7_ext,mode_1bytex2_alu_rod0_data6_ext,mode_1bytex2_alu_rod0_data5_ext,mode_1bytex2_alu_rod0_data4_ext,mode_1bytex2_alu_rod0_data3_ext,mode_1bytex2_alu_rod0_data2_ext,mode_1bytex2_alu_rod0_data1_ext,mode_1bytex2_alu_rod0_data0_ext};
assign mode_1bytex2_alu_rod1_pd = {mode_1bytex2_alu_rod1_data15_ext,mode_1bytex2_alu_rod1_data14_ext,mode_1bytex2_alu_rod1_data13_ext,mode_1bytex2_alu_rod1_data12_ext,mode_1bytex2_alu_rod1_data11_ext,mode_1bytex2_alu_rod1_data10_ext,mode_1bytex2_alu_rod1_data9_ext,mode_1bytex2_alu_rod1_data8_ext,mode_1bytex2_alu_rod1_data7_ext,mode_1bytex2_alu_rod1_data6_ext,mode_1bytex2_alu_rod1_data5_ext,mode_1bytex2_alu_rod1_data4_ext,mode_1bytex2_alu_rod1_data3_ext,mode_1bytex2_alu_rod1_data2_ext,mode_1bytex2_alu_rod1_data1_ext,mode_1bytex2_alu_rod1_data0_ext};
assign mode_1bytex2_alu_rod2_pd = {mode_1bytex2_alu_rod2_data15_ext,mode_1bytex2_alu_rod2_data14_ext,mode_1bytex2_alu_rod2_data13_ext,mode_1bytex2_alu_rod2_data12_ext,mode_1bytex2_alu_rod2_data11_ext,mode_1bytex2_alu_rod2_data10_ext,mode_1bytex2_alu_rod2_data9_ext,mode_1bytex2_alu_rod2_data8_ext,mode_1bytex2_alu_rod2_data7_ext,mode_1bytex2_alu_rod2_data6_ext,mode_1bytex2_alu_rod2_data5_ext,mode_1bytex2_alu_rod2_data4_ext,mode_1bytex2_alu_rod2_data3_ext,mode_1bytex2_alu_rod2_data2_ext,mode_1bytex2_alu_rod2_data1_ext,mode_1bytex2_alu_rod2_data0_ext};
assign mode_1bytex2_alu_rod3_pd = {mode_1bytex2_alu_rod3_data15_ext,mode_1bytex2_alu_rod3_data14_ext,mode_1bytex2_alu_rod3_data13_ext,mode_1bytex2_alu_rod3_data12_ext,mode_1bytex2_alu_rod3_data11_ext,mode_1bytex2_alu_rod3_data10_ext,mode_1bytex2_alu_rod3_data9_ext,mode_1bytex2_alu_rod3_data8_ext,mode_1bytex2_alu_rod3_data7_ext,mode_1bytex2_alu_rod3_data6_ext,mode_1bytex2_alu_rod3_data5_ext,mode_1bytex2_alu_rod3_data4_ext,mode_1bytex2_alu_rod3_data3_ext,mode_1bytex2_alu_rod3_data2_ext,mode_1bytex2_alu_rod3_data1_ext,mode_1bytex2_alu_rod3_data0_ext};
assign mode_1bytex2_mul_rod0_pd = {mode_1bytex2_mul_rod0_data15_ext,mode_1bytex2_mul_rod0_data14_ext,mode_1bytex2_mul_rod0_data13_ext,mode_1bytex2_mul_rod0_data12_ext,mode_1bytex2_mul_rod0_data11_ext,mode_1bytex2_mul_rod0_data10_ext,mode_1bytex2_mul_rod0_data9_ext,mode_1bytex2_mul_rod0_data8_ext,mode_1bytex2_mul_rod0_data7_ext,mode_1bytex2_mul_rod0_data6_ext,mode_1bytex2_mul_rod0_data5_ext,mode_1bytex2_mul_rod0_data4_ext,mode_1bytex2_mul_rod0_data3_ext,mode_1bytex2_mul_rod0_data2_ext,mode_1bytex2_mul_rod0_data1_ext,mode_1bytex2_mul_rod0_data0_ext};
assign mode_1bytex2_mul_rod1_pd = {mode_1bytex2_mul_rod1_data15_ext,mode_1bytex2_mul_rod1_data14_ext,mode_1bytex2_mul_rod1_data13_ext,mode_1bytex2_mul_rod1_data12_ext,mode_1bytex2_mul_rod1_data11_ext,mode_1bytex2_mul_rod1_data10_ext,mode_1bytex2_mul_rod1_data9_ext,mode_1bytex2_mul_rod1_data8_ext,mode_1bytex2_mul_rod1_data7_ext,mode_1bytex2_mul_rod1_data6_ext,mode_1bytex2_mul_rod1_data5_ext,mode_1bytex2_mul_rod1_data4_ext,mode_1bytex2_mul_rod1_data3_ext,mode_1bytex2_mul_rod1_data2_ext,mode_1bytex2_mul_rod1_data1_ext,mode_1bytex2_mul_rod1_data0_ext};
assign mode_1bytex2_mul_rod2_pd = {mode_1bytex2_mul_rod2_data15_ext,mode_1bytex2_mul_rod2_data14_ext,mode_1bytex2_mul_rod2_data13_ext,mode_1bytex2_mul_rod2_data12_ext,mode_1bytex2_mul_rod2_data11_ext,mode_1bytex2_mul_rod2_data10_ext,mode_1bytex2_mul_rod2_data9_ext,mode_1bytex2_mul_rod2_data8_ext,mode_1bytex2_mul_rod2_data7_ext,mode_1bytex2_mul_rod2_data6_ext,mode_1bytex2_mul_rod2_data5_ext,mode_1bytex2_mul_rod2_data4_ext,mode_1bytex2_mul_rod2_data3_ext,mode_1bytex2_mul_rod2_data2_ext,mode_1bytex2_mul_rod2_data1_ext,mode_1bytex2_mul_rod2_data0_ext};
assign mode_1bytex2_mul_rod3_pd = {mode_1bytex2_mul_rod3_data15_ext,mode_1bytex2_mul_rod3_data14_ext,mode_1bytex2_mul_rod3_data13_ext,mode_1bytex2_mul_rod3_data12_ext,mode_1bytex2_mul_rod3_data11_ext,mode_1bytex2_mul_rod3_data10_ext,mode_1bytex2_mul_rod3_data9_ext,mode_1bytex2_mul_rod3_data8_ext,mode_1bytex2_mul_rod3_data7_ext,mode_1bytex2_mul_rod3_data6_ext,mode_1bytex2_mul_rod3_data5_ext,mode_1bytex2_mul_rod3_data4_ext,mode_1bytex2_mul_rod3_data3_ext,mode_1bytex2_mul_rod3_data2_ext,mode_1bytex2_mul_rod3_data1_ext,mode_1bytex2_mul_rod3_data0_ext};

always @(
  cfg_mode_multi_batch
  or cfg_do_8
  or mode_1bytex2_cnt
  or lat_ecc_rd_mask
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            mode_1bytex2_mask[1:0] = mode_1bytex2_cnt==0 ? lat_ecc_rd_mask : 2'd0;
            mode_1bytex2_mask[3:2] = mode_1bytex2_cnt==1 ? lat_ecc_rd_mask : 2'd0;
        end else begin
            mode_1bytex2_mask[1:0] = lat_ecc_rd_mask;
            mode_1bytex2_mask[3:2] = 2'b00;
        end
    end else begin
        mode_1bytex2_mask[1:0] = lat_ecc_rd_mask;
        mode_1bytex2_mask[3:2] = 2'd0;
    end
end
assign mode_1bytex2_alu_mask = mode_1bytex2_mask;
assign mode_1bytex2_mul_mask = mode_1bytex2_mask;

// 2Bx2: (ALU,MUL)x16 -> (ALUx16,MULx16)
 assign mode_2bytex2_alu_rod0_data0 = {lat_ecc_rd_data[((32*0) + 16 - 1):32*0]};
 assign mode_2bytex2_alu_rod0_data1 = {lat_ecc_rd_data[((32*1) + 16 - 1):32*1]};
 assign mode_2bytex2_alu_rod0_data2 = {lat_ecc_rd_data[((32*2) + 16 - 1):32*2]};
 assign mode_2bytex2_alu_rod0_data3 = {lat_ecc_rd_data[((32*3) + 16 - 1):32*3]};
 assign mode_2bytex2_alu_rod0_data4 = {lat_ecc_rd_data[((32*4) + 16 - 1):32*4]};
 assign mode_2bytex2_alu_rod0_data5 = {lat_ecc_rd_data[((32*5) + 16 - 1):32*5]};
 assign mode_2bytex2_alu_rod0_data6 = {lat_ecc_rd_data[((32*6) + 16 - 1):32*6]};
 assign mode_2bytex2_alu_rod0_data7 = {lat_ecc_rd_data[((32*7) + 16 - 1):32*7]};
 assign mode_2bytex2_alu_rod0_data8 = {lat_ecc_rd_data[((32*8) + 16 - 1):32*8]};
 assign mode_2bytex2_alu_rod0_data9 = {lat_ecc_rd_data[((32*9) + 16 - 1):32*9]};
 assign mode_2bytex2_alu_rod0_data10 = {lat_ecc_rd_data[((32*10) + 16 - 1):32*10]};
 assign mode_2bytex2_alu_rod0_data11 = {lat_ecc_rd_data[((32*11) + 16 - 1):32*11]};
 assign mode_2bytex2_alu_rod0_data12 = {lat_ecc_rd_data[((32*12) + 16 - 1):32*12]};
 assign mode_2bytex2_alu_rod0_data13 = {lat_ecc_rd_data[((32*13) + 16 - 1):32*13]};
 assign mode_2bytex2_alu_rod0_data14 = {lat_ecc_rd_data[((32*14) + 16 - 1):32*14]};
 assign mode_2bytex2_alu_rod0_data15 = {lat_ecc_rd_data[((32*15) + 16 - 1):32*15]};
 assign mode_2bytex2_alu_rod1_data0 = {lat_ecc_rd_data[((32*0) + 16 - 1):32*0]};
 assign mode_2bytex2_alu_rod1_data1 = {lat_ecc_rd_data[((32*1) + 16 - 1):32*1]};
 assign mode_2bytex2_alu_rod1_data2 = {lat_ecc_rd_data[((32*2) + 16 - 1):32*2]};
 assign mode_2bytex2_alu_rod1_data3 = {lat_ecc_rd_data[((32*3) + 16 - 1):32*3]};
 assign mode_2bytex2_alu_rod1_data4 = {lat_ecc_rd_data[((32*4) + 16 - 1):32*4]};
 assign mode_2bytex2_alu_rod1_data5 = {lat_ecc_rd_data[((32*5) + 16 - 1):32*5]};
 assign mode_2bytex2_alu_rod1_data6 = {lat_ecc_rd_data[((32*6) + 16 - 1):32*6]};
 assign mode_2bytex2_alu_rod1_data7 = {lat_ecc_rd_data[((32*7) + 16 - 1):32*7]};
 assign mode_2bytex2_alu_rod1_data8 = {lat_ecc_rd_data[((32*8) + 16 - 1):32*8]};
 assign mode_2bytex2_alu_rod1_data9 = {lat_ecc_rd_data[((32*9) + 16 - 1):32*9]};
 assign mode_2bytex2_alu_rod1_data10 = {lat_ecc_rd_data[((32*10) + 16 - 1):32*10]};
 assign mode_2bytex2_alu_rod1_data11 = {lat_ecc_rd_data[((32*11) + 16 - 1):32*11]};
 assign mode_2bytex2_alu_rod1_data12 = {lat_ecc_rd_data[((32*12) + 16 - 1):32*12]};
 assign mode_2bytex2_alu_rod1_data13 = {lat_ecc_rd_data[((32*13) + 16 - 1):32*13]};
 assign mode_2bytex2_alu_rod1_data14 = {lat_ecc_rd_data[((32*14) + 16 - 1):32*14]};
 assign mode_2bytex2_alu_rod1_data15 = {lat_ecc_rd_data[((32*15) + 16 - 1):32*15]};
 assign mode_2bytex2_alu_rod2_data0 = {lat_ecc_rd_data[((32*0) + 16 - 1):32*0]};
 assign mode_2bytex2_alu_rod2_data1 = {lat_ecc_rd_data[((32*1) + 16 - 1):32*1]};
 assign mode_2bytex2_alu_rod2_data2 = {lat_ecc_rd_data[((32*2) + 16 - 1):32*2]};
 assign mode_2bytex2_alu_rod2_data3 = {lat_ecc_rd_data[((32*3) + 16 - 1):32*3]};
 assign mode_2bytex2_alu_rod2_data4 = {lat_ecc_rd_data[((32*4) + 16 - 1):32*4]};
 assign mode_2bytex2_alu_rod2_data5 = {lat_ecc_rd_data[((32*5) + 16 - 1):32*5]};
 assign mode_2bytex2_alu_rod2_data6 = {lat_ecc_rd_data[((32*6) + 16 - 1):32*6]};
 assign mode_2bytex2_alu_rod2_data7 = {lat_ecc_rd_data[((32*7) + 16 - 1):32*7]};
 assign mode_2bytex2_alu_rod2_data8 = {lat_ecc_rd_data[((32*8) + 16 - 1):32*8]};
 assign mode_2bytex2_alu_rod2_data9 = {lat_ecc_rd_data[((32*9) + 16 - 1):32*9]};
 assign mode_2bytex2_alu_rod2_data10 = {lat_ecc_rd_data[((32*10) + 16 - 1):32*10]};
 assign mode_2bytex2_alu_rod2_data11 = {lat_ecc_rd_data[((32*11) + 16 - 1):32*11]};
 assign mode_2bytex2_alu_rod2_data12 = {lat_ecc_rd_data[((32*12) + 16 - 1):32*12]};
 assign mode_2bytex2_alu_rod2_data13 = {lat_ecc_rd_data[((32*13) + 16 - 1):32*13]};
 assign mode_2bytex2_alu_rod2_data14 = {lat_ecc_rd_data[((32*14) + 16 - 1):32*14]};
 assign mode_2bytex2_alu_rod2_data15 = {lat_ecc_rd_data[((32*15) + 16 - 1):32*15]};
 assign mode_2bytex2_alu_rod3_data0 = {lat_ecc_rd_data[((32*0) + 16 - 1):32*0]};
 assign mode_2bytex2_alu_rod3_data1 = {lat_ecc_rd_data[((32*1) + 16 - 1):32*1]};
 assign mode_2bytex2_alu_rod3_data2 = {lat_ecc_rd_data[((32*2) + 16 - 1):32*2]};
 assign mode_2bytex2_alu_rod3_data3 = {lat_ecc_rd_data[((32*3) + 16 - 1):32*3]};
 assign mode_2bytex2_alu_rod3_data4 = {lat_ecc_rd_data[((32*4) + 16 - 1):32*4]};
 assign mode_2bytex2_alu_rod3_data5 = {lat_ecc_rd_data[((32*5) + 16 - 1):32*5]};
 assign mode_2bytex2_alu_rod3_data6 = {lat_ecc_rd_data[((32*6) + 16 - 1):32*6]};
 assign mode_2bytex2_alu_rod3_data7 = {lat_ecc_rd_data[((32*7) + 16 - 1):32*7]};
 assign mode_2bytex2_alu_rod3_data8 = {lat_ecc_rd_data[((32*8) + 16 - 1):32*8]};
 assign mode_2bytex2_alu_rod3_data9 = {lat_ecc_rd_data[((32*9) + 16 - 1):32*9]};
 assign mode_2bytex2_alu_rod3_data10 = {lat_ecc_rd_data[((32*10) + 16 - 1):32*10]};
 assign mode_2bytex2_alu_rod3_data11 = {lat_ecc_rd_data[((32*11) + 16 - 1):32*11]};
 assign mode_2bytex2_alu_rod3_data12 = {lat_ecc_rd_data[((32*12) + 16 - 1):32*12]};
 assign mode_2bytex2_alu_rod3_data13 = {lat_ecc_rd_data[((32*13) + 16 - 1):32*13]};
 assign mode_2bytex2_alu_rod3_data14 = {lat_ecc_rd_data[((32*14) + 16 - 1):32*14]};
 assign mode_2bytex2_alu_rod3_data15 = {lat_ecc_rd_data[((32*15) + 16 - 1):32*15]};
 assign mode_2bytex2_mul_rod0_data0 = {lat_ecc_rd_data[((32*0+16) + 16 - 1):32*0+16]};
 assign mode_2bytex2_mul_rod0_data1 = {lat_ecc_rd_data[((32*1+16) + 16 - 1):32*1+16]};
 assign mode_2bytex2_mul_rod0_data2 = {lat_ecc_rd_data[((32*2+16) + 16 - 1):32*2+16]};
 assign mode_2bytex2_mul_rod0_data3 = {lat_ecc_rd_data[((32*3+16) + 16 - 1):32*3+16]};
 assign mode_2bytex2_mul_rod0_data4 = {lat_ecc_rd_data[((32*4+16) + 16 - 1):32*4+16]};
 assign mode_2bytex2_mul_rod0_data5 = {lat_ecc_rd_data[((32*5+16) + 16 - 1):32*5+16]};
 assign mode_2bytex2_mul_rod0_data6 = {lat_ecc_rd_data[((32*6+16) + 16 - 1):32*6+16]};
 assign mode_2bytex2_mul_rod0_data7 = {lat_ecc_rd_data[((32*7+16) + 16 - 1):32*7+16]};
 assign mode_2bytex2_mul_rod0_data8 = {lat_ecc_rd_data[((32*8+16) + 16 - 1):32*8+16]};
 assign mode_2bytex2_mul_rod0_data9 = {lat_ecc_rd_data[((32*9+16) + 16 - 1):32*9+16]};
 assign mode_2bytex2_mul_rod0_data10 = {lat_ecc_rd_data[((32*10+16) + 16 - 1):32*10+16]};
 assign mode_2bytex2_mul_rod0_data11 = {lat_ecc_rd_data[((32*11+16) + 16 - 1):32*11+16]};
 assign mode_2bytex2_mul_rod0_data12 = {lat_ecc_rd_data[((32*12+16) + 16 - 1):32*12+16]};
 assign mode_2bytex2_mul_rod0_data13 = {lat_ecc_rd_data[((32*13+16) + 16 - 1):32*13+16]};
 assign mode_2bytex2_mul_rod0_data14 = {lat_ecc_rd_data[((32*14+16) + 16 - 1):32*14+16]};
 assign mode_2bytex2_mul_rod0_data15 = {lat_ecc_rd_data[((32*15+16) + 16 - 1):32*15+16]};
 assign mode_2bytex2_mul_rod1_data0 = {lat_ecc_rd_data[((32*0+16) + 16 - 1):32*0+16]};
 assign mode_2bytex2_mul_rod1_data1 = {lat_ecc_rd_data[((32*1+16) + 16 - 1):32*1+16]};
 assign mode_2bytex2_mul_rod1_data2 = {lat_ecc_rd_data[((32*2+16) + 16 - 1):32*2+16]};
 assign mode_2bytex2_mul_rod1_data3 = {lat_ecc_rd_data[((32*3+16) + 16 - 1):32*3+16]};
 assign mode_2bytex2_mul_rod1_data4 = {lat_ecc_rd_data[((32*4+16) + 16 - 1):32*4+16]};
 assign mode_2bytex2_mul_rod1_data5 = {lat_ecc_rd_data[((32*5+16) + 16 - 1):32*5+16]};
 assign mode_2bytex2_mul_rod1_data6 = {lat_ecc_rd_data[((32*6+16) + 16 - 1):32*6+16]};
 assign mode_2bytex2_mul_rod1_data7 = {lat_ecc_rd_data[((32*7+16) + 16 - 1):32*7+16]};
 assign mode_2bytex2_mul_rod1_data8 = {lat_ecc_rd_data[((32*8+16) + 16 - 1):32*8+16]};
 assign mode_2bytex2_mul_rod1_data9 = {lat_ecc_rd_data[((32*9+16) + 16 - 1):32*9+16]};
 assign mode_2bytex2_mul_rod1_data10 = {lat_ecc_rd_data[((32*10+16) + 16 - 1):32*10+16]};
 assign mode_2bytex2_mul_rod1_data11 = {lat_ecc_rd_data[((32*11+16) + 16 - 1):32*11+16]};
 assign mode_2bytex2_mul_rod1_data12 = {lat_ecc_rd_data[((32*12+16) + 16 - 1):32*12+16]};
 assign mode_2bytex2_mul_rod1_data13 = {lat_ecc_rd_data[((32*13+16) + 16 - 1):32*13+16]};
 assign mode_2bytex2_mul_rod1_data14 = {lat_ecc_rd_data[((32*14+16) + 16 - 1):32*14+16]};
 assign mode_2bytex2_mul_rod1_data15 = {lat_ecc_rd_data[((32*15+16) + 16 - 1):32*15+16]};
 assign mode_2bytex2_mul_rod2_data0 = {lat_ecc_rd_data[((32*0+16) + 16 - 1):32*0+16]};
 assign mode_2bytex2_mul_rod2_data1 = {lat_ecc_rd_data[((32*1+16) + 16 - 1):32*1+16]};
 assign mode_2bytex2_mul_rod2_data2 = {lat_ecc_rd_data[((32*2+16) + 16 - 1):32*2+16]};
 assign mode_2bytex2_mul_rod2_data3 = {lat_ecc_rd_data[((32*3+16) + 16 - 1):32*3+16]};
 assign mode_2bytex2_mul_rod2_data4 = {lat_ecc_rd_data[((32*4+16) + 16 - 1):32*4+16]};
 assign mode_2bytex2_mul_rod2_data5 = {lat_ecc_rd_data[((32*5+16) + 16 - 1):32*5+16]};
 assign mode_2bytex2_mul_rod2_data6 = {lat_ecc_rd_data[((32*6+16) + 16 - 1):32*6+16]};
 assign mode_2bytex2_mul_rod2_data7 = {lat_ecc_rd_data[((32*7+16) + 16 - 1):32*7+16]};
 assign mode_2bytex2_mul_rod2_data8 = {lat_ecc_rd_data[((32*8+16) + 16 - 1):32*8+16]};
 assign mode_2bytex2_mul_rod2_data9 = {lat_ecc_rd_data[((32*9+16) + 16 - 1):32*9+16]};
 assign mode_2bytex2_mul_rod2_data10 = {lat_ecc_rd_data[((32*10+16) + 16 - 1):32*10+16]};
 assign mode_2bytex2_mul_rod2_data11 = {lat_ecc_rd_data[((32*11+16) + 16 - 1):32*11+16]};
 assign mode_2bytex2_mul_rod2_data12 = {lat_ecc_rd_data[((32*12+16) + 16 - 1):32*12+16]};
 assign mode_2bytex2_mul_rod2_data13 = {lat_ecc_rd_data[((32*13+16) + 16 - 1):32*13+16]};
 assign mode_2bytex2_mul_rod2_data14 = {lat_ecc_rd_data[((32*14+16) + 16 - 1):32*14+16]};
 assign mode_2bytex2_mul_rod2_data15 = {lat_ecc_rd_data[((32*15+16) + 16 - 1):32*15+16]};
 assign mode_2bytex2_mul_rod3_data0 = {lat_ecc_rd_data[((32*0+16) + 16 - 1):32*0+16]};
 assign mode_2bytex2_mul_rod3_data1 = {lat_ecc_rd_data[((32*1+16) + 16 - 1):32*1+16]};
 assign mode_2bytex2_mul_rod3_data2 = {lat_ecc_rd_data[((32*2+16) + 16 - 1):32*2+16]};
 assign mode_2bytex2_mul_rod3_data3 = {lat_ecc_rd_data[((32*3+16) + 16 - 1):32*3+16]};
 assign mode_2bytex2_mul_rod3_data4 = {lat_ecc_rd_data[((32*4+16) + 16 - 1):32*4+16]};
 assign mode_2bytex2_mul_rod3_data5 = {lat_ecc_rd_data[((32*5+16) + 16 - 1):32*5+16]};
 assign mode_2bytex2_mul_rod3_data6 = {lat_ecc_rd_data[((32*6+16) + 16 - 1):32*6+16]};
 assign mode_2bytex2_mul_rod3_data7 = {lat_ecc_rd_data[((32*7+16) + 16 - 1):32*7+16]};
 assign mode_2bytex2_mul_rod3_data8 = {lat_ecc_rd_data[((32*8+16) + 16 - 1):32*8+16]};
 assign mode_2bytex2_mul_rod3_data9 = {lat_ecc_rd_data[((32*9+16) + 16 - 1):32*9+16]};
 assign mode_2bytex2_mul_rod3_data10 = {lat_ecc_rd_data[((32*10+16) + 16 - 1):32*10+16]};
 assign mode_2bytex2_mul_rod3_data11 = {lat_ecc_rd_data[((32*11+16) + 16 - 1):32*11+16]};
 assign mode_2bytex2_mul_rod3_data12 = {lat_ecc_rd_data[((32*12+16) + 16 - 1):32*12+16]};
 assign mode_2bytex2_mul_rod3_data13 = {lat_ecc_rd_data[((32*13+16) + 16 - 1):32*13+16]};
 assign mode_2bytex2_mul_rod3_data14 = {lat_ecc_rd_data[((32*14+16) + 16 - 1):32*14+16]};
 assign mode_2bytex2_mul_rod3_data15 = {lat_ecc_rd_data[((32*15+16) + 16 - 1):32*15+16]};
assign mode_2bytex2_alu_rod0_pd = {mode_2bytex2_alu_rod0_data15,mode_2bytex2_alu_rod0_data14,mode_2bytex2_alu_rod0_data13,mode_2bytex2_alu_rod0_data12,mode_2bytex2_alu_rod0_data11,mode_2bytex2_alu_rod0_data10,mode_2bytex2_alu_rod0_data9,mode_2bytex2_alu_rod0_data8,mode_2bytex2_alu_rod0_data7,mode_2bytex2_alu_rod0_data6,mode_2bytex2_alu_rod0_data5,mode_2bytex2_alu_rod0_data4,mode_2bytex2_alu_rod0_data3,mode_2bytex2_alu_rod0_data2,mode_2bytex2_alu_rod0_data1,mode_2bytex2_alu_rod0_data0};
assign mode_2bytex2_alu_rod1_pd = {mode_2bytex2_alu_rod1_data15,mode_2bytex2_alu_rod1_data14,mode_2bytex2_alu_rod1_data13,mode_2bytex2_alu_rod1_data12,mode_2bytex2_alu_rod1_data11,mode_2bytex2_alu_rod1_data10,mode_2bytex2_alu_rod1_data9,mode_2bytex2_alu_rod1_data8,mode_2bytex2_alu_rod1_data7,mode_2bytex2_alu_rod1_data6,mode_2bytex2_alu_rod1_data5,mode_2bytex2_alu_rod1_data4,mode_2bytex2_alu_rod1_data3,mode_2bytex2_alu_rod1_data2,mode_2bytex2_alu_rod1_data1,mode_2bytex2_alu_rod1_data0};
assign mode_2bytex2_alu_rod2_pd = {mode_2bytex2_alu_rod2_data15,mode_2bytex2_alu_rod2_data14,mode_2bytex2_alu_rod2_data13,mode_2bytex2_alu_rod2_data12,mode_2bytex2_alu_rod2_data11,mode_2bytex2_alu_rod2_data10,mode_2bytex2_alu_rod2_data9,mode_2bytex2_alu_rod2_data8,mode_2bytex2_alu_rod2_data7,mode_2bytex2_alu_rod2_data6,mode_2bytex2_alu_rod2_data5,mode_2bytex2_alu_rod2_data4,mode_2bytex2_alu_rod2_data3,mode_2bytex2_alu_rod2_data2,mode_2bytex2_alu_rod2_data1,mode_2bytex2_alu_rod2_data0};
assign mode_2bytex2_alu_rod3_pd = {mode_2bytex2_alu_rod3_data15,mode_2bytex2_alu_rod3_data14,mode_2bytex2_alu_rod3_data13,mode_2bytex2_alu_rod3_data12,mode_2bytex2_alu_rod3_data11,mode_2bytex2_alu_rod3_data10,mode_2bytex2_alu_rod3_data9,mode_2bytex2_alu_rod3_data8,mode_2bytex2_alu_rod3_data7,mode_2bytex2_alu_rod3_data6,mode_2bytex2_alu_rod3_data5,mode_2bytex2_alu_rod3_data4,mode_2bytex2_alu_rod3_data3,mode_2bytex2_alu_rod3_data2,mode_2bytex2_alu_rod3_data1,mode_2bytex2_alu_rod3_data0};
assign mode_2bytex2_mul_rod0_pd = {mode_2bytex2_mul_rod0_data15,mode_2bytex2_mul_rod0_data14,mode_2bytex2_mul_rod0_data13,mode_2bytex2_mul_rod0_data12,mode_2bytex2_mul_rod0_data11,mode_2bytex2_mul_rod0_data10,mode_2bytex2_mul_rod0_data9,mode_2bytex2_mul_rod0_data8,mode_2bytex2_mul_rod0_data7,mode_2bytex2_mul_rod0_data6,mode_2bytex2_mul_rod0_data5,mode_2bytex2_mul_rod0_data4,mode_2bytex2_mul_rod0_data3,mode_2bytex2_mul_rod0_data2,mode_2bytex2_mul_rod0_data1,mode_2bytex2_mul_rod0_data0};
assign mode_2bytex2_mul_rod1_pd = {mode_2bytex2_mul_rod1_data15,mode_2bytex2_mul_rod1_data14,mode_2bytex2_mul_rod1_data13,mode_2bytex2_mul_rod1_data12,mode_2bytex2_mul_rod1_data11,mode_2bytex2_mul_rod1_data10,mode_2bytex2_mul_rod1_data9,mode_2bytex2_mul_rod1_data8,mode_2bytex2_mul_rod1_data7,mode_2bytex2_mul_rod1_data6,mode_2bytex2_mul_rod1_data5,mode_2bytex2_mul_rod1_data4,mode_2bytex2_mul_rod1_data3,mode_2bytex2_mul_rod1_data2,mode_2bytex2_mul_rod1_data1,mode_2bytex2_mul_rod1_data0};
assign mode_2bytex2_mul_rod2_pd = {mode_2bytex2_mul_rod2_data15,mode_2bytex2_mul_rod2_data14,mode_2bytex2_mul_rod2_data13,mode_2bytex2_mul_rod2_data12,mode_2bytex2_mul_rod2_data11,mode_2bytex2_mul_rod2_data10,mode_2bytex2_mul_rod2_data9,mode_2bytex2_mul_rod2_data8,mode_2bytex2_mul_rod2_data7,mode_2bytex2_mul_rod2_data6,mode_2bytex2_mul_rod2_data5,mode_2bytex2_mul_rod2_data4,mode_2bytex2_mul_rod2_data3,mode_2bytex2_mul_rod2_data2,mode_2bytex2_mul_rod2_data1,mode_2bytex2_mul_rod2_data0};
assign mode_2bytex2_mul_rod3_pd = {mode_2bytex2_mul_rod3_data15,mode_2bytex2_mul_rod3_data14,mode_2bytex2_mul_rod3_data13,mode_2bytex2_mul_rod3_data12,mode_2bytex2_mul_rod3_data11,mode_2bytex2_mul_rod3_data10,mode_2bytex2_mul_rod3_data9,mode_2bytex2_mul_rod3_data8,mode_2bytex2_mul_rod3_data7,mode_2bytex2_mul_rod3_data6,mode_2bytex2_mul_rod3_data5,mode_2bytex2_mul_rod3_data4,mode_2bytex2_mul_rod3_data3,mode_2bytex2_mul_rod3_data2,mode_2bytex2_mul_rod3_data1,mode_2bytex2_mul_rod3_data0};

always @(
  cfg_mode_multi_batch
  or cfg_do_8
  or mode_2bytex2_cnt
  or mode_2bytex2_sel
  or cfg_dp_8
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            mode_2bytex2_mask[0] = mode_2bytex2_cnt==0;
            mode_2bytex2_mask[1] = mode_2bytex2_cnt==1;
            mode_2bytex2_mask[2] = mode_2bytex2_cnt==2;
            mode_2bytex2_mask[3] = mode_2bytex2_cnt==3;
        end else begin
            mode_2bytex2_mask[0] = mode_2bytex2_sel==0;
            mode_2bytex2_mask[1] = mode_2bytex2_sel==1;
            mode_2bytex2_mask[2] = 1'b0;
            mode_2bytex2_mask[3] = 1'b0;
        end
    end else begin
        if (cfg_dp_8) begin
            mode_2bytex2_mask[0] = mode_2bytex2_sel==0;
            mode_2bytex2_mask[1] = mode_2bytex2_sel==1;
            mode_2bytex2_mask[2] = 1'b0;
            mode_2bytex2_mask[3] = 1'b0;
        end else begin
            mode_2bytex2_mask[0] = 1'b1;
            mode_2bytex2_mask[1] = 1'b0;
            mode_2bytex2_mask[2] = 1'b0;
            mode_2bytex2_mask[3] = 1'b0;
        end
    end
end
assign mode_2bytex2_alu_mask = mode_2bytex2_mask;
assign mode_2bytex2_mul_mask = mode_2bytex2_mask;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"2bytex2 mode, MASK can NOT be half")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, cfg_mode_2bytex2 & lat_ecc_rd_pvld & ((&lat_ecc_rd_mask)==0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//assign lat_ecc_rd_accept = lat_ecc_rd_pvld & lat_ecc_rd_prdy;

//==========================================
//==========================================
//&Always;
//    batch_fifo_size = 2'd0;
//    if (cfg_mode_multi_batch) begin
//        if (cfg_do_8) begin
//            batch_fifo_size = 2'd1;
//        end else begin
//            batch_fifo_size = 2'd0;
//        end
//    end
//&End;
//&Vector batch_fifo_size batch_fifo_cnt;
//&Always posedge;
//    if (cfg_mode_multi_batch) begin
//        if (is_any_rod_accept) begin
//            if (is_last_batch_fifo) begin
//                batch_fifo_cnt <0= 0;
//            end else begin
//                batch_fifo_cnt <0= batch_fifo_cnt + 1;
//            end
//        end
//    end
//&End;
//assign is_last_batch_fifo = batch_fifo_cnt == batch_fifo_size;

// mode_1bytex1_cnt is used to sel lower 32B or higher 32B from 64B latency FIFO
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mode_1bytex1_cnt <= 1'b0;
  end else begin
    if (cfg_mode_1bytex1) begin
        if (!need_extra_rod) begin
            if (is_any_rod_accept) begin
                if (is_last_beat & is_data_half) begin
                    mode_1bytex1_cnt <= 1'b0;
                end else begin
                    mode_1bytex1_cnt <= ~mode_1bytex1_cnt;
                end
            end
        end
    end
  end
end

// mode_2bytex1_cnt is used to 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mode_2bytex1_cnt <= 1'b0;
  end else begin
    if (cfg_mode_2bytex1) begin
        if (need_extra_rod) begin
            if (is_any_rod_accept) begin
                if (is_last_beat) begin
                    mode_2bytex1_cnt <= 1'b0;
                end else begin
                    mode_2bytex1_cnt <= ~mode_2bytex1_cnt;
                end
            end
        end
    end
  end
end

// mode_1bytex2_cnt is used to 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mode_1bytex2_cnt <= 1'b0;
  end else begin
    if (cfg_mode_1bytex2) begin
        if (need_extra_rod) begin
            if (is_any_rod_accept) begin
                if (is_last_beat) begin
                    mode_1bytex2_cnt <= 1'b0;
                end else begin
                    mode_1bytex2_cnt <= ~mode_1bytex2_cnt;
                end
            end
        end
    end
  end
end

assign is_any_rod_accept = (mul_rod_vld & mul_rod_rdy) | (alu_rod_vld & alu_rod_rdy);

// mode_2bytex2_sel is used to sel lower 32B or higher 32B from 64B latency FIFO
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mode_2bytex2_cnt <= {2{1'b0}};
  end else begin
    if (cfg_mode_2bytex2) begin
        if (is_any_rod_accept) begin
            if (is_last_beat) begin
                mode_2bytex2_cnt <= 2'd0;
            end else begin
                mode_2bytex2_cnt <= mode_2bytex2_cnt + 1;
            end
        end
    end
  end
end
assign mode_2bytex2_sel = mode_2bytex2_cnt[0];

//===================

//===================
// MUL
//===================
always @(
  cfg_mode_1bytex1
  or mode_1bytex1_mul_rod0_pd
  or mode_1bytex1_mul_rod1_pd
  or mode_1bytex1_mul_rod2_pd
  or mode_1bytex1_mul_rod3_pd
  or cfg_mode_2bytex1
  or mode_2bytex1_mul_rod0_pd
  or mode_2bytex1_mul_rod1_pd
  or mode_2bytex1_mul_rod2_pd
  or mode_2bytex1_mul_rod3_pd
  or cfg_mode_1bytex2
  or mode_1bytex2_mul_rod0_pd
  or mode_1bytex2_mul_rod1_pd
  or mode_1bytex2_mul_rod2_pd
  or mode_1bytex2_mul_rod3_pd
  or cfg_mode_2bytex2
  or mode_2bytex2_mul_rod0_pd
  or mode_2bytex2_mul_rod1_pd
  or mode_2bytex2_mul_rod2_pd
  or mode_2bytex2_mul_rod3_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: begin
        mul_rod0_pd = mode_1bytex1_mul_rod0_pd;
        mul_rod1_pd = mode_1bytex1_mul_rod1_pd;
        mul_rod2_pd = mode_1bytex1_mul_rod2_pd;
        mul_rod3_pd = mode_1bytex1_mul_rod3_pd;
    end
    cfg_mode_2bytex1: begin
        mul_rod0_pd = mode_2bytex1_mul_rod0_pd;
        mul_rod1_pd = mode_2bytex1_mul_rod1_pd;
        mul_rod2_pd = mode_2bytex1_mul_rod2_pd;
        mul_rod3_pd = mode_2bytex1_mul_rod3_pd;
    end
    cfg_mode_1bytex2: begin
        mul_rod0_pd = mode_1bytex2_mul_rod0_pd;
        mul_rod1_pd = mode_1bytex2_mul_rod1_pd;
        mul_rod2_pd = mode_1bytex2_mul_rod2_pd;
        mul_rod3_pd = mode_1bytex2_mul_rod3_pd;
    end
    cfg_mode_2bytex2: begin
        mul_rod0_pd = mode_2bytex2_mul_rod0_pd;
        mul_rod1_pd = mode_2bytex2_mul_rod1_pd;
        mul_rod2_pd = mode_2bytex2_mul_rod2_pd;
        mul_rod3_pd = mode_2bytex2_mul_rod3_pd;
    end
    //VCS coverage off
    default : begin 
                mul_rod0_pd[255:0] = {256{`x_or_0}};
                mul_rod1_pd[255:0] = {256{`x_or_0}};
                mul_rod2_pd[255:0] = {256{`x_or_0}};
                mul_rod3_pd[255:0] = {256{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end
always @(
  cfg_mode_1bytex1
  or mode_1bytex1_mul_mask
  or cfg_mode_2bytex1
  or mode_2bytex1_mul_mask
  or cfg_mode_1bytex2
  or mode_1bytex2_mul_mask
  or cfg_mode_2bytex2
  or mode_2bytex2_mul_mask
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: mul_rod_mask = mode_1bytex1_mul_mask;
    cfg_mode_2bytex1: mul_rod_mask = mode_2bytex1_mul_mask;
    cfg_mode_1bytex2: mul_rod_mask = mode_1bytex2_mul_mask;
    cfg_mode_2bytex2: mul_rod_mask = mode_2bytex2_mul_mask;
    //VCS coverage off
    default : begin 
                mul_rod_mask[3:0] = {4{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//=====================================
always @(
  cfg_mode_1bytex1
  or need_extra_rod
  or lat_ecc_rd_mask
  or cfg_dp_8
  or cfg_mode_2bytex1
  or is_last_beat
  or cfg_mode_1bytex2
  or cfg_mode_2bytex2
  or cfg_mode_multi_batch
  or cfg_do_8
  or is_2bytex2_int8_2nd_last_beat
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: begin
        if (need_extra_rod) begin
            mul_roc_size = lat_ecc_rd_mask[1] ? 2'd3 : 2'd1;
        end else begin
            if (cfg_dp_8) begin
                mul_roc_size = 2'd0;
            end else begin
                mul_roc_size = 2'd1;
            end
        end
    end
    cfg_mode_2bytex1: begin
        if (need_extra_rod) begin
            mul_roc_size = is_last_beat ? 2'd1 : 2'd3;
        end else begin
            if (cfg_dp_8) begin
                mul_roc_size = 2'd0;
            end else begin
                mul_roc_size = lat_ecc_rd_mask[1] ? 2'd1 : 2'd0;
            end
        end
    end
    cfg_mode_1bytex2: begin
        if (need_extra_rod) begin
            mul_roc_size = is_last_beat ? 2'd1 : 2'd3;
        end else begin
            if (cfg_dp_8) begin
                mul_roc_size = 2'd0;
            end else begin
                mul_roc_size = lat_ecc_rd_mask[1] ? 2'd1 : 2'd0;
            end
        end
    end
    cfg_mode_2bytex2: begin
        if (cfg_mode_multi_batch) begin
            if (cfg_do_8) begin
                mul_roc_size = is_2bytex2_int8_2nd_last_beat  ? 2'd1 : 2'd3;
            end else begin
                mul_roc_size = is_last_beat ? 2'd0 : 2'd1;
            end
        end else begin
            //if (cfg_do_8) begin
            //    mul_roc_size = is_last_beat ? 2'd0 : 2'd1;
            //end
            mul_roc_size = 2'd0;
        end
    end
    //VCS coverage off
    default : begin 
                mul_roc_size[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//assign mul_roc_half = is_data_half;
assign mul_roc_half = 1'b0;

//===================
// ALU
//===================
always @(
  cfg_mode_1bytex1
  or mode_1bytex1_alu_rod0_pd
  or mode_1bytex1_alu_rod1_pd
  or mode_1bytex1_alu_rod2_pd
  or mode_1bytex1_alu_rod3_pd
  or cfg_mode_2bytex1
  or mode_2bytex1_alu_rod0_pd
  or mode_2bytex1_alu_rod1_pd
  or mode_2bytex1_alu_rod2_pd
  or mode_2bytex1_alu_rod3_pd
  or cfg_mode_1bytex2
  or mode_1bytex2_alu_rod0_pd
  or mode_1bytex2_alu_rod1_pd
  or mode_1bytex2_alu_rod2_pd
  or mode_1bytex2_alu_rod3_pd
  or cfg_mode_2bytex2
  or mode_2bytex2_alu_rod0_pd
  or mode_2bytex2_alu_rod1_pd
  or mode_2bytex2_alu_rod2_pd
  or mode_2bytex2_alu_rod3_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: begin
        alu_rod0_pd = mode_1bytex1_alu_rod0_pd;
        alu_rod1_pd = mode_1bytex1_alu_rod1_pd;
        alu_rod2_pd = mode_1bytex1_alu_rod2_pd;
        alu_rod3_pd = mode_1bytex1_alu_rod3_pd;
    end
    cfg_mode_2bytex1: begin
        alu_rod0_pd = mode_2bytex1_alu_rod0_pd;
        alu_rod1_pd = mode_2bytex1_alu_rod1_pd;
        alu_rod2_pd = mode_2bytex1_alu_rod2_pd;
        alu_rod3_pd = mode_2bytex1_alu_rod3_pd;
    end
    cfg_mode_1bytex2: begin
        alu_rod0_pd = mode_1bytex2_alu_rod0_pd;
        alu_rod1_pd = mode_1bytex2_alu_rod1_pd;
        alu_rod2_pd = mode_1bytex2_alu_rod2_pd;
        alu_rod3_pd = mode_1bytex2_alu_rod3_pd;
    end
    cfg_mode_2bytex2: begin
        alu_rod0_pd = mode_2bytex2_alu_rod0_pd;
        alu_rod1_pd = mode_2bytex2_alu_rod1_pd;
        alu_rod2_pd = mode_2bytex2_alu_rod2_pd;
        alu_rod3_pd = mode_2bytex2_alu_rod3_pd;
    end
    //VCS coverage off
    default : begin 
                alu_rod0_pd[255:0] = {256{`x_or_0}};
                alu_rod1_pd[255:0] = {256{`x_or_0}};
                alu_rod2_pd[255:0] = {256{`x_or_0}};
                alu_rod3_pd[255:0] = {256{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end
always @(
  cfg_mode_1bytex1
  or mode_1bytex1_alu_mask
  or cfg_mode_2bytex1
  or mode_2bytex1_alu_mask
  or cfg_mode_1bytex2
  or mode_1bytex2_alu_mask
  or cfg_mode_2bytex2
  or mode_2bytex2_alu_mask
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: alu_rod_mask = mode_1bytex1_alu_mask;
    cfg_mode_2bytex1: alu_rod_mask = mode_2bytex1_alu_mask;
    cfg_mode_1bytex2: alu_rod_mask = mode_1bytex2_alu_mask;
    cfg_mode_2bytex2: alu_rod_mask = mode_2bytex2_alu_mask;
    //VCS coverage off
    default : begin 
                alu_rod_mask[3:0] = {4{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//=====================================
always @(
  cfg_mode_1bytex1
  or need_extra_rod
  or lat_ecc_rd_mask
  or cfg_dp_8
  or cfg_mode_2bytex1
  or is_last_beat
  or cfg_mode_1bytex2
  or cfg_mode_2bytex2
  or cfg_mode_multi_batch
  or cfg_do_8
  or is_2bytex2_int8_2nd_last_beat
  ) begin
//spyglass disable_block W171 W226
    case (1'b1)
    cfg_mode_1bytex1: begin
        if (need_extra_rod) begin
            alu_roc_size = lat_ecc_rd_mask[1] ? 2'd3 : 2'd1;
        end else begin
            if (cfg_dp_8) begin
                alu_roc_size = 2'd0;
            end else begin
                alu_roc_size = 2'd1;
            end
        end
    end
    cfg_mode_2bytex1: begin
        if (need_extra_rod) begin
            alu_roc_size = is_last_beat ? 2'd1 : 2'd3;
        end else begin
            if (cfg_dp_8) begin
                alu_roc_size = 2'd0;
            end else begin
                alu_roc_size = lat_ecc_rd_mask[1] ? 2'd1 : 2'd0;
            end
        end
    end
    cfg_mode_1bytex2: begin
        if (need_extra_rod) begin
            alu_roc_size = is_last_beat ? 2'd1 : 2'd3;
        end else begin
            if (cfg_dp_8) begin
                alu_roc_size = 2'd0;
            end else begin
                alu_roc_size = lat_ecc_rd_mask[1] ? 2'd1 : 2'd0;
            end
        end
    end
    cfg_mode_2bytex2: begin
        if (cfg_mode_multi_batch) begin
            if (cfg_do_8) begin
                alu_roc_size = is_2bytex2_int8_2nd_last_beat  ? 2'd1 : 2'd3;
            end else begin
                alu_roc_size = is_last_beat ? 2'd0 : 2'd1;
            end
        end else begin
            alu_roc_size = 2'd0;
        end
    end
    //VCS coverage off
    default : begin 
                alu_roc_size[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

// half means only half of the buffer is used than full usage, normally happen in the end of a line
//assign alu_roc_half = is_data_half;
assign alu_roc_half = 1'b0;

assign is_cube_last = ig2eg_cube_end & is_last_beat;

NV_NVDLA_SDP_BRDMA_EG_ro u_alu (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.sdp_brdma2dp_valid         (sdp_brdma2dp_alu_valid)         //|> o
  ,.sdp_brdma2dp_ready         (sdp_brdma2dp_alu_ready)         //|< i
  ,.sdp_brdma2dp_pd            (sdp_brdma2dp_alu_pd[256:0])     //|> o
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  ,.rod0_wr_pd                 (alu_rod0_pd[255:0])             //|< r
  ,.rod1_wr_pd                 (alu_rod1_pd[255:0])             //|< r
  ,.rod2_wr_pd                 (alu_rod2_pd[255:0])             //|< r
  ,.rod3_wr_pd                 (alu_rod3_pd[255:0])             //|< r
  ,.rod_wr_mask                (alu_rod_mask[3:0])              //|< r
  ,.rod_wr_vld                 (alu_rod_vld)                    //|< w
  ,.rod_wr_rdy                 (alu_rod_rdy)                    //|> w
  ,.roc_wr_pd                  (alu_roc_pd[3:0])                //|< w
  ,.roc_wr_vld                 (alu_roc_vld)                    //|< w
  ,.roc_wr_rdy                 (alu_roc_rdy)                    //|> w
  ,.cfg_do_8                   (cfg_do_8)                       //|< w
  ,.cfg_dp_8                   (cfg_dp_8)                       //|< w
  ,.cfg_mode_multi_batch       (cfg_mode_multi_batch)           //|< w
  ,.cfg_mode_per_element       (cfg_mode_per_element)           //|< w
  ,.reg2dp_batch_number        (reg2dp_batch_number[4:0])       //|< i
  ,.reg2dp_channel             (reg2dp_channel[12:0])           //|< i
  ,.reg2dp_height              (reg2dp_height[12:0])            //|< i
  ,.reg2dp_width               (reg2dp_width[12:0])             //|< i
  ,.layer_end                  (alu_layer_end)                  //|> w
  );

assign  alu_roc_pd = {is_cube_last,alu_roc_half,alu_roc_size};

NV_NVDLA_SDP_BRDMA_EG_ro u_mul (
   .nvdla_core_clk             (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn            (nvdla_core_rstn)                //|< i
  ,.sdp_brdma2dp_valid         (sdp_brdma2dp_mul_valid)         //|> o
  ,.sdp_brdma2dp_ready         (sdp_brdma2dp_mul_ready)         //|< i
  ,.sdp_brdma2dp_pd            (sdp_brdma2dp_mul_pd[256:0])     //|> o
  ,.pwrbus_ram_pd              (pwrbus_ram_pd[31:0])            //|< i
  ,.rod0_wr_pd                 (mul_rod0_pd[255:0])             //|< r
  ,.rod1_wr_pd                 (mul_rod1_pd[255:0])             //|< r
  ,.rod2_wr_pd                 (mul_rod2_pd[255:0])             //|< r
  ,.rod3_wr_pd                 (mul_rod3_pd[255:0])             //|< r
  ,.rod_wr_mask                (mul_rod_mask[3:0])              //|< r
  ,.rod_wr_vld                 (mul_rod_vld)                    //|< w
  ,.rod_wr_rdy                 (mul_rod_rdy)                    //|> w
  ,.roc_wr_pd                  (mul_roc_pd[3:0])                //|< w
  ,.roc_wr_vld                 (mul_roc_vld)                    //|< w
  ,.roc_wr_rdy                 (mul_roc_rdy)                    //|> w
  ,.cfg_do_8                   (cfg_do_8)                       //|< w
  ,.cfg_dp_8                   (cfg_dp_8)                       //|< w
  ,.cfg_mode_multi_batch       (cfg_mode_multi_batch)           //|< w
  ,.cfg_mode_per_element       (cfg_mode_per_element)           //|< w
  ,.reg2dp_batch_number        (reg2dp_batch_number[4:0])       //|< i
  ,.reg2dp_channel             (reg2dp_channel[12:0])           //|< i
  ,.reg2dp_height              (reg2dp_height[12:0])            //|< i
  ,.reg2dp_width               (reg2dp_width[12:0])             //|< i
  ,.layer_end                  (mul_layer_end)                  //|> w
  );

assign  mul_roc_pd = {is_cube_last,mul_roc_half,mul_roc_size};

// MULTI_BATCH 
// ROD/ROC WRITE SIDE

assign mon_both_roc_rdy = alu_roc_rdy & mul_roc_rdy;
assign both_rod_rdy = alu_rod_rdy & mul_rod_rdy;

always @(
  cfg_mode_multi_batch
  or cfg_do_8
  or cfg_mode_1bytex1
  or cfg_mode_2bytex1
  or mode_2bytex1_cnt
  or cfg_mode_1bytex2
  or mode_1bytex2_cnt
  or cfg_mode_2bytex2
  or mode_2bytex2_cnt
  or mode_2bytex2_sel
  or cfg_dp_8
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            if (cfg_mode_1bytex1) begin
                alu_roc_en = 1'b1;
            end else if (cfg_mode_2bytex1) begin
                alu_roc_en = mode_2bytex1_cnt==0;
            end else if (cfg_mode_1bytex2) begin
                alu_roc_en = mode_1bytex2_cnt==0;
            end else if (cfg_mode_2bytex2) begin
                alu_roc_en = mode_2bytex2_cnt==0;
            end else begin
                alu_roc_en = 1'b0;
            end
        end else begin
            if (cfg_mode_1bytex1) begin
                alu_roc_en = 1'b1;
            end else if (cfg_mode_2bytex1) begin
                alu_roc_en = 1'b1;
            end else if (cfg_mode_1bytex2) begin
                alu_roc_en = 1'b1;
            end else if (cfg_mode_2bytex2) begin
                alu_roc_en = mode_2bytex2_sel==0;
            end else begin
                alu_roc_en = 1'b0;
            end
        end
    end else begin
        if (cfg_dp_8 & cfg_mode_2bytex2) begin
            alu_roc_en = mode_2bytex2_sel==0;
        end else begin
            alu_roc_en = 1'b1;
        end
    end
end
assign alu_roc_vld = cfg_alu_en & lat_ecc_rd_pvld & both_rod_rdy & alu_roc_en;
assign alu_rod_vld = cfg_alu_en & lat_ecc_rd_pvld & mul_rod_rdy;

always @(
  cfg_mode_multi_batch
  or cfg_do_8
  or cfg_mode_1bytex1
  or cfg_mode_2bytex1
  or mode_2bytex1_cnt
  or cfg_mode_1bytex2
  or mode_1bytex2_cnt
  or cfg_mode_2bytex2
  or mode_2bytex2_cnt
  or mode_2bytex2_sel
  or cfg_dp_8
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            if (cfg_mode_1bytex1) begin
                mul_roc_en = 1'b1;
            end else if (cfg_mode_2bytex1) begin
                mul_roc_en = mode_2bytex1_cnt==0;
            end else if (cfg_mode_1bytex2) begin
                mul_roc_en = mode_1bytex2_cnt==0;
            end else if (cfg_mode_2bytex2) begin
                mul_roc_en = mode_2bytex2_cnt==0;
            end else begin
                mul_roc_en = 1'b0;
            end
        end else begin
            if (cfg_mode_1bytex1) begin
                mul_roc_en = 1'b1;
            end else if (cfg_mode_2bytex1) begin
                mul_roc_en = 1'b1;
            end else if (cfg_mode_1bytex2) begin
                mul_roc_en = 1'b1;
            end else if (cfg_mode_2bytex2) begin
                mul_roc_en = mode_2bytex2_sel==0;
            end else begin
                mul_roc_en = 1'b0;
            end
        end
    end else begin
        if (cfg_dp_8 & cfg_mode_2bytex2) begin
            mul_roc_en = mode_2bytex2_sel==0;
        end else begin
            mul_roc_en = 1'b1;
        end
    end
end

assign mul_roc_vld = cfg_mul_en & lat_ecc_rd_pvld & both_rod_rdy & mul_roc_en;
assign mul_rod_vld = cfg_mul_en & lat_ecc_rd_pvld & alu_rod_rdy;

//==============
// Context Queue: read
//==============
assign cq2eg_prdy  = is_last_beat & lat_ecc_rd_pvld & lat_ecc_rd_prdy;
assign mon_cq2eg_pvld = cq2eg_pvld;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
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
  nv_assert_never #(0,0,"info in CQ there be there when return data come")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (!mon_cq2eg_pvld) & lat_ecc_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// PKT_UNPACK_WIRE( sdp_brdma_ig2eg ,  ig2eg_ ,  cq2eg_pd )
assign        ig2eg_size[14:0] =     cq2eg_pd[14:0];
assign         ig2eg_cube_end  =     cq2eg_pd[15];

assign beat_size = ig2eg_size[14:1]; // ig2eg_size is in unit of 32B, beat_size is in unit of 64B
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {14{1'b0}};
  end else begin
    if (lat_ecc_rd_pvld & lat_ecc_rd_prdy) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count == beat_size);
assign is_2bytex2_int8_2nd_last_beat = (beat_count==beat_size-1);
//assign is_cube_last = layer_end;

//==============
// Layer Done
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    alu_layer_done <= 1'b0;
  end else begin
    if (op_load) begin
        if (cfg_alu_en) begin
            alu_layer_done <= 1'b0;
        end else begin
            alu_layer_done <= 1'b1;
        end
    end else if (alu_layer_end) begin
        alu_layer_done <= 1'b1;
    end else if (layer_done) begin
        alu_layer_done <= 1'b0;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_layer_done <= 1'b0;
  end else begin
    if (op_load) begin
        if (cfg_mul_en) begin
            mul_layer_done <= 1'b0;
        end else begin
            mul_layer_done <= 1'b1;
        end
    end else if (mul_layer_end) begin
        mul_layer_done <= 1'b1;
    end else if (layer_done) begin
        mul_layer_done <= 1'b0;
    end
  end
end

assign layer_done = alu_layer_done & mul_layer_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg_done <= 1'b0;
  end else begin
  eg_done <= layer_done;
  end
end

//==============
// OBS

//assign obs_bus_sdp_brdma_eg_cvif_rd_rsp_ready    = cvif2sdp_b_rd_rsp_ready; 
//assign obs_bus_sdp_brdma_eg_cvif_rd_rsp_valid    = cvif2sdp_b_rd_rsp_valid; 
//assign obs_bus_sdp_brdma_eg_lat_fifo_rd_pvld     = lat_rd_pvld; 
//assign obs_bus_sdp_brdma_eg_lat_fifo_rd_prdy     = lat_rd_prdy; 
//assign obs_bus_sdp_brdma_eg_lat_fifo_wr_pvld     = lat_wr_pvld; 
//assign obs_bus_sdp_brdma_eg_lat_fifo_wr_prdy     = lat_wr_prdy; 
//assign obs_bus_sdp_brdma_eg_layer_end            = layer_done;
//assign obs_bus_sdp_brdma_eg_mcif_rd_rsp_ready    = cvif2sdp_b_rd_rsp_ready; 
//assign obs_bus_sdp_brdma_eg_mcif_rd_rsp_valid    = cvif2sdp_b_rd_rsp_valid; 

endmodule // NV_NVDLA_SDP_BRDMA_eg



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os -rand none mcif2sdp_b_rd_rsp_pd_d1[513:0] (mcif2sdp_b_rd_rsp_valid_d1,mcif2sdp_b_rd_rsp_ready_d1) <= mcif2sdp_b_rd_rsp_pd_d0[513:0] (mcif2sdp_b_rd_rsp_valid_d0,mcif2sdp_b_rd_rsp_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_SDP_BRDMA_EG_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mcif2sdp_b_rd_rsp_pd_d0
  ,mcif2sdp_b_rd_rsp_ready_d1
  ,mcif2sdp_b_rd_rsp_valid_d0
  ,mcif2sdp_b_rd_rsp_pd_d1
  ,mcif2sdp_b_rd_rsp_ready_d0
  ,mcif2sdp_b_rd_rsp_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] mcif2sdp_b_rd_rsp_pd_d0;
input          mcif2sdp_b_rd_rsp_ready_d1;
input          mcif2sdp_b_rd_rsp_valid_d0;
output [513:0] mcif2sdp_b_rd_rsp_pd_d1;
output         mcif2sdp_b_rd_rsp_ready_d0;
output         mcif2sdp_b_rd_rsp_valid_d1;
reg    [513:0] mcif2sdp_b_rd_rsp_pd_d1;
reg            mcif2sdp_b_rd_rsp_ready_d0;
reg            mcif2sdp_b_rd_rsp_valid_d1;
reg    [513:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [513:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [513:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? mcif2sdp_b_rd_rsp_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && mcif2sdp_b_rd_rsp_valid_d0)? mcif2sdp_b_rd_rsp_pd_d0[513:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  mcif2sdp_b_rd_rsp_ready_d0 = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or mcif2sdp_b_rd_rsp_ready_d1
  or p1_pipe_skid_data
  ) begin
  mcif2sdp_b_rd_rsp_valid_d1 = p1_pipe_skid_valid;
  p1_pipe_skid_ready = mcif2sdp_b_rd_rsp_ready_d1;
  mcif2sdp_b_rd_rsp_pd_d1[513:0] = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_b_rd_rsp_valid_d1^mcif2sdp_b_rd_rsp_ready_d1^mcif2sdp_b_rd_rsp_valid_d0^mcif2sdp_b_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_5x (nvdla_core_clk, `ASSERT_RESET, (mcif2sdp_b_rd_rsp_valid_d0 && !mcif2sdp_b_rd_rsp_ready_d0), (mcif2sdp_b_rd_rsp_valid_d0), (mcif2sdp_b_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_BRDMA_EG_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os -rand none cvif2sdp_b_rd_rsp_pd_d1[513:0] (cvif2sdp_b_rd_rsp_valid_d1,cvif2sdp_b_rd_rsp_ready_d1) <= cvif2sdp_b_rd_rsp_pd_d0[513:0] (cvif2sdp_b_rd_rsp_valid_d0,cvif2sdp_b_rd_rsp_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_SDP_BRDMA_EG_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cvif2sdp_b_rd_rsp_pd_d0
  ,cvif2sdp_b_rd_rsp_ready_d1
  ,cvif2sdp_b_rd_rsp_valid_d0
  ,cvif2sdp_b_rd_rsp_pd_d1
  ,cvif2sdp_b_rd_rsp_ready_d0
  ,cvif2sdp_b_rd_rsp_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cvif2sdp_b_rd_rsp_pd_d0;
input          cvif2sdp_b_rd_rsp_ready_d1;
input          cvif2sdp_b_rd_rsp_valid_d0;
output [513:0] cvif2sdp_b_rd_rsp_pd_d1;
output         cvif2sdp_b_rd_rsp_ready_d0;
output         cvif2sdp_b_rd_rsp_valid_d1;
reg    [513:0] cvif2sdp_b_rd_rsp_pd_d1;
reg            cvif2sdp_b_rd_rsp_ready_d0;
reg            cvif2sdp_b_rd_rsp_valid_d1;
reg    [513:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg    [513:0] p2_pipe_skid_data;
reg            p2_pipe_skid_ready;
reg            p2_pipe_skid_valid;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [513:0] p2_skid_data;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? cvif2sdp_b_rd_rsp_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && cvif2sdp_b_rd_rsp_valid_d0)? cvif2sdp_b_rd_rsp_pd_d0[513:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  cvif2sdp_b_rd_rsp_ready_d0 = p2_pipe_ready_bc;
end
//## pipe (2) skid buffer
always @(
  p2_pipe_valid
  or p2_skid_ready_flop
  or p2_pipe_skid_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_valid && p2_skid_ready_flop && !p2_pipe_skid_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_pipe_skid_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_pipe_skid_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_valid
  or p2_skid_valid
  or p2_pipe_data
  or p2_skid_data
  ) begin
  p2_pipe_skid_valid = (p2_skid_ready_flop)? p2_pipe_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_pipe_skid_data = (p2_skid_ready_flop)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) output
always @(
  p2_pipe_skid_valid
  or cvif2sdp_b_rd_rsp_ready_d1
  or p2_pipe_skid_data
  ) begin
  cvif2sdp_b_rd_rsp_valid_d1 = p2_pipe_skid_valid;
  p2_pipe_skid_ready = cvif2sdp_b_rd_rsp_ready_d1;
  cvif2sdp_b_rd_rsp_pd_d1[513:0] = p2_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cvif2sdp_b_rd_rsp_valid_d1^cvif2sdp_b_rd_rsp_ready_d1^cvif2sdp_b_rd_rsp_valid_d0^cvif2sdp_b_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_7x (nvdla_core_clk, `ASSERT_RESET, (cvif2sdp_b_rd_rsp_valid_d0 && !cvif2sdp_b_rd_rsp_ready_d0), (cvif2sdp_b_rd_rsp_valid_d0), (cvif2sdp_b_rd_rsp_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_BRDMA_EG_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_BRDMA_EG_pipe_p3 (
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
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_9x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_BRDMA_EG_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_BRDMA_EG_pipe_p4 (
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
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_eg_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_11x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_BRDMA_EG_pipe_p4


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_BRDMA_EG_lat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus lat_wr -rd_pipebus lat_rd -rd_reg -d 160 -w 514 -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_BRDMA_EG_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [513:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [513:0] lat_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] lat_wr_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_160 = ( wr_count_next_no_wr_popping == 8'd160 );
wire wr_count_next_is_160 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_160;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_160 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  8'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [7:0] lat_wr_adr;			// current write address
wire [7:0] lat_rd_adr_p;		// read address to use for ram
wire [513:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_160x514 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [7:0] wr_adr_next = (lat_wr_adr == 8'd159) ? 8'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  8'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [7:0] lat_rd_adr;		// current read address
// next    read address
wire [7:0] rd_adr_next = (lat_rd_adr == 8'd159) ? 8'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  8'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [7:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  8'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
assign ore = rd_popping;

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_lat_fifo_wr_limit : 8'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 8'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 8'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 8'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [7:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 8'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( lat_wr_pvld && !(!lat_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst2(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst3(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd160 : wr_limit_reg} )
    , .curr	( {24'd0, lat_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_EG_lat_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_SDP_BRDMA_EG_lat_fifo



