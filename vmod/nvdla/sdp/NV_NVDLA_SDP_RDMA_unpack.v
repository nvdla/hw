// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_unpack.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_RDMA_unpack (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_data
  ,inp_pvld
  ,inp_prdy
  ,inp_end
  ,out_pvld
  ,out_data
  ,out_prdy
);

parameter   RATIO = 4*AM_DW/NVDLA_MEMIF_WIDTH;

input nvdla_core_clk;
input nvdla_core_rstn;

input  inp_end;
input  inp_pvld;
output inp_prdy;
input  [NVDLA_DMA_RD_RSP-1:0] inp_data;

output out_pvld;
input  out_prdy;
output [4*AM_DW+3:0] out_data;

reg    [1:0] pack_cnt;
wire   [2:0] pack_cnt_nxt;
reg          mon_pack_cnt;
reg          pack_pvld;
wire         pack_prdy;
wire         inp_acc;
wire         is_pack_last;
reg  [3:0]       pack_mask;
reg  [AM_DW-1:0] pack_seq0;
reg  [AM_DW-1:0] pack_seq1;
reg  [AM_DW-1:0] pack_seq2;
reg  [AM_DW-1:0] pack_seq3;
wire [4*AM_DW-1:0] pack_total;


assign pack_prdy = out_prdy;
assign out_pvld  = pack_pvld;
assign inp_prdy  = (!pack_pvld) | pack_prdy ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn)
      pack_pvld <= 1'b0;
  else if (inp_prdy)
      pack_pvld <= inp_pvld & is_pack_last;
end
assign inp_acc = inp_pvld & inp_prdy;


wire [3:0]  data_mask = {{(4-NVDLA_DMA_MASK_BIT){1'b0}},inp_data[NVDLA_DMA_RD_RSP-1:NVDLA_MEMIF_WIDTH]};
wire [1:0]  data_size = data_mask[0] + data_mask[1] + data_mask[2] + data_mask[3];
assign      pack_cnt_nxt = pack_cnt + data_size;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
      {mon_pack_cnt,pack_cnt} <= 3'h0;
  end else begin
    if (inp_acc) begin
        if (is_pack_last) begin
            {mon_pack_cnt,pack_cnt} <= 3'h0;
        end else begin
            {mon_pack_cnt,pack_cnt} <= pack_cnt_nxt;
        end
    end
  end
end

assign is_pack_last = (pack_cnt_nxt == 3'h4) | inp_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) 
     pack_mask <= 4'h0;
  else if (inp_acc & is_pack_last) 
     pack_mask <= pack_cnt_nxt == 3'h4 ? 4'hf : pack_cnt_nxt == 3'h3 ? 4'h7 : 
                  pack_cnt_nxt == 3'h2 ? 4'h3 : pack_cnt_nxt; 
end 


generate
if(RATIO == 1) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) {pack_seq3,pack_seq2,pack_seq1,pack_seq0} <= inp_data[4*AM_DW-1:0]; 
end
end

else if(RATIO == 2) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==3'h0)  {pack_seq1,pack_seq0} <= inp_data[2*AM_DW-1:0];
    if (pack_cnt==3'h2)  {pack_seq3,pack_seq2} <= inp_data[2*AM_DW-1:0];
  end
end
end

else if(RATIO == 4) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==3'h0)  pack_seq0 <= inp_data[AM_DW-1:0];
    if (pack_cnt==3'h1)  pack_seq1 <= inp_data[AM_DW-1:0];
    if (pack_cnt==3'h2)  pack_seq2 <= inp_data[AM_DW-1:0];
    if (pack_cnt==3'h3)  pack_seq3 <= inp_data[AM_DW-1:0];
  end
end
end

endgenerate


assign pack_total = {pack_seq3,pack_seq2,pack_seq1,pack_seq0};

assign out_data   = {pack_mask[3:0],pack_total[4*AM_DW-1:0]};



endmodule // NV_NVDLA_SDP_RDMA_unpack

