// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_shared_buffer.v

module NV_NVDLA_CDMA_shared_buffer (
   nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,pwrbus_ram_pd       //|< i
  ,dc2sbuf_p0_wr_en    //|< i
  ,dc2sbuf_p0_wr_addr  //|< i
  ,dc2sbuf_p0_wr_data  //|< i
  ,dc2sbuf_p1_wr_en    //|< i
  ,dc2sbuf_p1_wr_addr  //|< i
  ,dc2sbuf_p1_wr_data  //|< i
  ,wg2sbuf_p0_wr_en    //|< i
  ,wg2sbuf_p0_wr_addr  //|< i
  ,wg2sbuf_p0_wr_data  //|< i
  ,wg2sbuf_p1_wr_en    //|< i
  ,wg2sbuf_p1_wr_addr  //|< i
  ,wg2sbuf_p1_wr_data  //|< i
  ,img2sbuf_p0_wr_en   //|< i
  ,img2sbuf_p0_wr_addr //|< i
  ,img2sbuf_p0_wr_data //|< i
  ,img2sbuf_p1_wr_en   //|< i
  ,img2sbuf_p1_wr_addr //|< i
  ,img2sbuf_p1_wr_data //|< i
  ,dc2sbuf_p0_rd_en    //|< i
  ,dc2sbuf_p0_rd_addr  //|< i
  ,dc2sbuf_p0_rd_data  //|> o
  ,dc2sbuf_p1_rd_en    //|< i
  ,dc2sbuf_p1_rd_addr  //|< i
  ,dc2sbuf_p1_rd_data  //|> o
  ,wg2sbuf_p0_rd_en    //|< i
  ,wg2sbuf_p0_rd_addr  //|< i
  ,wg2sbuf_p0_rd_data  //|> o
  ,wg2sbuf_p1_rd_en    //|< i
  ,wg2sbuf_p1_rd_addr  //|< i
  ,wg2sbuf_p1_rd_data  //|> o
  ,img2sbuf_p0_rd_en   //|< i
  ,img2sbuf_p0_rd_addr //|< i
  ,img2sbuf_p0_rd_data //|> o
  ,img2sbuf_p1_rd_en   //|< i
  ,img2sbuf_p1_rd_addr //|< i
  ,img2sbuf_p1_rd_data //|> o
  );

//
// NV_NVDLA_CDMA_shared_buffer_ports.v
//
input  nvdla_core_clk;   /* dc2sbuf_p0_wr, dc2sbuf_p1_wr, wg2sbuf_p0_wr, wg2sbuf_p1_wr, img2sbuf_p0_wr, img2sbuf_p1_wr, dc2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, dc2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256 */
input  nvdla_core_rstn;  /* dc2sbuf_p0_wr, dc2sbuf_p1_wr, wg2sbuf_p0_wr, wg2sbuf_p1_wr, img2sbuf_p0_wr, img2sbuf_p1_wr, dc2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, dc2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, dc2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, wg2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, wg2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256 */

input [31:0] pwrbus_ram_pd;

input         dc2sbuf_p0_wr_en;    /* data valid */
input   [7:0] dc2sbuf_p0_wr_addr;
input [255:0] dc2sbuf_p0_wr_data;

input         dc2sbuf_p1_wr_en;    /* data valid */
input   [7:0] dc2sbuf_p1_wr_addr;
input [255:0] dc2sbuf_p1_wr_data;

input         wg2sbuf_p0_wr_en;    /* data valid */
input   [7:0] wg2sbuf_p0_wr_addr;
input [255:0] wg2sbuf_p0_wr_data;

input         wg2sbuf_p1_wr_en;    /* data valid */
input   [7:0] wg2sbuf_p1_wr_addr;
input [255:0] wg2sbuf_p1_wr_data;

input         img2sbuf_p0_wr_en;    /* data valid */
input   [7:0] img2sbuf_p0_wr_addr;
input [255:0] img2sbuf_p0_wr_data;

input         img2sbuf_p1_wr_en;    /* data valid */
input   [7:0] img2sbuf_p1_wr_addr;
input [255:0] img2sbuf_p1_wr_data;

input       dc2sbuf_p0_rd_en;    /* data valid */
input [7:0] dc2sbuf_p0_rd_addr;

output [255:0] dc2sbuf_p0_rd_data;

input       dc2sbuf_p1_rd_en;    /* data valid */
input [7:0] dc2sbuf_p1_rd_addr;

output [255:0] dc2sbuf_p1_rd_data;

input       wg2sbuf_p0_rd_en;    /* data valid */
input [7:0] wg2sbuf_p0_rd_addr;

output [255:0] wg2sbuf_p0_rd_data;

input       wg2sbuf_p1_rd_en;    /* data valid */
input [7:0] wg2sbuf_p1_rd_addr;

output [255:0] wg2sbuf_p1_rd_data;

input       img2sbuf_p0_rd_en;    /* data valid */
input [7:0] img2sbuf_p0_rd_addr;

output [255:0] img2sbuf_p0_rd_data;

input       img2sbuf_p1_rd_en;    /* data valid */
input [7:0] img2sbuf_p1_rd_addr;

output [255:0] img2sbuf_p1_rd_data;


wire   [3:0] dc2sbuf_p0_rd_bsel;
wire   [3:0] dc2sbuf_p0_rd_esel;
wire   [3:0] dc2sbuf_p0_wr_bsel;
wire   [3:0] dc2sbuf_p1_rd_bsel;
wire   [3:0] dc2sbuf_p1_rd_esel;
wire   [3:0] dc2sbuf_p1_wr_bsel;
wire   [3:0] img2sbuf_p0_rd_bsel;
wire   [3:0] img2sbuf_p0_rd_esel;
wire   [3:0] img2sbuf_p0_wr_bsel;
wire   [3:0] img2sbuf_p1_rd_bsel;
wire   [3:0] img2sbuf_p1_rd_esel;
wire   [3:0] img2sbuf_p1_wr_bsel;
wire [255:0] sbuf_rdat_00;
wire [255:0] sbuf_rdat_01;
wire [255:0] sbuf_rdat_02;
wire [255:0] sbuf_rdat_03;
wire [255:0] sbuf_rdat_04;
wire [255:0] sbuf_rdat_05;
wire [255:0] sbuf_rdat_06;
wire [255:0] sbuf_rdat_07;
wire [255:0] sbuf_rdat_08;
wire [255:0] sbuf_rdat_09;
wire [255:0] sbuf_rdat_10;
wire [255:0] sbuf_rdat_11;
wire [255:0] sbuf_rdat_12;
wire [255:0] sbuf_rdat_13;
wire [255:0] sbuf_rdat_14;
wire [255:0] sbuf_rdat_15;
wire   [1:0] wg2sbuf_p0_rd_bsel;
wire   [3:0] wg2sbuf_p0_rd_esel;
wire   [3:0] wg2sbuf_p0_wr_bsel;
wire   [1:0] wg2sbuf_p1_rd_bsel;
wire   [3:0] wg2sbuf_p1_rd_esel;
wire   [3:0] wg2sbuf_p1_wr_bsel;
reg          dc2sbuf_p0_rd_sel_00;
reg          dc2sbuf_p0_rd_sel_01;
reg          dc2sbuf_p0_rd_sel_02;
reg          dc2sbuf_p0_rd_sel_03;
reg          dc2sbuf_p0_rd_sel_04;
reg          dc2sbuf_p0_rd_sel_05;
reg          dc2sbuf_p0_rd_sel_06;
reg          dc2sbuf_p0_rd_sel_07;
reg          dc2sbuf_p0_rd_sel_08;
reg          dc2sbuf_p0_rd_sel_09;
reg          dc2sbuf_p0_rd_sel_10;
reg          dc2sbuf_p0_rd_sel_11;
reg          dc2sbuf_p0_rd_sel_12;
reg          dc2sbuf_p0_rd_sel_13;
reg          dc2sbuf_p0_rd_sel_14;
reg          dc2sbuf_p0_rd_sel_15;
reg          dc2sbuf_p0_wr_sel_00;
reg          dc2sbuf_p0_wr_sel_01;
reg          dc2sbuf_p0_wr_sel_02;
reg          dc2sbuf_p0_wr_sel_03;
reg          dc2sbuf_p0_wr_sel_04;
reg          dc2sbuf_p0_wr_sel_05;
reg          dc2sbuf_p0_wr_sel_06;
reg          dc2sbuf_p0_wr_sel_07;
reg          dc2sbuf_p0_wr_sel_08;
reg          dc2sbuf_p0_wr_sel_09;
reg          dc2sbuf_p0_wr_sel_10;
reg          dc2sbuf_p0_wr_sel_11;
reg          dc2sbuf_p0_wr_sel_12;
reg          dc2sbuf_p0_wr_sel_13;
reg          dc2sbuf_p0_wr_sel_14;
reg          dc2sbuf_p0_wr_sel_15;
reg          dc2sbuf_p1_rd_sel_00;
reg          dc2sbuf_p1_rd_sel_01;
reg          dc2sbuf_p1_rd_sel_02;
reg          dc2sbuf_p1_rd_sel_03;
reg          dc2sbuf_p1_rd_sel_04;
reg          dc2sbuf_p1_rd_sel_05;
reg          dc2sbuf_p1_rd_sel_06;
reg          dc2sbuf_p1_rd_sel_07;
reg          dc2sbuf_p1_rd_sel_08;
reg          dc2sbuf_p1_rd_sel_09;
reg          dc2sbuf_p1_rd_sel_10;
reg          dc2sbuf_p1_rd_sel_11;
reg          dc2sbuf_p1_rd_sel_12;
reg          dc2sbuf_p1_rd_sel_13;
reg          dc2sbuf_p1_rd_sel_14;
reg          dc2sbuf_p1_rd_sel_15;
reg          dc2sbuf_p1_wr_sel_00;
reg          dc2sbuf_p1_wr_sel_01;
reg          dc2sbuf_p1_wr_sel_02;
reg          dc2sbuf_p1_wr_sel_03;
reg          dc2sbuf_p1_wr_sel_04;
reg          dc2sbuf_p1_wr_sel_05;
reg          dc2sbuf_p1_wr_sel_06;
reg          dc2sbuf_p1_wr_sel_07;
reg          dc2sbuf_p1_wr_sel_08;
reg          dc2sbuf_p1_wr_sel_09;
reg          dc2sbuf_p1_wr_sel_10;
reg          dc2sbuf_p1_wr_sel_11;
reg          dc2sbuf_p1_wr_sel_12;
reg          dc2sbuf_p1_wr_sel_13;
reg          dc2sbuf_p1_wr_sel_14;
reg          dc2sbuf_p1_wr_sel_15;
reg          img2sbuf_p0_rd_sel_00;
reg          img2sbuf_p0_rd_sel_01;
reg          img2sbuf_p0_rd_sel_02;
reg          img2sbuf_p0_rd_sel_03;
reg          img2sbuf_p0_rd_sel_04;
reg          img2sbuf_p0_rd_sel_05;
reg          img2sbuf_p0_rd_sel_06;
reg          img2sbuf_p0_rd_sel_07;
reg          img2sbuf_p0_rd_sel_08;
reg          img2sbuf_p0_rd_sel_09;
reg          img2sbuf_p0_rd_sel_10;
reg          img2sbuf_p0_rd_sel_11;
reg          img2sbuf_p0_rd_sel_12;
reg          img2sbuf_p0_rd_sel_13;
reg          img2sbuf_p0_rd_sel_14;
reg          img2sbuf_p0_rd_sel_15;
reg          img2sbuf_p0_wr_sel_00;
reg          img2sbuf_p0_wr_sel_01;
reg          img2sbuf_p0_wr_sel_02;
reg          img2sbuf_p0_wr_sel_03;
reg          img2sbuf_p0_wr_sel_04;
reg          img2sbuf_p0_wr_sel_05;
reg          img2sbuf_p0_wr_sel_06;
reg          img2sbuf_p0_wr_sel_07;
reg          img2sbuf_p0_wr_sel_08;
reg          img2sbuf_p0_wr_sel_09;
reg          img2sbuf_p0_wr_sel_10;
reg          img2sbuf_p0_wr_sel_11;
reg          img2sbuf_p0_wr_sel_12;
reg          img2sbuf_p0_wr_sel_13;
reg          img2sbuf_p0_wr_sel_14;
reg          img2sbuf_p0_wr_sel_15;
reg          img2sbuf_p1_rd_sel_00;
reg          img2sbuf_p1_rd_sel_01;
reg          img2sbuf_p1_rd_sel_02;
reg          img2sbuf_p1_rd_sel_03;
reg          img2sbuf_p1_rd_sel_04;
reg          img2sbuf_p1_rd_sel_05;
reg          img2sbuf_p1_rd_sel_06;
reg          img2sbuf_p1_rd_sel_07;
reg          img2sbuf_p1_rd_sel_08;
reg          img2sbuf_p1_rd_sel_09;
reg          img2sbuf_p1_rd_sel_10;
reg          img2sbuf_p1_rd_sel_11;
reg          img2sbuf_p1_rd_sel_12;
reg          img2sbuf_p1_rd_sel_13;
reg          img2sbuf_p1_rd_sel_14;
reg          img2sbuf_p1_rd_sel_15;
reg          img2sbuf_p1_wr_sel_00;
reg          img2sbuf_p1_wr_sel_01;
reg          img2sbuf_p1_wr_sel_02;
reg          img2sbuf_p1_wr_sel_03;
reg          img2sbuf_p1_wr_sel_04;
reg          img2sbuf_p1_wr_sel_05;
reg          img2sbuf_p1_wr_sel_06;
reg          img2sbuf_p1_wr_sel_07;
reg          img2sbuf_p1_wr_sel_08;
reg          img2sbuf_p1_wr_sel_09;
reg          img2sbuf_p1_wr_sel_10;
reg          img2sbuf_p1_wr_sel_11;
reg          img2sbuf_p1_wr_sel_12;
reg          img2sbuf_p1_wr_sel_13;
reg          img2sbuf_p1_wr_sel_14;
reg          img2sbuf_p1_wr_sel_15;
reg  [255:0] sbuf_p0_norm_rdat;
reg          sbuf_p0_rd_en_d1;
reg  [255:0] sbuf_p0_rdat;
reg  [255:0] sbuf_p0_rdat_d2;
reg          sbuf_p0_re_00;
reg          sbuf_p0_re_00_norm_d1;
reg          sbuf_p0_re_00_wg_d1;
reg          sbuf_p0_re_01;
reg          sbuf_p0_re_01_norm_d1;
reg          sbuf_p0_re_01_wg_d1;
reg          sbuf_p0_re_02;
reg          sbuf_p0_re_02_norm_d1;
reg          sbuf_p0_re_02_wg_d1;
reg          sbuf_p0_re_03;
reg          sbuf_p0_re_03_norm_d1;
reg          sbuf_p0_re_03_wg_d1;
reg          sbuf_p0_re_04;
reg          sbuf_p0_re_04_norm_d1;
reg          sbuf_p0_re_05;
reg          sbuf_p0_re_05_norm_d1;
reg          sbuf_p0_re_06;
reg          sbuf_p0_re_06_norm_d1;
reg          sbuf_p0_re_07;
reg          sbuf_p0_re_07_norm_d1;
reg          sbuf_p0_re_08;
reg          sbuf_p0_re_08_norm_d1;
reg          sbuf_p0_re_09;
reg          sbuf_p0_re_09_norm_d1;
reg          sbuf_p0_re_10;
reg          sbuf_p0_re_10_norm_d1;
reg          sbuf_p0_re_11;
reg          sbuf_p0_re_11_norm_d1;
reg          sbuf_p0_re_12;
reg          sbuf_p0_re_12_norm_d1;
reg          sbuf_p0_re_13;
reg          sbuf_p0_re_13_norm_d1;
reg          sbuf_p0_re_14;
reg          sbuf_p0_re_14_norm_d1;
reg          sbuf_p0_re_15;
reg          sbuf_p0_re_15_norm_d1;
reg  [255:0] sbuf_p0_wg_rdat;
reg  [255:0] sbuf_p0_wg_rdat_src_0;
reg  [255:0] sbuf_p0_wg_rdat_src_1;
reg  [255:0] sbuf_p0_wg_rdat_src_2;
reg  [255:0] sbuf_p0_wg_rdat_src_3;
reg          sbuf_p0_wg_sel_q0;
reg          sbuf_p0_wg_sel_q0_d1;
reg          sbuf_p0_wg_sel_q1;
reg          sbuf_p0_wg_sel_q1_d1;
reg          sbuf_p0_wg_sel_q2;
reg          sbuf_p0_wg_sel_q2_d1;
reg          sbuf_p0_wg_sel_q3;
reg          sbuf_p0_wg_sel_q3_d1;
reg  [255:0] sbuf_p1_norm_rdat;
reg          sbuf_p1_rd_en_d1;
reg  [255:0] sbuf_p1_rdat;
reg  [255:0] sbuf_p1_rdat_d2;
reg          sbuf_p1_re_00;
reg          sbuf_p1_re_00_norm_d1;
reg          sbuf_p1_re_00_wg_d1;
reg          sbuf_p1_re_01;
reg          sbuf_p1_re_01_norm_d1;
reg          sbuf_p1_re_01_wg_d1;
reg          sbuf_p1_re_02;
reg          sbuf_p1_re_02_norm_d1;
reg          sbuf_p1_re_02_wg_d1;
reg          sbuf_p1_re_03;
reg          sbuf_p1_re_03_norm_d1;
reg          sbuf_p1_re_03_wg_d1;
reg          sbuf_p1_re_04;
reg          sbuf_p1_re_04_norm_d1;
reg          sbuf_p1_re_05;
reg          sbuf_p1_re_05_norm_d1;
reg          sbuf_p1_re_06;
reg          sbuf_p1_re_06_norm_d1;
reg          sbuf_p1_re_07;
reg          sbuf_p1_re_07_norm_d1;
reg          sbuf_p1_re_08;
reg          sbuf_p1_re_08_norm_d1;
reg          sbuf_p1_re_09;
reg          sbuf_p1_re_09_norm_d1;
reg          sbuf_p1_re_10;
reg          sbuf_p1_re_10_norm_d1;
reg          sbuf_p1_re_11;
reg          sbuf_p1_re_11_norm_d1;
reg          sbuf_p1_re_12;
reg          sbuf_p1_re_12_norm_d1;
reg          sbuf_p1_re_13;
reg          sbuf_p1_re_13_norm_d1;
reg          sbuf_p1_re_14;
reg          sbuf_p1_re_14_norm_d1;
reg          sbuf_p1_re_15;
reg          sbuf_p1_re_15_norm_d1;
reg  [255:0] sbuf_p1_wg_rdat;
reg  [255:0] sbuf_p1_wg_rdat_src_0;
reg  [255:0] sbuf_p1_wg_rdat_src_1;
reg  [255:0] sbuf_p1_wg_rdat_src_2;
reg  [255:0] sbuf_p1_wg_rdat_src_3;
reg          sbuf_p1_wg_sel_q0;
reg          sbuf_p1_wg_sel_q0_d1;
reg          sbuf_p1_wg_sel_q1;
reg          sbuf_p1_wg_sel_q1_d1;
reg          sbuf_p1_wg_sel_q2;
reg          sbuf_p1_wg_sel_q2_d1;
reg          sbuf_p1_wg_sel_q3;
reg          sbuf_p1_wg_sel_q3_d1;
reg    [3:0] sbuf_ra_00;
reg    [3:0] sbuf_ra_01;
reg    [3:0] sbuf_ra_02;
reg    [3:0] sbuf_ra_03;
reg    [3:0] sbuf_ra_04;
reg    [3:0] sbuf_ra_05;
reg    [3:0] sbuf_ra_06;
reg    [3:0] sbuf_ra_07;
reg    [3:0] sbuf_ra_08;
reg    [3:0] sbuf_ra_09;
reg    [3:0] sbuf_ra_10;
reg    [3:0] sbuf_ra_11;
reg    [3:0] sbuf_ra_12;
reg    [3:0] sbuf_ra_13;
reg    [3:0] sbuf_ra_14;
reg    [3:0] sbuf_ra_15;
reg          sbuf_re_00;
reg          sbuf_re_01;
reg          sbuf_re_02;
reg          sbuf_re_03;
reg          sbuf_re_04;
reg          sbuf_re_05;
reg          sbuf_re_06;
reg          sbuf_re_07;
reg          sbuf_re_08;
reg          sbuf_re_09;
reg          sbuf_re_10;
reg          sbuf_re_11;
reg          sbuf_re_12;
reg          sbuf_re_13;
reg          sbuf_re_14;
reg          sbuf_re_15;
reg    [3:0] sbuf_wa_00;
reg    [3:0] sbuf_wa_01;
reg    [3:0] sbuf_wa_02;
reg    [3:0] sbuf_wa_03;
reg    [3:0] sbuf_wa_04;
reg    [3:0] sbuf_wa_05;
reg    [3:0] sbuf_wa_06;
reg    [3:0] sbuf_wa_07;
reg    [3:0] sbuf_wa_08;
reg    [3:0] sbuf_wa_09;
reg    [3:0] sbuf_wa_10;
reg    [3:0] sbuf_wa_11;
reg    [3:0] sbuf_wa_12;
reg    [3:0] sbuf_wa_13;
reg    [3:0] sbuf_wa_14;
reg    [3:0] sbuf_wa_15;
reg  [255:0] sbuf_wdat_00;
reg  [255:0] sbuf_wdat_01;
reg  [255:0] sbuf_wdat_02;
reg  [255:0] sbuf_wdat_03;
reg  [255:0] sbuf_wdat_04;
reg  [255:0] sbuf_wdat_05;
reg  [255:0] sbuf_wdat_06;
reg  [255:0] sbuf_wdat_07;
reg  [255:0] sbuf_wdat_08;
reg  [255:0] sbuf_wdat_09;
reg  [255:0] sbuf_wdat_10;
reg  [255:0] sbuf_wdat_11;
reg  [255:0] sbuf_wdat_12;
reg  [255:0] sbuf_wdat_13;
reg  [255:0] sbuf_wdat_14;
reg  [255:0] sbuf_wdat_15;
reg          sbuf_we_00;
reg          sbuf_we_01;
reg          sbuf_we_02;
reg          sbuf_we_03;
reg          sbuf_we_04;
reg          sbuf_we_05;
reg          sbuf_we_06;
reg          sbuf_we_07;
reg          sbuf_we_08;
reg          sbuf_we_09;
reg          sbuf_we_10;
reg          sbuf_we_11;
reg          sbuf_we_12;
reg          sbuf_we_13;
reg          sbuf_we_14;
reg          sbuf_we_15;
reg          wg2sbuf_p0_rd_sel_00;
reg          wg2sbuf_p0_rd_sel_01;
reg          wg2sbuf_p0_rd_sel_02;
reg          wg2sbuf_p0_rd_sel_03;
reg          wg2sbuf_p0_rd_sel_04;
reg          wg2sbuf_p0_rd_sel_05;
reg          wg2sbuf_p0_rd_sel_06;
reg          wg2sbuf_p0_rd_sel_07;
reg          wg2sbuf_p0_rd_sel_08;
reg          wg2sbuf_p0_rd_sel_09;
reg          wg2sbuf_p0_rd_sel_10;
reg          wg2sbuf_p0_rd_sel_11;
reg          wg2sbuf_p0_rd_sel_12;
reg          wg2sbuf_p0_rd_sel_13;
reg          wg2sbuf_p0_rd_sel_14;
reg          wg2sbuf_p0_rd_sel_15;
reg          wg2sbuf_p0_wr_sel_00;
reg          wg2sbuf_p0_wr_sel_01;
reg          wg2sbuf_p0_wr_sel_02;
reg          wg2sbuf_p0_wr_sel_03;
reg          wg2sbuf_p0_wr_sel_04;
reg          wg2sbuf_p0_wr_sel_05;
reg          wg2sbuf_p0_wr_sel_06;
reg          wg2sbuf_p0_wr_sel_07;
reg          wg2sbuf_p0_wr_sel_08;
reg          wg2sbuf_p0_wr_sel_09;
reg          wg2sbuf_p0_wr_sel_10;
reg          wg2sbuf_p0_wr_sel_11;
reg          wg2sbuf_p0_wr_sel_12;
reg          wg2sbuf_p0_wr_sel_13;
reg          wg2sbuf_p0_wr_sel_14;
reg          wg2sbuf_p0_wr_sel_15;
reg          wg2sbuf_p1_rd_sel_00;
reg          wg2sbuf_p1_rd_sel_01;
reg          wg2sbuf_p1_rd_sel_02;
reg          wg2sbuf_p1_rd_sel_03;
reg          wg2sbuf_p1_rd_sel_04;
reg          wg2sbuf_p1_rd_sel_05;
reg          wg2sbuf_p1_rd_sel_06;
reg          wg2sbuf_p1_rd_sel_07;
reg          wg2sbuf_p1_rd_sel_08;
reg          wg2sbuf_p1_rd_sel_09;
reg          wg2sbuf_p1_rd_sel_10;
reg          wg2sbuf_p1_rd_sel_11;
reg          wg2sbuf_p1_rd_sel_12;
reg          wg2sbuf_p1_rd_sel_13;
reg          wg2sbuf_p1_rd_sel_14;
reg          wg2sbuf_p1_rd_sel_15;
reg          wg2sbuf_p1_wr_sel_00;
reg          wg2sbuf_p1_wr_sel_01;
reg          wg2sbuf_p1_wr_sel_02;
reg          wg2sbuf_p1_wr_sel_03;
reg          wg2sbuf_p1_wr_sel_04;
reg          wg2sbuf_p1_wr_sel_05;
reg          wg2sbuf_p1_wr_sel_06;
reg          wg2sbuf_p1_wr_sel_07;
reg          wg2sbuf_p1_wr_sel_08;
reg          wg2sbuf_p1_wr_sel_09;
reg          wg2sbuf_p1_wr_sel_10;
reg          wg2sbuf_p1_wr_sel_11;
reg          wg2sbuf_p1_wr_sel_12;
reg          wg2sbuf_p1_wr_sel_13;
reg          wg2sbuf_p1_wr_sel_14;
reg          wg2sbuf_p1_wr_sel_15;

////////////////////////////////////////////////////////////////////////\n";
// Input port to RAMS                                                 //\n";
////////////////////////////////////////////////////////////////////////\n";

assign dc2sbuf_p0_wr_bsel = dc2sbuf_p0_wr_addr[7:4];
assign dc2sbuf_p1_wr_bsel = dc2sbuf_p1_wr_addr[7:4];

assign wg2sbuf_p0_wr_bsel = wg2sbuf_p0_wr_addr[7:4];
assign wg2sbuf_p1_wr_bsel = wg2sbuf_p1_wr_addr[7:4];

assign img2sbuf_p0_wr_bsel = img2sbuf_p0_wr_addr[7:4];
assign img2sbuf_p1_wr_bsel = img2sbuf_p1_wr_addr[7:4];


always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_00 = (dc2sbuf_p0_wr_bsel == 4'd0) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_00 = (dc2sbuf_p1_wr_bsel == 4'd0) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_00 = (wg2sbuf_p0_wr_bsel == 4'd0) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_00 = (wg2sbuf_p1_wr_bsel == 4'd0) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_00 = (img2sbuf_p0_wr_bsel == 4'd0) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_00 = (img2sbuf_p1_wr_bsel == 4'd0) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_01 = (dc2sbuf_p0_wr_bsel == 4'd1) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_01 = (dc2sbuf_p1_wr_bsel == 4'd1) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_01 = (wg2sbuf_p0_wr_bsel == 4'd1) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_01 = (wg2sbuf_p1_wr_bsel == 4'd1) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_01 = (img2sbuf_p0_wr_bsel == 4'd1) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_01 = (img2sbuf_p1_wr_bsel == 4'd1) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_02 = (dc2sbuf_p0_wr_bsel == 4'd2) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_02 = (dc2sbuf_p1_wr_bsel == 4'd2) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_02 = (wg2sbuf_p0_wr_bsel == 4'd2) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_02 = (wg2sbuf_p1_wr_bsel == 4'd2) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_02 = (img2sbuf_p0_wr_bsel == 4'd2) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_02 = (img2sbuf_p1_wr_bsel == 4'd2) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_03 = (dc2sbuf_p0_wr_bsel == 4'd3) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_03 = (dc2sbuf_p1_wr_bsel == 4'd3) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_03 = (wg2sbuf_p0_wr_bsel == 4'd3) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_03 = (wg2sbuf_p1_wr_bsel == 4'd3) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_03 = (img2sbuf_p0_wr_bsel == 4'd3) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_03 = (img2sbuf_p1_wr_bsel == 4'd3) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_04 = (dc2sbuf_p0_wr_bsel == 4'd4) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_04 = (dc2sbuf_p1_wr_bsel == 4'd4) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_04 = (wg2sbuf_p0_wr_bsel == 4'd4) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_04 = (wg2sbuf_p1_wr_bsel == 4'd4) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_04 = (img2sbuf_p0_wr_bsel == 4'd4) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_04 = (img2sbuf_p1_wr_bsel == 4'd4) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_05 = (dc2sbuf_p0_wr_bsel == 4'd5) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_05 = (dc2sbuf_p1_wr_bsel == 4'd5) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_05 = (wg2sbuf_p0_wr_bsel == 4'd5) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_05 = (wg2sbuf_p1_wr_bsel == 4'd5) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_05 = (img2sbuf_p0_wr_bsel == 4'd5) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_05 = (img2sbuf_p1_wr_bsel == 4'd5) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_06 = (dc2sbuf_p0_wr_bsel == 4'd6) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_06 = (dc2sbuf_p1_wr_bsel == 4'd6) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_06 = (wg2sbuf_p0_wr_bsel == 4'd6) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_06 = (wg2sbuf_p1_wr_bsel == 4'd6) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_06 = (img2sbuf_p0_wr_bsel == 4'd6) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_06 = (img2sbuf_p1_wr_bsel == 4'd6) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_07 = (dc2sbuf_p0_wr_bsel == 4'd7) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_07 = (dc2sbuf_p1_wr_bsel == 4'd7) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_07 = (wg2sbuf_p0_wr_bsel == 4'd7) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_07 = (wg2sbuf_p1_wr_bsel == 4'd7) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_07 = (img2sbuf_p0_wr_bsel == 4'd7) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_07 = (img2sbuf_p1_wr_bsel == 4'd7) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_08 = (dc2sbuf_p0_wr_bsel == 4'd8) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_08 = (dc2sbuf_p1_wr_bsel == 4'd8) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_08 = (wg2sbuf_p0_wr_bsel == 4'd8) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_08 = (wg2sbuf_p1_wr_bsel == 4'd8) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_08 = (img2sbuf_p0_wr_bsel == 4'd8) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_08 = (img2sbuf_p1_wr_bsel == 4'd8) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_09 = (dc2sbuf_p0_wr_bsel == 4'd9) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_09 = (dc2sbuf_p1_wr_bsel == 4'd9) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_09 = (wg2sbuf_p0_wr_bsel == 4'd9) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_09 = (wg2sbuf_p1_wr_bsel == 4'd9) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_09 = (img2sbuf_p0_wr_bsel == 4'd9) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_09 = (img2sbuf_p1_wr_bsel == 4'd9) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_10 = (dc2sbuf_p0_wr_bsel == 4'd10) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_10 = (dc2sbuf_p1_wr_bsel == 4'd10) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_10 = (wg2sbuf_p0_wr_bsel == 4'd10) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_10 = (wg2sbuf_p1_wr_bsel == 4'd10) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_10 = (img2sbuf_p0_wr_bsel == 4'd10) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_10 = (img2sbuf_p1_wr_bsel == 4'd10) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_11 = (dc2sbuf_p0_wr_bsel == 4'd11) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_11 = (dc2sbuf_p1_wr_bsel == 4'd11) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_11 = (wg2sbuf_p0_wr_bsel == 4'd11) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_11 = (wg2sbuf_p1_wr_bsel == 4'd11) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_11 = (img2sbuf_p0_wr_bsel == 4'd11) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_11 = (img2sbuf_p1_wr_bsel == 4'd11) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_12 = (dc2sbuf_p0_wr_bsel == 4'd12) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_12 = (dc2sbuf_p1_wr_bsel == 4'd12) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_12 = (wg2sbuf_p0_wr_bsel == 4'd12) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_12 = (wg2sbuf_p1_wr_bsel == 4'd12) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_12 = (img2sbuf_p0_wr_bsel == 4'd12) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_12 = (img2sbuf_p1_wr_bsel == 4'd12) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_13 = (dc2sbuf_p0_wr_bsel == 4'd13) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_13 = (dc2sbuf_p1_wr_bsel == 4'd13) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_13 = (wg2sbuf_p0_wr_bsel == 4'd13) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_13 = (wg2sbuf_p1_wr_bsel == 4'd13) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_13 = (img2sbuf_p0_wr_bsel == 4'd13) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_13 = (img2sbuf_p1_wr_bsel == 4'd13) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_14 = (dc2sbuf_p0_wr_bsel == 4'd14) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_14 = (dc2sbuf_p1_wr_bsel == 4'd14) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_14 = (wg2sbuf_p0_wr_bsel == 4'd14) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_14 = (wg2sbuf_p1_wr_bsel == 4'd14) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_14 = (img2sbuf_p0_wr_bsel == 4'd14) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_14 = (img2sbuf_p1_wr_bsel == 4'd14) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_bsel
  or dc2sbuf_p0_wr_en
  ) begin
    dc2sbuf_p0_wr_sel_15 = (dc2sbuf_p0_wr_bsel == 4'd15) & dc2sbuf_p0_wr_en;
end

always @(
  dc2sbuf_p1_wr_bsel
  or dc2sbuf_p1_wr_en
  ) begin
    dc2sbuf_p1_wr_sel_15 = (dc2sbuf_p1_wr_bsel == 4'd15) & dc2sbuf_p1_wr_en;
end

always @(
  wg2sbuf_p0_wr_bsel
  or wg2sbuf_p0_wr_en
  ) begin
    wg2sbuf_p0_wr_sel_15 = (wg2sbuf_p0_wr_bsel == 4'd15) & wg2sbuf_p0_wr_en;
end

always @(
  wg2sbuf_p1_wr_bsel
  or wg2sbuf_p1_wr_en
  ) begin
    wg2sbuf_p1_wr_sel_15 = (wg2sbuf_p1_wr_bsel == 4'd15) & wg2sbuf_p1_wr_en;
end

always @(
  img2sbuf_p0_wr_bsel
  or img2sbuf_p0_wr_en
  ) begin
    img2sbuf_p0_wr_sel_15 = (img2sbuf_p0_wr_bsel == 4'd15) & img2sbuf_p0_wr_en;
end

always @(
  img2sbuf_p1_wr_bsel
  or img2sbuf_p1_wr_en
  ) begin
    img2sbuf_p1_wr_sel_15 = (img2sbuf_p1_wr_bsel == 4'd15) & img2sbuf_p1_wr_en;
end

always @(
  dc2sbuf_p0_wr_sel_00
  or dc2sbuf_p1_wr_sel_00
  or wg2sbuf_p0_wr_sel_00
  or wg2sbuf_p1_wr_sel_00
  or img2sbuf_p0_wr_sel_00
  or img2sbuf_p1_wr_sel_00
  ) begin
    sbuf_we_00 = dc2sbuf_p0_wr_sel_00 |
                 dc2sbuf_p1_wr_sel_00 |
                 wg2sbuf_p0_wr_sel_00 |
                 wg2sbuf_p1_wr_sel_00 |
                 img2sbuf_p0_wr_sel_00 |
                 img2sbuf_p1_wr_sel_00;
end

always @(
  dc2sbuf_p0_wr_sel_01
  or dc2sbuf_p1_wr_sel_01
  or wg2sbuf_p0_wr_sel_01
  or wg2sbuf_p1_wr_sel_01
  or img2sbuf_p0_wr_sel_01
  or img2sbuf_p1_wr_sel_01
  ) begin
    sbuf_we_01 = dc2sbuf_p0_wr_sel_01 |
                 dc2sbuf_p1_wr_sel_01 |
                 wg2sbuf_p0_wr_sel_01 |
                 wg2sbuf_p1_wr_sel_01 |
                 img2sbuf_p0_wr_sel_01 |
                 img2sbuf_p1_wr_sel_01;
end

always @(
  dc2sbuf_p0_wr_sel_02
  or dc2sbuf_p1_wr_sel_02
  or wg2sbuf_p0_wr_sel_02
  or wg2sbuf_p1_wr_sel_02
  or img2sbuf_p0_wr_sel_02
  or img2sbuf_p1_wr_sel_02
  ) begin
    sbuf_we_02 = dc2sbuf_p0_wr_sel_02 |
                 dc2sbuf_p1_wr_sel_02 |
                 wg2sbuf_p0_wr_sel_02 |
                 wg2sbuf_p1_wr_sel_02 |
                 img2sbuf_p0_wr_sel_02 |
                 img2sbuf_p1_wr_sel_02;
end

always @(
  dc2sbuf_p0_wr_sel_03
  or dc2sbuf_p1_wr_sel_03
  or wg2sbuf_p0_wr_sel_03
  or wg2sbuf_p1_wr_sel_03
  or img2sbuf_p0_wr_sel_03
  or img2sbuf_p1_wr_sel_03
  ) begin
    sbuf_we_03 = dc2sbuf_p0_wr_sel_03 |
                 dc2sbuf_p1_wr_sel_03 |
                 wg2sbuf_p0_wr_sel_03 |
                 wg2sbuf_p1_wr_sel_03 |
                 img2sbuf_p0_wr_sel_03 |
                 img2sbuf_p1_wr_sel_03;
end

always @(
  dc2sbuf_p0_wr_sel_04
  or dc2sbuf_p1_wr_sel_04
  or wg2sbuf_p0_wr_sel_04
  or wg2sbuf_p1_wr_sel_04
  or img2sbuf_p0_wr_sel_04
  or img2sbuf_p1_wr_sel_04
  ) begin
    sbuf_we_04 = dc2sbuf_p0_wr_sel_04 |
                 dc2sbuf_p1_wr_sel_04 |
                 wg2sbuf_p0_wr_sel_04 |
                 wg2sbuf_p1_wr_sel_04 |
                 img2sbuf_p0_wr_sel_04 |
                 img2sbuf_p1_wr_sel_04;
end

always @(
  dc2sbuf_p0_wr_sel_05
  or dc2sbuf_p1_wr_sel_05
  or wg2sbuf_p0_wr_sel_05
  or wg2sbuf_p1_wr_sel_05
  or img2sbuf_p0_wr_sel_05
  or img2sbuf_p1_wr_sel_05
  ) begin
    sbuf_we_05 = dc2sbuf_p0_wr_sel_05 |
                 dc2sbuf_p1_wr_sel_05 |
                 wg2sbuf_p0_wr_sel_05 |
                 wg2sbuf_p1_wr_sel_05 |
                 img2sbuf_p0_wr_sel_05 |
                 img2sbuf_p1_wr_sel_05;
end

always @(
  dc2sbuf_p0_wr_sel_06
  or dc2sbuf_p1_wr_sel_06
  or wg2sbuf_p0_wr_sel_06
  or wg2sbuf_p1_wr_sel_06
  or img2sbuf_p0_wr_sel_06
  or img2sbuf_p1_wr_sel_06
  ) begin
    sbuf_we_06 = dc2sbuf_p0_wr_sel_06 |
                 dc2sbuf_p1_wr_sel_06 |
                 wg2sbuf_p0_wr_sel_06 |
                 wg2sbuf_p1_wr_sel_06 |
                 img2sbuf_p0_wr_sel_06 |
                 img2sbuf_p1_wr_sel_06;
end

always @(
  dc2sbuf_p0_wr_sel_07
  or dc2sbuf_p1_wr_sel_07
  or wg2sbuf_p0_wr_sel_07
  or wg2sbuf_p1_wr_sel_07
  or img2sbuf_p0_wr_sel_07
  or img2sbuf_p1_wr_sel_07
  ) begin
    sbuf_we_07 = dc2sbuf_p0_wr_sel_07 |
                 dc2sbuf_p1_wr_sel_07 |
                 wg2sbuf_p0_wr_sel_07 |
                 wg2sbuf_p1_wr_sel_07 |
                 img2sbuf_p0_wr_sel_07 |
                 img2sbuf_p1_wr_sel_07;
end

always @(
  dc2sbuf_p0_wr_sel_08
  or dc2sbuf_p1_wr_sel_08
  or wg2sbuf_p0_wr_sel_08
  or wg2sbuf_p1_wr_sel_08
  or img2sbuf_p0_wr_sel_08
  or img2sbuf_p1_wr_sel_08
  ) begin
    sbuf_we_08 = dc2sbuf_p0_wr_sel_08 |
                 dc2sbuf_p1_wr_sel_08 |
                 wg2sbuf_p0_wr_sel_08 |
                 wg2sbuf_p1_wr_sel_08 |
                 img2sbuf_p0_wr_sel_08 |
                 img2sbuf_p1_wr_sel_08;
end

always @(
  dc2sbuf_p0_wr_sel_09
  or dc2sbuf_p1_wr_sel_09
  or wg2sbuf_p0_wr_sel_09
  or wg2sbuf_p1_wr_sel_09
  or img2sbuf_p0_wr_sel_09
  or img2sbuf_p1_wr_sel_09
  ) begin
    sbuf_we_09 = dc2sbuf_p0_wr_sel_09 |
                 dc2sbuf_p1_wr_sel_09 |
                 wg2sbuf_p0_wr_sel_09 |
                 wg2sbuf_p1_wr_sel_09 |
                 img2sbuf_p0_wr_sel_09 |
                 img2sbuf_p1_wr_sel_09;
end

always @(
  dc2sbuf_p0_wr_sel_10
  or dc2sbuf_p1_wr_sel_10
  or wg2sbuf_p0_wr_sel_10
  or wg2sbuf_p1_wr_sel_10
  or img2sbuf_p0_wr_sel_10
  or img2sbuf_p1_wr_sel_10
  ) begin
    sbuf_we_10 = dc2sbuf_p0_wr_sel_10 |
                 dc2sbuf_p1_wr_sel_10 |
                 wg2sbuf_p0_wr_sel_10 |
                 wg2sbuf_p1_wr_sel_10 |
                 img2sbuf_p0_wr_sel_10 |
                 img2sbuf_p1_wr_sel_10;
end

always @(
  dc2sbuf_p0_wr_sel_11
  or dc2sbuf_p1_wr_sel_11
  or wg2sbuf_p0_wr_sel_11
  or wg2sbuf_p1_wr_sel_11
  or img2sbuf_p0_wr_sel_11
  or img2sbuf_p1_wr_sel_11
  ) begin
    sbuf_we_11 = dc2sbuf_p0_wr_sel_11 |
                 dc2sbuf_p1_wr_sel_11 |
                 wg2sbuf_p0_wr_sel_11 |
                 wg2sbuf_p1_wr_sel_11 |
                 img2sbuf_p0_wr_sel_11 |
                 img2sbuf_p1_wr_sel_11;
end

always @(
  dc2sbuf_p0_wr_sel_12
  or dc2sbuf_p1_wr_sel_12
  or wg2sbuf_p0_wr_sel_12
  or wg2sbuf_p1_wr_sel_12
  or img2sbuf_p0_wr_sel_12
  or img2sbuf_p1_wr_sel_12
  ) begin
    sbuf_we_12 = dc2sbuf_p0_wr_sel_12 |
                 dc2sbuf_p1_wr_sel_12 |
                 wg2sbuf_p0_wr_sel_12 |
                 wg2sbuf_p1_wr_sel_12 |
                 img2sbuf_p0_wr_sel_12 |
                 img2sbuf_p1_wr_sel_12;
end

always @(
  dc2sbuf_p0_wr_sel_13
  or dc2sbuf_p1_wr_sel_13
  or wg2sbuf_p0_wr_sel_13
  or wg2sbuf_p1_wr_sel_13
  or img2sbuf_p0_wr_sel_13
  or img2sbuf_p1_wr_sel_13
  ) begin
    sbuf_we_13 = dc2sbuf_p0_wr_sel_13 |
                 dc2sbuf_p1_wr_sel_13 |
                 wg2sbuf_p0_wr_sel_13 |
                 wg2sbuf_p1_wr_sel_13 |
                 img2sbuf_p0_wr_sel_13 |
                 img2sbuf_p1_wr_sel_13;
end

always @(
  dc2sbuf_p0_wr_sel_14
  or dc2sbuf_p1_wr_sel_14
  or wg2sbuf_p0_wr_sel_14
  or wg2sbuf_p1_wr_sel_14
  or img2sbuf_p0_wr_sel_14
  or img2sbuf_p1_wr_sel_14
  ) begin
    sbuf_we_14 = dc2sbuf_p0_wr_sel_14 |
                 dc2sbuf_p1_wr_sel_14 |
                 wg2sbuf_p0_wr_sel_14 |
                 wg2sbuf_p1_wr_sel_14 |
                 img2sbuf_p0_wr_sel_14 |
                 img2sbuf_p1_wr_sel_14;
end

always @(
  dc2sbuf_p0_wr_sel_15
  or dc2sbuf_p1_wr_sel_15
  or wg2sbuf_p0_wr_sel_15
  or wg2sbuf_p1_wr_sel_15
  or img2sbuf_p0_wr_sel_15
  or img2sbuf_p1_wr_sel_15
  ) begin
    sbuf_we_15 = dc2sbuf_p0_wr_sel_15 |
                 dc2sbuf_p1_wr_sel_15 |
                 wg2sbuf_p0_wr_sel_15 |
                 wg2sbuf_p1_wr_sel_15 |
                 img2sbuf_p0_wr_sel_15 |
                 img2sbuf_p1_wr_sel_15;
end

always @(
  dc2sbuf_p0_wr_sel_00
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_00
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_00
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_00
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_00
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_00
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_00 = ({4{dc2sbuf_p0_wr_sel_00}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_00}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_00}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_00}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_00}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_00}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_01
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_01
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_01
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_01
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_01
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_01
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_01 = ({4{dc2sbuf_p0_wr_sel_01}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_01}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_01}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_01}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_01}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_01}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_02
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_02
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_02
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_02
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_02
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_02
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_02 = ({4{dc2sbuf_p0_wr_sel_02}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_02}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_02}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_02}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_02}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_02}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_03
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_03
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_03
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_03
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_03
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_03
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_03 = ({4{dc2sbuf_p0_wr_sel_03}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_03}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_03}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_03}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_03}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_03}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_04
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_04
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_04
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_04
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_04
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_04
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_04 = ({4{dc2sbuf_p0_wr_sel_04}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_04}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_04}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_04}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_04}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_04}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_05
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_05
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_05
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_05
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_05
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_05
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_05 = ({4{dc2sbuf_p0_wr_sel_05}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_05}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_05}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_05}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_05}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_05}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_06
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_06
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_06
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_06
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_06
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_06
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_06 = ({4{dc2sbuf_p0_wr_sel_06}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_06}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_06}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_06}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_06}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_06}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_07
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_07
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_07
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_07
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_07
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_07
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_07 = ({4{dc2sbuf_p0_wr_sel_07}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_07}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_07}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_07}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_07}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_07}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_08
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_08
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_08
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_08
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_08
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_08
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_08 = ({4{dc2sbuf_p0_wr_sel_08}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_08}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_08}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_08}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_08}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_08}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_09
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_09
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_09
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_09
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_09
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_09
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_09 = ({4{dc2sbuf_p0_wr_sel_09}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_09}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_09}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_09}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_09}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_09}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_10
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_10
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_10
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_10
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_10
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_10
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_10 = ({4{dc2sbuf_p0_wr_sel_10}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_10}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_10}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_10}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_10}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_10}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_11
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_11
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_11
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_11
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_11
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_11
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_11 = ({4{dc2sbuf_p0_wr_sel_11}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_11}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_11}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_11}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_11}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_11}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_12
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_12
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_12
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_12
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_12
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_12
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_12 = ({4{dc2sbuf_p0_wr_sel_12}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_12}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_12}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_12}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_12}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_12}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_13
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_13
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_13
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_13
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_13
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_13
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_13 = ({4{dc2sbuf_p0_wr_sel_13}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_13}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_13}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_13}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_13}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_13}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_14
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_14
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_14
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_14
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_14
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_14
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_14 = ({4{dc2sbuf_p0_wr_sel_14}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_14}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_14}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_14}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_14}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_14}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_15
  or dc2sbuf_p0_wr_addr
  or dc2sbuf_p1_wr_sel_15
  or dc2sbuf_p1_wr_addr
  or wg2sbuf_p0_wr_sel_15
  or wg2sbuf_p0_wr_addr
  or wg2sbuf_p1_wr_sel_15
  or wg2sbuf_p1_wr_addr
  or img2sbuf_p0_wr_sel_15
  or img2sbuf_p0_wr_addr
  or img2sbuf_p1_wr_sel_15
  or img2sbuf_p1_wr_addr
  ) begin
    sbuf_wa_15 = ({4{dc2sbuf_p0_wr_sel_15}} & dc2sbuf_p0_wr_addr[3:0]) |
                 ({4{dc2sbuf_p1_wr_sel_15}} & dc2sbuf_p1_wr_addr[3:0]) |
                 ({4{wg2sbuf_p0_wr_sel_15}} & wg2sbuf_p0_wr_addr[3:0]) |
                 ({4{wg2sbuf_p1_wr_sel_15}} & wg2sbuf_p1_wr_addr[3:0]) |
                 ({4{img2sbuf_p0_wr_sel_15}} & img2sbuf_p0_wr_addr[3:0]) |
                 ({4{img2sbuf_p1_wr_sel_15}} & img2sbuf_p1_wr_addr[3:0]);
end

always @(
  dc2sbuf_p0_wr_sel_00
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_00
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_00
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_00
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_00
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_00
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_00 = ({256{dc2sbuf_p0_wr_sel_00}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_00}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_00}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_00}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_00}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_00}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_01
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_01
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_01
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_01
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_01
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_01
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_01 = ({256{dc2sbuf_p0_wr_sel_01}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_01}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_01}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_01}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_01}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_01}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_02
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_02
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_02
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_02
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_02
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_02
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_02 = ({256{dc2sbuf_p0_wr_sel_02}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_02}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_02}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_02}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_02}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_02}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_03
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_03
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_03
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_03
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_03
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_03
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_03 = ({256{dc2sbuf_p0_wr_sel_03}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_03}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_03}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_03}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_03}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_03}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_04
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_04
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_04
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_04
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_04
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_04
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_04 = ({256{dc2sbuf_p0_wr_sel_04}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_04}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_04}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_04}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_04}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_04}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_05
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_05
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_05
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_05
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_05
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_05
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_05 = ({256{dc2sbuf_p0_wr_sel_05}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_05}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_05}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_05}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_05}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_05}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_06
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_06
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_06
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_06
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_06
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_06
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_06 = ({256{dc2sbuf_p0_wr_sel_06}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_06}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_06}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_06}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_06}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_06}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_07
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_07
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_07
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_07
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_07
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_07
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_07 = ({256{dc2sbuf_p0_wr_sel_07}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_07}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_07}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_07}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_07}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_07}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_08
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_08
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_08
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_08
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_08
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_08
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_08 = ({256{dc2sbuf_p0_wr_sel_08}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_08}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_08}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_08}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_08}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_08}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_09
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_09
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_09
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_09
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_09
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_09
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_09 = ({256{dc2sbuf_p0_wr_sel_09}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_09}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_09}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_09}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_09}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_09}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_10
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_10
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_10
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_10
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_10
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_10
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_10 = ({256{dc2sbuf_p0_wr_sel_10}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_10}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_10}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_10}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_10}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_10}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_11
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_11
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_11
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_11
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_11
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_11
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_11 = ({256{dc2sbuf_p0_wr_sel_11}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_11}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_11}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_11}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_11}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_11}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_12
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_12
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_12
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_12
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_12
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_12
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_12 = ({256{dc2sbuf_p0_wr_sel_12}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_12}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_12}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_12}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_12}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_12}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_13
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_13
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_13
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_13
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_13
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_13
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_13 = ({256{dc2sbuf_p0_wr_sel_13}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_13}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_13}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_13}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_13}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_13}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_14
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_14
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_14
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_14
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_14
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_14
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_14 = ({256{dc2sbuf_p0_wr_sel_14}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_14}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_14}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_14}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_14}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_14}} & img2sbuf_p1_wr_data);
end

always @(
  dc2sbuf_p0_wr_sel_15
  or dc2sbuf_p0_wr_data
  or dc2sbuf_p1_wr_sel_15
  or dc2sbuf_p1_wr_data
  or wg2sbuf_p0_wr_sel_15
  or wg2sbuf_p0_wr_data
  or wg2sbuf_p1_wr_sel_15
  or wg2sbuf_p1_wr_data
  or img2sbuf_p0_wr_sel_15
  or img2sbuf_p0_wr_data
  or img2sbuf_p1_wr_sel_15
  or img2sbuf_p1_wr_data
  ) begin
    sbuf_wdat_15 = ({256{dc2sbuf_p0_wr_sel_15}} & dc2sbuf_p0_wr_data) |
                   ({256{dc2sbuf_p1_wr_sel_15}} & dc2sbuf_p1_wr_data) |
                   ({256{wg2sbuf_p0_wr_sel_15}} & wg2sbuf_p0_wr_data) |
                   ({256{wg2sbuf_p1_wr_sel_15}} & wg2sbuf_p1_wr_data) |
                   ({256{img2sbuf_p0_wr_sel_15}} & img2sbuf_p0_wr_data) |
                   ({256{img2sbuf_p1_wr_sel_15}} & img2sbuf_p1_wr_data);
end


////////////////////////////////////////////////////////////////////////\n";
// Instance 16 256bx8 RAMs as local shared buffers                    //\n";
////////////////////////////////////////////////////////////////////////\n";

nv_ram_rws_16x256 u_shared_buffer_00 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_00[3:0])     //|< r
  ,.re            (sbuf_re_00)          //|< r
  ,.dout          (sbuf_rdat_00[255:0]) //|> w
  ,.wa            (sbuf_wa_00[3:0])     //|< r
  ,.we            (sbuf_we_00)          //|< r
  ,.di            (sbuf_wdat_00[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_01 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_01[3:0])     //|< r
  ,.re            (sbuf_re_01)          //|< r
  ,.dout          (sbuf_rdat_01[255:0]) //|> w
  ,.wa            (sbuf_wa_01[3:0])     //|< r
  ,.we            (sbuf_we_01)          //|< r
  ,.di            (sbuf_wdat_01[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_02 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_02[3:0])     //|< r
  ,.re            (sbuf_re_02)          //|< r
  ,.dout          (sbuf_rdat_02[255:0]) //|> w
  ,.wa            (sbuf_wa_02[3:0])     //|< r
  ,.we            (sbuf_we_02)          //|< r
  ,.di            (sbuf_wdat_02[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_03 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_03[3:0])     //|< r
  ,.re            (sbuf_re_03)          //|< r
  ,.dout          (sbuf_rdat_03[255:0]) //|> w
  ,.wa            (sbuf_wa_03[3:0])     //|< r
  ,.we            (sbuf_we_03)          //|< r
  ,.di            (sbuf_wdat_03[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_04 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_04[3:0])     //|< r
  ,.re            (sbuf_re_04)          //|< r
  ,.dout          (sbuf_rdat_04[255:0]) //|> w
  ,.wa            (sbuf_wa_04[3:0])     //|< r
  ,.we            (sbuf_we_04)          //|< r
  ,.di            (sbuf_wdat_04[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_05 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_05[3:0])     //|< r
  ,.re            (sbuf_re_05)          //|< r
  ,.dout          (sbuf_rdat_05[255:0]) //|> w
  ,.wa            (sbuf_wa_05[3:0])     //|< r
  ,.we            (sbuf_we_05)          //|< r
  ,.di            (sbuf_wdat_05[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_06 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_06[3:0])     //|< r
  ,.re            (sbuf_re_06)          //|< r
  ,.dout          (sbuf_rdat_06[255:0]) //|> w
  ,.wa            (sbuf_wa_06[3:0])     //|< r
  ,.we            (sbuf_we_06)          //|< r
  ,.di            (sbuf_wdat_06[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_07 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_07[3:0])     //|< r
  ,.re            (sbuf_re_07)          //|< r
  ,.dout          (sbuf_rdat_07[255:0]) //|> w
  ,.wa            (sbuf_wa_07[3:0])     //|< r
  ,.we            (sbuf_we_07)          //|< r
  ,.di            (sbuf_wdat_07[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_08 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_08[3:0])     //|< r
  ,.re            (sbuf_re_08)          //|< r
  ,.dout          (sbuf_rdat_08[255:0]) //|> w
  ,.wa            (sbuf_wa_08[3:0])     //|< r
  ,.we            (sbuf_we_08)          //|< r
  ,.di            (sbuf_wdat_08[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_09 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_09[3:0])     //|< r
  ,.re            (sbuf_re_09)          //|< r
  ,.dout          (sbuf_rdat_09[255:0]) //|> w
  ,.wa            (sbuf_wa_09[3:0])     //|< r
  ,.we            (sbuf_we_09)          //|< r
  ,.di            (sbuf_wdat_09[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_10 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_10[3:0])     //|< r
  ,.re            (sbuf_re_10)          //|< r
  ,.dout          (sbuf_rdat_10[255:0]) //|> w
  ,.wa            (sbuf_wa_10[3:0])     //|< r
  ,.we            (sbuf_we_10)          //|< r
  ,.di            (sbuf_wdat_10[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_11 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_11[3:0])     //|< r
  ,.re            (sbuf_re_11)          //|< r
  ,.dout          (sbuf_rdat_11[255:0]) //|> w
  ,.wa            (sbuf_wa_11[3:0])     //|< r
  ,.we            (sbuf_we_11)          //|< r
  ,.di            (sbuf_wdat_11[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_12 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_12[3:0])     //|< r
  ,.re            (sbuf_re_12)          //|< r
  ,.dout          (sbuf_rdat_12[255:0]) //|> w
  ,.wa            (sbuf_wa_12[3:0])     //|< r
  ,.we            (sbuf_we_12)          //|< r
  ,.di            (sbuf_wdat_12[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_13 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_13[3:0])     //|< r
  ,.re            (sbuf_re_13)          //|< r
  ,.dout          (sbuf_rdat_13[255:0]) //|> w
  ,.wa            (sbuf_wa_13[3:0])     //|< r
  ,.we            (sbuf_we_13)          //|< r
  ,.di            (sbuf_wdat_13[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_14 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_14[3:0])     //|< r
  ,.re            (sbuf_re_14)          //|< r
  ,.dout          (sbuf_rdat_14[255:0]) //|> w
  ,.wa            (sbuf_wa_14[3:0])     //|< r
  ,.we            (sbuf_we_14)          //|< r
  ,.di            (sbuf_wdat_14[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


nv_ram_rws_16x256 u_shared_buffer_15 (
   .clk           (nvdla_core_clk)      //|< i
  ,.ra            (sbuf_ra_15[3:0])     //|< r
  ,.re            (sbuf_re_15)          //|< r
  ,.dout          (sbuf_rdat_15[255:0]) //|> w
  ,.wa            (sbuf_wa_15[3:0])     //|< r
  ,.we            (sbuf_we_15)          //|< r
  ,.di            (sbuf_wdat_15[255:0]) //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );


////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage 1                                       //\n";
////////////////////////////////////////////////////////////////////////\n";

assign dc2sbuf_p0_rd_bsel = dc2sbuf_p0_rd_addr[7:4];
assign dc2sbuf_p1_rd_bsel = dc2sbuf_p1_rd_addr[7:4];

assign img2sbuf_p0_rd_bsel = img2sbuf_p0_rd_addr[7:4];
assign img2sbuf_p1_rd_bsel = img2sbuf_p1_rd_addr[7:4];

assign wg2sbuf_p0_rd_bsel = wg2sbuf_p0_rd_addr[7:6];
assign wg2sbuf_p1_rd_bsel = wg2sbuf_p1_rd_addr[7:6];


always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_00 = (dc2sbuf_p0_rd_bsel == 4'd0) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_00 = (dc2sbuf_p1_rd_bsel == 4'd0) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_00 = (img2sbuf_p0_rd_bsel == 4'd0) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_00 = (img2sbuf_p1_rd_bsel == 4'd0) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_01 = (dc2sbuf_p0_rd_bsel == 4'd1) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_01 = (dc2sbuf_p1_rd_bsel == 4'd1) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_01 = (img2sbuf_p0_rd_bsel == 4'd1) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_01 = (img2sbuf_p1_rd_bsel == 4'd1) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_02 = (dc2sbuf_p0_rd_bsel == 4'd2) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_02 = (dc2sbuf_p1_rd_bsel == 4'd2) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_02 = (img2sbuf_p0_rd_bsel == 4'd2) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_02 = (img2sbuf_p1_rd_bsel == 4'd2) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_03 = (dc2sbuf_p0_rd_bsel == 4'd3) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_03 = (dc2sbuf_p1_rd_bsel == 4'd3) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_03 = (img2sbuf_p0_rd_bsel == 4'd3) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_03 = (img2sbuf_p1_rd_bsel == 4'd3) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_04 = (dc2sbuf_p0_rd_bsel == 4'd4) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_04 = (dc2sbuf_p1_rd_bsel == 4'd4) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_04 = (img2sbuf_p0_rd_bsel == 4'd4) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_04 = (img2sbuf_p1_rd_bsel == 4'd4) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_05 = (dc2sbuf_p0_rd_bsel == 4'd5) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_05 = (dc2sbuf_p1_rd_bsel == 4'd5) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_05 = (img2sbuf_p0_rd_bsel == 4'd5) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_05 = (img2sbuf_p1_rd_bsel == 4'd5) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_06 = (dc2sbuf_p0_rd_bsel == 4'd6) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_06 = (dc2sbuf_p1_rd_bsel == 4'd6) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_06 = (img2sbuf_p0_rd_bsel == 4'd6) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_06 = (img2sbuf_p1_rd_bsel == 4'd6) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_07 = (dc2sbuf_p0_rd_bsel == 4'd7) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_07 = (dc2sbuf_p1_rd_bsel == 4'd7) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_07 = (img2sbuf_p0_rd_bsel == 4'd7) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_07 = (img2sbuf_p1_rd_bsel == 4'd7) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_08 = (dc2sbuf_p0_rd_bsel == 4'd8) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_08 = (dc2sbuf_p1_rd_bsel == 4'd8) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_08 = (img2sbuf_p0_rd_bsel == 4'd8) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_08 = (img2sbuf_p1_rd_bsel == 4'd8) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_09 = (dc2sbuf_p0_rd_bsel == 4'd9) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_09 = (dc2sbuf_p1_rd_bsel == 4'd9) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_09 = (img2sbuf_p0_rd_bsel == 4'd9) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_09 = (img2sbuf_p1_rd_bsel == 4'd9) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_10 = (dc2sbuf_p0_rd_bsel == 4'd10) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_10 = (dc2sbuf_p1_rd_bsel == 4'd10) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_10 = (img2sbuf_p0_rd_bsel == 4'd10) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_10 = (img2sbuf_p1_rd_bsel == 4'd10) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_11 = (dc2sbuf_p0_rd_bsel == 4'd11) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_11 = (dc2sbuf_p1_rd_bsel == 4'd11) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_11 = (img2sbuf_p0_rd_bsel == 4'd11) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_11 = (img2sbuf_p1_rd_bsel == 4'd11) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_12 = (dc2sbuf_p0_rd_bsel == 4'd12) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_12 = (dc2sbuf_p1_rd_bsel == 4'd12) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_12 = (img2sbuf_p0_rd_bsel == 4'd12) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_12 = (img2sbuf_p1_rd_bsel == 4'd12) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_13 = (dc2sbuf_p0_rd_bsel == 4'd13) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_13 = (dc2sbuf_p1_rd_bsel == 4'd13) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_13 = (img2sbuf_p0_rd_bsel == 4'd13) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_13 = (img2sbuf_p1_rd_bsel == 4'd13) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_14 = (dc2sbuf_p0_rd_bsel == 4'd14) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_14 = (dc2sbuf_p1_rd_bsel == 4'd14) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_14 = (img2sbuf_p0_rd_bsel == 4'd14) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_14 = (img2sbuf_p1_rd_bsel == 4'd14) & img2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_bsel
  or dc2sbuf_p0_rd_en
  ) begin
    dc2sbuf_p0_rd_sel_15 = (dc2sbuf_p0_rd_bsel == 4'd15) & dc2sbuf_p0_rd_en;
end

always @(
  dc2sbuf_p1_rd_bsel
  or dc2sbuf_p1_rd_en
  ) begin
    dc2sbuf_p1_rd_sel_15 = (dc2sbuf_p1_rd_bsel == 4'd15) & dc2sbuf_p1_rd_en;
end

always @(
  img2sbuf_p0_rd_bsel
  or img2sbuf_p0_rd_en
  ) begin
    img2sbuf_p0_rd_sel_15 = (img2sbuf_p0_rd_bsel == 4'd15) & img2sbuf_p0_rd_en;
end

always @(
  img2sbuf_p1_rd_bsel
  or img2sbuf_p1_rd_en
  ) begin
    img2sbuf_p1_rd_sel_15 = (img2sbuf_p1_rd_bsel == 4'd15) & img2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_00 = (wg2sbuf_p0_rd_bsel == 2'd0) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_00 = (wg2sbuf_p1_rd_bsel == 2'd0) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_01 = (wg2sbuf_p0_rd_bsel == 2'd0) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_01 = (wg2sbuf_p1_rd_bsel == 2'd0) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_02 = (wg2sbuf_p0_rd_bsel == 2'd0) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_02 = (wg2sbuf_p1_rd_bsel == 2'd0) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_03 = (wg2sbuf_p0_rd_bsel == 2'd0) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_03 = (wg2sbuf_p1_rd_bsel == 2'd0) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_04 = (wg2sbuf_p0_rd_bsel == 2'd1) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_04 = (wg2sbuf_p1_rd_bsel == 2'd1) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_05 = (wg2sbuf_p0_rd_bsel == 2'd1) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_05 = (wg2sbuf_p1_rd_bsel == 2'd1) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_06 = (wg2sbuf_p0_rd_bsel == 2'd1) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_06 = (wg2sbuf_p1_rd_bsel == 2'd1) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_07 = (wg2sbuf_p0_rd_bsel == 2'd1) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_07 = (wg2sbuf_p1_rd_bsel == 2'd1) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_08 = (wg2sbuf_p0_rd_bsel == 2'd2) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_08 = (wg2sbuf_p1_rd_bsel == 2'd2) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_09 = (wg2sbuf_p0_rd_bsel == 2'd2) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_09 = (wg2sbuf_p1_rd_bsel == 2'd2) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_10 = (wg2sbuf_p0_rd_bsel == 2'd2) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_10 = (wg2sbuf_p1_rd_bsel == 2'd2) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_11 = (wg2sbuf_p0_rd_bsel == 2'd2) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_11 = (wg2sbuf_p1_rd_bsel == 2'd2) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_12 = (wg2sbuf_p0_rd_bsel == 2'd3) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_12 = (wg2sbuf_p1_rd_bsel == 2'd3) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_13 = (wg2sbuf_p0_rd_bsel == 2'd3) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_13 = (wg2sbuf_p1_rd_bsel == 2'd3) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_14 = (wg2sbuf_p0_rd_bsel == 2'd3) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_14 = (wg2sbuf_p1_rd_bsel == 2'd3) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p0_rd_bsel
  or wg2sbuf_p0_rd_en
  ) begin
    wg2sbuf_p0_rd_sel_15 = (wg2sbuf_p0_rd_bsel == 2'd3) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_bsel
  or wg2sbuf_p1_rd_en
  ) begin
    wg2sbuf_p1_rd_sel_15 = (wg2sbuf_p1_rd_bsel == 2'd3) & wg2sbuf_p1_rd_en;
end

always @(
  dc2sbuf_p0_rd_sel_00
  or wg2sbuf_p0_rd_sel_00
  or img2sbuf_p0_rd_sel_00
  ) begin
    sbuf_p0_re_00 = dc2sbuf_p0_rd_sel_00 | wg2sbuf_p0_rd_sel_00 | img2sbuf_p0_rd_sel_00;
end

always @(
  dc2sbuf_p1_rd_sel_00
  or wg2sbuf_p1_rd_sel_00
  or img2sbuf_p1_rd_sel_00
  ) begin
    sbuf_p1_re_00 = dc2sbuf_p1_rd_sel_00 | wg2sbuf_p1_rd_sel_00 | img2sbuf_p1_rd_sel_00;
end

always @(
  dc2sbuf_p0_rd_sel_01
  or wg2sbuf_p0_rd_sel_01
  or img2sbuf_p0_rd_sel_01
  ) begin
    sbuf_p0_re_01 = dc2sbuf_p0_rd_sel_01 | wg2sbuf_p0_rd_sel_01 | img2sbuf_p0_rd_sel_01;
end

always @(
  dc2sbuf_p1_rd_sel_01
  or wg2sbuf_p1_rd_sel_01
  or img2sbuf_p1_rd_sel_01
  ) begin
    sbuf_p1_re_01 = dc2sbuf_p1_rd_sel_01 | wg2sbuf_p1_rd_sel_01 | img2sbuf_p1_rd_sel_01;
end

always @(
  dc2sbuf_p0_rd_sel_02
  or wg2sbuf_p0_rd_sel_02
  or img2sbuf_p0_rd_sel_02
  ) begin
    sbuf_p0_re_02 = dc2sbuf_p0_rd_sel_02 | wg2sbuf_p0_rd_sel_02 | img2sbuf_p0_rd_sel_02;
end

always @(
  dc2sbuf_p1_rd_sel_02
  or wg2sbuf_p1_rd_sel_02
  or img2sbuf_p1_rd_sel_02
  ) begin
    sbuf_p1_re_02 = dc2sbuf_p1_rd_sel_02 | wg2sbuf_p1_rd_sel_02 | img2sbuf_p1_rd_sel_02;
end

always @(
  dc2sbuf_p0_rd_sel_03
  or wg2sbuf_p0_rd_sel_03
  or img2sbuf_p0_rd_sel_03
  ) begin
    sbuf_p0_re_03 = dc2sbuf_p0_rd_sel_03 | wg2sbuf_p0_rd_sel_03 | img2sbuf_p0_rd_sel_03;
end

always @(
  dc2sbuf_p1_rd_sel_03
  or wg2sbuf_p1_rd_sel_03
  or img2sbuf_p1_rd_sel_03
  ) begin
    sbuf_p1_re_03 = dc2sbuf_p1_rd_sel_03 | wg2sbuf_p1_rd_sel_03 | img2sbuf_p1_rd_sel_03;
end

always @(
  dc2sbuf_p0_rd_sel_04
  or wg2sbuf_p0_rd_sel_04
  or img2sbuf_p0_rd_sel_04
  ) begin
    sbuf_p0_re_04 = dc2sbuf_p0_rd_sel_04 | wg2sbuf_p0_rd_sel_04 | img2sbuf_p0_rd_sel_04;
end

always @(
  dc2sbuf_p1_rd_sel_04
  or wg2sbuf_p1_rd_sel_04
  or img2sbuf_p1_rd_sel_04
  ) begin
    sbuf_p1_re_04 = dc2sbuf_p1_rd_sel_04 | wg2sbuf_p1_rd_sel_04 | img2sbuf_p1_rd_sel_04;
end

always @(
  dc2sbuf_p0_rd_sel_05
  or wg2sbuf_p0_rd_sel_05
  or img2sbuf_p0_rd_sel_05
  ) begin
    sbuf_p0_re_05 = dc2sbuf_p0_rd_sel_05 | wg2sbuf_p0_rd_sel_05 | img2sbuf_p0_rd_sel_05;
end

always @(
  dc2sbuf_p1_rd_sel_05
  or wg2sbuf_p1_rd_sel_05
  or img2sbuf_p1_rd_sel_05
  ) begin
    sbuf_p1_re_05 = dc2sbuf_p1_rd_sel_05 | wg2sbuf_p1_rd_sel_05 | img2sbuf_p1_rd_sel_05;
end

always @(
  dc2sbuf_p0_rd_sel_06
  or wg2sbuf_p0_rd_sel_06
  or img2sbuf_p0_rd_sel_06
  ) begin
    sbuf_p0_re_06 = dc2sbuf_p0_rd_sel_06 | wg2sbuf_p0_rd_sel_06 | img2sbuf_p0_rd_sel_06;
end

always @(
  dc2sbuf_p1_rd_sel_06
  or wg2sbuf_p1_rd_sel_06
  or img2sbuf_p1_rd_sel_06
  ) begin
    sbuf_p1_re_06 = dc2sbuf_p1_rd_sel_06 | wg2sbuf_p1_rd_sel_06 | img2sbuf_p1_rd_sel_06;
end

always @(
  dc2sbuf_p0_rd_sel_07
  or wg2sbuf_p0_rd_sel_07
  or img2sbuf_p0_rd_sel_07
  ) begin
    sbuf_p0_re_07 = dc2sbuf_p0_rd_sel_07 | wg2sbuf_p0_rd_sel_07 | img2sbuf_p0_rd_sel_07;
end

always @(
  dc2sbuf_p1_rd_sel_07
  or wg2sbuf_p1_rd_sel_07
  or img2sbuf_p1_rd_sel_07
  ) begin
    sbuf_p1_re_07 = dc2sbuf_p1_rd_sel_07 | wg2sbuf_p1_rd_sel_07 | img2sbuf_p1_rd_sel_07;
end

always @(
  dc2sbuf_p0_rd_sel_08
  or wg2sbuf_p0_rd_sel_08
  or img2sbuf_p0_rd_sel_08
  ) begin
    sbuf_p0_re_08 = dc2sbuf_p0_rd_sel_08 | wg2sbuf_p0_rd_sel_08 | img2sbuf_p0_rd_sel_08;
end

always @(
  dc2sbuf_p1_rd_sel_08
  or wg2sbuf_p1_rd_sel_08
  or img2sbuf_p1_rd_sel_08
  ) begin
    sbuf_p1_re_08 = dc2sbuf_p1_rd_sel_08 | wg2sbuf_p1_rd_sel_08 | img2sbuf_p1_rd_sel_08;
end

always @(
  dc2sbuf_p0_rd_sel_09
  or wg2sbuf_p0_rd_sel_09
  or img2sbuf_p0_rd_sel_09
  ) begin
    sbuf_p0_re_09 = dc2sbuf_p0_rd_sel_09 | wg2sbuf_p0_rd_sel_09 | img2sbuf_p0_rd_sel_09;
end

always @(
  dc2sbuf_p1_rd_sel_09
  or wg2sbuf_p1_rd_sel_09
  or img2sbuf_p1_rd_sel_09
  ) begin
    sbuf_p1_re_09 = dc2sbuf_p1_rd_sel_09 | wg2sbuf_p1_rd_sel_09 | img2sbuf_p1_rd_sel_09;
end

always @(
  dc2sbuf_p0_rd_sel_10
  or wg2sbuf_p0_rd_sel_10
  or img2sbuf_p0_rd_sel_10
  ) begin
    sbuf_p0_re_10 = dc2sbuf_p0_rd_sel_10 | wg2sbuf_p0_rd_sel_10 | img2sbuf_p0_rd_sel_10;
end

always @(
  dc2sbuf_p1_rd_sel_10
  or wg2sbuf_p1_rd_sel_10
  or img2sbuf_p1_rd_sel_10
  ) begin
    sbuf_p1_re_10 = dc2sbuf_p1_rd_sel_10 | wg2sbuf_p1_rd_sel_10 | img2sbuf_p1_rd_sel_10;
end

always @(
  dc2sbuf_p0_rd_sel_11
  or wg2sbuf_p0_rd_sel_11
  or img2sbuf_p0_rd_sel_11
  ) begin
    sbuf_p0_re_11 = dc2sbuf_p0_rd_sel_11 | wg2sbuf_p0_rd_sel_11 | img2sbuf_p0_rd_sel_11;
end

always @(
  dc2sbuf_p1_rd_sel_11
  or wg2sbuf_p1_rd_sel_11
  or img2sbuf_p1_rd_sel_11
  ) begin
    sbuf_p1_re_11 = dc2sbuf_p1_rd_sel_11 | wg2sbuf_p1_rd_sel_11 | img2sbuf_p1_rd_sel_11;
end

always @(
  dc2sbuf_p0_rd_sel_12
  or wg2sbuf_p0_rd_sel_12
  or img2sbuf_p0_rd_sel_12
  ) begin
    sbuf_p0_re_12 = dc2sbuf_p0_rd_sel_12 | wg2sbuf_p0_rd_sel_12 | img2sbuf_p0_rd_sel_12;
end

always @(
  dc2sbuf_p1_rd_sel_12
  or wg2sbuf_p1_rd_sel_12
  or img2sbuf_p1_rd_sel_12
  ) begin
    sbuf_p1_re_12 = dc2sbuf_p1_rd_sel_12 | wg2sbuf_p1_rd_sel_12 | img2sbuf_p1_rd_sel_12;
end

always @(
  dc2sbuf_p0_rd_sel_13
  or wg2sbuf_p0_rd_sel_13
  or img2sbuf_p0_rd_sel_13
  ) begin
    sbuf_p0_re_13 = dc2sbuf_p0_rd_sel_13 | wg2sbuf_p0_rd_sel_13 | img2sbuf_p0_rd_sel_13;
end

always @(
  dc2sbuf_p1_rd_sel_13
  or wg2sbuf_p1_rd_sel_13
  or img2sbuf_p1_rd_sel_13
  ) begin
    sbuf_p1_re_13 = dc2sbuf_p1_rd_sel_13 | wg2sbuf_p1_rd_sel_13 | img2sbuf_p1_rd_sel_13;
end

always @(
  dc2sbuf_p0_rd_sel_14
  or wg2sbuf_p0_rd_sel_14
  or img2sbuf_p0_rd_sel_14
  ) begin
    sbuf_p0_re_14 = dc2sbuf_p0_rd_sel_14 | wg2sbuf_p0_rd_sel_14 | img2sbuf_p0_rd_sel_14;
end

always @(
  dc2sbuf_p1_rd_sel_14
  or wg2sbuf_p1_rd_sel_14
  or img2sbuf_p1_rd_sel_14
  ) begin
    sbuf_p1_re_14 = dc2sbuf_p1_rd_sel_14 | wg2sbuf_p1_rd_sel_14 | img2sbuf_p1_rd_sel_14;
end

always @(
  dc2sbuf_p0_rd_sel_15
  or wg2sbuf_p0_rd_sel_15
  or img2sbuf_p0_rd_sel_15
  ) begin
    sbuf_p0_re_15 = dc2sbuf_p0_rd_sel_15 | wg2sbuf_p0_rd_sel_15 | img2sbuf_p0_rd_sel_15;
end

always @(
  dc2sbuf_p1_rd_sel_15
  or wg2sbuf_p1_rd_sel_15
  or img2sbuf_p1_rd_sel_15
  ) begin
    sbuf_p1_re_15 = dc2sbuf_p1_rd_sel_15 | wg2sbuf_p1_rd_sel_15 | img2sbuf_p1_rd_sel_15;
end

always @(
  sbuf_p0_re_00
  or sbuf_p1_re_00
  ) begin
    sbuf_re_00 = sbuf_p0_re_00 | sbuf_p1_re_00;
end

always @(
  sbuf_p0_re_01
  or sbuf_p1_re_01
  ) begin
    sbuf_re_01 = sbuf_p0_re_01 | sbuf_p1_re_01;
end

always @(
  sbuf_p0_re_02
  or sbuf_p1_re_02
  ) begin
    sbuf_re_02 = sbuf_p0_re_02 | sbuf_p1_re_02;
end

always @(
  sbuf_p0_re_03
  or sbuf_p1_re_03
  ) begin
    sbuf_re_03 = sbuf_p0_re_03 | sbuf_p1_re_03;
end

always @(
  sbuf_p0_re_04
  or sbuf_p1_re_04
  ) begin
    sbuf_re_04 = sbuf_p0_re_04 | sbuf_p1_re_04;
end

always @(
  sbuf_p0_re_05
  or sbuf_p1_re_05
  ) begin
    sbuf_re_05 = sbuf_p0_re_05 | sbuf_p1_re_05;
end

always @(
  sbuf_p0_re_06
  or sbuf_p1_re_06
  ) begin
    sbuf_re_06 = sbuf_p0_re_06 | sbuf_p1_re_06;
end

always @(
  sbuf_p0_re_07
  or sbuf_p1_re_07
  ) begin
    sbuf_re_07 = sbuf_p0_re_07 | sbuf_p1_re_07;
end

always @(
  sbuf_p0_re_08
  or sbuf_p1_re_08
  ) begin
    sbuf_re_08 = sbuf_p0_re_08 | sbuf_p1_re_08;
end

always @(
  sbuf_p0_re_09
  or sbuf_p1_re_09
  ) begin
    sbuf_re_09 = sbuf_p0_re_09 | sbuf_p1_re_09;
end

always @(
  sbuf_p0_re_10
  or sbuf_p1_re_10
  ) begin
    sbuf_re_10 = sbuf_p0_re_10 | sbuf_p1_re_10;
end

always @(
  sbuf_p0_re_11
  or sbuf_p1_re_11
  ) begin
    sbuf_re_11 = sbuf_p0_re_11 | sbuf_p1_re_11;
end

always @(
  sbuf_p0_re_12
  or sbuf_p1_re_12
  ) begin
    sbuf_re_12 = sbuf_p0_re_12 | sbuf_p1_re_12;
end

always @(
  sbuf_p0_re_13
  or sbuf_p1_re_13
  ) begin
    sbuf_re_13 = sbuf_p0_re_13 | sbuf_p1_re_13;
end

always @(
  sbuf_p0_re_14
  or sbuf_p1_re_14
  ) begin
    sbuf_re_14 = sbuf_p0_re_14 | sbuf_p1_re_14;
end

always @(
  sbuf_p0_re_15
  or sbuf_p1_re_15
  ) begin
    sbuf_re_15 = sbuf_p0_re_15 | sbuf_p1_re_15;
end


assign dc2sbuf_p0_rd_esel = dc2sbuf_p0_rd_addr[3:0];
assign dc2sbuf_p1_rd_esel = dc2sbuf_p1_rd_addr[3:0];

assign img2sbuf_p0_rd_esel = img2sbuf_p0_rd_addr[3:0];
assign img2sbuf_p1_rd_esel = img2sbuf_p1_rd_addr[3:0];

assign wg2sbuf_p0_rd_esel = wg2sbuf_p0_rd_addr[5:2];
assign wg2sbuf_p1_rd_esel = wg2sbuf_p1_rd_addr[5:2];
always @(
  dc2sbuf_p0_rd_sel_00
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_00
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_00
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_00
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_00
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_00
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_00 = ({4{dc2sbuf_p0_rd_sel_00}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_00}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_00}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_00}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_00}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_00}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_01
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_01
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_01
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_01
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_01
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_01
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_01 = ({4{dc2sbuf_p0_rd_sel_01}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_01}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_01}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_01}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_01}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_01}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_02
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_02
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_02
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_02
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_02
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_02
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_02 = ({4{dc2sbuf_p0_rd_sel_02}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_02}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_02}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_02}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_02}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_02}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_03
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_03
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_03
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_03
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_03
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_03
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_03 = ({4{dc2sbuf_p0_rd_sel_03}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_03}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_03}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_03}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_03}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_03}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_04
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_04
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_04
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_04
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_04
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_04
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_04 = ({4{dc2sbuf_p0_rd_sel_04}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_04}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_04}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_04}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_04}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_04}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_05
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_05
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_05
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_05
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_05
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_05
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_05 = ({4{dc2sbuf_p0_rd_sel_05}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_05}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_05}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_05}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_05}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_05}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_06
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_06
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_06
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_06
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_06
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_06
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_06 = ({4{dc2sbuf_p0_rd_sel_06}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_06}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_06}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_06}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_06}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_06}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_07
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_07
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_07
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_07
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_07
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_07
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_07 = ({4{dc2sbuf_p0_rd_sel_07}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_07}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_07}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_07}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_07}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_07}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_08
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_08
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_08
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_08
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_08
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_08
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_08 = ({4{dc2sbuf_p0_rd_sel_08}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_08}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_08}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_08}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_08}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_08}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_09
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_09
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_09
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_09
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_09
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_09
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_09 = ({4{dc2sbuf_p0_rd_sel_09}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_09}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_09}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_09}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_09}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_09}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_10
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_10
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_10
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_10
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_10
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_10
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_10 = ({4{dc2sbuf_p0_rd_sel_10}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_10}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_10}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_10}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_10}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_10}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_11
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_11
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_11
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_11
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_11
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_11
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_11 = ({4{dc2sbuf_p0_rd_sel_11}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_11}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_11}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_11}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_11}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_11}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_12
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_12
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_12
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_12
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_12
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_12
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_12 = ({4{dc2sbuf_p0_rd_sel_12}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_12}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_12}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_12}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_12}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_12}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_13
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_13
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_13
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_13
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_13
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_13
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_13 = ({4{dc2sbuf_p0_rd_sel_13}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_13}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_13}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_13}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_13}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_13}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_14
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_14
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_14
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_14
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_14
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_14
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_14 = ({4{dc2sbuf_p0_rd_sel_14}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_14}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_14}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_14}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_14}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_14}} & img2sbuf_p1_rd_esel);
end

always @(
  dc2sbuf_p0_rd_sel_15
  or dc2sbuf_p0_rd_esel
  or dc2sbuf_p1_rd_sel_15
  or dc2sbuf_p1_rd_esel
  or wg2sbuf_p0_rd_sel_15
  or wg2sbuf_p0_rd_esel
  or wg2sbuf_p1_rd_sel_15
  or wg2sbuf_p1_rd_esel
  or img2sbuf_p0_rd_sel_15
  or img2sbuf_p0_rd_esel
  or img2sbuf_p1_rd_sel_15
  or img2sbuf_p1_rd_esel
  ) begin
    sbuf_ra_15 = ({4{dc2sbuf_p0_rd_sel_15}} & dc2sbuf_p0_rd_esel) |
                 ({4{dc2sbuf_p1_rd_sel_15}} & dc2sbuf_p1_rd_esel) |
                 ({4{wg2sbuf_p0_rd_sel_15}} & wg2sbuf_p0_rd_esel) |
                 ({4{wg2sbuf_p1_rd_sel_15}} & wg2sbuf_p1_rd_esel) |
                 ({4{img2sbuf_p0_rd_sel_15}} & img2sbuf_p0_rd_esel) |
                 ({4{img2sbuf_p1_rd_sel_15}} & img2sbuf_p1_rd_esel);
end



always @(
  wg2sbuf_p0_rd_addr
  or wg2sbuf_p0_rd_en
  ) begin
    sbuf_p0_wg_sel_q0 = (wg2sbuf_p0_rd_addr[1:0] == 2'h0) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p0_rd_addr
  or wg2sbuf_p0_rd_en
  ) begin
    sbuf_p0_wg_sel_q1 = (wg2sbuf_p0_rd_addr[1:0] == 2'h1) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p0_rd_addr
  or wg2sbuf_p0_rd_en
  ) begin
    sbuf_p0_wg_sel_q2 = (wg2sbuf_p0_rd_addr[1:0] == 2'h2) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p0_rd_addr
  or wg2sbuf_p0_rd_en
  ) begin
    sbuf_p0_wg_sel_q3 = (wg2sbuf_p0_rd_addr[1:0] == 2'h3) & wg2sbuf_p0_rd_en;
end

always @(
  wg2sbuf_p1_rd_addr
  or wg2sbuf_p1_rd_en
  ) begin
    sbuf_p1_wg_sel_q0 = (wg2sbuf_p1_rd_addr[1:0] == 2'h0) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p1_rd_addr
  or wg2sbuf_p1_rd_en
  ) begin
    sbuf_p1_wg_sel_q1 = (wg2sbuf_p1_rd_addr[1:0] == 2'h1) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p1_rd_addr
  or wg2sbuf_p1_rd_en
  ) begin
    sbuf_p1_wg_sel_q2 = (wg2sbuf_p1_rd_addr[1:0] == 2'h2) & wg2sbuf_p1_rd_en;
end

always @(
  wg2sbuf_p1_rd_addr
  or wg2sbuf_p1_rd_en
  ) begin
    sbuf_p1_wg_sel_q3 = (wg2sbuf_p1_rd_addr[1:0] == 2'h3) & wg2sbuf_p1_rd_en;
end




////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage1 register                               //\n";
////////////////////////////////////////////////////////////////////////\n";
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_00_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_00_norm_d1 <= sbuf_p0_re_00 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_00_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_00_norm_d1 <= sbuf_p1_re_00 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_01_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_01_norm_d1 <= sbuf_p0_re_01 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_01_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_01_norm_d1 <= sbuf_p1_re_01 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_02_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_02_norm_d1 <= sbuf_p0_re_02 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_02_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_02_norm_d1 <= sbuf_p1_re_02 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_03_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_03_norm_d1 <= sbuf_p0_re_03 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_03_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_03_norm_d1 <= sbuf_p1_re_03 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_04_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_04_norm_d1 <= sbuf_p0_re_04 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_04_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_04_norm_d1 <= sbuf_p1_re_04 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_05_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_05_norm_d1 <= sbuf_p0_re_05 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_05_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_05_norm_d1 <= sbuf_p1_re_05 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_06_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_06_norm_d1 <= sbuf_p0_re_06 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_06_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_06_norm_d1 <= sbuf_p1_re_06 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_07_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_07_norm_d1 <= sbuf_p0_re_07 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_07_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_07_norm_d1 <= sbuf_p1_re_07 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_08_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_08_norm_d1 <= sbuf_p0_re_08 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_08_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_08_norm_d1 <= sbuf_p1_re_08 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_09_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_09_norm_d1 <= sbuf_p0_re_09 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_09_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_09_norm_d1 <= sbuf_p1_re_09 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_10_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_10_norm_d1 <= sbuf_p0_re_10 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_10_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_10_norm_d1 <= sbuf_p1_re_10 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_11_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_11_norm_d1 <= sbuf_p0_re_11 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_11_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_11_norm_d1 <= sbuf_p1_re_11 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_12_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_12_norm_d1 <= sbuf_p0_re_12 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_12_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_12_norm_d1 <= sbuf_p1_re_12 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_13_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_13_norm_d1 <= sbuf_p0_re_13 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_13_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_13_norm_d1 <= sbuf_p1_re_13 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_14_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_14_norm_d1 <= sbuf_p0_re_14 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_14_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_14_norm_d1 <= sbuf_p1_re_14 & ~wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_15_norm_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_15_norm_d1 <= sbuf_p0_re_15 & ~wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_15_norm_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_15_norm_d1 <= sbuf_p1_re_15 & ~wg2sbuf_p1_rd_en;
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_00_wg_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_00_wg_d1 <= sbuf_p0_re_00 & wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_00_wg_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_00_wg_d1 <= sbuf_p1_re_00 & wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_01_wg_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_01_wg_d1 <= sbuf_p0_re_04 & wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_01_wg_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_01_wg_d1 <= sbuf_p1_re_04 & wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_02_wg_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_02_wg_d1 <= sbuf_p0_re_08 & wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_02_wg_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_02_wg_d1 <= sbuf_p1_re_08 & wg2sbuf_p1_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_re_03_wg_d1 <= 1'b0;
  end else begin
  sbuf_p0_re_03_wg_d1 <= sbuf_p0_re_12 & wg2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_re_03_wg_d1 <= 1'b0;
  end else begin
  sbuf_p1_re_03_wg_d1 <= sbuf_p1_re_12 & wg2sbuf_p1_rd_en;
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_wg_sel_q0_d1 <= 1'b0;
  end else begin
  sbuf_p0_wg_sel_q0_d1 <= sbuf_p0_wg_sel_q0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_wg_sel_q1_d1 <= 1'b0;
  end else begin
  sbuf_p0_wg_sel_q1_d1 <= sbuf_p0_wg_sel_q1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_wg_sel_q2_d1 <= 1'b0;
  end else begin
  sbuf_p0_wg_sel_q2_d1 <= sbuf_p0_wg_sel_q2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_wg_sel_q3_d1 <= 1'b0;
  end else begin
  sbuf_p0_wg_sel_q3_d1 <= sbuf_p0_wg_sel_q3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_wg_sel_q0_d1 <= 1'b0;
  end else begin
  sbuf_p1_wg_sel_q0_d1 <= sbuf_p1_wg_sel_q0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_wg_sel_q1_d1 <= 1'b0;
  end else begin
  sbuf_p1_wg_sel_q1_d1 <= sbuf_p1_wg_sel_q1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_wg_sel_q2_d1 <= 1'b0;
  end else begin
  sbuf_p1_wg_sel_q2_d1 <= sbuf_p1_wg_sel_q2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_wg_sel_q3_d1 <= 1'b0;
  end else begin
  sbuf_p1_wg_sel_q3_d1 <= sbuf_p1_wg_sel_q3;
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p0_rd_en_d1 <= 1'b0;
  end else begin
  sbuf_p0_rd_en_d1 <= dc2sbuf_p0_rd_en | wg2sbuf_p0_rd_en | img2sbuf_p0_rd_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sbuf_p1_rd_en_d1 <= 1'b0;
  end else begin
  sbuf_p1_rd_en_d1 <= dc2sbuf_p1_rd_en | wg2sbuf_p1_rd_en | img2sbuf_p1_rd_en;
  end
end



////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage2                                        //\n";
////////////////////////////////////////////////////////////////////////\n";
always @(
  sbuf_p0_re_00_norm_d1
  or sbuf_rdat_00
  or sbuf_p0_re_01_norm_d1
  or sbuf_rdat_01
  or sbuf_p0_re_02_norm_d1
  or sbuf_rdat_02
  or sbuf_p0_re_03_norm_d1
  or sbuf_rdat_03
  or sbuf_p0_re_04_norm_d1
  or sbuf_rdat_04
  or sbuf_p0_re_05_norm_d1
  or sbuf_rdat_05
  or sbuf_p0_re_06_norm_d1
  or sbuf_rdat_06
  or sbuf_p0_re_07_norm_d1
  or sbuf_rdat_07
  or sbuf_p0_re_08_norm_d1
  or sbuf_rdat_08
  or sbuf_p0_re_09_norm_d1
  or sbuf_rdat_09
  or sbuf_p0_re_10_norm_d1
  or sbuf_rdat_10
  or sbuf_p0_re_11_norm_d1
  or sbuf_rdat_11
  or sbuf_p0_re_12_norm_d1
  or sbuf_rdat_12
  or sbuf_p0_re_13_norm_d1
  or sbuf_rdat_13
  or sbuf_p0_re_14_norm_d1
  or sbuf_rdat_14
  or sbuf_p0_re_15_norm_d1
  or sbuf_rdat_15
  ) begin
    sbuf_p0_norm_rdat = ({256  {sbuf_p0_re_00_norm_d1}} & sbuf_rdat_00) |
                        ({256  {sbuf_p0_re_01_norm_d1}} & sbuf_rdat_01) |
                        ({256  {sbuf_p0_re_02_norm_d1}} & sbuf_rdat_02) |
                        ({256  {sbuf_p0_re_03_norm_d1}} & sbuf_rdat_03) |
                        ({256  {sbuf_p0_re_04_norm_d1}} & sbuf_rdat_04) |
                        ({256  {sbuf_p0_re_05_norm_d1}} & sbuf_rdat_05) |
                        ({256  {sbuf_p0_re_06_norm_d1}} & sbuf_rdat_06) |
                        ({256  {sbuf_p0_re_07_norm_d1}} & sbuf_rdat_07) |
                        ({256  {sbuf_p0_re_08_norm_d1}} & sbuf_rdat_08) |
                        ({256  {sbuf_p0_re_09_norm_d1}} & sbuf_rdat_09) |
                        ({256  {sbuf_p0_re_10_norm_d1}} & sbuf_rdat_10) |
                        ({256  {sbuf_p0_re_11_norm_d1}} & sbuf_rdat_11) |
                        ({256  {sbuf_p0_re_12_norm_d1}} & sbuf_rdat_12) |
                        ({256  {sbuf_p0_re_13_norm_d1}} & sbuf_rdat_13) |
                        ({256  {sbuf_p0_re_14_norm_d1}} & sbuf_rdat_14) |
                        ({256  {sbuf_p0_re_15_norm_d1}} & sbuf_rdat_15);
end

always @(
  sbuf_p1_re_00_norm_d1
  or sbuf_rdat_00
  or sbuf_p1_re_01_norm_d1
  or sbuf_rdat_01
  or sbuf_p1_re_02_norm_d1
  or sbuf_rdat_02
  or sbuf_p1_re_03_norm_d1
  or sbuf_rdat_03
  or sbuf_p1_re_04_norm_d1
  or sbuf_rdat_04
  or sbuf_p1_re_05_norm_d1
  or sbuf_rdat_05
  or sbuf_p1_re_06_norm_d1
  or sbuf_rdat_06
  or sbuf_p1_re_07_norm_d1
  or sbuf_rdat_07
  or sbuf_p1_re_08_norm_d1
  or sbuf_rdat_08
  or sbuf_p1_re_09_norm_d1
  or sbuf_rdat_09
  or sbuf_p1_re_10_norm_d1
  or sbuf_rdat_10
  or sbuf_p1_re_11_norm_d1
  or sbuf_rdat_11
  or sbuf_p1_re_12_norm_d1
  or sbuf_rdat_12
  or sbuf_p1_re_13_norm_d1
  or sbuf_rdat_13
  or sbuf_p1_re_14_norm_d1
  or sbuf_rdat_14
  or sbuf_p1_re_15_norm_d1
  or sbuf_rdat_15
  ) begin
    sbuf_p1_norm_rdat = ({256  {sbuf_p1_re_00_norm_d1}} & sbuf_rdat_00) |
                        ({256  {sbuf_p1_re_01_norm_d1}} & sbuf_rdat_01) |
                        ({256  {sbuf_p1_re_02_norm_d1}} & sbuf_rdat_02) |
                        ({256  {sbuf_p1_re_03_norm_d1}} & sbuf_rdat_03) |
                        ({256  {sbuf_p1_re_04_norm_d1}} & sbuf_rdat_04) |
                        ({256  {sbuf_p1_re_05_norm_d1}} & sbuf_rdat_05) |
                        ({256  {sbuf_p1_re_06_norm_d1}} & sbuf_rdat_06) |
                        ({256  {sbuf_p1_re_07_norm_d1}} & sbuf_rdat_07) |
                        ({256  {sbuf_p1_re_08_norm_d1}} & sbuf_rdat_08) |
                        ({256  {sbuf_p1_re_09_norm_d1}} & sbuf_rdat_09) |
                        ({256  {sbuf_p1_re_10_norm_d1}} & sbuf_rdat_10) |
                        ({256  {sbuf_p1_re_11_norm_d1}} & sbuf_rdat_11) |
                        ({256  {sbuf_p1_re_12_norm_d1}} & sbuf_rdat_12) |
                        ({256  {sbuf_p1_re_13_norm_d1}} & sbuf_rdat_13) |
                        ({256  {sbuf_p1_re_14_norm_d1}} & sbuf_rdat_14) |
                        ({256  {sbuf_p1_re_15_norm_d1}} & sbuf_rdat_15);
end



always @(
  sbuf_p0_re_00_wg_d1
  or sbuf_rdat_00
  or sbuf_p0_re_01_wg_d1
  or sbuf_rdat_04
  or sbuf_p0_re_02_wg_d1
  or sbuf_rdat_08
  or sbuf_p0_re_03_wg_d1
  or sbuf_rdat_12
  ) begin
    sbuf_p0_wg_rdat_src_0 = ({256  {sbuf_p0_re_00_wg_d1}} & sbuf_rdat_00) |
                            ({256  {sbuf_p0_re_01_wg_d1}} & sbuf_rdat_04) |
                            ({256  {sbuf_p0_re_02_wg_d1}} & sbuf_rdat_08) |
                            ({256  {sbuf_p0_re_03_wg_d1}} & sbuf_rdat_12);
end

always @(
  sbuf_p0_re_00_wg_d1
  or sbuf_rdat_01
  or sbuf_p0_re_01_wg_d1
  or sbuf_rdat_05
  or sbuf_p0_re_02_wg_d1
  or sbuf_rdat_09
  or sbuf_p0_re_03_wg_d1
  or sbuf_rdat_13
  ) begin
    sbuf_p0_wg_rdat_src_1 = ({256  {sbuf_p0_re_00_wg_d1}} & sbuf_rdat_01) |
                            ({256  {sbuf_p0_re_01_wg_d1}} & sbuf_rdat_05) |
                            ({256  {sbuf_p0_re_02_wg_d1}} & sbuf_rdat_09) |
                            ({256  {sbuf_p0_re_03_wg_d1}} & sbuf_rdat_13);
end

always @(
  sbuf_p0_re_00_wg_d1
  or sbuf_rdat_02
  or sbuf_p0_re_01_wg_d1
  or sbuf_rdat_06
  or sbuf_p0_re_02_wg_d1
  or sbuf_rdat_10
  or sbuf_p0_re_03_wg_d1
  or sbuf_rdat_14
  ) begin
    sbuf_p0_wg_rdat_src_2 = ({256  {sbuf_p0_re_00_wg_d1}} & sbuf_rdat_02) |
                            ({256  {sbuf_p0_re_01_wg_d1}} & sbuf_rdat_06) |
                            ({256  {sbuf_p0_re_02_wg_d1}} & sbuf_rdat_10) |
                            ({256  {sbuf_p0_re_03_wg_d1}} & sbuf_rdat_14);
end

always @(
  sbuf_p0_re_00_wg_d1
  or sbuf_rdat_03
  or sbuf_p0_re_01_wg_d1
  or sbuf_rdat_07
  or sbuf_p0_re_02_wg_d1
  or sbuf_rdat_11
  or sbuf_p0_re_03_wg_d1
  or sbuf_rdat_15
  ) begin
    sbuf_p0_wg_rdat_src_3 = ({256  {sbuf_p0_re_00_wg_d1}} & sbuf_rdat_03) |
                            ({256  {sbuf_p0_re_01_wg_d1}} & sbuf_rdat_07) |
                            ({256  {sbuf_p0_re_02_wg_d1}} & sbuf_rdat_11) |
                            ({256  {sbuf_p0_re_03_wg_d1}} & sbuf_rdat_15);
end

always @(
  sbuf_p1_re_00_wg_d1
  or sbuf_rdat_00
  or sbuf_p1_re_01_wg_d1
  or sbuf_rdat_04
  or sbuf_p1_re_02_wg_d1
  or sbuf_rdat_08
  or sbuf_p1_re_03_wg_d1
  or sbuf_rdat_12
  ) begin
    sbuf_p1_wg_rdat_src_0 = ({256  {sbuf_p1_re_00_wg_d1}} & sbuf_rdat_00) |
                            ({256  {sbuf_p1_re_01_wg_d1}} & sbuf_rdat_04) |
                            ({256  {sbuf_p1_re_02_wg_d1}} & sbuf_rdat_08) |
                            ({256  {sbuf_p1_re_03_wg_d1}} & sbuf_rdat_12);
end

always @(
  sbuf_p1_re_00_wg_d1
  or sbuf_rdat_01
  or sbuf_p1_re_01_wg_d1
  or sbuf_rdat_05
  or sbuf_p1_re_02_wg_d1
  or sbuf_rdat_09
  or sbuf_p1_re_03_wg_d1
  or sbuf_rdat_13
  ) begin
    sbuf_p1_wg_rdat_src_1 = ({256  {sbuf_p1_re_00_wg_d1}} & sbuf_rdat_01) |
                            ({256  {sbuf_p1_re_01_wg_d1}} & sbuf_rdat_05) |
                            ({256  {sbuf_p1_re_02_wg_d1}} & sbuf_rdat_09) |
                            ({256  {sbuf_p1_re_03_wg_d1}} & sbuf_rdat_13);
end

always @(
  sbuf_p1_re_00_wg_d1
  or sbuf_rdat_02
  or sbuf_p1_re_01_wg_d1
  or sbuf_rdat_06
  or sbuf_p1_re_02_wg_d1
  or sbuf_rdat_10
  or sbuf_p1_re_03_wg_d1
  or sbuf_rdat_14
  ) begin
    sbuf_p1_wg_rdat_src_2 = ({256  {sbuf_p1_re_00_wg_d1}} & sbuf_rdat_02) |
                            ({256  {sbuf_p1_re_01_wg_d1}} & sbuf_rdat_06) |
                            ({256  {sbuf_p1_re_02_wg_d1}} & sbuf_rdat_10) |
                            ({256  {sbuf_p1_re_03_wg_d1}} & sbuf_rdat_14);
end

always @(
  sbuf_p1_re_00_wg_d1
  or sbuf_rdat_03
  or sbuf_p1_re_01_wg_d1
  or sbuf_rdat_07
  or sbuf_p1_re_02_wg_d1
  or sbuf_rdat_11
  or sbuf_p1_re_03_wg_d1
  or sbuf_rdat_15
  ) begin
    sbuf_p1_wg_rdat_src_3 = ({256  {sbuf_p1_re_00_wg_d1}} & sbuf_rdat_03) |
                            ({256  {sbuf_p1_re_01_wg_d1}} & sbuf_rdat_07) |
                            ({256  {sbuf_p1_re_02_wg_d1}} & sbuf_rdat_11) |
                            ({256  {sbuf_p1_re_03_wg_d1}} & sbuf_rdat_15);
end



always @(
  sbuf_p0_wg_sel_q0_d1
  or sbuf_p0_wg_rdat_src_3
  or sbuf_p0_wg_rdat_src_2
  or sbuf_p0_wg_rdat_src_1
  or sbuf_p0_wg_rdat_src_0
  or sbuf_p0_wg_sel_q1_d1
  or sbuf_p0_wg_sel_q2_d1
  or sbuf_p0_wg_sel_q3_d1
  ) begin
    sbuf_p0_wg_rdat = ({256  {sbuf_p0_wg_sel_q0_d1}} & {sbuf_p0_wg_rdat_src_3[63:0], sbuf_p0_wg_rdat_src_2[63:0], sbuf_p0_wg_rdat_src_1[63:0], sbuf_p0_wg_rdat_src_0[63:0]}) |
                      ({256  {sbuf_p0_wg_sel_q1_d1}} & {sbuf_p0_wg_rdat_src_3[127:64], sbuf_p0_wg_rdat_src_2[127:64], sbuf_p0_wg_rdat_src_1[127:64], sbuf_p0_wg_rdat_src_0[127:64]}) |
                      ({256  {sbuf_p0_wg_sel_q2_d1}} & {sbuf_p0_wg_rdat_src_3[191:128], sbuf_p0_wg_rdat_src_2[191:128], sbuf_p0_wg_rdat_src_1[191:128], sbuf_p0_wg_rdat_src_0[191:128]}) |
                      ({256  {sbuf_p0_wg_sel_q3_d1}} & {sbuf_p0_wg_rdat_src_3[255:192], sbuf_p0_wg_rdat_src_2[255:192], sbuf_p0_wg_rdat_src_1[255:192], sbuf_p0_wg_rdat_src_0[255:192]});
end
always @(
  sbuf_p1_wg_sel_q0_d1
  or sbuf_p1_wg_rdat_src_3
  or sbuf_p1_wg_rdat_src_2
  or sbuf_p1_wg_rdat_src_1
  or sbuf_p1_wg_rdat_src_0
  or sbuf_p1_wg_sel_q1_d1
  or sbuf_p1_wg_sel_q2_d1
  or sbuf_p1_wg_sel_q3_d1
  ) begin
    sbuf_p1_wg_rdat = ({256  {sbuf_p1_wg_sel_q0_d1}} & {sbuf_p1_wg_rdat_src_3[63:0], sbuf_p1_wg_rdat_src_2[63:0], sbuf_p1_wg_rdat_src_1[63:0], sbuf_p1_wg_rdat_src_0[63:0]}) |
                      ({256  {sbuf_p1_wg_sel_q1_d1}} & {sbuf_p1_wg_rdat_src_3[127:64], sbuf_p1_wg_rdat_src_2[127:64], sbuf_p1_wg_rdat_src_1[127:64], sbuf_p1_wg_rdat_src_0[127:64]}) |
                      ({256  {sbuf_p1_wg_sel_q2_d1}} & {sbuf_p1_wg_rdat_src_3[191:128], sbuf_p1_wg_rdat_src_2[191:128], sbuf_p1_wg_rdat_src_1[191:128], sbuf_p1_wg_rdat_src_0[191:128]}) |
                      ({256  {sbuf_p1_wg_sel_q3_d1}} & {sbuf_p1_wg_rdat_src_3[255:192], sbuf_p1_wg_rdat_src_2[255:192], sbuf_p1_wg_rdat_src_1[255:192], sbuf_p1_wg_rdat_src_0[255:192]});
end


always @(
  sbuf_p0_norm_rdat
  or sbuf_p0_wg_rdat
  ) begin
    sbuf_p0_rdat = sbuf_p0_norm_rdat | sbuf_p0_wg_rdat;
end
always @(
  sbuf_p1_norm_rdat
  or sbuf_p1_wg_rdat
  ) begin
    sbuf_p1_rdat = sbuf_p1_norm_rdat | sbuf_p1_wg_rdat;
end



////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage2 register                               //\n";
////////////////////////////////////////////////////////////////////////\n";
always @(posedge nvdla_core_clk) begin
  if ((sbuf_p0_rd_en_d1) == 1'b1) begin
    sbuf_p0_rdat_d2 <= sbuf_p0_rdat;
  // VCS coverage off
  end else if ((sbuf_p0_rd_en_d1) == 1'b0) begin
  end else begin
    sbuf_p0_rdat_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sbuf_p1_rd_en_d1) == 1'b1) begin
    sbuf_p1_rdat_d2 <= sbuf_p1_rdat;
  // VCS coverage off
  end else if ((sbuf_p1_rd_en_d1) == 1'b0) begin
  end else begin
    sbuf_p1_rdat_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: connect output data signal                    //\n";
////////////////////////////////////////////////////////////////////////\n";
assign dc2sbuf_p0_rd_data = sbuf_p0_rdat_d2;
assign wg2sbuf_p0_rd_data = sbuf_p0_rdat_d2;
assign img2sbuf_p0_rd_data = sbuf_p0_rdat_d2;
assign dc2sbuf_p1_rd_data = sbuf_p1_rdat_d2;
assign wg2sbuf_p1_rd_data = sbuf_p1_rdat_d2;
assign img2sbuf_p1_rd_data = sbuf_p1_rdat_d2;

////////////////////////////////////////////////////////////////////////\n";
// Assertion                                                          //\n";
////////////////////////////////////////////////////////////////////////\n";
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"multiple write to shared buffer")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_wr_en | dc2sbuf_p1_wr_en) & (wg2sbuf_p0_wr_en | wg2sbuf_p1_wr_en)) |                                                              ((dc2sbuf_p0_wr_en | dc2sbuf_p1_wr_en) & (img2sbuf_p0_wr_en | img2sbuf_p1_wr_en)) |                                                              ((wg2sbuf_p0_wr_en | wg2sbuf_p1_wr_en) & (img2sbuf_p0_wr_en | img2sbuf_p1_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"multiple read to shared buffer")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_rd_en | dc2sbuf_p1_rd_en) & (wg2sbuf_p0_rd_en | wg2sbuf_p1_rd_en)) |                                                             ((dc2sbuf_p0_rd_en | dc2sbuf_p1_rd_en) & (img2sbuf_p0_rd_en | img2sbuf_p1_rd_en)) |                                                             ((wg2sbuf_p0_rd_en | wg2sbuf_p1_rd_en) & (img2sbuf_p0_rd_en | img2sbuf_p1_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"dc write same buffer")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_wr_en & dc2sbuf_p1_wr_en & (dc2sbuf_p0_wr_bsel == dc2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"wg write same buffer")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (wg2sbuf_p0_wr_en & wg2sbuf_p1_wr_en & (wg2sbuf_p0_wr_bsel == wg2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"img write same buffer")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_wr_en & img2sbuf_p1_wr_en & (img2sbuf_p0_wr_bsel == img2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"dc read same buffer")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_rd_en & dc2sbuf_p1_rd_en & (dc2sbuf_p0_rd_bsel == dc2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"wg read same buffer")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (wg2sbuf_p0_rd_en & wg2sbuf_p1_rd_en & (wg2sbuf_p0_rd_bsel == wg2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"img read same buffer")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_rd_en & img2sbuf_p1_rd_en & (img2sbuf_p0_rd_bsel == img2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 00 read and write hazard!")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_00 & sbuf_we_00 & (sbuf_ra_00 == sbuf_wa_00))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 01 read and write hazard!")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_01 & sbuf_we_01 & (sbuf_ra_01 == sbuf_wa_01))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 02 read and write hazard!")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_02 & sbuf_we_02 & (sbuf_ra_02 == sbuf_wa_02))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 03 read and write hazard!")      zzz_assert_never_12x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_03 & sbuf_we_03 & (sbuf_ra_03 == sbuf_wa_03))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 04 read and write hazard!")      zzz_assert_never_13x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_04 & sbuf_we_04 & (sbuf_ra_04 == sbuf_wa_04))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 05 read and write hazard!")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_05 & sbuf_we_05 & (sbuf_ra_05 == sbuf_wa_05))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 06 read and write hazard!")      zzz_assert_never_15x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_06 & sbuf_we_06 & (sbuf_ra_06 == sbuf_wa_06))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 07 read and write hazard!")      zzz_assert_never_16x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_07 & sbuf_we_07 & (sbuf_ra_07 == sbuf_wa_07))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 08 read and write hazard!")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_08 & sbuf_we_08 & (sbuf_ra_08 == sbuf_wa_08))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 09 read and write hazard!")      zzz_assert_never_18x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_09 & sbuf_we_09 & (sbuf_ra_09 == sbuf_wa_09))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 10 read and write hazard!")      zzz_assert_never_19x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_10 & sbuf_we_10 & (sbuf_ra_10 == sbuf_wa_10))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 11 read and write hazard!")      zzz_assert_never_20x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_11 & sbuf_we_11 & (sbuf_ra_11 == sbuf_wa_11))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 12 read and write hazard!")      zzz_assert_never_21x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_12 & sbuf_we_12 & (sbuf_ra_12 == sbuf_wa_12))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 13 read and write hazard!")      zzz_assert_never_22x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_13 & sbuf_we_13 & (sbuf_ra_13 == sbuf_wa_13))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 14 read and write hazard!")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_14 & sbuf_we_14 & (sbuf_ra_14 == sbuf_wa_14))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! shared ram 15 read and write hazard!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_15 & sbuf_we_15 & (sbuf_ra_15 == sbuf_wa_15))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

endmodule // NV_NVDLA_CDMA_shared_buffer


