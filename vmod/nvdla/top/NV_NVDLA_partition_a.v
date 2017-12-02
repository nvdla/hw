// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_a.v

`ifdef NV_HWACC
`include "NV_HWACC_NVDLA_tick_defines.vh"
`endif


module NV_NVDLA_partition_a (
   cacc2sdp_ready                //|< i
  ,csb2cacc_req_dst_pd           //|< i
  ,csb2cacc_req_dst_pvld         //|< i
  ,direct_reset_                 //|< i
  ,dla_reset_rstn                //|< i
  ,global_clk_ovr_on             //|< i
  ,mac_a2accu_dst_data0          //|< i
  ,mac_a2accu_dst_data1          //|< i
  ,mac_a2accu_dst_data2          //|< i
  ,mac_a2accu_dst_data3          //|< i
  ,mac_a2accu_dst_data4          //|< i
  ,mac_a2accu_dst_data5          //|< i
  ,mac_a2accu_dst_data6          //|< i
  ,mac_a2accu_dst_data7          //|< i
  ,mac_a2accu_dst_mask           //|< i
  ,mac_a2accu_dst_mode           //|< i
  ,mac_a2accu_dst_pd             //|< i
  ,mac_a2accu_dst_pvld           //|< i
  ,mac_b2accu_src_data0          //|< i
  ,mac_b2accu_src_data1          //|< i
  ,mac_b2accu_src_data2          //|< i
  ,mac_b2accu_src_data3          //|< i
  ,mac_b2accu_src_data4          //|< i
  ,mac_b2accu_src_data5          //|< i
  ,mac_b2accu_src_data6          //|< i
  ,mac_b2accu_src_data7          //|< i
  ,mac_b2accu_src_mask           //|< i
  ,mac_b2accu_src_mode           //|< i
  ,mac_b2accu_src_pd             //|< i
  ,mac_b2accu_src_pvld           //|< i
  ,nvdla_clk_ovr_on              //|< i
  ,nvdla_core_clk                //|< i
  ,pwrbus_ram_pd                 //|< i
  ,test_mode                     //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,accu2sc_credit_size           //|> o
  ,accu2sc_credit_vld            //|> o
  ,cacc2csb_resp_src_pd          //|> o
  ,cacc2csb_resp_src_valid       //|> o
  ,cacc2glb_done_intr_src_pd     //|> o
  ,cacc2sdp_pd                   //|> o
  ,cacc2sdp_valid                //|> o
  ,csb2cacc_req_dst_prdy         //|> o
  );

//
// NV_NVDLA_partition_a_io.v
//

input  test_mode;
input  direct_reset_;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

output       accu2sc_credit_vld;   /* data valid */
output [2:0] accu2sc_credit_size;

output        cacc2csb_resp_src_valid;  /* data valid */
output [33:0] cacc2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output [1:0] cacc2glb_done_intr_src_pd;

output         cacc2sdp_valid;  /* data valid */
input          cacc2sdp_ready;  /* data return handshake */
output [513:0] cacc2sdp_pd;

input         csb2cacc_req_dst_pvld;  /* data valid */
output        csb2cacc_req_dst_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_dst_pd;

input         mac_a2accu_dst_pvld;   /* data valid */
input   [7:0] mac_a2accu_dst_mask;
input   [7:0] mac_a2accu_dst_mode;
input [175:0] mac_a2accu_dst_data0;
input [175:0] mac_a2accu_dst_data1;
input [175:0] mac_a2accu_dst_data2;
input [175:0] mac_a2accu_dst_data3;
input [175:0] mac_a2accu_dst_data4;
input [175:0] mac_a2accu_dst_data5;
input [175:0] mac_a2accu_dst_data6;
input [175:0] mac_a2accu_dst_data7;
input   [8:0] mac_a2accu_dst_pd;

input         mac_b2accu_src_pvld;   /* data valid */
input   [7:0] mac_b2accu_src_mask;
input   [7:0] mac_b2accu_src_mode;
input [175:0] mac_b2accu_src_data0;
input [175:0] mac_b2accu_src_data1;
input [175:0] mac_b2accu_src_data2;
input [175:0] mac_b2accu_src_data3;
input [175:0] mac_b2accu_src_data4;
input [175:0] mac_b2accu_src_data5;
input [175:0] mac_b2accu_src_data6;
input [175:0] mac_b2accu_src_data7;
input   [8:0] mac_b2accu_src_pd;

input [31:0] pwrbus_ram_pd;

//input  la_r_clk;           
//input  larstn;             

input  nvdla_core_clk;     
input  dla_reset_rstn;     

input         nvdla_clk_ovr_on;

wire          dla_clk_ovr_on_sync;
wire          global_clk_ovr_on_sync;
wire  [175:0] mac_b2accu_dst_data0;
wire  [175:0] mac_b2accu_dst_data1;
wire  [175:0] mac_b2accu_dst_data2;
wire  [175:0] mac_b2accu_dst_data3;
wire  [175:0] mac_b2accu_dst_data4;
wire  [175:0] mac_b2accu_dst_data5;
wire  [175:0] mac_b2accu_dst_data6;
wire  [175:0] mac_b2accu_dst_data7;
wire    [7:0] mac_b2accu_dst_mask;
wire    [7:0] mac_b2accu_dst_mode;
wire    [8:0] mac_b2accu_dst_pd;
wire          mac_b2accu_dst_pvld;
wire          nvdla_core_rstn;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition M:    Reset Syncer                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_a_reset (
   .dla_reset_rstn                (dla_reset_rstn)                 //|< i
  ,.direct_reset_                 (direct_reset_)                  //|< i
  ,.test_mode                     (test_mode)                      //|< i
  ,.synced_rstn                   (nvdla_core_rstn)                //|> w
  ,.nvdla_clk                     (nvdla_core_clk)                 //|< i
  );

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.sync_i                        (nvdla_clk_ovr_on)               //|< i
  ,.sync_o                        (dla_clk_ovr_on_sync)            //|> w
  );

NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.prst                          (nvdla_core_rstn)                //|< w
  ,.sync_i                        (global_clk_ovr_on)              //|< i
  ,.sync_o                        (global_clk_ovr_on_sync)         //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:     Convolution Accumulator                    //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cacc u_NV_NVDLA_cacc (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.csb2cacc_req_pvld             (csb2cacc_req_dst_pvld)          //|< i
  ,.csb2cacc_req_prdy             (csb2cacc_req_dst_prdy)          //|> o
  ,.csb2cacc_req_pd               (csb2cacc_req_dst_pd[62:0])      //|< i
  ,.cacc2csb_resp_valid           (cacc2csb_resp_src_valid)        //|> o
  ,.cacc2csb_resp_pd              (cacc2csb_resp_src_pd[33:0])     //|> o
  ,.mac_a2accu_pvld               (mac_a2accu_dst_pvld)            //|< i
  ,.mac_a2accu_mask               (mac_a2accu_dst_mask[7:0])       //|< i
  ,.mac_a2accu_mode               (mac_a2accu_dst_mode[7:0])       //|< i
  ,.mac_a2accu_data0              (mac_a2accu_dst_data0[175:0])    //|< i
  ,.mac_a2accu_data1              (mac_a2accu_dst_data1[175:0])    //|< i
  ,.mac_a2accu_data2              (mac_a2accu_dst_data2[175:0])    //|< i
  ,.mac_a2accu_data3              (mac_a2accu_dst_data3[175:0])    //|< i
  ,.mac_a2accu_data4              (mac_a2accu_dst_data4[175:0])    //|< i
  ,.mac_a2accu_data5              (mac_a2accu_dst_data5[175:0])    //|< i
  ,.mac_a2accu_data6              (mac_a2accu_dst_data6[175:0])    //|< i
  ,.mac_a2accu_data7              (mac_a2accu_dst_data7[175:0])    //|< i
  ,.mac_a2accu_pd                 (mac_a2accu_dst_pd[8:0])         //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_dst_pvld)            //|< w
  ,.mac_b2accu_mask               (mac_b2accu_dst_mask[7:0])       //|< w
  ,.mac_b2accu_mode               (mac_b2accu_dst_mode[7:0])       //|< w
  ,.mac_b2accu_data0              (mac_b2accu_dst_data0[175:0])    //|< w
  ,.mac_b2accu_data1              (mac_b2accu_dst_data1[175:0])    //|< w
  ,.mac_b2accu_data2              (mac_b2accu_dst_data2[175:0])    //|< w
  ,.mac_b2accu_data3              (mac_b2accu_dst_data3[175:0])    //|< w
  ,.mac_b2accu_data4              (mac_b2accu_dst_data4[175:0])    //|< w
  ,.mac_b2accu_data5              (mac_b2accu_dst_data5[175:0])    //|< w
  ,.mac_b2accu_data6              (mac_b2accu_dst_data6[175:0])    //|< w
  ,.mac_b2accu_data7              (mac_b2accu_dst_data7[175:0])    //|< w
  ,.mac_b2accu_pd                 (mac_b2accu_dst_pd[8:0])         //|< w
  ,.cacc2sdp_valid                (cacc2sdp_valid)                 //|> o
  ,.cacc2sdp_ready                (cacc2sdp_ready)                 //|< i
  ,.cacc2sdp_pd                   (cacc2sdp_pd[513:0])             //|> o
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)             //|> o
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])       //|> o
  ,.cacc2glb_done_intr_pd         (cacc2glb_done_intr_src_pd[1:0]) //|> o
  ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)  //|< i
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:    Retiming path cmac_b->cacc                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_cmac_b2cacc u_NV_NVDLA_RT_cmac_b2cacc (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.mac2accu_src_pvld             (mac_b2accu_src_pvld)            //|< i
  ,.mac2accu_src_mask             (mac_b2accu_src_mask[7:0])       //|< i
  ,.mac2accu_src_mode             (mac_b2accu_src_mode[7:0])       //|< i
  ,.mac2accu_src_data0            (mac_b2accu_src_data0[175:0])    //|< i
  ,.mac2accu_src_data1            (mac_b2accu_src_data1[175:0])    //|< i
  ,.mac2accu_src_data2            (mac_b2accu_src_data2[175:0])    //|< i
  ,.mac2accu_src_data3            (mac_b2accu_src_data3[175:0])    //|< i
  ,.mac2accu_src_data4            (mac_b2accu_src_data4[175:0])    //|< i
  ,.mac2accu_src_data5            (mac_b2accu_src_data5[175:0])    //|< i
  ,.mac2accu_src_data6            (mac_b2accu_src_data6[175:0])    //|< i
  ,.mac2accu_src_data7            (mac_b2accu_src_data7[175:0])    //|< i
  ,.mac2accu_src_pd               (mac_b2accu_src_pd[8:0])         //|< i
  ,.mac2accu_dst_pvld             (mac_b2accu_dst_pvld)            //|> w
  ,.mac2accu_dst_mask             (mac_b2accu_dst_mask[7:0])       //|> w
  ,.mac2accu_dst_mode             (mac_b2accu_dst_mode[7:0])       //|> w
  ,.mac2accu_dst_data0            (mac_b2accu_dst_data0[175:0])    //|> w
  ,.mac2accu_dst_data1            (mac_b2accu_dst_data1[175:0])    //|> w
  ,.mac2accu_dst_data2            (mac_b2accu_dst_data2[175:0])    //|> w
  ,.mac2accu_dst_data3            (mac_b2accu_dst_data3[175:0])    //|> w
  ,.mac2accu_dst_data4            (mac_b2accu_dst_data4[175:0])    //|> w
  ,.mac2accu_dst_data5            (mac_b2accu_dst_data5[175:0])    //|> w
  ,.mac2accu_dst_data6            (mac_b2accu_dst_data6[175:0])    //|> w
  ,.mac2accu_dst_data7            (mac_b2accu_dst_data7[175:0])    //|> w
  ,.mac2accu_dst_pd               (mac_b2accu_dst_pd[8:0])         //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition A:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_A_obs;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_a


