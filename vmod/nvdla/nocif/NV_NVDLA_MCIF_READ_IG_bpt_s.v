// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_bpt_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_bpt_s (
   nvdla_core_clk           //|< i
  ,nvdla_core_rstn          //|< i
  ,bpt2arb_req_ready        //|< i
  ,dma2bpt_cdt_lat_fifo_pop //|< i
  ,dma2bpt_req_pd           //|< i
  ,dma2bpt_req_valid        //|< i
  ,tieoff_axid              //|< i
  ,tieoff_lat_fifo_depth    //|< i
  ,bpt2arb_req_pd           //|> o
  ,bpt2arb_req_valid        //|> o
  ,dma2bpt_req_ready        //|> o
  );
//////////////////////////////////////////////
// NV_NVDLA_MCIF_READ_IG_bpt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         dma2bpt_req_valid;  /* data valid */
output        dma2bpt_req_ready;  /* data return handshake */
input  [MEMREQ_PD_BW-1:0] dma2bpt_req_pd;
input  dma2bpt_cdt_lat_fifo_pop;

output        bpt2arb_req_valid;  /* data valid */
input         bpt2arb_req_ready;  /* data return handshake */
output [74:0] bpt2arb_req_pd;

input  [3:0] tieoff_axid;
input  [7:0] tieoff_lat_fifo_depth;
//////////////////////////////////////////////
reg   [13:0] count_req;
wire         lat_adv;
reg    [7:0] lat_cnt_cur;
wire   [9:0] lat_cnt_nxt;
reg    [7:0] lat_count_cnt;
reg    [0:0] lat_count_dec;
reg   [31:0] out_addr;
reg    [1:0] out_size;
reg   [13:0] req_num;
wire    [2:0] slot_needed;
//wire   [1:0] beat_size_NC;
wire         bpt2arb_accept;
wire  [31:0] bpt2arb_addr;
wire   [3:0] bpt2arb_axid;
wire         bpt2arb_ftran;
wire         bpt2arb_ltran;
wire         bpt2arb_odd;
wire   [2:0] bpt2arb_size;
wire         bpt2arb_swizzle;
wire   [1:0] end_offset;
wire   [2:0] ftran_num;
wire   [1:0] ftran_size;
wire  [31:0] in_addr;
wire         in_rdy;
wire         in_rdy_p;
wire  [14:0] in_size;
wire  [MEMREQ_PD_BW-1:0] in_vld_pd;
wire         is_ftran;
wire         is_ltran;
wire         is_mtran;
wire         is_single_tran;
wire   [2:0] lat_count_inc;
wire   [7:0] lat_fifo_free_slot;
wire         lat_fifo_stall_enable;
wire   [2:0] ltran_num;
wire   [1:0] ltran_size;
wire         mon_end_offset_c;
wire         mon_lat_fifo_free_slot_c;
wire         mon_out_beats_c;
wire  [14:0] mtran_num;
wire         req_enable;
wire         req_rdy;
wire         req_vld;
wire   [1:0] size_offset;
wire   [1:0] stt_offset;
//////////////////////////////////////////////
//: my $mem = MEMREQ_PD_BW;
//: &eperl::pipe(" -wid $mem -os -do in_pd_p -vo in_vld_p -ri in_rdy_p  -di dma2bpt_req_pd -vi dma2bpt_req_valid -ro dma2bpt_req_ready ");
//: &eperl::pipe(" -wid $mem -is -do in_pd -vo in_vld -ri in_rdy -di in_pd_p -vi in_vld_p -ro in_rdy_p_f ");
assign in_rdy_p = in_rdy_p_f;
    
assign in_rdy = req_rdy & is_ltran;

assign in_vld_pd = {MEMREQ_PD_BW{in_vld}} & in_pd;

assign       in_addr[31:0] =    in_vld_pd[31:0];
assign       in_size[14:0] =    in_vld_pd[46:32];
///////////DorisL////////////////////////////
//keep burst length to 4, then update boundary from 4*64B to 4*8B
// DorisL assign stt_offset[2:0] = in_addr[5:3];
// DorisL assign size_offset[2:0] = in_size[2:0];
// DorisL assign {mon_end_offset_c, end_offset[2:0]} = stt_offset + size_offset;
// DorisL 
// DorisL assign is_single_tran = (stt_offset + in_size) < 8;
// DorisL 
// DorisL assign ftran_size[2:0] = is_single_tran ? size_offset : 3'd7-stt_offset;
// DorisL assign ftran_num[3:0] = ftran_size + 1;
// DorisL 
// DorisL assign ltran_size[2:0] = is_single_tran ? `tick_x_or_0 : end_offset; // when single tran, size of ltran is meanningless
// DorisL assign ltran_num[3:0]  = is_single_tran ? 0 : end_offset+1;
// DorisL 
// DorisL assign mtran_num = in_size + 1 - ftran_num - ltran_num;

//keep burst length to 4, then update boundary from 4*64B to 4*8B
assign stt_offset[1:0] = in_addr[4:3];
assign size_offset[1:0] = in_size[1:0];
assign {mon_end_offset_c, end_offset[1:0]} = stt_offset + size_offset;

assign is_single_tran = (stt_offset + in_size) < 4;

assign ftran_size[1:0] = is_single_tran ? size_offset : 2'd3-stt_offset;
assign ftran_num[2:0] = ftran_size + 1;

assign ltran_size[1:0] = is_single_tran ? `tick_x_or_0 : end_offset; // when single tran, size of ltran is meanningless
assign ltran_num[2:0]  = is_single_tran ? 0 : end_offset+1;

assign mtran_num = in_size + 1 - ftran_num - ltran_num;
//================
// check the empty entry of lat.fifo
//================
//always @( *) begin
//    if (is_single_tran) begin
//        slot_needed = (out_size>>1) + 1;
//    end else if (is_ltran) begin
//        slot_needed = ((out_size+out_swizzle)>>1) + 1; //spyglass disable SelfDeterminedExpr-ML
//    end else if (is_ftran) begin
//        slot_needed = (out_size+1)>>1;
//    end else begin
//        slot_needed = 3'd4;
//    end
//end
/*always @(*) begin
    if (is_single_tran || is_ltran || is_ftran) begin
        slot_needed = out_size + 1;
    end else begin
        slot_needed = 3'd4;
    end
end*/

assign slot_needed = 3'd1;
assign lat_fifo_stall_enable = (tieoff_lat_fifo_depth!=0);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lat_count_dec <= 1'b0;
  end else begin
  lat_count_dec <= dma2bpt_cdt_lat_fifo_pop;
  end
end
assign lat_count_inc = (bpt2arb_accept && lat_fifo_stall_enable ) ? slot_needed : 0;

// lat adv logic
assign  lat_adv = lat_count_inc[2:0] != {{2{1'b0}}, lat_count_dec};
assign  lat_cnt_nxt[9:0] = (lat_adv)? (lat_cnt_cur + lat_count_inc[2:0] - lat_count_dec[0:0]) : {1'b0, 1'b0, lat_cnt_cur};

// lat flops
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lat_cnt_cur[7:0] <= 0;
  end else begin
  lat_cnt_cur[7:0] <= lat_cnt_nxt[7:0];
  end
end

always @(*) begin
  lat_count_cnt[7:0] = lat_cnt_cur[7:0];
end
  
assign {mon_lat_fifo_free_slot_c,lat_fifo_free_slot[7:0]} = tieoff_lat_fifo_depth - lat_count_cnt;
assign req_enable = (!lat_fifo_stall_enable) || ({{5{1'b0}}, slot_needed} <= lat_fifo_free_slot);

////================
//// bsp out: swizzle
////================
//assign out_swizzle = (stt_offset[0]==1'b1); //
//assign out_odd     = (in_size[0]==1'b0);    //

//================
// bsp out: size
//================
always @(*) begin
    out_size = {2{`tick_x_or_0}};
    if (is_ftran) begin
        out_size = ftran_size;
    end else if (is_mtran) begin
        out_size = 2'd3;
    end else if (is_ltran) begin
        out_size = ltran_size;
    end
end
//================
// bsp out: USER: SIZE
//================
//================
// bpt2arb: addr
//================
always @(posedge nvdla_core_clk) begin
    if (bpt2arb_accept) begin
        //if (is_ftran) begin
        //    out_addr <= in_addr + ((ftran_size+1)<<3);
        //end else begin
        //    out_addr <= out_addr + (8<<3);
        //end
        if (is_ftran) begin
            out_addr <= in_addr + 8;
        end else begin
            out_addr <= out_addr + 8;
        end
    end
end
//================
// tran count
//================
always @(*) begin
    //if (is_single_tran) begin
    //    req_num = 1;
    //end else if (mtran_num==0) begin
    //    req_num = 2;
    //end else begin
    //    req_num = 2 + mtran_num[14:3];
    //end
        req_num = in_size+1; 
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_req <= {13{1'b0}};
  end else if (bpt2arb_accept) begin
        if (is_ltran) begin
            count_req <= 0;
        end else begin
            count_req <= count_req + 1;
        end
  end
end

assign is_ftran = (count_req==0);
//assign is_mtran = (count_req>0 && count_req<req_num-1);
assign is_ltran = (count_req==req_num-1);
//
assign req_rdy = req_enable & bpt2arb_req_ready;
assign req_vld = req_enable & in_vld; 

assign bpt2arb_req_valid = req_vld;
assign bpt2arb_accept = bpt2arb_req_valid & req_rdy;
//
assign bpt2arb_axid  = tieoff_axid[3:0];
assign bpt2arb_addr = (is_ftran) ? in_addr : out_addr;
assign bpt2arb_size = 3'b0; //{1'b0,out_size};
assign bpt2arb_swizzle = 1'b0;//out_swizzle;
assign bpt2arb_odd   = 1'b0;//out_odd;
assign bpt2arb_ltran = is_ltran;
assign bpt2arb_ftran = is_ftran;
//
assign      bpt2arb_req_pd[3:0] =    bpt2arb_axid[3:0];
assign      bpt2arb_req_pd[67:4] =    {32'd0,bpt2arb_addr[31:0]};
assign      bpt2arb_req_pd[70:68] =    bpt2arb_size[2:0];
assign      bpt2arb_req_pd[71] =    bpt2arb_swizzle ;
assign      bpt2arb_req_pd[72] =    bpt2arb_odd ;
assign      bpt2arb_req_pd[73] =    bpt2arb_ltran ;
assign      bpt2arb_req_pd[74] =    bpt2arb_ftran ;


endmodule // NV_NVDLA_MCIF_READ_IG_bpt


