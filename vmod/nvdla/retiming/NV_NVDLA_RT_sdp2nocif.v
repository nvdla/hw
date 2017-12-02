// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_sdp2nocif.v

module NV_NVDLA_RT_sdp2nocif (
   nvdla_core_clk                     //|< i
  ,nvdla_core_rstn                    //|< i
  ,sdp2mcif_rd_req_src_valid          //|< i
  ,sdp2mcif_rd_req_src_ready          //|> o
  ,sdp2mcif_rd_req_src_pd             //|< i
  ,sdp2mcif_rd_req_dst_valid          //|> o
  ,sdp2mcif_rd_req_dst_ready          //|< i
  ,sdp2mcif_rd_req_dst_pd             //|> o
  ,sdp2cvif_rd_req_src_valid          //|< i
  ,sdp2cvif_rd_req_src_ready          //|> o
  ,sdp2cvif_rd_req_src_pd             //|< i
  ,sdp2cvif_rd_req_dst_valid          //|> o
  ,sdp2cvif_rd_req_dst_ready          //|< i
  ,sdp2cvif_rd_req_dst_pd             //|> o
  ,sdp2mcif_rd_cdt_src_lat_fifo_pop   //|< i
  ,sdp2mcif_rd_cdt_dst_lat_fifo_pop   //|> o
  ,sdp2cvif_rd_cdt_src_lat_fifo_pop   //|< i
  ,sdp2cvif_rd_cdt_dst_lat_fifo_pop   //|> o
  ,mcif2sdp_rd_rsp_src_valid          //|< i
  ,mcif2sdp_rd_rsp_src_ready          //|> o
  ,mcif2sdp_rd_rsp_src_pd             //|< i
  ,mcif2sdp_rd_rsp_dst_valid          //|> o
  ,mcif2sdp_rd_rsp_dst_ready          //|< i
  ,mcif2sdp_rd_rsp_dst_pd             //|> o
  ,cvif2sdp_rd_rsp_src_valid          //|< i
  ,cvif2sdp_rd_rsp_src_ready          //|> o
  ,cvif2sdp_rd_rsp_src_pd             //|< i
  ,cvif2sdp_rd_rsp_dst_valid          //|> o
  ,cvif2sdp_rd_rsp_dst_ready          //|< i
  ,cvif2sdp_rd_rsp_dst_pd             //|> o
  ,sdp_b2mcif_rd_req_src_valid        //|< i
  ,sdp_b2mcif_rd_req_src_ready        //|> o
  ,sdp_b2mcif_rd_req_src_pd           //|< i
  ,sdp_b2mcif_rd_req_dst_valid        //|> o
  ,sdp_b2mcif_rd_req_dst_ready        //|< i
  ,sdp_b2mcif_rd_req_dst_pd           //|> o
  ,sdp_b2cvif_rd_req_src_valid        //|< i
  ,sdp_b2cvif_rd_req_src_ready        //|> o
  ,sdp_b2cvif_rd_req_src_pd           //|< i
  ,sdp_b2cvif_rd_req_dst_valid        //|> o
  ,sdp_b2cvif_rd_req_dst_ready        //|< i
  ,sdp_b2cvif_rd_req_dst_pd           //|> o
  ,sdp_b2mcif_rd_cdt_src_lat_fifo_pop //|< i
  ,sdp_b2mcif_rd_cdt_dst_lat_fifo_pop //|> o
  ,sdp_b2cvif_rd_cdt_src_lat_fifo_pop //|< i
  ,sdp_b2cvif_rd_cdt_dst_lat_fifo_pop //|> o
  ,mcif2sdp_b_rd_rsp_src_valid        //|< i
  ,mcif2sdp_b_rd_rsp_src_ready        //|> o
  ,mcif2sdp_b_rd_rsp_src_pd           //|< i
  ,mcif2sdp_b_rd_rsp_dst_valid        //|> o
  ,mcif2sdp_b_rd_rsp_dst_ready        //|< i
  ,mcif2sdp_b_rd_rsp_dst_pd           //|> o
  ,cvif2sdp_b_rd_rsp_src_valid        //|< i
  ,cvif2sdp_b_rd_rsp_src_ready        //|> o
  ,cvif2sdp_b_rd_rsp_src_pd           //|< i
  ,cvif2sdp_b_rd_rsp_dst_valid        //|> o
  ,cvif2sdp_b_rd_rsp_dst_ready        //|< i
  ,cvif2sdp_b_rd_rsp_dst_pd           //|> o
  );
//
// NV_NVDLA_RT_sdp2nocif_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         sdp2mcif_rd_req_src_valid;  /* data valid */
output        sdp2mcif_rd_req_src_ready;  /* data return handshake */
input  [78:0] sdp2mcif_rd_req_src_pd;

output        sdp2mcif_rd_req_dst_valid;  /* data valid */
input         sdp2mcif_rd_req_dst_ready;  /* data return handshake */
output [78:0] sdp2mcif_rd_req_dst_pd;

input         sdp2cvif_rd_req_src_valid;  /* data valid */
output        sdp2cvif_rd_req_src_ready;  /* data return handshake */
input  [78:0] sdp2cvif_rd_req_src_pd;

output        sdp2cvif_rd_req_dst_valid;  /* data valid */
input         sdp2cvif_rd_req_dst_ready;  /* data return handshake */
output [78:0] sdp2cvif_rd_req_dst_pd;

input  sdp2mcif_rd_cdt_src_lat_fifo_pop;

output  sdp2mcif_rd_cdt_dst_lat_fifo_pop;

input  sdp2cvif_rd_cdt_src_lat_fifo_pop;

output  sdp2cvif_rd_cdt_dst_lat_fifo_pop;

input          mcif2sdp_rd_rsp_src_valid;  /* data valid */
output         mcif2sdp_rd_rsp_src_ready;  /* data return handshake */
input  [513:0] mcif2sdp_rd_rsp_src_pd;

output         mcif2sdp_rd_rsp_dst_valid;  /* data valid */
input          mcif2sdp_rd_rsp_dst_ready;  /* data return handshake */
output [513:0] mcif2sdp_rd_rsp_dst_pd;

input          cvif2sdp_rd_rsp_src_valid;  /* data valid */
output         cvif2sdp_rd_rsp_src_ready;  /* data return handshake */
input  [513:0] cvif2sdp_rd_rsp_src_pd;

output         cvif2sdp_rd_rsp_dst_valid;  /* data valid */
input          cvif2sdp_rd_rsp_dst_ready;  /* data return handshake */
output [513:0] cvif2sdp_rd_rsp_dst_pd;

input         sdp_b2mcif_rd_req_src_valid;  /* data valid */
output        sdp_b2mcif_rd_req_src_ready;  /* data return handshake */
input  [78:0] sdp_b2mcif_rd_req_src_pd;

output        sdp_b2mcif_rd_req_dst_valid;  /* data valid */
input         sdp_b2mcif_rd_req_dst_ready;  /* data return handshake */
output [78:0] sdp_b2mcif_rd_req_dst_pd;

input         sdp_b2cvif_rd_req_src_valid;  /* data valid */
output        sdp_b2cvif_rd_req_src_ready;  /* data return handshake */
input  [78:0] sdp_b2cvif_rd_req_src_pd;

output        sdp_b2cvif_rd_req_dst_valid;  /* data valid */
input         sdp_b2cvif_rd_req_dst_ready;  /* data return handshake */
output [78:0] sdp_b2cvif_rd_req_dst_pd;

input  sdp_b2mcif_rd_cdt_src_lat_fifo_pop;

output  sdp_b2mcif_rd_cdt_dst_lat_fifo_pop;

input  sdp_b2cvif_rd_cdt_src_lat_fifo_pop;

output  sdp_b2cvif_rd_cdt_dst_lat_fifo_pop;

input          mcif2sdp_b_rd_rsp_src_valid;  /* data valid */
output         mcif2sdp_b_rd_rsp_src_ready;  /* data return handshake */
input  [513:0] mcif2sdp_b_rd_rsp_src_pd;

output         mcif2sdp_b_rd_rsp_dst_valid;  /* data valid */
input          mcif2sdp_b_rd_rsp_dst_ready;  /* data return handshake */
output [513:0] mcif2sdp_b_rd_rsp_dst_pd;

input          cvif2sdp_b_rd_rsp_src_valid;  /* data valid */
output         cvif2sdp_b_rd_rsp_src_ready;  /* data return handshake */
input  [513:0] cvif2sdp_b_rd_rsp_src_pd;

output         cvif2sdp_b_rd_rsp_dst_valid;  /* data valid */
input          cvif2sdp_b_rd_rsp_dst_ready;  /* data return handshake */
output [513:0] cvif2sdp_b_rd_rsp_dst_pd;

reg          sdp2cvif_rd_cdt_src_lat_fifo_pop_d1;
reg          sdp2mcif_rd_cdt_src_lat_fifo_pop_d1;
reg          sdp_b2cvif_rd_cdt_src_lat_fifo_pop_d1;
reg          sdp_b2mcif_rd_cdt_src_lat_fifo_pop_d1;
wire [513:0] cvif2sdp_b_rd_rsp_src_pd_d0;
wire [513:0] cvif2sdp_b_rd_rsp_src_pd_d1;
wire         cvif2sdp_b_rd_rsp_src_ready_d0;
wire         cvif2sdp_b_rd_rsp_src_ready_d1;
wire         cvif2sdp_b_rd_rsp_src_valid_d0;
wire         cvif2sdp_b_rd_rsp_src_valid_d1;
wire [513:0] cvif2sdp_rd_rsp_src_pd_d0;
wire [513:0] cvif2sdp_rd_rsp_src_pd_d1;
wire         cvif2sdp_rd_rsp_src_ready_d0;
wire         cvif2sdp_rd_rsp_src_ready_d1;
wire         cvif2sdp_rd_rsp_src_valid_d0;
wire         cvif2sdp_rd_rsp_src_valid_d1;
wire [513:0] mcif2sdp_b_rd_rsp_src_pd_d0;
wire [513:0] mcif2sdp_b_rd_rsp_src_pd_d1;
wire         mcif2sdp_b_rd_rsp_src_ready_d0;
wire         mcif2sdp_b_rd_rsp_src_ready_d1;
wire         mcif2sdp_b_rd_rsp_src_valid_d0;
wire         mcif2sdp_b_rd_rsp_src_valid_d1;
wire [513:0] mcif2sdp_rd_rsp_src_pd_d0;
wire [513:0] mcif2sdp_rd_rsp_src_pd_d1;
wire         mcif2sdp_rd_rsp_src_ready_d0;
wire         mcif2sdp_rd_rsp_src_ready_d1;
wire         mcif2sdp_rd_rsp_src_valid_d0;
wire         mcif2sdp_rd_rsp_src_valid_d1;
wire  [78:0] sdp2cvif_rd_req_src_pd_d0;
wire  [78:0] sdp2cvif_rd_req_src_pd_d1;
wire         sdp2cvif_rd_req_src_ready_d0;
wire         sdp2cvif_rd_req_src_ready_d1;
wire         sdp2cvif_rd_req_src_valid_d0;
wire         sdp2cvif_rd_req_src_valid_d1;
wire  [78:0] sdp2mcif_rd_req_src_pd_d0;
wire  [78:0] sdp2mcif_rd_req_src_pd_d1;
wire         sdp2mcif_rd_req_src_ready_d0;
wire         sdp2mcif_rd_req_src_ready_d1;
wire         sdp2mcif_rd_req_src_valid_d0;
wire         sdp2mcif_rd_req_src_valid_d1;
wire  [78:0] sdp_b2cvif_rd_req_src_pd_d0;
wire  [78:0] sdp_b2cvif_rd_req_src_pd_d1;
wire         sdp_b2cvif_rd_req_src_ready_d0;
wire         sdp_b2cvif_rd_req_src_ready_d1;
wire         sdp_b2cvif_rd_req_src_valid_d0;
wire         sdp_b2cvif_rd_req_src_valid_d1;
wire  [78:0] sdp_b2mcif_rd_req_src_pd_d0;
wire  [78:0] sdp_b2mcif_rd_req_src_pd_d1;
wire         sdp_b2mcif_rd_req_src_ready_d0;
wire         sdp_b2mcif_rd_req_src_ready_d1;
wire         sdp_b2mcif_rd_req_src_valid_d0;
wire         sdp_b2mcif_rd_req_src_valid_d1;

// Valid Ready Pipe

assign sdp2mcif_rd_req_src_valid_d0 = sdp2mcif_rd_req_src_valid;
assign sdp2mcif_rd_req_src_ready = sdp2mcif_rd_req_src_ready_d0;
assign sdp2mcif_rd_req_src_pd_d0[78:0] = sdp2mcif_rd_req_src_pd[78:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p1 pipe_p1 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.sdp2mcif_rd_req_src_pd_d0      (sdp2mcif_rd_req_src_pd_d0[78:0])    //|< w
  ,.sdp2mcif_rd_req_src_ready_d1   (sdp2mcif_rd_req_src_ready_d1)       //|< w
  ,.sdp2mcif_rd_req_src_valid_d0   (sdp2mcif_rd_req_src_valid_d0)       //|< w
  ,.sdp2mcif_rd_req_src_pd_d1      (sdp2mcif_rd_req_src_pd_d1[78:0])    //|> w
  ,.sdp2mcif_rd_req_src_ready_d0   (sdp2mcif_rd_req_src_ready_d0)       //|> w
  ,.sdp2mcif_rd_req_src_valid_d1   (sdp2mcif_rd_req_src_valid_d1)       //|> w
  );
assign sdp2mcif_rd_req_dst_valid = sdp2mcif_rd_req_src_valid_d1;
assign sdp2mcif_rd_req_src_ready_d1 = sdp2mcif_rd_req_dst_ready;
assign sdp2mcif_rd_req_dst_pd[78:0] = sdp2mcif_rd_req_src_pd_d1[78:0];


assign mcif2sdp_b_rd_rsp_src_valid_d0 = mcif2sdp_b_rd_rsp_src_valid;
assign mcif2sdp_b_rd_rsp_src_ready = mcif2sdp_b_rd_rsp_src_ready_d0;
assign mcif2sdp_b_rd_rsp_src_pd_d0[513:0] = mcif2sdp_b_rd_rsp_src_pd[513:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p2 pipe_p2 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.mcif2sdp_b_rd_rsp_src_pd_d0    (mcif2sdp_b_rd_rsp_src_pd_d0[513:0]) //|< w
  ,.mcif2sdp_b_rd_rsp_src_ready_d1 (mcif2sdp_b_rd_rsp_src_ready_d1)     //|< w
  ,.mcif2sdp_b_rd_rsp_src_valid_d0 (mcif2sdp_b_rd_rsp_src_valid_d0)     //|< w
  ,.mcif2sdp_b_rd_rsp_src_pd_d1    (mcif2sdp_b_rd_rsp_src_pd_d1[513:0]) //|> w
  ,.mcif2sdp_b_rd_rsp_src_ready_d0 (mcif2sdp_b_rd_rsp_src_ready_d0)     //|> w
  ,.mcif2sdp_b_rd_rsp_src_valid_d1 (mcif2sdp_b_rd_rsp_src_valid_d1)     //|> w
  );
assign mcif2sdp_b_rd_rsp_dst_valid = mcif2sdp_b_rd_rsp_src_valid_d1;
assign mcif2sdp_b_rd_rsp_src_ready_d1 = mcif2sdp_b_rd_rsp_dst_ready;
assign mcif2sdp_b_rd_rsp_dst_pd[513:0] = mcif2sdp_b_rd_rsp_src_pd_d1[513:0];


assign sdp2cvif_rd_req_src_valid_d0 = sdp2cvif_rd_req_src_valid;
assign sdp2cvif_rd_req_src_ready = sdp2cvif_rd_req_src_ready_d0;
assign sdp2cvif_rd_req_src_pd_d0[78:0] = sdp2cvif_rd_req_src_pd[78:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p3 pipe_p3 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.sdp2cvif_rd_req_src_pd_d0      (sdp2cvif_rd_req_src_pd_d0[78:0])    //|< w
  ,.sdp2cvif_rd_req_src_ready_d1   (sdp2cvif_rd_req_src_ready_d1)       //|< w
  ,.sdp2cvif_rd_req_src_valid_d0   (sdp2cvif_rd_req_src_valid_d0)       //|< w
  ,.sdp2cvif_rd_req_src_pd_d1      (sdp2cvif_rd_req_src_pd_d1[78:0])    //|> w
  ,.sdp2cvif_rd_req_src_ready_d0   (sdp2cvif_rd_req_src_ready_d0)       //|> w
  ,.sdp2cvif_rd_req_src_valid_d1   (sdp2cvif_rd_req_src_valid_d1)       //|> w
  );
assign sdp2cvif_rd_req_dst_valid = sdp2cvif_rd_req_src_valid_d1;
assign sdp2cvif_rd_req_src_ready_d1 = sdp2cvif_rd_req_dst_ready;
assign sdp2cvif_rd_req_dst_pd[78:0] = sdp2cvif_rd_req_src_pd_d1[78:0];


assign sdp_b2mcif_rd_req_src_valid_d0 = sdp_b2mcif_rd_req_src_valid;
assign sdp_b2mcif_rd_req_src_ready = sdp_b2mcif_rd_req_src_ready_d0;
assign sdp_b2mcif_rd_req_src_pd_d0[78:0] = sdp_b2mcif_rd_req_src_pd[78:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p4 pipe_p4 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.sdp_b2mcif_rd_req_src_pd_d0    (sdp_b2mcif_rd_req_src_pd_d0[78:0])  //|< w
  ,.sdp_b2mcif_rd_req_src_ready_d1 (sdp_b2mcif_rd_req_src_ready_d1)     //|< w
  ,.sdp_b2mcif_rd_req_src_valid_d0 (sdp_b2mcif_rd_req_src_valid_d0)     //|< w
  ,.sdp_b2mcif_rd_req_src_pd_d1    (sdp_b2mcif_rd_req_src_pd_d1[78:0])  //|> w
  ,.sdp_b2mcif_rd_req_src_ready_d0 (sdp_b2mcif_rd_req_src_ready_d0)     //|> w
  ,.sdp_b2mcif_rd_req_src_valid_d1 (sdp_b2mcif_rd_req_src_valid_d1)     //|> w
  );
assign sdp_b2mcif_rd_req_dst_valid = sdp_b2mcif_rd_req_src_valid_d1;
assign sdp_b2mcif_rd_req_src_ready_d1 = sdp_b2mcif_rd_req_dst_ready;
assign sdp_b2mcif_rd_req_dst_pd[78:0] = sdp_b2mcif_rd_req_src_pd_d1[78:0];


assign sdp_b2cvif_rd_req_src_valid_d0 = sdp_b2cvif_rd_req_src_valid;
assign sdp_b2cvif_rd_req_src_ready = sdp_b2cvif_rd_req_src_ready_d0;
assign sdp_b2cvif_rd_req_src_pd_d0[78:0] = sdp_b2cvif_rd_req_src_pd[78:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p5 pipe_p5 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.sdp_b2cvif_rd_req_src_pd_d0    (sdp_b2cvif_rd_req_src_pd_d0[78:0])  //|< w
  ,.sdp_b2cvif_rd_req_src_ready_d1 (sdp_b2cvif_rd_req_src_ready_d1)     //|< w
  ,.sdp_b2cvif_rd_req_src_valid_d0 (sdp_b2cvif_rd_req_src_valid_d0)     //|< w
  ,.sdp_b2cvif_rd_req_src_pd_d1    (sdp_b2cvif_rd_req_src_pd_d1[78:0])  //|> w
  ,.sdp_b2cvif_rd_req_src_ready_d0 (sdp_b2cvif_rd_req_src_ready_d0)     //|> w
  ,.sdp_b2cvif_rd_req_src_valid_d1 (sdp_b2cvif_rd_req_src_valid_d1)     //|> w
  );
assign sdp_b2cvif_rd_req_dst_valid = sdp_b2cvif_rd_req_src_valid_d1;
assign sdp_b2cvif_rd_req_src_ready_d1 = sdp_b2cvif_rd_req_dst_ready;
assign sdp_b2cvif_rd_req_dst_pd[78:0] = sdp_b2cvif_rd_req_src_pd_d1[78:0];


assign cvif2sdp_b_rd_rsp_src_valid_d0 = cvif2sdp_b_rd_rsp_src_valid;
assign cvif2sdp_b_rd_rsp_src_ready = cvif2sdp_b_rd_rsp_src_ready_d0;
assign cvif2sdp_b_rd_rsp_src_pd_d0[513:0] = cvif2sdp_b_rd_rsp_src_pd[513:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p6 pipe_p6 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.cvif2sdp_b_rd_rsp_src_pd_d0    (cvif2sdp_b_rd_rsp_src_pd_d0[513:0]) //|< w
  ,.cvif2sdp_b_rd_rsp_src_ready_d1 (cvif2sdp_b_rd_rsp_src_ready_d1)     //|< w
  ,.cvif2sdp_b_rd_rsp_src_valid_d0 (cvif2sdp_b_rd_rsp_src_valid_d0)     //|< w
  ,.cvif2sdp_b_rd_rsp_src_pd_d1    (cvif2sdp_b_rd_rsp_src_pd_d1[513:0]) //|> w
  ,.cvif2sdp_b_rd_rsp_src_ready_d0 (cvif2sdp_b_rd_rsp_src_ready_d0)     //|> w
  ,.cvif2sdp_b_rd_rsp_src_valid_d1 (cvif2sdp_b_rd_rsp_src_valid_d1)     //|> w
  );
assign cvif2sdp_b_rd_rsp_dst_valid = cvif2sdp_b_rd_rsp_src_valid_d1;
assign cvif2sdp_b_rd_rsp_src_ready_d1 = cvif2sdp_b_rd_rsp_dst_ready;
assign cvif2sdp_b_rd_rsp_dst_pd[513:0] = cvif2sdp_b_rd_rsp_src_pd_d1[513:0];


assign mcif2sdp_rd_rsp_src_valid_d0 = mcif2sdp_rd_rsp_src_valid;
assign mcif2sdp_rd_rsp_src_ready = mcif2sdp_rd_rsp_src_ready_d0;
assign mcif2sdp_rd_rsp_src_pd_d0[513:0] = mcif2sdp_rd_rsp_src_pd[513:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p7 pipe_p7 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.mcif2sdp_rd_rsp_src_pd_d0      (mcif2sdp_rd_rsp_src_pd_d0[513:0])   //|< w
  ,.mcif2sdp_rd_rsp_src_ready_d1   (mcif2sdp_rd_rsp_src_ready_d1)       //|< w
  ,.mcif2sdp_rd_rsp_src_valid_d0   (mcif2sdp_rd_rsp_src_valid_d0)       //|< w
  ,.mcif2sdp_rd_rsp_src_pd_d1      (mcif2sdp_rd_rsp_src_pd_d1[513:0])   //|> w
  ,.mcif2sdp_rd_rsp_src_ready_d0   (mcif2sdp_rd_rsp_src_ready_d0)       //|> w
  ,.mcif2sdp_rd_rsp_src_valid_d1   (mcif2sdp_rd_rsp_src_valid_d1)       //|> w
  );
assign mcif2sdp_rd_rsp_dst_valid = mcif2sdp_rd_rsp_src_valid_d1;
assign mcif2sdp_rd_rsp_src_ready_d1 = mcif2sdp_rd_rsp_dst_ready;
assign mcif2sdp_rd_rsp_dst_pd[513:0] = mcif2sdp_rd_rsp_src_pd_d1[513:0];


assign cvif2sdp_rd_rsp_src_valid_d0 = cvif2sdp_rd_rsp_src_valid;
assign cvif2sdp_rd_rsp_src_ready = cvif2sdp_rd_rsp_src_ready_d0;
assign cvif2sdp_rd_rsp_src_pd_d0[513:0] = cvif2sdp_rd_rsp_src_pd[513:0];
NV_NVDLA_RT_SDP2NOCIF_pipe_p8 pipe_p8 (
   .nvdla_core_clk                 (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    //|< i
  ,.cvif2sdp_rd_rsp_src_pd_d0      (cvif2sdp_rd_rsp_src_pd_d0[513:0])   //|< w
  ,.cvif2sdp_rd_rsp_src_ready_d1   (cvif2sdp_rd_rsp_src_ready_d1)       //|< w
  ,.cvif2sdp_rd_rsp_src_valid_d0   (cvif2sdp_rd_rsp_src_valid_d0)       //|< w
  ,.cvif2sdp_rd_rsp_src_pd_d1      (cvif2sdp_rd_rsp_src_pd_d1[513:0])   //|> w
  ,.cvif2sdp_rd_rsp_src_ready_d0   (cvif2sdp_rd_rsp_src_ready_d0)       //|> w
  ,.cvif2sdp_rd_rsp_src_valid_d1   (cvif2sdp_rd_rsp_src_valid_d1)       //|> w
  );
assign cvif2sdp_rd_rsp_dst_valid = cvif2sdp_rd_rsp_src_valid_d1;
assign cvif2sdp_rd_rsp_src_ready_d1 = cvif2sdp_rd_rsp_dst_ready;
assign cvif2sdp_rd_rsp_dst_pd[513:0] = cvif2sdp_rd_rsp_src_pd_d1[513:0];


// Valid Only Pipe

always @(posedge nvdla_core_clk) begin
  sdp_b2cvif_rd_cdt_src_lat_fifo_pop_d1 <= sdp_b2cvif_rd_cdt_src_lat_fifo_pop;
end
assign sdp_b2cvif_rd_cdt_dst_lat_fifo_pop = sdp_b2cvif_rd_cdt_src_lat_fifo_pop_d1;


always @(posedge nvdla_core_clk) begin
  sdp_b2mcif_rd_cdt_src_lat_fifo_pop_d1 <= sdp_b2mcif_rd_cdt_src_lat_fifo_pop;
end
assign sdp_b2mcif_rd_cdt_dst_lat_fifo_pop = sdp_b2mcif_rd_cdt_src_lat_fifo_pop_d1;


always @(posedge nvdla_core_clk) begin
  sdp2mcif_rd_cdt_src_lat_fifo_pop_d1 <= sdp2mcif_rd_cdt_src_lat_fifo_pop;
end
assign sdp2mcif_rd_cdt_dst_lat_fifo_pop = sdp2mcif_rd_cdt_src_lat_fifo_pop_d1;


always @(posedge nvdla_core_clk) begin
  sdp2cvif_rd_cdt_src_lat_fifo_pop_d1 <= sdp2cvif_rd_cdt_src_lat_fifo_pop;
end
assign sdp2cvif_rd_cdt_dst_lat_fifo_pop = sdp2cvif_rd_cdt_src_lat_fifo_pop_d1;


endmodule // NV_NVDLA_RT_sdp2nocif



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none sdp2mcif_rd_req_src_pd_d1[78:0] (sdp2mcif_rd_req_src_valid_d1,sdp2mcif_rd_req_src_ready_d1) <= sdp2mcif_rd_req_src_pd_d0[78:0] (sdp2mcif_rd_req_src_valid_d0,sdp2mcif_rd_req_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sdp2mcif_rd_req_src_pd_d0
  ,sdp2mcif_rd_req_src_ready_d1
  ,sdp2mcif_rd_req_src_valid_d0
  ,sdp2mcif_rd_req_src_pd_d1
  ,sdp2mcif_rd_req_src_ready_d0
  ,sdp2mcif_rd_req_src_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] sdp2mcif_rd_req_src_pd_d0;
input         sdp2mcif_rd_req_src_ready_d1;
input         sdp2mcif_rd_req_src_valid_d0;
output [78:0] sdp2mcif_rd_req_src_pd_d1;
output        sdp2mcif_rd_req_src_ready_d0;
output        sdp2mcif_rd_req_src_valid_d1;
reg    [78:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg    [78:0] sdp2mcif_rd_req_src_pd_d1;
reg           sdp2mcif_rd_req_src_ready_d0;
reg           sdp2mcif_rd_req_src_valid_d1;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? sdp2mcif_rd_req_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && sdp2mcif_rd_req_src_valid_d0)? sdp2mcif_rd_req_src_pd_d0[78:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  sdp2mcif_rd_req_src_ready_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or sdp2mcif_rd_req_src_ready_d1
  or p1_pipe_data
  ) begin
  sdp2mcif_rd_req_src_valid_d1 = p1_pipe_valid;
  p1_pipe_ready = sdp2mcif_rd_req_src_ready_d1;
  sdp2mcif_rd_req_src_pd_d1[78:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp2mcif_rd_req_src_valid_d1^sdp2mcif_rd_req_src_ready_d1^sdp2mcif_rd_req_src_valid_d0^sdp2mcif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (sdp2mcif_rd_req_src_valid_d0 && !sdp2mcif_rd_req_src_ready_d0), (sdp2mcif_rd_req_src_valid_d0), (sdp2mcif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none mcif2sdp_b_rd_rsp_src_pd_d1[513:0] (mcif2sdp_b_rd_rsp_src_valid_d1,mcif2sdp_b_rd_rsp_src_ready_d1) <= mcif2sdp_b_rd_rsp_src_pd_d0[513:0] (mcif2sdp_b_rd_rsp_src_valid_d0,mcif2sdp_b_rd_rsp_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mcif2sdp_b_rd_rsp_src_pd_d0
  ,mcif2sdp_b_rd_rsp_src_ready_d1
  ,mcif2sdp_b_rd_rsp_src_valid_d0
  ,mcif2sdp_b_rd_rsp_src_pd_d1
  ,mcif2sdp_b_rd_rsp_src_ready_d0
  ,mcif2sdp_b_rd_rsp_src_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] mcif2sdp_b_rd_rsp_src_pd_d0;
input          mcif2sdp_b_rd_rsp_src_ready_d1;
input          mcif2sdp_b_rd_rsp_src_valid_d0;
output [513:0] mcif2sdp_b_rd_rsp_src_pd_d1;
output         mcif2sdp_b_rd_rsp_src_ready_d0;
output         mcif2sdp_b_rd_rsp_src_valid_d1;
reg    [513:0] mcif2sdp_b_rd_rsp_src_pd_d1;
reg            mcif2sdp_b_rd_rsp_src_ready_d0;
reg            mcif2sdp_b_rd_rsp_src_valid_d1;
reg    [513:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? mcif2sdp_b_rd_rsp_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && mcif2sdp_b_rd_rsp_src_valid_d0)? mcif2sdp_b_rd_rsp_src_pd_d0[513:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  mcif2sdp_b_rd_rsp_src_ready_d0 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or mcif2sdp_b_rd_rsp_src_ready_d1
  or p2_pipe_data
  ) begin
  mcif2sdp_b_rd_rsp_src_valid_d1 = p2_pipe_valid;
  p2_pipe_ready = mcif2sdp_b_rd_rsp_src_ready_d1;
  mcif2sdp_b_rd_rsp_src_pd_d1[513:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_b_rd_rsp_src_valid_d1^mcif2sdp_b_rd_rsp_src_ready_d1^mcif2sdp_b_rd_rsp_src_valid_d0^mcif2sdp_b_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (mcif2sdp_b_rd_rsp_src_valid_d0 && !mcif2sdp_b_rd_rsp_src_ready_d0), (mcif2sdp_b_rd_rsp_src_valid_d0), (mcif2sdp_b_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none sdp2cvif_rd_req_src_pd_d1[78:0] (sdp2cvif_rd_req_src_valid_d1,sdp2cvif_rd_req_src_ready_d1) <= sdp2cvif_rd_req_src_pd_d0[78:0] (sdp2cvif_rd_req_src_valid_d0,sdp2cvif_rd_req_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sdp2cvif_rd_req_src_pd_d0
  ,sdp2cvif_rd_req_src_ready_d1
  ,sdp2cvif_rd_req_src_valid_d0
  ,sdp2cvif_rd_req_src_pd_d1
  ,sdp2cvif_rd_req_src_ready_d0
  ,sdp2cvif_rd_req_src_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] sdp2cvif_rd_req_src_pd_d0;
input         sdp2cvif_rd_req_src_ready_d1;
input         sdp2cvif_rd_req_src_valid_d0;
output [78:0] sdp2cvif_rd_req_src_pd_d1;
output        sdp2cvif_rd_req_src_ready_d0;
output        sdp2cvif_rd_req_src_valid_d1;
reg    [78:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg    [78:0] sdp2cvif_rd_req_src_pd_d1;
reg           sdp2cvif_rd_req_src_ready_d0;
reg           sdp2cvif_rd_req_src_valid_d1;
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? sdp2cvif_rd_req_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && sdp2cvif_rd_req_src_valid_d0)? sdp2cvif_rd_req_src_pd_d0[78:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  sdp2cvif_rd_req_src_ready_d0 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or sdp2cvif_rd_req_src_ready_d1
  or p3_pipe_data
  ) begin
  sdp2cvif_rd_req_src_valid_d1 = p3_pipe_valid;
  p3_pipe_ready = sdp2cvif_rd_req_src_ready_d1;
  sdp2cvif_rd_req_src_pd_d1[78:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp2cvif_rd_req_src_valid_d1^sdp2cvif_rd_req_src_ready_d1^sdp2cvif_rd_req_src_valid_d0^sdp2cvif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (sdp2cvif_rd_req_src_valid_d0 && !sdp2cvif_rd_req_src_ready_d0), (sdp2cvif_rd_req_src_valid_d0), (sdp2cvif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none sdp_b2mcif_rd_req_src_pd_d1[78:0] (sdp_b2mcif_rd_req_src_valid_d1,sdp_b2mcif_rd_req_src_ready_d1) <= sdp_b2mcif_rd_req_src_pd_d0[78:0] (sdp_b2mcif_rd_req_src_valid_d0,sdp_b2mcif_rd_req_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sdp_b2mcif_rd_req_src_pd_d0
  ,sdp_b2mcif_rd_req_src_ready_d1
  ,sdp_b2mcif_rd_req_src_valid_d0
  ,sdp_b2mcif_rd_req_src_pd_d1
  ,sdp_b2mcif_rd_req_src_ready_d0
  ,sdp_b2mcif_rd_req_src_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] sdp_b2mcif_rd_req_src_pd_d0;
input         sdp_b2mcif_rd_req_src_ready_d1;
input         sdp_b2mcif_rd_req_src_valid_d0;
output [78:0] sdp_b2mcif_rd_req_src_pd_d1;
output        sdp_b2mcif_rd_req_src_ready_d0;
output        sdp_b2mcif_rd_req_src_valid_d1;
reg    [78:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
reg    [78:0] sdp_b2mcif_rd_req_src_pd_d1;
reg           sdp_b2mcif_rd_req_src_ready_d0;
reg           sdp_b2mcif_rd_req_src_valid_d1;
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? sdp_b2mcif_rd_req_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && sdp_b2mcif_rd_req_src_valid_d0)? sdp_b2mcif_rd_req_src_pd_d0[78:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  sdp_b2mcif_rd_req_src_ready_d0 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or sdp_b2mcif_rd_req_src_ready_d1
  or p4_pipe_data
  ) begin
  sdp_b2mcif_rd_req_src_valid_d1 = p4_pipe_valid;
  p4_pipe_ready = sdp_b2mcif_rd_req_src_ready_d1;
  sdp_b2mcif_rd_req_src_pd_d1[78:0] = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_b2mcif_rd_req_src_valid_d1^sdp_b2mcif_rd_req_src_ready_d1^sdp_b2mcif_rd_req_src_valid_d0^sdp_b2mcif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (sdp_b2mcif_rd_req_src_valid_d0 && !sdp_b2mcif_rd_req_src_ready_d0), (sdp_b2mcif_rd_req_src_valid_d0), (sdp_b2mcif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none sdp_b2cvif_rd_req_src_pd_d1[78:0] (sdp_b2cvif_rd_req_src_valid_d1,sdp_b2cvif_rd_req_src_ready_d1) <= sdp_b2cvif_rd_req_src_pd_d0[78:0] (sdp_b2cvif_rd_req_src_valid_d0,sdp_b2cvif_rd_req_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sdp_b2cvif_rd_req_src_pd_d0
  ,sdp_b2cvif_rd_req_src_ready_d1
  ,sdp_b2cvif_rd_req_src_valid_d0
  ,sdp_b2cvif_rd_req_src_pd_d1
  ,sdp_b2cvif_rd_req_src_ready_d0
  ,sdp_b2cvif_rd_req_src_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] sdp_b2cvif_rd_req_src_pd_d0;
input         sdp_b2cvif_rd_req_src_ready_d1;
input         sdp_b2cvif_rd_req_src_valid_d0;
output [78:0] sdp_b2cvif_rd_req_src_pd_d1;
output        sdp_b2cvif_rd_req_src_ready_d0;
output        sdp_b2cvif_rd_req_src_valid_d1;
reg    [78:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg           p5_pipe_valid;
reg    [78:0] sdp_b2cvif_rd_req_src_pd_d1;
reg           sdp_b2cvif_rd_req_src_ready_d0;
reg           sdp_b2cvif_rd_req_src_valid_d1;
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? sdp_b2cvif_rd_req_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && sdp_b2cvif_rd_req_src_valid_d0)? sdp_b2cvif_rd_req_src_pd_d0[78:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  sdp_b2cvif_rd_req_src_ready_d0 = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or sdp_b2cvif_rd_req_src_ready_d1
  or p5_pipe_data
  ) begin
  sdp_b2cvif_rd_req_src_valid_d1 = p5_pipe_valid;
  p5_pipe_ready = sdp_b2cvif_rd_req_src_ready_d1;
  sdp_b2cvif_rd_req_src_pd_d1[78:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_b2cvif_rd_req_src_valid_d1^sdp_b2cvif_rd_req_src_ready_d1^sdp_b2cvif_rd_req_src_valid_d0^sdp_b2cvif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (sdp_b2cvif_rd_req_src_valid_d0 && !sdp_b2cvif_rd_req_src_ready_d0), (sdp_b2cvif_rd_req_src_valid_d0), (sdp_b2cvif_rd_req_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none cvif2sdp_b_rd_rsp_src_pd_d1[513:0] (cvif2sdp_b_rd_rsp_src_valid_d1,cvif2sdp_b_rd_rsp_src_ready_d1) <= cvif2sdp_b_rd_rsp_src_pd_d0[513:0] (cvif2sdp_b_rd_rsp_src_valid_d0,cvif2sdp_b_rd_rsp_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cvif2sdp_b_rd_rsp_src_pd_d0
  ,cvif2sdp_b_rd_rsp_src_ready_d1
  ,cvif2sdp_b_rd_rsp_src_valid_d0
  ,cvif2sdp_b_rd_rsp_src_pd_d1
  ,cvif2sdp_b_rd_rsp_src_ready_d0
  ,cvif2sdp_b_rd_rsp_src_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cvif2sdp_b_rd_rsp_src_pd_d0;
input          cvif2sdp_b_rd_rsp_src_ready_d1;
input          cvif2sdp_b_rd_rsp_src_valid_d0;
output [513:0] cvif2sdp_b_rd_rsp_src_pd_d1;
output         cvif2sdp_b_rd_rsp_src_ready_d0;
output         cvif2sdp_b_rd_rsp_src_valid_d1;
reg    [513:0] cvif2sdp_b_rd_rsp_src_pd_d1;
reg            cvif2sdp_b_rd_rsp_src_ready_d0;
reg            cvif2sdp_b_rd_rsp_src_valid_d1;
reg    [513:0] p6_pipe_data;
reg            p6_pipe_ready;
reg            p6_pipe_ready_bc;
reg            p6_pipe_valid;
//## pipe (6) valid-ready-bubble-collapse
always @(
  p6_pipe_ready
  or p6_pipe_valid
  ) begin
  p6_pipe_ready_bc = p6_pipe_ready || !p6_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_pipe_valid <= 1'b0;
  end else begin
  p6_pipe_valid <= (p6_pipe_ready_bc)? cvif2sdp_b_rd_rsp_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && cvif2sdp_b_rd_rsp_src_valid_d0)? cvif2sdp_b_rd_rsp_src_pd_d0[513:0] : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  cvif2sdp_b_rd_rsp_src_ready_d0 = p6_pipe_ready_bc;
end
//## pipe (6) output
always @(
  p6_pipe_valid
  or cvif2sdp_b_rd_rsp_src_ready_d1
  or p6_pipe_data
  ) begin
  cvif2sdp_b_rd_rsp_src_valid_d1 = p6_pipe_valid;
  p6_pipe_ready = cvif2sdp_b_rd_rsp_src_ready_d1;
  cvif2sdp_b_rd_rsp_src_pd_d1[513:0] = p6_pipe_data;
end
//## pipe (6) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p6_assert_clk = nvdla_core_clk;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cvif2sdp_b_rd_rsp_src_valid_d1^cvif2sdp_b_rd_rsp_src_ready_d1^cvif2sdp_b_rd_rsp_src_valid_d0^cvif2sdp_b_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (cvif2sdp_b_rd_rsp_src_valid_d0 && !cvif2sdp_b_rd_rsp_src_ready_d0), (cvif2sdp_b_rd_rsp_src_valid_d0), (cvif2sdp_b_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none mcif2sdp_rd_rsp_src_pd_d1[513:0] (mcif2sdp_rd_rsp_src_valid_d1,mcif2sdp_rd_rsp_src_ready_d1) <= mcif2sdp_rd_rsp_src_pd_d0[513:0] (mcif2sdp_rd_rsp_src_valid_d0,mcif2sdp_rd_rsp_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mcif2sdp_rd_rsp_src_pd_d0
  ,mcif2sdp_rd_rsp_src_ready_d1
  ,mcif2sdp_rd_rsp_src_valid_d0
  ,mcif2sdp_rd_rsp_src_pd_d1
  ,mcif2sdp_rd_rsp_src_ready_d0
  ,mcif2sdp_rd_rsp_src_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] mcif2sdp_rd_rsp_src_pd_d0;
input          mcif2sdp_rd_rsp_src_ready_d1;
input          mcif2sdp_rd_rsp_src_valid_d0;
output [513:0] mcif2sdp_rd_rsp_src_pd_d1;
output         mcif2sdp_rd_rsp_src_ready_d0;
output         mcif2sdp_rd_rsp_src_valid_d1;
reg    [513:0] mcif2sdp_rd_rsp_src_pd_d1;
reg            mcif2sdp_rd_rsp_src_ready_d0;
reg            mcif2sdp_rd_rsp_src_valid_d1;
reg    [513:0] p7_pipe_data;
reg            p7_pipe_ready;
reg            p7_pipe_ready_bc;
reg            p7_pipe_valid;
//## pipe (7) valid-ready-bubble-collapse
always @(
  p7_pipe_ready
  or p7_pipe_valid
  ) begin
  p7_pipe_ready_bc = p7_pipe_ready || !p7_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_pipe_valid <= 1'b0;
  end else begin
  p7_pipe_valid <= (p7_pipe_ready_bc)? mcif2sdp_rd_rsp_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && mcif2sdp_rd_rsp_src_valid_d0)? mcif2sdp_rd_rsp_src_pd_d0[513:0] : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  mcif2sdp_rd_rsp_src_ready_d0 = p7_pipe_ready_bc;
end
//## pipe (7) output
always @(
  p7_pipe_valid
  or mcif2sdp_rd_rsp_src_ready_d1
  or p7_pipe_data
  ) begin
  mcif2sdp_rd_rsp_src_valid_d1 = p7_pipe_valid;
  p7_pipe_ready = mcif2sdp_rd_rsp_src_ready_d1;
  mcif2sdp_rd_rsp_src_pd_d1[513:0] = p7_pipe_data;
end
//## pipe (7) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p7_assert_clk = nvdla_core_clk;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2sdp_rd_rsp_src_valid_d1^mcif2sdp_rd_rsp_src_ready_d1^mcif2sdp_rd_rsp_src_valid_d0^mcif2sdp_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (mcif2sdp_rd_rsp_src_valid_d0 && !mcif2sdp_rd_rsp_src_ready_d0), (mcif2sdp_rd_rsp_src_valid_d0), (mcif2sdp_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none cvif2sdp_rd_rsp_src_pd_d1[513:0] (cvif2sdp_rd_rsp_src_valid_d1,cvif2sdp_rd_rsp_src_ready_d1) <= cvif2sdp_rd_rsp_src_pd_d0[513:0] (cvif2sdp_rd_rsp_src_valid_d0,cvif2sdp_rd_rsp_src_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_RT_SDP2NOCIF_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cvif2sdp_rd_rsp_src_pd_d0
  ,cvif2sdp_rd_rsp_src_ready_d1
  ,cvif2sdp_rd_rsp_src_valid_d0
  ,cvif2sdp_rd_rsp_src_pd_d1
  ,cvif2sdp_rd_rsp_src_ready_d0
  ,cvif2sdp_rd_rsp_src_valid_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cvif2sdp_rd_rsp_src_pd_d0;
input          cvif2sdp_rd_rsp_src_ready_d1;
input          cvif2sdp_rd_rsp_src_valid_d0;
output [513:0] cvif2sdp_rd_rsp_src_pd_d1;
output         cvif2sdp_rd_rsp_src_ready_d0;
output         cvif2sdp_rd_rsp_src_valid_d1;
reg    [513:0] cvif2sdp_rd_rsp_src_pd_d1;
reg            cvif2sdp_rd_rsp_src_ready_d0;
reg            cvif2sdp_rd_rsp_src_valid_d1;
reg    [513:0] p8_pipe_data;
reg            p8_pipe_ready;
reg            p8_pipe_ready_bc;
reg            p8_pipe_valid;
//## pipe (8) valid-ready-bubble-collapse
always @(
  p8_pipe_ready
  or p8_pipe_valid
  ) begin
  p8_pipe_ready_bc = p8_pipe_ready || !p8_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_pipe_valid <= 1'b0;
  end else begin
  p8_pipe_valid <= (p8_pipe_ready_bc)? cvif2sdp_rd_rsp_src_valid_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && cvif2sdp_rd_rsp_src_valid_d0)? cvif2sdp_rd_rsp_src_pd_d0[513:0] : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  cvif2sdp_rd_rsp_src_ready_d0 = p8_pipe_ready_bc;
end
//## pipe (8) output
always @(
  p8_pipe_valid
  or cvif2sdp_rd_rsp_src_ready_d1
  or p8_pipe_data
  ) begin
  cvif2sdp_rd_rsp_src_valid_d1 = p8_pipe_valid;
  p8_pipe_ready = cvif2sdp_rd_rsp_src_ready_d1;
  cvif2sdp_rd_rsp_src_pd_d1[513:0] = p8_pipe_data;
end
//## pipe (8) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p8_assert_clk = nvdla_core_clk;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cvif2sdp_rd_rsp_src_valid_d1^cvif2sdp_rd_rsp_src_ready_d1^cvif2sdp_rd_rsp_src_valid_d0^cvif2sdp_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (cvif2sdp_rd_rsp_src_valid_d0 && !cvif2sdp_rd_rsp_src_ready_d0), (cvif2sdp_rd_rsp_src_valid_d0), (cvif2sdp_rd_rsp_src_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RT_SDP2NOCIF_pipe_p8


