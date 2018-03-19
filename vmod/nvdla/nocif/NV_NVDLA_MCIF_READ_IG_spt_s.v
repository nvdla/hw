// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_spt_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_spt_s (
   nvdla_core_clk    //|< i
  ,nvdla_core_rstn   //|< i
  ,arb2spt_req_valid //|< i
  ,arb2spt_req_ready //|> o
  ,arb2spt_req_pd    //|< i
  ,spt2cvt_req_valid //|> o
  ,spt2cvt_req_ready //|< i
  ,spt2cvt_req_pd    //|> o
  );
////////////////////////////////////
// NV_NVDLA_MCIF_READ_IG_spt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         arb2spt_req_valid;  /* data valid */
output        arb2spt_req_ready;  /* data return handshake */
input  [42:0] arb2spt_req_pd;

output        spt2cvt_req_valid;  /* data valid */
input         spt2cvt_req_ready;  /* data return handshake */
output [42:0] spt2cvt_req_pd;
///////////////////////////////////////////////
reg     [1:0] beat_count;
reg     [2:0] out_size;
wire          spt_out_rdy;
//wire    [2:0] first_addr_offset;
wire          is_first_beat;
//wire          is_ftran_odd;
wire          is_last_beat;
//wire          is_ltran_odd;
//wire    [2:0] non_first_addr_offset;
wire   [31:0] out_addr;
//wire    [2:0] out_addr_offset;
wire          out_ftran;
wire          out_ltran;
wire          req_accept;
wire   [31:0] spt2cvt_addr;
wire    [3:0] spt2cvt_axid;
wire          spt2cvt_ftran;
wire          spt2cvt_ltran;
wire          spt2cvt_odd;
wire    [2:0] spt2cvt_size;
wire          spt2cvt_swizzle;
wire          spt_inc;
wire   [42:0] spt_out_pd;
wire          spt_out_vld;
wire   [31:0] spt_req_addr;
wire    [3:0] spt_req_axid;
wire          spt_req_ftran;
wire          spt_req_ltran;
wire          spt_req_odd;
//wire    [1:0] spt_req_offset;
//wire   [42:0] spt_req_pd;
wire          spt_req_rdy;
wire    [2:0] spt_req_size;
wire          spt_req_swizzle;
//wire          spt_req_vld;
wire   [42:0] spt_req_vld_pd;
////////////////////////////////////////////////////////
//: &eperl::pipe(" -wid 43 -do spt_req_pd -vo spt_req_vld -ri spt_req_rdy -di arb2spt_req_pd -vi arb2spt_req_valid -ro arb2spt_req_ready ");

assign spt_req_rdy = spt_out_rdy & is_last_beat;

assign spt_req_vld_pd = {43{spt_req_vld}} & spt_req_pd;

assign       spt_req_axid[3:0] =    spt_req_vld_pd[3:0];
assign       spt_req_addr[31:0] =    spt_req_vld_pd[35:4];
assign       spt_req_size[2:0] =    spt_req_vld_pd[38:36];
assign        spt_req_swizzle  =    spt_req_vld_pd[39];
assign        spt_req_odd  =    spt_req_vld_pd[40];
assign        spt_req_ltran  =    spt_req_vld_pd[41];
assign        spt_req_ftran  =    spt_req_vld_pd[42];
//==============
// size -> size_64 mapping & Split
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {2{1'b0}};
  end else if (req_accept) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
  end
end
assign is_last_beat  = (beat_count==spt_req_size[1:0]);
assign is_first_beat = (beat_count==0);
//==============
// OUT: FTRAN / LTRAN
//==============
assign out_ftran = spt_req_ftran & is_first_beat;
assign out_ltran = spt_req_ltran & is_last_beat;
//==============
// OUT: SIZE
//==============
assign out_size = 0;
//==============
// OUT: ADDR
//==============
//assign spt_req_offset = spt_req_addr[4:3];
//assign first_addr_offset = spt_req_offset;
//assign non_first_addr_offset[2:0] = (spt_req_offset[2:1] + beat_count) << 1; //spyglass disable SelfDeterminedExpr-ML
//assign out_addr_offset = (beat_count==0) ? first_addr_offset : non_first_addr_offset;

assign out_addr = spt_req_addr; // {spt_req_addr[31:5],beat_count,{3{1'b0}}}; //DorisL
//==============
//==============
assign spt2cvt_axid = spt_req_axid;
assign spt2cvt_addr = out_addr;
assign spt2cvt_size = out_size;
assign spt2cvt_swizzle = spt_req_swizzle;
assign spt2cvt_odd   = spt_req_odd;
assign spt2cvt_ftran  = out_ftran;
assign spt2cvt_ltran  = out_ltran;

assign req_accept = spt_out_vld & spt_out_rdy;

assign spt_out_vld = spt_req_vld;

// PKT_PACK_WIRE( cvt_read_cmd , spt2cvt_ , spt_out_pd )
assign      spt_out_pd[3:0] =    spt2cvt_axid[3:0];
assign      spt_out_pd[35:4] =    spt2cvt_addr[31:0];
assign      spt_out_pd[38:36] =    spt2cvt_size[2:0];
assign      spt_out_pd[39] =    spt2cvt_swizzle ;
assign      spt_out_pd[40] =    spt2cvt_odd ;
assign      spt_out_pd[41] =    spt2cvt_ltran ;
assign      spt_out_pd[42] =    spt2cvt_ftran ;

//: &eperl::pipe(" -wid 43 -do spt2cvt_req_pd -vo spt2cvt_req_valid -ri spt2cvt_req_ready -di spt_out_pd -vi spt_out_vld -ro spt_out_rdy_f ");
assign spt_out_rdy = spt_out_rdy_f;


endmodule // NV_NVDLA_MCIF_READ_IG_spt



