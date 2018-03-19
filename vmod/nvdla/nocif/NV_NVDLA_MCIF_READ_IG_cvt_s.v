// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_cvt_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_cvt_s (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,cq_wr_prdy              //|< i
  ,eg2ig_axi_vld           //|< i
  ,mcif2noc_axi_ar_arready //|< i
  ,reg2dp_rd_os_cnt        //|< i
  ,spt2cvt_req_pd          //|< i
  ,spt2cvt_req_valid       //|< i
  ,cq_wr_pd                //|> o
  ,cq_wr_pvld              //|> o
  ,cq_wr_thread_id         //|> o
  ,mcif2noc_axi_ar_araddr  //|> o
  ,mcif2noc_axi_ar_arid    //|> o
  ,mcif2noc_axi_ar_arlen   //|> o
  ,mcif2noc_axi_ar_arvalid //|> o
  ,spt2cvt_req_ready       //|> o
  );
//
// NV_NVDLA_MCIF_READ_IG_cvt_ports.v
/////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         spt2cvt_req_valid;  /* data valid */
output        spt2cvt_req_ready;  /* data return handshake */
input  [42:0] spt2cvt_req_pd;

output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [3:0] cq_wr_thread_id;
output [6:0] cq_wr_pd;

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [31:0] mcif2noc_axi_ar_araddr;
/////////////////////////////////////////////////////

//&Ports /streamid/; //stepheng.
input  [7:0] reg2dp_rd_os_cnt;
input        eg2ig_axi_vld;
reg          eg2ig_axi_vld_d;
wire         os_adv;
reg    [8:0] os_cnt_cur;
wire  [10:0] os_cnt_nxt;
wire  [31:0] axi_addr;
wire   [3:0] axi_axid;
wire  [37:0] axi_cmd_pd;
wire         axi_cmd_rdy;
wire         axi_cmd_vld;
wire   [1:0] axi_len;
wire  [31:0] cmd_addr;
wire   [3:0] cmd_axid;
wire         cmd_ftran;
wire         cmd_ltran;
wire         cmd_odd;
wire         cmd_rdy;
wire   [2:0] cmd_size;
wire         cmd_swizzle;
wire         cmd_vld;
wire         ig2cq_fdrop;
wire         ig2cq_ldrop;
wire   [1:0] ig2cq_lens;
wire         ig2cq_ltran;
wire         ig2cq_odd;
wire         ig2cq_swizzle;
wire         mon_end_offset_c;
wire  [31:0] opipe_axi_addr;
wire   [3:0] opipe_axi_axid;
wire   [1:0] opipe_axi_len;
//wire  [69:0] opipe_axi_pd;
wire         opipe_axi_rdy;
//wire         opipe_axi_vld;
wire   [2:0] os_cnt_add;
wire         os_cnt_add_en;
wire         os_cnt_cen;
wire         os_cnt_full;
wire   [2:0] os_inp_add_nxt;
wire   [9:0] os_inp_nxt;
wire   [0:0] os_inp_sub_nxt;
////////////////////////////////////////////////////
assign cmd_vld = spt2cvt_req_valid;
assign spt2cvt_req_ready = cmd_rdy;

assign       cmd_axid[3:0] =    spt2cvt_req_pd[3:0];
assign       cmd_addr[31:0] =    spt2cvt_req_pd[35:4];
assign       cmd_size[2:0] =    spt2cvt_req_pd[38:36];
assign        cmd_swizzle  =    spt2cvt_req_pd[39];
assign        cmd_odd  =    spt2cvt_req_pd[40];
assign        cmd_ltran  =    spt2cvt_req_pd[41];
assign        cmd_ftran  =    spt2cvt_req_pd[42];

// IG===AXI Trans GEN
assign axi_axid   = cmd_axid;
assign axi_addr = cmd_addr; // & 32'hffff_fff8;
assign axi_len[1:0]  = cmd_size[1:0];

// IG===Context Queue
// ( Upp,Low)    10   11     00   01
// Count
// 0:            F           1M    L
// 1:            F+1M F+L    2M 1M+L
// 2:            F+2M F+1M+L 3M 2M+L
// 3:            F+3M F+2M+L 4M 3M+L
assign cq_wr_pvld = cmd_vld & axi_cmd_rdy & !os_cnt_full; // inter-lock with opipe

assign ig2cq_lens  = axi_len;
assign ig2cq_swizzle = cmd_swizzle;
assign ig2cq_ltran = cmd_ltran;
assign ig2cq_odd   = cmd_odd;
assign ig2cq_fdrop = 1'b0;//cmd_ftran & stt_addr_is_32_align;
assign ig2cq_ldrop = 1'b0;//cmd_ltran & end_addr_is_32_align;

assign      cq_wr_pd[1:0] =    ig2cq_lens[1:0];
assign      cq_wr_pd[2] =    ig2cq_swizzle ;
assign      cq_wr_pd[3] =    ig2cq_odd ;
assign      cq_wr_pd[4] =    ig2cq_ltran ;
assign      cq_wr_pd[5] =    ig2cq_fdrop ;
assign      cq_wr_pd[6] =    ig2cq_ldrop ;

assign cq_wr_thread_id = cmd_axid;

// IG===AXI OUT PIPE
assign axi_cmd_vld = cmd_vld & cq_wr_prdy & !os_cnt_full; // inter-lock with context-queue
assign cmd_rdy = axi_cmd_rdy & cq_wr_prdy & !os_cnt_full;

assign os_inp_add_nxt[2:0] = cmd_vld ? (axi_len + 1) : 3'd0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg2ig_axi_vld_d <= 1'b0;
  end else begin
  eg2ig_axi_vld_d <= eg2ig_axi_vld;
  end
end
assign os_inp_sub_nxt[0:0] = eg2ig_axi_vld_d ? 1'd1 : 1'd0;
assign os_inp_nxt[9:0] = os_cnt_cur + os_inp_add_nxt - os_inp_sub_nxt;

// 256 outstanding trans
assign os_cnt_add_en = axi_cmd_vld & axi_cmd_rdy;
assign os_cnt_cen = os_cnt_add_en | eg2ig_axi_vld_d;
assign os_cnt_add = os_cnt_add_en ? (axi_len + 1) : 3'd0;
assign os_cnt_full = os_inp_nxt > (reg2dp_rd_os_cnt[7:0] + 1);

assign  os_adv = os_cnt_add[2:0] != {{2{1'b0}}, eg2ig_axi_vld_d};
assign  os_cnt_nxt[10:0] = (os_adv)? (os_cnt_cur + os_cnt_add[2:0] - eg2ig_axi_vld_d) : {1'b0, 1'b0, os_cnt_cur};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    os_cnt_cur[8:0] <= 0;
  end else if (os_cnt_cen) begin
  os_cnt_cur[8:0] <= os_cnt_nxt[8:0];
  end
end
    
assign axi_cmd_pd = {axi_axid,axi_addr,axi_len};
//: &eperl::pipe(" -wid 38 -is -do opipe_axi_pd -vo opipe_axi_vld -ri opipe_axi_rdy -di axi_cmd_pd -vi axi_cmd_vld -ro axi_cmd_rdy_f ");
assign axi_cmd_rdy = axi_cmd_rdy_f;
assign {opipe_axi_axid,opipe_axi_addr,opipe_axi_len} = opipe_axi_pd;


// IG===AXI OUT ZERO EXT
assign mcif2noc_axi_ar_arid     = {{4{1'b0}}, opipe_axi_axid};
assign mcif2noc_axi_ar_araddr   = opipe_axi_addr;
assign mcif2noc_axi_ar_arlen    = {{2{1'b0}}, opipe_axi_len}; //stepheng.

// IG===AXI OUT valid/ready
assign mcif2noc_axi_ar_arvalid  = opipe_axi_vld;
assign opipe_axi_rdy            = mcif2noc_axi_ar_arready;

//==========================================

endmodule // NV_NVDLA_MCIF_READ_IG_cvt




