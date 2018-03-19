// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_unpack.v

module NV_NVDLA_SDP_WDMA_unpack (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cfg_dp_8
  ,inp_pvld
  ,inp_data
  ,inp_prdy
  ,out_pvld
  ,out_data
  ,out_prdy
);

parameter   IW = 256;
parameter   IHW = IW/2;
parameter   OW = 256;
parameter   RATIO = OW/IW; 

input nvdla_core_clk;
input nvdla_core_rstn;
input  cfg_dp_8;
input  inp_pvld;
output inp_prdy;
input  [IW-1:0] inp_data;

output out_pvld;
input  out_prdy;
output [OW-1:0] out_data;

reg    [3:0]  pack_cnt;
reg           pack_pvld;
wire          pack_prdy;
wire          inp_acc;
wire          is_pack_last;
reg  [IW-1:0] pack_seg0;
reg  [IW-1:0] pack_seg1;
reg  [IW-1:0] pack_seg2;
reg  [IW-1:0] pack_seg3;
reg  [IW-1:0] pack_seg4;
reg  [IW-1:0] pack_seg5;
reg  [IW-1:0] pack_seg6;
reg  [IW-1:0] pack_seg7;
reg  [IW-1:0] pack_seg8;
reg  [IW-1:0] pack_seg9;
reg  [IW-1:0] pack_sega;
reg  [IW-1:0] pack_segb;
reg  [IW-1:0] pack_segc;
reg  [IW-1:0] pack_segd;
reg  [IW-1:0] pack_sege;
reg  [IW-1:0] pack_segf;
wire [8*IW-1:0] pack_total_8;
wire [8*IW-1:0] pack_total_16;
wire [8*IW-1:0] pack_total;


assign pack_prdy = out_prdy;
assign out_pvld  = pack_pvld;
assign inp_prdy  = (!pack_pvld) | pack_prdy ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pack_pvld <= 1'b0;
  end 
  else if ((inp_prdy) == 1'b1) begin
    pack_pvld <= inp_pvld & is_pack_last;
  end
end
assign inp_acc = inp_pvld & inp_prdy;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pack_cnt <= {4{1'b0}};
  end else begin
    if (inp_acc) begin
        if (is_pack_last) begin
            pack_cnt <= 0;
        end else begin
            pack_cnt <= pack_cnt + 1;
        end
    end
  end
end

assign is_pack_last = cfg_dp_8 ? (pack_cnt==2*RATIO-1) : (pack_cnt==RATIO-1);


generate
if(RATIO == 1) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==4'h0)  pack_seg0 <= inp_data;
    if (pack_cnt==4'h1)  pack_seg1 <= inp_data;
  end
end
end

else if(RATIO == 2) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==4'h0)  pack_seg0 <= inp_data;
    if (pack_cnt==4'h1)  pack_seg1 <= inp_data;
    if (pack_cnt==4'h2)  pack_seg2 <= inp_data;
    if (pack_cnt==4'h3)  pack_seg3 <= inp_data;
  end
end
end

else if (RATIO == 4) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==4'h0)  pack_seg0 <= inp_data;
    if (pack_cnt==4'h1)  pack_seg1 <= inp_data;
    if (pack_cnt==4'h2)  pack_seg2 <= inp_data;
    if (pack_cnt==4'h3)  pack_seg3 <= inp_data;
    if (pack_cnt==4'h4)  pack_seg4 <= inp_data;
    if (pack_cnt==4'h5)  pack_seg5 <= inp_data;
    if (pack_cnt==4'h6)  pack_seg6 <= inp_data;
    if (pack_cnt==4'h7)  pack_seg7 <= inp_data;
  end
end
end               

else if (RATIO == 8) begin
always @(posedge nvdla_core_clk) begin
  if (inp_acc) begin
    if (pack_cnt==4'h0)  pack_seg0 <= inp_data;
    if (pack_cnt==4'h1)  pack_seg1 <= inp_data;
    if (pack_cnt==4'h2)  pack_seg2 <= inp_data;
    if (pack_cnt==4'h3)  pack_seg3 <= inp_data;
    if (pack_cnt==4'h4)  pack_seg4 <= inp_data;
    if (pack_cnt==4'h5)  pack_seg5 <= inp_data;
    if (pack_cnt==4'h6)  pack_seg6 <= inp_data;
    if (pack_cnt==4'h7)  pack_seg7 <= inp_data;
    if (pack_cnt==4'h8)  pack_seg8 <= inp_data;
    if (pack_cnt==4'h9)  pack_seg9 <= inp_data;
    if (pack_cnt==4'ha)  pack_sega <= inp_data;
    if (pack_cnt==4'hb)  pack_segb <= inp_data;
    if (pack_cnt==4'hc)  pack_segc <= inp_data;
    if (pack_cnt==4'hd)  pack_segd <= inp_data;
    if (pack_cnt==4'he)  pack_sege <= inp_data;
    if (pack_cnt==4'hf)  pack_segf <= inp_data;
  end
end
end               

endgenerate


assign pack_total_8 = {pack_segf[IHW-1:0], pack_sege[IHW-1:0], pack_segd[IHW-1:0], pack_segc[IHW-1:0],
                       pack_segb[IHW-1:0], pack_sega[IHW-1:0], pack_seg9[IHW-1:0], pack_seg8[IHW-1:0],
                       pack_seg7[IHW-1:0], pack_seg6[IHW-1:0], pack_seg5[IHW-1:0], pack_seg4[IHW-1:0],
                       pack_seg3[IHW-1:0], pack_seg2[IHW-1:0], pack_seg1[IHW-1:0], pack_seg0[IHW-1:0]};

assign pack_total_16 = {pack_seg7 , pack_seg6 , pack_seg5 , pack_seg4,
                        pack_seg3 , pack_seg2 , pack_seg1 , pack_seg0};

assign pack_total = cfg_dp_8 ? pack_total_8 : pack_total_16;

assign out_data  = pack_total[OW-1:0];


endmodule // NV_NVDLA_SDP_WDMA_unpack

