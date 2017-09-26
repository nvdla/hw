// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_p.v

`ifdef NV_HWACC
`include "NV_HWACC_NVDLA_tick_defines.vh"
`endif


module NV_NVDLA_partition_p (
   cacc2sdp_pd                    //|< i
  ,cacc2sdp_valid                 //|< i
  ,csb2sdp_rdma_req_pd            //|< i
  ,csb2sdp_rdma_req_pvld          //|< i
  ,csb2sdp_req_pd                 //|< i
  ,csb2sdp_req_pvld               //|< i
  ,cvif2sdp_b_rd_rsp_pd           //|< i
  ,cvif2sdp_b_rd_rsp_valid        //|< i
  ,cvif2sdp_e_rd_rsp_pd           //|< i
  ,cvif2sdp_e_rd_rsp_valid        //|< i
  ,cvif2sdp_n_rd_rsp_pd           //|< i
  ,cvif2sdp_n_rd_rsp_valid        //|< i
  ,cvif2sdp_rd_rsp_pd             //|< i
  ,cvif2sdp_rd_rsp_valid          //|< i
  ,cvif2sdp_wr_rsp_complete       //|< i
  ,direct_reset_                  //|< i
  ,dla_reset_rstn                 //|< i
  ,global_clk_ovr_on              //|< i
  ,mac_a2accu_src_data0           //|< i
  ,mac_a2accu_src_data1           //|< i
  ,mac_a2accu_src_data2           //|< i
  ,mac_a2accu_src_data3           //|< i
  ,mac_a2accu_src_data4           //|< i
  ,mac_a2accu_src_data5           //|< i
  ,mac_a2accu_src_data6           //|< i
  ,mac_a2accu_src_data7           //|< i
  ,mac_a2accu_src_mask            //|< i
  ,mac_a2accu_src_mode            //|< i
  ,mac_a2accu_src_pd              //|< i
  ,mac_a2accu_src_pvld            //|< i
  ,mcif2sdp_b_rd_rsp_pd           //|< i
  ,mcif2sdp_b_rd_rsp_valid        //|< i
  ,mcif2sdp_e_rd_rsp_pd           //|< i
  ,mcif2sdp_e_rd_rsp_valid        //|< i
  ,mcif2sdp_n_rd_rsp_pd           //|< i
  ,mcif2sdp_n_rd_rsp_valid        //|< i
  ,mcif2sdp_rd_rsp_pd             //|< i
  ,mcif2sdp_rd_rsp_valid          //|< i
  ,mcif2sdp_wr_rsp_complete       //|< i
  ,nvdla_clk_ovr_on               //|< i
  ,nvdla_core_clk                 //|< i
  ,pwrbus_ram_pd                  //|< i
  ,sdp2cvif_rd_req_ready          //|< i
  ,sdp2cvif_wr_req_ready          //|< i
  ,sdp2mcif_rd_req_ready          //|< i
  ,sdp2mcif_wr_req_ready          //|< i
  ,sdp2pdp_ready                  //|< i
  ,sdp_b2cvif_rd_req_ready        //|< i
  ,sdp_b2mcif_rd_req_ready        //|< i
  ,sdp_e2cvif_rd_req_ready        //|< i
  ,sdp_e2mcif_rd_req_ready        //|< i
  ,sdp_n2cvif_rd_req_ready        //|< i
  ,sdp_n2mcif_rd_req_ready        //|< i
  ,test_mode                      //|< i
  ,tmc2slcg_disable_clock_gating  //|< i
  ,cacc2sdp_ready                 //|> o
  ,csb2sdp_rdma_req_prdy          //|> o
  ,csb2sdp_req_prdy               //|> o
  ,cvif2sdp_b_rd_rsp_ready        //|> o
  ,cvif2sdp_e_rd_rsp_ready        //|> o
  ,cvif2sdp_n_rd_rsp_ready        //|> o
  ,cvif2sdp_rd_rsp_ready          //|> o
  ,mac_a2accu_dst_data0           //|> o
  ,mac_a2accu_dst_data1           //|> o
  ,mac_a2accu_dst_data2           //|> o
  ,mac_a2accu_dst_data3           //|> o
  ,mac_a2accu_dst_data4           //|> o
  ,mac_a2accu_dst_data5           //|> o
  ,mac_a2accu_dst_data6           //|> o
  ,mac_a2accu_dst_data7           //|> o
  ,mac_a2accu_dst_mask            //|> o
  ,mac_a2accu_dst_mode            //|> o
  ,mac_a2accu_dst_pd              //|> o
  ,mac_a2accu_dst_pvld            //|> o
  ,mcif2sdp_b_rd_rsp_ready        //|> o
  ,mcif2sdp_e_rd_rsp_ready        //|> o
  ,mcif2sdp_n_rd_rsp_ready        //|> o
  ,mcif2sdp_rd_rsp_ready          //|> o
  ,sdp2csb_resp_pd                //|> o
  ,sdp2csb_resp_valid             //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2cvif_rd_req_pd             //|> o
  ,sdp2cvif_rd_req_valid          //|> o
  ,sdp2cvif_wr_req_pd             //|> o
  ,sdp2cvif_wr_req_valid          //|> o
  ,sdp2glb_done_intr_pd           //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|> o
  ,sdp2mcif_rd_req_pd             //|> o
  ,sdp2mcif_rd_req_valid          //|> o
  ,sdp2mcif_wr_req_pd             //|> o
  ,sdp2mcif_wr_req_valid          //|> o
  ,sdp2pdp_pd                     //|> o
  ,sdp2pdp_valid                  //|> o
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2cvif_rd_req_pd           //|> o
  ,sdp_b2cvif_rd_req_valid        //|> o
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_b2mcif_rd_req_pd           //|> o
  ,sdp_b2mcif_rd_req_valid        //|> o
  ,sdp_e2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2cvif_rd_req_pd           //|> o
  ,sdp_e2cvif_rd_req_valid        //|> o
  ,sdp_e2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_e2mcif_rd_req_pd           //|> o
  ,sdp_e2mcif_rd_req_valid        //|> o
  ,sdp_n2cvif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2cvif_rd_req_pd           //|> o
  ,sdp_n2cvif_rd_req_valid        //|> o
  ,sdp_n2mcif_rd_cdt_lat_fifo_pop //|> o
  ,sdp_n2mcif_rd_req_pd           //|> o
  ,sdp_n2mcif_rd_req_valid        //|> o
  ,sdp_rdma2csb_resp_pd           //|> o
  ,sdp_rdma2csb_resp_valid        //|> o
  );

//
// NV_NVDLA_partition_p_io.v
// DO NOT EDIT, generated by ness version 2.0, backend=verilog
//
// Command: /home/ip/shared/inf/ness/2.0/38823533/bin/run_ispec_backend verilog nvdla_all.nessdb defs.touch-verilog -backend_opt '--nogenerate_io_capture' -backend_opt '--generate_ports'

//<-- reset_in clk=nvdla_core_clk flow=none ctype=nvdla_reset_in_t c_hdr=nvdla_reset_in_iface.h
input  test_mode;
input  direct_reset_;

//<-- nvdla_global_clk clk=none flow=none ctype=ip_clock_global_if_t c_hdr=ip_clock_global_if_iface.h
input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

//<-- cacc2sdp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=cacc2sdp_valid busy=!cacc2sdp_ready ctype=nvdla_accu2pp_if_t c_hdr=nvdla_accu2pp_if_iface.h
input          cacc2sdp_valid;  /* data valid */
output         cacc2sdp_ready;  /* data return handshake */
input  [513:0] cacc2sdp_pd;

//<-- csb2sdp_rdma_req clk=nvdla_core_clk flow=req_busy baseflow=pvld_prdy req=csb2sdp_rdma_req_pvld busy=!csb2sdp_rdma_req_prdy ctype=NV_MSDEC_csb2xx_16m_be_lvl_t c_hdr=NV_MSDEC_csb2xx_16m_be_lvl_iface.h
input         csb2sdp_rdma_req_pvld;  /* data valid */
output        csb2sdp_rdma_req_prdy;  /* data return handshake */
input  [62:0] csb2sdp_rdma_req_pd;

//<-- csb2sdp_req clk=nvdla_core_clk flow=req_busy baseflow=pvld_prdy req=csb2sdp_req_pvld busy=!csb2sdp_req_prdy ctype=NV_MSDEC_csb2xx_16m_be_lvl_t c_hdr=NV_MSDEC_csb2xx_16m_be_lvl_iface.h
input         csb2sdp_req_pvld;  /* data valid */
output        csb2sdp_req_prdy;  /* data return handshake */
input  [62:0] csb2sdp_req_pd;

//<-- cvif2sdp_b_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=cvif2sdp_b_rd_rsp_valid busy=!cvif2sdp_b_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          cvif2sdp_b_rd_rsp_valid;  /* data valid */
output         cvif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_b_rd_rsp_pd;

//<-- cvif2sdp_e_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=cvif2sdp_e_rd_rsp_valid busy=!cvif2sdp_e_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          cvif2sdp_e_rd_rsp_valid;  /* data valid */
output         cvif2sdp_e_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_e_rd_rsp_pd;

//<-- cvif2sdp_n_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=cvif2sdp_n_rd_rsp_valid busy=!cvif2sdp_n_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          cvif2sdp_n_rd_rsp_valid;  /* data valid */
output         cvif2sdp_n_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_n_rd_rsp_pd;

//<-- cvif2sdp_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=cvif2sdp_rd_rsp_valid busy=!cvif2sdp_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          cvif2sdp_rd_rsp_valid;  /* data valid */
output         cvif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2sdp_rd_rsp_pd;

//<-- cvif2sdp_wr_rsp clk=nvdla_core_clk flow=none ctype=nvdla_dma_wr_rsp_t c_hdr=nvdla_dma_wr_rsp_iface.h
input  cvif2sdp_wr_rsp_complete;

output         mac_a2accu_dst_pvld;   /* data valid */
output   [7:0] mac_a2accu_dst_mask;
output   [7:0] mac_a2accu_dst_mode;
output [175:0] mac_a2accu_dst_data0;
output [175:0] mac_a2accu_dst_data1;
output [175:0] mac_a2accu_dst_data2;
output [175:0] mac_a2accu_dst_data3;
output [175:0] mac_a2accu_dst_data4;
output [175:0] mac_a2accu_dst_data5;
output [175:0] mac_a2accu_dst_data6;
output [175:0] mac_a2accu_dst_data7;
output   [8:0] mac_a2accu_dst_pd;

//<-- mac_a2accu_src clk=nvdla_core_clk flow=req_only req=mac_a2accu_src_pvld ctype=nvdla_mac2accu_if_t c_hdr=nvdla_mac2accu_if_iface.h
input         mac_a2accu_src_pvld;   /* data valid */
input   [7:0] mac_a2accu_src_mask;
input   [7:0] mac_a2accu_src_mode;
input [175:0] mac_a2accu_src_data0;
input [175:0] mac_a2accu_src_data1;
input [175:0] mac_a2accu_src_data2;
input [175:0] mac_a2accu_src_data3;
input [175:0] mac_a2accu_src_data4;
input [175:0] mac_a2accu_src_data5;
input [175:0] mac_a2accu_src_data6;
input [175:0] mac_a2accu_src_data7;
input   [8:0] mac_a2accu_src_pd;

//<-- mcif2sdp_b_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=mcif2sdp_b_rd_rsp_valid busy=!mcif2sdp_b_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          mcif2sdp_b_rd_rsp_valid;  /* data valid */
output         mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_b_rd_rsp_pd;

//<-- mcif2sdp_e_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=mcif2sdp_e_rd_rsp_valid busy=!mcif2sdp_e_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          mcif2sdp_e_rd_rsp_valid;  /* data valid */
output         mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_e_rd_rsp_pd;

//<-- mcif2sdp_n_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=mcif2sdp_n_rd_rsp_valid busy=!mcif2sdp_n_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          mcif2sdp_n_rd_rsp_valid;  /* data valid */
output         mcif2sdp_n_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_n_rd_rsp_pd;

//<-- mcif2sdp_rd_rsp clk=nvdla_core_clk flow=req_busy baseflow=valid_ready req=mcif2sdp_rd_rsp_valid busy=!mcif2sdp_rd_rsp_ready ctype=nvdla_dma_rd_rsp_t c_hdr=nvdla_dma_rd_rsp_iface.h
input          mcif2sdp_rd_rsp_valid;  /* data valid */
output         mcif2sdp_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2sdp_rd_rsp_pd;

//<-- mcif2sdp_wr_rsp clk=nvdla_core_clk flow=none ctype=nvdla_dma_wr_rsp_t c_hdr=nvdla_dma_wr_rsp_iface.h
input  mcif2sdp_wr_rsp_complete;

//<-- pwrbus_ram clk=none flow=none ctype=pwrbus_ram_t c_hdr=pwrbus_ram_iface.h
input [31:0] pwrbus_ram_pd;

output        sdp2csb_resp_valid;  /* data valid */
output [33:0] sdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output  sdp2cvif_rd_cdt_lat_fifo_pop;

output        sdp2cvif_rd_req_valid;  /* data valid */
input         sdp2cvif_rd_req_ready;  /* data return handshake */
output [54:0] sdp2cvif_rd_req_pd;

output         sdp2cvif_wr_req_valid;  /* data valid */
input          sdp2cvif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=54,514  */

output [1:0] sdp2glb_done_intr_pd;

output  sdp2mcif_rd_cdt_lat_fifo_pop;

output        sdp2mcif_rd_req_valid;  /* data valid */
input         sdp2mcif_rd_req_ready;  /* data return handshake */
output [54:0] sdp2mcif_rd_req_pd;

output         sdp2mcif_wr_req_valid;  /* data valid */
input          sdp2mcif_wr_req_ready;  /* data return handshake */
output [514:0] sdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=54,514  */

output         sdp2pdp_valid;  /* data valid */
input          sdp2pdp_ready;  /* data return handshake */
output [255:0] sdp2pdp_pd;

output  sdp_b2cvif_rd_cdt_lat_fifo_pop;

output        sdp_b2cvif_rd_req_valid;  /* data valid */
input         sdp_b2cvif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_b2cvif_rd_req_pd;

output  sdp_b2mcif_rd_cdt_lat_fifo_pop;

output        sdp_b2mcif_rd_req_valid;  /* data valid */
input         sdp_b2mcif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_b2mcif_rd_req_pd;

output  sdp_e2cvif_rd_cdt_lat_fifo_pop;

output        sdp_e2cvif_rd_req_valid;  /* data valid */
input         sdp_e2cvif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_e2cvif_rd_req_pd;

output  sdp_e2mcif_rd_cdt_lat_fifo_pop;

output        sdp_e2mcif_rd_req_valid;  /* data valid */
input         sdp_e2mcif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_e2mcif_rd_req_pd;

output  sdp_n2cvif_rd_cdt_lat_fifo_pop;

output        sdp_n2cvif_rd_req_valid;  /* data valid */
input         sdp_n2cvif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_n2cvif_rd_req_pd;

output  sdp_n2mcif_rd_cdt_lat_fifo_pop;

output        sdp_n2mcif_rd_req_valid;  /* data valid */
input         sdp_n2mcif_rd_req_ready;  /* data return handshake */
output [54:0] sdp_n2mcif_rd_req_pd;

output        sdp_rdma2csb_resp_valid;  /* data valid */
output [33:0] sdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

//input  la_r_clk;           
//input  larstn;             

input  nvdla_core_clk;     
input  dla_reset_rstn;     

input  nvdla_clk_ovr_on;

wire   dla_clk_ovr_on_sync;
wire   global_clk_ovr_on_sync;
wire   nvdla_core_rstn;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P:    Reset Syncer                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_p_reset (
   .dla_reset_rstn                 (dla_reset_rstn)                 //|< i
  ,.direct_reset_                  (direct_reset_)                  //|< i
  ,.test_mode                      (test_mode)                      //|< i
  ,.synced_rstn                    (nvdla_core_rstn)                //|> w
  ,.nvdla_clk                      (nvdla_core_clk)                 //|< i
  );

////////////////////////////////////////////////////////////////////////
// Sync for SLCG
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_dla_clk_ovr_on_sync (
   .clk                            (nvdla_core_clk)                 //|< i
  ,.sync_i                         (nvdla_clk_ovr_on)               //|< i
  ,.sync_o                         (dla_clk_ovr_on_sync)            //|> w
  );

NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync (
   .clk                            (nvdla_core_clk)                 //|< i
  ,.prst                           (nvdla_core_rstn)                //|< w
  ,.sync_i                         (global_clk_ovr_on)              //|< i
  ,.sync_o                         (global_clk_ovr_on_sync)         //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P:    Single Data Processor                       //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sdp u_NV_NVDLA_sdp (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< w
  ,.cacc2sdp_valid                 (cacc2sdp_valid)                 //|< i
  ,.cacc2sdp_ready                 (cacc2sdp_ready)                 //|> o
  ,.cacc2sdp_pd                    (cacc2sdp_pd[513:0])             //|< i
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)          //|< i
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)          //|> o
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])      //|< i
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)               //|< i
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)               //|> o
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])           //|< i
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|< i
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|> o
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])    //|< i
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|< i
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|> o
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])    //|< i
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|< i
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|> o
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])    //|< i
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|< i
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|> o
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])      //|< i
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       //|< i
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        //|< i
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        //|> o
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])    //|< i
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        //|< i
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        //|> o
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])    //|< i
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        //|< i
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        //|> o
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])    //|< i
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)          //|< i
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)          //|> o
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])      //|< i
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)       //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)             //|> o
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])          //|> o
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   //|> o
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          //|> o
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          //|< i
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[54:0])       //|> o
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          //|> o
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          //|< i
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd[514:0])      //|> o
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])      //|> o
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)   //|> o
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)          //|> o
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)          //|< i
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[54:0])       //|> o
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)          //|> o
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)          //|< i
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd[514:0])      //|> o
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                  //|> o
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                  //|< i
  ,.sdp2pdp_pd                     (sdp2pdp_pd[255:0])              //|> o
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        //|> o
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        //|< i
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[54:0])     //|> o
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        //|> o
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        //|< i
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[54:0])     //|> o
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|> o
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|< i
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[54:0])     //|> o
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        //|> o
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        //|< i
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[54:0])     //|> o
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        //|> o
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        //|< i
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[54:0])     //|> o
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) //|> o
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)        //|> o
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)        //|< i
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[54:0])     //|> o
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)        //|> o
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])     //|> o
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  );
    //&Connect s/sdp2(mc|cv)if_rd_(req|cdt)/sdp2${1}if_rd_${2}_src/;
    //&Connect s/(mc|cv)if2sdp_rd_(rsp)/${1}if2sdp_rd_${2}_dst/;
    //&Connect s/sdp_b2(mc|cv)if_rd_(req|cdt)/sdp_b2${1}if_rd_${2}_src/;
    //&Connect s/(mc|cv)if2sdp_b_rd_(rsp)/${1}if2sdp_b_rd_${2}_dst/;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P:    Retiming path cmac_a->cacc                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_cmac_a2cacc u_NV_NVDLA_RT_cmac_a2cacc (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< w
  ,.mac2accu_src_pvld              (mac_a2accu_src_pvld)            //|< i
  ,.mac2accu_src_mask              (mac_a2accu_src_mask[7:0])       //|< i
  ,.mac2accu_src_mode              (mac_a2accu_src_mode[7:0])       //|< i
  ,.mac2accu_src_data0             (mac_a2accu_src_data0[175:0])    //|< i
  ,.mac2accu_src_data1             (mac_a2accu_src_data1[175:0])    //|< i
  ,.mac2accu_src_data2             (mac_a2accu_src_data2[175:0])    //|< i
  ,.mac2accu_src_data3             (mac_a2accu_src_data3[175:0])    //|< i
  ,.mac2accu_src_data4             (mac_a2accu_src_data4[175:0])    //|< i
  ,.mac2accu_src_data5             (mac_a2accu_src_data5[175:0])    //|< i
  ,.mac2accu_src_data6             (mac_a2accu_src_data6[175:0])    //|< i
  ,.mac2accu_src_data7             (mac_a2accu_src_data7[175:0])    //|< i
  ,.mac2accu_src_pd                (mac_a2accu_src_pd[8:0])         //|< i
  ,.mac2accu_dst_pvld              (mac_a2accu_dst_pvld)            //|> o
  ,.mac2accu_dst_mask              (mac_a2accu_dst_mask[7:0])       //|> o
  ,.mac2accu_dst_mode              (mac_a2accu_dst_mode[7:0])       //|> o
  ,.mac2accu_dst_data0             (mac_a2accu_dst_data0[175:0])    //|> o
  ,.mac2accu_dst_data1             (mac_a2accu_dst_data1[175:0])    //|> o
  ,.mac2accu_dst_data2             (mac_a2accu_dst_data2[175:0])    //|> o
  ,.mac2accu_dst_data3             (mac_a2accu_dst_data3[175:0])    //|> o
  ,.mac2accu_dst_data4             (mac_a2accu_dst_data4[175:0])    //|> o
  ,.mac2accu_dst_data5             (mac_a2accu_dst_data5[175:0])    //|> o
  ,.mac2accu_dst_data6             (mac_a2accu_dst_data6[175:0])    //|> o
  ,.mac2accu_dst_data7             (mac_a2accu_dst_data7[175:0])    //|> o
  ,.mac2accu_dst_pd                (mac_a2accu_dst_pd[8:0])         //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition P:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_P_obs;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_p


