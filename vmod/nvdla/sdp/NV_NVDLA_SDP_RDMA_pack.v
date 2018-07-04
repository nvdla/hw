// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_pack.v

module NV_NVDLA_SDP_RDMA_pack (
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

parameter   IW = 512;   //data width
parameter   CW = 1;     //control width  
parameter   OW = 256; 
parameter   RATIO = IW/OW; 

input  nvdla_core_clk;
input  nvdla_core_rstn;
input  cfg_dp_8;

input  inp_pvld;
output inp_prdy;
input  [IW+CW-1:0] inp_data;

output out_pvld;
input  out_prdy;
output [OW+CW-1:0] out_data;

reg   [CW-1:0] ctrl_done;
wire  [CW-1:0] ctrl_end;
reg   [IW-1:0] pack_data;
reg            pack_pvld;
wire           pack_prdy;
wire           inp_acc;
wire           out_acc;
wire           is_pack_last;
reg   [OW-1:0] mux_data;


assign out_data  = {ctrl_end,mux_data};

assign pack_prdy = out_prdy;
assign out_pvld  = pack_pvld;
assign inp_prdy = (!pack_pvld) | (pack_prdy & is_pack_last);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) 
    pack_pvld <= 1'b0;
  else if (inp_prdy) 
    pack_pvld <= inp_pvld;
end

assign inp_acc = inp_pvld & inp_prdy;
assign out_acc = out_pvld & out_prdy;

always @(posedge nvdla_core_clk) begin
  if (inp_acc) 
     ctrl_done[CW-1:0] <= inp_data[IW+CW-1:IW];
  else if (out_acc & is_pack_last)
     ctrl_done[CW-1:0] <= {CW{1'b0}};
end
assign ctrl_end = ctrl_done & {CW{is_pack_last}};

//push data 
always @(posedge nvdla_core_clk) begin
  if (inp_acc) 
    pack_data <= inp_data[IW-1:0];
end

wire [OW*16-1:0] pack_data_ext = {{(OW*16-IW){1'b0}},pack_data};  //spyglass disable W164b

reg  [3:0]  pack_cnt;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) 
    pack_cnt <= 4'h0;
  else if (out_acc) begin
    if (is_pack_last) 
        pack_cnt <= 4'h0;
    else 
        pack_cnt <= pack_cnt + 1;
  end
end

assign is_pack_last = !cfg_dp_8 ? (pack_cnt==RATIO/2-1) : (pack_cnt==RATIO-1);

wire [OW-1:0]  pack_seg0  = pack_data_ext[((OW*0) + OW - 1):OW*0];
wire [OW-1:0]  pack_seg1  = pack_data_ext[((OW*1) + OW - 1):OW*1];
wire [OW-1:0]  pack_seg2  = pack_data_ext[((OW*2) + OW - 1):OW*2];
wire [OW-1:0]  pack_seg3  = pack_data_ext[((OW*3) + OW - 1):OW*3];
wire [OW-1:0]  pack_seg4  = pack_data_ext[((OW*4) + OW - 1):OW*4];
wire [OW-1:0]  pack_seg5  = pack_data_ext[((OW*5) + OW - 1):OW*5];
wire [OW-1:0]  pack_seg6  = pack_data_ext[((OW*6) + OW - 1):OW*6];
wire [OW-1:0]  pack_seg7  = pack_data_ext[((OW*7) + OW - 1):OW*7];
wire [OW-1:0]  pack_seg8  = pack_data_ext[((OW*8) + OW - 1):OW*8];
wire [OW-1:0]  pack_seg9  = pack_data_ext[((OW*9) + OW - 1):OW*9];
wire [OW-1:0]  pack_seg10 = pack_data_ext[((OW*10) + OW - 1):OW*10];
wire [OW-1:0]  pack_seg11 = pack_data_ext[((OW*11) + OW - 1):OW*11];
wire [OW-1:0]  pack_seg12 = pack_data_ext[((OW*12) + OW - 1):OW*12];
wire [OW-1:0]  pack_seg13 = pack_data_ext[((OW*13) + OW - 1):OW*13];
wire [OW-1:0]  pack_seg14 = pack_data_ext[((OW*14) + OW - 1):OW*14];
wire [OW-1:0]  pack_seg15 = pack_data_ext[((OW*15) + OW - 1):OW*15];


generate
if(RATIO == 1) begin
always @( pack_seg0) begin
     mux_data = pack_seg0;
end
end

else if(RATIO == 2) begin
always @(
  pack_cnt
  or pack_seg0
  or pack_seg1
  ) begin
    case (pack_cnt)
     0: mux_data = pack_seg0;
     1: mux_data = pack_seg1;
    default : mux_data = {OW{1'b0}};
    endcase
end
end

else if(RATIO == 4) begin
always @(
  pack_cnt
  or pack_seg0
  or pack_seg1
  or pack_seg2
  or pack_seg3
  ) begin
    case (pack_cnt)
     0: mux_data = pack_seg0;
     1: mux_data = pack_seg1;
     2: mux_data = pack_seg2;
     3: mux_data = pack_seg3;
    default : mux_data = {OW{1'b0}};
    endcase
end
end

else if (RATIO == 8) begin
always @(
  pack_cnt
  or pack_seg0
  or pack_seg1
  or pack_seg2
  or pack_seg3
  or pack_seg4
  or pack_seg5
  or pack_seg6
  or pack_seg7
  ) begin
    case (pack_cnt)
     0: mux_data = pack_seg0;
     1: mux_data = pack_seg1;
     2: mux_data = pack_seg2;
     3: mux_data = pack_seg3;
     4: mux_data = pack_seg4;
     5: mux_data = pack_seg5;
     6: mux_data = pack_seg6;
     7: mux_data = pack_seg7;
    default : mux_data = {OW{1'b0}};
    endcase
end
end

else if (RATIO == 16) begin
always @(
  pack_cnt
  or pack_seg0
  or pack_seg1
  or pack_seg2
  or pack_seg3
  or pack_seg4
  or pack_seg5
  or pack_seg6
  or pack_seg7
  or pack_seg8
  or pack_seg9
  or pack_seg10
  or pack_seg11
  or pack_seg12
  or pack_seg13
  or pack_seg14
  or pack_seg15
  ) begin
    case (pack_cnt)
     0: mux_data = pack_seg0;
     1: mux_data = pack_seg1;
     2: mux_data = pack_seg2;
     3: mux_data = pack_seg3;
     4: mux_data = pack_seg4;
     5: mux_data = pack_seg5;
     6: mux_data = pack_seg6;
     7: mux_data = pack_seg7;
     8: mux_data = pack_seg8;
     9: mux_data = pack_seg9;
     10: mux_data = pack_seg10;
     11: mux_data = pack_seg11;
     12: mux_data = pack_seg12;
     13: mux_data = pack_seg13;
     14: mux_data = pack_seg14;
     15: mux_data = pack_seg15;
    default : mux_data = {OW{1'b0}};
    endcase
end
end
endgenerate



endmodule // NV_NVDLA_SDP_RDMA_pack


