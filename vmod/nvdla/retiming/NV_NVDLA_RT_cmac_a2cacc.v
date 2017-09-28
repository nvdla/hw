// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_cmac_a2cacc.v

module NV_NVDLA_RT_cmac_a2cacc (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mac2accu_src_pvld
  ,mac2accu_src_mask
  ,mac2accu_src_mode
  ,mac2accu_src_data0
  ,mac2accu_src_data1
  ,mac2accu_src_data2
  ,mac2accu_src_data3
  ,mac2accu_src_data4
  ,mac2accu_src_data5
  ,mac2accu_src_data6
  ,mac2accu_src_data7
  ,mac2accu_src_pd
  ,mac2accu_dst_pvld
  ,mac2accu_dst_mask
  ,mac2accu_dst_mode
  ,mac2accu_dst_data0
  ,mac2accu_dst_data1
  ,mac2accu_dst_data2
  ,mac2accu_dst_data3
  ,mac2accu_dst_data4
  ,mac2accu_dst_data5
  ,mac2accu_dst_data6
  ,mac2accu_dst_data7
  ,mac2accu_dst_pd
  );

//
// NV_NVDLA_RT_cmac2cacc_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         mac2accu_src_pvld;   /* data valid */
input   [7:0] mac2accu_src_mask;
input   [7:0] mac2accu_src_mode;
input [175:0] mac2accu_src_data0;
input [175:0] mac2accu_src_data1;
input [175:0] mac2accu_src_data2;
input [175:0] mac2accu_src_data3;
input [175:0] mac2accu_src_data4;
input [175:0] mac2accu_src_data5;
input [175:0] mac2accu_src_data6;
input [175:0] mac2accu_src_data7;
input   [8:0] mac2accu_src_pd;

output         mac2accu_dst_pvld;   /* data valid */
output   [7:0] mac2accu_dst_mask;
output   [7:0] mac2accu_dst_mode;
output [175:0] mac2accu_dst_data0;
output [175:0] mac2accu_dst_data1;
output [175:0] mac2accu_dst_data2;
output [175:0] mac2accu_dst_data3;
output [175:0] mac2accu_dst_data4;
output [175:0] mac2accu_dst_data5;
output [175:0] mac2accu_dst_data6;
output [175:0] mac2accu_dst_data7;
output   [8:0] mac2accu_dst_pd;

wire [175:0] mac2accu_data0_d0;
wire [175:0] mac2accu_data1_d0;
wire [175:0] mac2accu_data2_d0;
wire [175:0] mac2accu_data3_d0;
wire [175:0] mac2accu_data4_d0;
wire [175:0] mac2accu_data5_d0;
wire [175:0] mac2accu_data6_d0;
wire [175:0] mac2accu_data7_d0;
wire   [7:0] mac2accu_mask_d0;
wire   [7:0] mac2accu_mode_d0;
wire   [8:0] mac2accu_pd_d0;
wire         mac2accu_pvld_d0;
reg  [175:0] mac2accu_data0_d1;
reg  [175:0] mac2accu_data0_d2;
reg  [175:0] mac2accu_data1_d1;
reg  [175:0] mac2accu_data1_d2;
reg  [175:0] mac2accu_data2_d1;
reg  [175:0] mac2accu_data2_d2;
reg  [175:0] mac2accu_data3_d1;
reg  [175:0] mac2accu_data3_d2;
reg  [175:0] mac2accu_data4_d1;
reg  [175:0] mac2accu_data4_d2;
reg  [175:0] mac2accu_data5_d1;
reg  [175:0] mac2accu_data5_d2;
reg  [175:0] mac2accu_data6_d1;
reg  [175:0] mac2accu_data6_d2;
reg  [175:0] mac2accu_data7_d1;
reg  [175:0] mac2accu_data7_d2;
reg    [7:0] mac2accu_mask_d1;
reg    [7:0] mac2accu_mask_d2;
reg    [7:0] mac2accu_mode_d1;
reg    [7:0] mac2accu_mode_d2;
reg    [8:0] mac2accu_pd_d1;
reg    [8:0] mac2accu_pd_d2;
reg          mac2accu_pvld_d1;
reg          mac2accu_pvld_d2;


assign mac2accu_pvld_d0 = mac2accu_src_pvld;
assign mac2accu_pd_d0 = mac2accu_src_pd;
assign mac2accu_mask_d0 = mac2accu_src_mask;
assign mac2accu_mode_d0 = mac2accu_src_mode;
assign mac2accu_data0_d0 = mac2accu_src_data0;
assign mac2accu_data1_d0 = mac2accu_src_data1;
assign mac2accu_data2_d0 = mac2accu_src_data2;
assign mac2accu_data3_d0 = mac2accu_src_data3;
assign mac2accu_data4_d0 = mac2accu_src_data4;
assign mac2accu_data5_d0 = mac2accu_src_data5;
assign mac2accu_data6_d0 = mac2accu_src_data6;
assign mac2accu_data7_d0 = mac2accu_src_data7;




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac2accu_pvld_d1 <= 1'b0;
  end else begin
  mac2accu_pvld_d1 <= mac2accu_pvld_d0;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_pvld_d0) == 1'b1) begin
    mac2accu_pd_d1 <= mac2accu_pd_d0;
  // VCS coverage off
  end else if ((mac2accu_pvld_d0) == 1'b0) begin
  end else begin
    mac2accu_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_pvld_d0) == 1'b1) begin
    mac2accu_mode_d1 <= mac2accu_mode_d0;
  // VCS coverage off
  end else if ((mac2accu_pvld_d0) == 1'b0) begin
  end else begin
    mac2accu_mode_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac2accu_mask_d1 <= {8{1'b0}};
  end else begin
  mac2accu_mask_d1 <= mac2accu_mask_d0;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[0]) == 1'b1) begin
    mac2accu_data0_d1[43:0] <= mac2accu_data0_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[0]) == 1'b0) begin
  end else begin
    mac2accu_data0_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[0] & mac2accu_mode_d0[0]) == 1'b1) begin
    mac2accu_data0_d1[175:44] <= mac2accu_data0_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[0] & mac2accu_mode_d0[0]) == 1'b0) begin
  end else begin
    mac2accu_data0_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[1]) == 1'b1) begin
    mac2accu_data1_d1[43:0] <= mac2accu_data1_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[1]) == 1'b0) begin
  end else begin
    mac2accu_data1_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[1] & mac2accu_mode_d0[1]) == 1'b1) begin
    mac2accu_data1_d1[175:44] <= mac2accu_data1_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[1] & mac2accu_mode_d0[1]) == 1'b0) begin
  end else begin
    mac2accu_data1_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[2]) == 1'b1) begin
    mac2accu_data2_d1[43:0] <= mac2accu_data2_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[2]) == 1'b0) begin
  end else begin
    mac2accu_data2_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[2] & mac2accu_mode_d0[2]) == 1'b1) begin
    mac2accu_data2_d1[175:44] <= mac2accu_data2_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[2] & mac2accu_mode_d0[2]) == 1'b0) begin
  end else begin
    mac2accu_data2_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[3]) == 1'b1) begin
    mac2accu_data3_d1[43:0] <= mac2accu_data3_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[3]) == 1'b0) begin
  end else begin
    mac2accu_data3_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[3] & mac2accu_mode_d0[3]) == 1'b1) begin
    mac2accu_data3_d1[175:44] <= mac2accu_data3_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[3] & mac2accu_mode_d0[3]) == 1'b0) begin
  end else begin
    mac2accu_data3_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[4]) == 1'b1) begin
    mac2accu_data4_d1[43:0] <= mac2accu_data4_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[4]) == 1'b0) begin
  end else begin
    mac2accu_data4_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[4] & mac2accu_mode_d0[4]) == 1'b1) begin
    mac2accu_data4_d1[175:44] <= mac2accu_data4_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[4] & mac2accu_mode_d0[4]) == 1'b0) begin
  end else begin
    mac2accu_data4_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[5]) == 1'b1) begin
    mac2accu_data5_d1[43:0] <= mac2accu_data5_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[5]) == 1'b0) begin
  end else begin
    mac2accu_data5_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[5] & mac2accu_mode_d0[5]) == 1'b1) begin
    mac2accu_data5_d1[175:44] <= mac2accu_data5_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[5] & mac2accu_mode_d0[5]) == 1'b0) begin
  end else begin
    mac2accu_data5_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[6]) == 1'b1) begin
    mac2accu_data6_d1[43:0] <= mac2accu_data6_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[6]) == 1'b0) begin
  end else begin
    mac2accu_data6_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[6] & mac2accu_mode_d0[6]) == 1'b1) begin
    mac2accu_data6_d1[175:44] <= mac2accu_data6_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[6] & mac2accu_mode_d0[6]) == 1'b0) begin
  end else begin
    mac2accu_data6_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[7]) == 1'b1) begin
    mac2accu_data7_d1[43:0] <= mac2accu_data7_d0[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[7]) == 1'b0) begin
  end else begin
    mac2accu_data7_d1[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d0[7] & mac2accu_mode_d0[7]) == 1'b1) begin
    mac2accu_data7_d1[175:44] <= mac2accu_data7_d0[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d0[7] & mac2accu_mode_d0[7]) == 1'b0) begin
  end else begin
    mac2accu_data7_d1[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac2accu_pvld_d2 <= 1'b0;
  end else begin
  mac2accu_pvld_d2 <= mac2accu_pvld_d1;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_pvld_d1) == 1'b1) begin
    mac2accu_pd_d2 <= mac2accu_pd_d1;
  // VCS coverage off
  end else if ((mac2accu_pvld_d1) == 1'b0) begin
  end else begin
    mac2accu_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_pvld_d1) == 1'b1) begin
    mac2accu_mode_d2 <= mac2accu_mode_d1;
  // VCS coverage off
  end else if ((mac2accu_pvld_d1) == 1'b0) begin
  end else begin
    mac2accu_mode_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mac2accu_mask_d2 <= {8{1'b0}};
  end else begin
  mac2accu_mask_d2 <= mac2accu_mask_d1;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[0]) == 1'b1) begin
    mac2accu_data0_d2[43:0] <= mac2accu_data0_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[0]) == 1'b0) begin
  end else begin
    mac2accu_data0_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[0] & mac2accu_mode_d1[0]) == 1'b1) begin
    mac2accu_data0_d2[175:44] <= mac2accu_data0_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[0] & mac2accu_mode_d1[0]) == 1'b0) begin
  end else begin
    mac2accu_data0_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[1]) == 1'b1) begin
    mac2accu_data1_d2[43:0] <= mac2accu_data1_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[1]) == 1'b0) begin
  end else begin
    mac2accu_data1_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[1] & mac2accu_mode_d1[1]) == 1'b1) begin
    mac2accu_data1_d2[175:44] <= mac2accu_data1_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[1] & mac2accu_mode_d1[1]) == 1'b0) begin
  end else begin
    mac2accu_data1_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[2]) == 1'b1) begin
    mac2accu_data2_d2[43:0] <= mac2accu_data2_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[2]) == 1'b0) begin
  end else begin
    mac2accu_data2_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[2] & mac2accu_mode_d1[2]) == 1'b1) begin
    mac2accu_data2_d2[175:44] <= mac2accu_data2_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[2] & mac2accu_mode_d1[2]) == 1'b0) begin
  end else begin
    mac2accu_data2_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[3]) == 1'b1) begin
    mac2accu_data3_d2[43:0] <= mac2accu_data3_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[3]) == 1'b0) begin
  end else begin
    mac2accu_data3_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[3] & mac2accu_mode_d1[3]) == 1'b1) begin
    mac2accu_data3_d2[175:44] <= mac2accu_data3_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[3] & mac2accu_mode_d1[3]) == 1'b0) begin
  end else begin
    mac2accu_data3_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[4]) == 1'b1) begin
    mac2accu_data4_d2[43:0] <= mac2accu_data4_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[4]) == 1'b0) begin
  end else begin
    mac2accu_data4_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[4] & mac2accu_mode_d1[4]) == 1'b1) begin
    mac2accu_data4_d2[175:44] <= mac2accu_data4_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[4] & mac2accu_mode_d1[4]) == 1'b0) begin
  end else begin
    mac2accu_data4_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[5]) == 1'b1) begin
    mac2accu_data5_d2[43:0] <= mac2accu_data5_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[5]) == 1'b0) begin
  end else begin
    mac2accu_data5_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[5] & mac2accu_mode_d1[5]) == 1'b1) begin
    mac2accu_data5_d2[175:44] <= mac2accu_data5_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[5] & mac2accu_mode_d1[5]) == 1'b0) begin
  end else begin
    mac2accu_data5_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[6]) == 1'b1) begin
    mac2accu_data6_d2[43:0] <= mac2accu_data6_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[6]) == 1'b0) begin
  end else begin
    mac2accu_data6_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[6] & mac2accu_mode_d1[6]) == 1'b1) begin
    mac2accu_data6_d2[175:44] <= mac2accu_data6_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[6] & mac2accu_mode_d1[6]) == 1'b0) begin
  end else begin
    mac2accu_data6_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[7]) == 1'b1) begin
    mac2accu_data7_d2[43:0] <= mac2accu_data7_d1[43:0];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[7]) == 1'b0) begin
  end else begin
    mac2accu_data7_d2[43:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((mac2accu_mask_d1[7] & mac2accu_mode_d1[7]) == 1'b1) begin
    mac2accu_data7_d2[175:44] <= mac2accu_data7_d1[175:44];
  // VCS coverage off
  end else if ((mac2accu_mask_d1[7] & mac2accu_mode_d1[7]) == 1'b0) begin
  end else begin
    mac2accu_data7_d2[175:44] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end






assign mac2accu_dst_pvld = mac2accu_pvld_d2;
assign mac2accu_dst_pd = mac2accu_pd_d2;
assign mac2accu_dst_mask = mac2accu_mask_d2;
assign mac2accu_dst_mode = mac2accu_mode_d2;
assign mac2accu_dst_data0 = mac2accu_data0_d2;
assign mac2accu_dst_data1 = mac2accu_data1_d2;
assign mac2accu_dst_data2 = mac2accu_data2_d2;
assign mac2accu_dst_data3 = mac2accu_data3_d2;
assign mac2accu_dst_data4 = mac2accu_data4_d2;
assign mac2accu_dst_data5 = mac2accu_data5_d2;
assign mac2accu_dst_data6 = mac2accu_data6_d2;
assign mac2accu_dst_data7 = mac2accu_data7_d2;





endmodule // NV_NVDLA_RT_cmac_a2cacc

