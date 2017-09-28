// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_READ_IG_arb.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_READ_IG_arb (
   arb2spt_req_ready         //|< i
  ,bpt2arb_req0_pd           //|< i
  ,bpt2arb_req0_valid        //|< i
  ,bpt2arb_req1_pd           //|< i
  ,bpt2arb_req1_valid        //|< i
  ,bpt2arb_req2_pd           //|< i
  ,bpt2arb_req2_valid        //|< i
  ,bpt2arb_req3_pd           //|< i
  ,bpt2arb_req3_valid        //|< i
  ,bpt2arb_req4_pd           //|< i
  ,bpt2arb_req4_valid        //|< i
  ,bpt2arb_req5_pd           //|< i
  ,bpt2arb_req5_valid        //|< i
  ,bpt2arb_req6_pd           //|< i
  ,bpt2arb_req6_valid        //|< i
  ,bpt2arb_req7_pd           //|< i
  ,bpt2arb_req7_valid        //|< i
  ,bpt2arb_req8_pd           //|< i
  ,bpt2arb_req8_valid        //|< i
  ,bpt2arb_req9_pd           //|< i
  ,bpt2arb_req9_valid        //|< i
  ,nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,reg2dp_rd_weight_bdma     //|< i
  ,reg2dp_rd_weight_cdma_dat //|< i
  ,reg2dp_rd_weight_cdma_wt  //|< i
  ,reg2dp_rd_weight_cdp      //|< i
  ,reg2dp_rd_weight_pdp      //|< i
  ,reg2dp_rd_weight_rbk      //|< i
  ,reg2dp_rd_weight_sdp      //|< i
  ,reg2dp_rd_weight_sdp_b    //|< i
  ,reg2dp_rd_weight_sdp_e    //|< i
  ,reg2dp_rd_weight_sdp_n    //|< i
  ,arb2spt_req_pd            //|> o
  ,arb2spt_req_valid         //|> o
  ,bpt2arb_req0_ready        //|> o
  ,bpt2arb_req1_ready        //|> o
  ,bpt2arb_req2_ready        //|> o
  ,bpt2arb_req3_ready        //|> o
  ,bpt2arb_req4_ready        //|> o
  ,bpt2arb_req5_ready        //|> o
  ,bpt2arb_req6_ready        //|> o
  ,bpt2arb_req7_ready        //|> o
  ,bpt2arb_req8_ready        //|> o
  ,bpt2arb_req9_ready        //|> o
  );
//
// NV_NVDLA_CVIF_READ_IG_arb_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         bpt2arb_req0_valid;  /* data valid */
output        bpt2arb_req0_ready;  /* data return handshake */
input  [74:0] bpt2arb_req0_pd;

input         bpt2arb_req1_valid;  /* data valid */
output        bpt2arb_req1_ready;  /* data return handshake */
input  [74:0] bpt2arb_req1_pd;

input         bpt2arb_req2_valid;  /* data valid */
output        bpt2arb_req2_ready;  /* data return handshake */
input  [74:0] bpt2arb_req2_pd;

input         bpt2arb_req3_valid;  /* data valid */
output        bpt2arb_req3_ready;  /* data return handshake */
input  [74:0] bpt2arb_req3_pd;

input         bpt2arb_req4_valid;  /* data valid */
output        bpt2arb_req4_ready;  /* data return handshake */
input  [74:0] bpt2arb_req4_pd;

input         bpt2arb_req5_valid;  /* data valid */
output        bpt2arb_req5_ready;  /* data return handshake */
input  [74:0] bpt2arb_req5_pd;

input         bpt2arb_req6_valid;  /* data valid */
output        bpt2arb_req6_ready;  /* data return handshake */
input  [74:0] bpt2arb_req6_pd;

input         bpt2arb_req7_valid;  /* data valid */
output        bpt2arb_req7_ready;  /* data return handshake */
input  [74:0] bpt2arb_req7_pd;

input         bpt2arb_req8_valid;  /* data valid */
output        bpt2arb_req8_ready;  /* data return handshake */
input  [74:0] bpt2arb_req8_pd;

input         bpt2arb_req9_valid;  /* data valid */
output        bpt2arb_req9_ready;  /* data return handshake */
input  [74:0] bpt2arb_req9_pd;

output        arb2spt_req_valid;  /* data valid */
input         arb2spt_req_ready;  /* data return handshake */
output [74:0] arb2spt_req_pd;

input  [7:0] reg2dp_rd_weight_bdma;
input  [7:0] reg2dp_rd_weight_cdma_dat;
input  [7:0] reg2dp_rd_weight_cdma_wt;
input  [7:0] reg2dp_rd_weight_cdp;
input  [7:0] reg2dp_rd_weight_pdp;
input  [7:0] reg2dp_rd_weight_rbk;
input  [7:0] reg2dp_rd_weight_sdp;
input  [7:0] reg2dp_rd_weight_sdp_b;
input  [7:0] reg2dp_rd_weight_sdp_e;
input  [7:0] reg2dp_rd_weight_sdp_n;
reg   [74:0] arb_pd;
wire   [9:0] arb_gnt;
wire  [74:0] arb_src0_pd;
wire         arb_src0_rdy;
wire         arb_src0_vld;
wire  [74:0] arb_src1_pd;
wire         arb_src1_rdy;
wire         arb_src1_vld;
wire  [74:0] arb_src2_pd;
wire         arb_src2_rdy;
wire         arb_src2_vld;
wire  [74:0] arb_src3_pd;
wire         arb_src3_rdy;
wire         arb_src3_vld;
wire  [74:0] arb_src4_pd;
wire         arb_src4_rdy;
wire         arb_src4_vld;
wire  [74:0] arb_src5_pd;
wire         arb_src5_rdy;
wire         arb_src5_vld;
wire  [74:0] arb_src6_pd;
wire         arb_src6_rdy;
wire         arb_src6_vld;
wire  [74:0] arb_src7_pd;
wire         arb_src7_rdy;
wire         arb_src7_vld;
wire  [74:0] arb_src8_pd;
wire         arb_src8_rdy;
wire         arb_src8_vld;
wire  [74:0] arb_src9_pd;
wire         arb_src9_rdy;
wire         arb_src9_vld;
wire         gnt_busy;
wire         src0_gnt;
wire         src0_req;
wire         src1_gnt;
wire         src1_req;
wire         src2_gnt;
wire         src2_req;
wire         src3_gnt;
wire         src3_req;
wire         src4_gnt;
wire         src4_req;
wire         src5_gnt;
wire         src5_req;
wire         src6_gnt;
wire         src6_req;
wire         src7_gnt;
wire         src7_req;
wire         src8_gnt;
wire         src8_req;
wire         src9_gnt;
wire         src9_req;
wire   [7:0] wt0;
wire   [7:0] wt1;
wire   [7:0] wt2;
wire   [7:0] wt3;
wire   [7:0] wt4;
wire   [7:0] wt5;
wire   [7:0] wt6;
wire   [7:0] wt7;
wire   [7:0] wt8;
wire   [7:0] wt9;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

NV_NVDLA_CVIF_READ_IG_ARB_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src0_rdy       (arb_src0_rdy)          //|< w
  ,.bpt2arb_req0_pd    (bpt2arb_req0_pd[74:0]) //|< i
  ,.bpt2arb_req0_valid (bpt2arb_req0_valid)    //|< i
  ,.arb_src0_pd        (arb_src0_pd[74:0])     //|> w
  ,.arb_src0_vld       (arb_src0_vld)          //|> w
  ,.bpt2arb_req0_ready (bpt2arb_req0_ready)    //|> o
  );
assign src0_req   = arb_src0_vld;
assign arb_src0_rdy = src0_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p2 pipe_p2 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src1_rdy       (arb_src1_rdy)          //|< w
  ,.bpt2arb_req1_pd    (bpt2arb_req1_pd[74:0]) //|< i
  ,.bpt2arb_req1_valid (bpt2arb_req1_valid)    //|< i
  ,.arb_src1_pd        (arb_src1_pd[74:0])     //|> w
  ,.arb_src1_vld       (arb_src1_vld)          //|> w
  ,.bpt2arb_req1_ready (bpt2arb_req1_ready)    //|> o
  );
assign src1_req   = arb_src1_vld;
assign arb_src1_rdy = src1_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p3 pipe_p3 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src2_rdy       (arb_src2_rdy)          //|< w
  ,.bpt2arb_req2_pd    (bpt2arb_req2_pd[74:0]) //|< i
  ,.bpt2arb_req2_valid (bpt2arb_req2_valid)    //|< i
  ,.arb_src2_pd        (arb_src2_pd[74:0])     //|> w
  ,.arb_src2_vld       (arb_src2_vld)          //|> w
  ,.bpt2arb_req2_ready (bpt2arb_req2_ready)    //|> o
  );
assign src2_req   = arb_src2_vld;
assign arb_src2_rdy = src2_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p4 pipe_p4 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src3_rdy       (arb_src3_rdy)          //|< w
  ,.bpt2arb_req3_pd    (bpt2arb_req3_pd[74:0]) //|< i
  ,.bpt2arb_req3_valid (bpt2arb_req3_valid)    //|< i
  ,.arb_src3_pd        (arb_src3_pd[74:0])     //|> w
  ,.arb_src3_vld       (arb_src3_vld)          //|> w
  ,.bpt2arb_req3_ready (bpt2arb_req3_ready)    //|> o
  );
assign src3_req   = arb_src3_vld;
assign arb_src3_rdy = src3_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p5 pipe_p5 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src4_rdy       (arb_src4_rdy)          //|< w
  ,.bpt2arb_req4_pd    (bpt2arb_req4_pd[74:0]) //|< i
  ,.bpt2arb_req4_valid (bpt2arb_req4_valid)    //|< i
  ,.arb_src4_pd        (arb_src4_pd[74:0])     //|> w
  ,.arb_src4_vld       (arb_src4_vld)          //|> w
  ,.bpt2arb_req4_ready (bpt2arb_req4_ready)    //|> o
  );
assign src4_req   = arb_src4_vld;
assign arb_src4_rdy = src4_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p6 pipe_p6 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src5_rdy       (arb_src5_rdy)          //|< w
  ,.bpt2arb_req5_pd    (bpt2arb_req5_pd[74:0]) //|< i
  ,.bpt2arb_req5_valid (bpt2arb_req5_valid)    //|< i
  ,.arb_src5_pd        (arb_src5_pd[74:0])     //|> w
  ,.arb_src5_vld       (arb_src5_vld)          //|> w
  ,.bpt2arb_req5_ready (bpt2arb_req5_ready)    //|> o
  );
assign src5_req   = arb_src5_vld;
assign arb_src5_rdy = src5_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p7 pipe_p7 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src6_rdy       (arb_src6_rdy)          //|< w
  ,.bpt2arb_req6_pd    (bpt2arb_req6_pd[74:0]) //|< i
  ,.bpt2arb_req6_valid (bpt2arb_req6_valid)    //|< i
  ,.arb_src6_pd        (arb_src6_pd[74:0])     //|> w
  ,.arb_src6_vld       (arb_src6_vld)          //|> w
  ,.bpt2arb_req6_ready (bpt2arb_req6_ready)    //|> o
  );
assign src6_req   = arb_src6_vld;
assign arb_src6_rdy = src6_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p8 pipe_p8 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src7_rdy       (arb_src7_rdy)          //|< w
  ,.bpt2arb_req7_pd    (bpt2arb_req7_pd[74:0]) //|< i
  ,.bpt2arb_req7_valid (bpt2arb_req7_valid)    //|< i
  ,.arb_src7_pd        (arb_src7_pd[74:0])     //|> w
  ,.arb_src7_vld       (arb_src7_vld)          //|> w
  ,.bpt2arb_req7_ready (bpt2arb_req7_ready)    //|> o
  );
assign src7_req   = arb_src7_vld;
assign arb_src7_rdy = src7_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p9 pipe_p9 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src8_rdy       (arb_src8_rdy)          //|< w
  ,.bpt2arb_req8_pd    (bpt2arb_req8_pd[74:0]) //|< i
  ,.bpt2arb_req8_valid (bpt2arb_req8_valid)    //|< i
  ,.arb_src8_pd        (arb_src8_pd[74:0])     //|> w
  ,.arb_src8_vld       (arb_src8_vld)          //|> w
  ,.bpt2arb_req8_ready (bpt2arb_req8_ready)    //|> o
  );
assign src8_req   = arb_src8_vld;
assign arb_src8_rdy = src8_gnt;
NV_NVDLA_CVIF_READ_IG_ARB_pipe_p10 pipe_p10 (
   .nvdla_core_clk     (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)       //|< i
  ,.arb_src9_rdy       (arb_src9_rdy)          //|< w
  ,.bpt2arb_req9_pd    (bpt2arb_req9_pd[74:0]) //|< i
  ,.bpt2arb_req9_valid (bpt2arb_req9_valid)    //|< i
  ,.arb_src9_pd        (arb_src9_pd[74:0])     //|> w
  ,.arb_src9_vld       (arb_src9_vld)          //|> w
  ,.bpt2arb_req9_ready (bpt2arb_req9_ready)    //|> o
  );
assign src9_req   = arb_src9_vld;
assign arb_src9_rdy = src9_gnt;

assign wt0 = reg2dp_rd_weight_bdma;
assign wt1 = reg2dp_rd_weight_sdp;
assign wt2 = reg2dp_rd_weight_pdp;
assign wt3 = reg2dp_rd_weight_cdp;
assign wt4 = reg2dp_rd_weight_rbk;
assign wt5 = reg2dp_rd_weight_sdp_b;
assign wt6 = reg2dp_rd_weight_sdp_n;
assign wt7 = reg2dp_rd_weight_sdp_e;
assign wt8 = reg2dp_rd_weight_cdma_dat;
assign wt9 = reg2dp_rd_weight_cdma_wt;

read_ig_arb u_read_ig_arb (
   .req0               (src0_req)              //|< w
  ,.req1               (src1_req)              //|< w
  ,.req2               (src2_req)              //|< w
  ,.req3               (src3_req)              //|< w
  ,.req4               (src4_req)              //|< w
  ,.req5               (src5_req)              //|< w
  ,.req6               (src6_req)              //|< w
  ,.req7               (src7_req)              //|< w
  ,.req8               (src8_req)              //|< w
  ,.req9               (src9_req)              //|< w
  ,.wt0                (wt0[7:0])              //|< w
  ,.wt1                (wt1[7:0])              //|< w
  ,.wt2                (wt2[7:0])              //|< w
  ,.wt3                (wt3[7:0])              //|< w
  ,.wt4                (wt4[7:0])              //|< w
  ,.wt5                (wt5[7:0])              //|< w
  ,.wt6                (wt6[7:0])              //|< w
  ,.wt7                (wt7[7:0])              //|< w
  ,.wt8                (wt8[7:0])              //|< w
  ,.wt9                (wt9[7:0])              //|< w
  ,.gnt_busy           (gnt_busy)              //|< w
  ,.clk                (nvdla_core_clk)        //|< i
  ,.reset_             (nvdla_core_rstn)       //|< i
  ,.gnt0               (src0_gnt)              //|> w
  ,.gnt1               (src1_gnt)              //|> w
  ,.gnt2               (src2_gnt)              //|> w
  ,.gnt3               (src3_gnt)              //|> w
  ,.gnt4               (src4_gnt)              //|> w
  ,.gnt5               (src5_gnt)              //|> w
  ,.gnt6               (src6_gnt)              //|> w
  ,.gnt7               (src7_gnt)              //|> w
  ,.gnt8               (src8_gnt)              //|> w
  ,.gnt9               (src9_gnt)              //|> w
  );

// MUX OUT
always @(
  src0_gnt
  or arb_src0_pd
  or src1_gnt
  or arb_src1_pd
  or src2_gnt
  or arb_src2_pd
  or src3_gnt
  or arb_src3_pd
  or src4_gnt
  or arb_src4_pd
  or src5_gnt
  or arb_src5_pd
  or src6_gnt
  or arb_src6_pd
  or src7_gnt
  or arb_src7_pd
  or src8_gnt
  or arb_src8_pd
  or src9_gnt
  or arb_src9_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
       src0_gnt: arb_pd = arb_src0_pd;
       src1_gnt: arb_pd = arb_src1_pd;
       src2_gnt: arb_pd = arb_src2_pd;
       src3_gnt: arb_pd = arb_src3_pd;
       src4_gnt: arb_pd = arb_src4_pd;
       src5_gnt: arb_pd = arb_src5_pd;
       src6_gnt: arb_pd = arb_src6_pd;
       src7_gnt: arb_pd = arb_src7_pd;
       src8_gnt: arb_pd = arb_src8_pd;
       src9_gnt: arb_pd = arb_src9_pd;
    //VCS coverage off
    default : begin 
                arb_pd[74:0] = {75{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

assign arb_gnt = {src9_gnt, src8_gnt, src7_gnt, src6_gnt, src5_gnt, src4_gnt, src3_gnt, src2_gnt, src1_gnt, src0_gnt};
assign arb2spt_req_valid = |arb_gnt;
assign gnt_busy = !arb2spt_req_ready;

assign arb2spt_req_pd = arb_pd;

//==========================================
// OBS
//assign obs_bus_cvif_read_ig_arb_gnt_busy = gnt_busy;

endmodule // NV_NVDLA_CVIF_READ_IG_arb



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src0_pd (arb_src0_vld,arb_src0_rdy) <= bpt2arb_req0_pd[74:0] (bpt2arb_req0_valid,bpt2arb_req0_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src0_rdy
  ,bpt2arb_req0_pd
  ,bpt2arb_req0_valid
  ,arb_src0_pd
  ,arb_src0_vld
  ,bpt2arb_req0_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src0_rdy;
input  [74:0] bpt2arb_req0_pd;
input         bpt2arb_req0_valid;
output [74:0] arb_src0_pd;
output        arb_src0_vld;
output        bpt2arb_req0_ready;
reg    [74:0] arb_src0_pd;
reg           arb_src0_vld;
reg           bpt2arb_req0_ready;
reg    [74:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg    [74:0] p1_pipe_skid_data;
reg           p1_pipe_skid_ready;
reg           p1_pipe_skid_valid;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [74:0] p1_skid_data;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? bpt2arb_req0_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && bpt2arb_req0_valid)? bpt2arb_req0_pd[74:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  bpt2arb_req0_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or arb_src0_rdy
  or p1_pipe_skid_data
  ) begin
  arb_src0_vld = p1_pipe_skid_valid;
  p1_pipe_skid_ready = arb_src0_rdy;
  arb_src0_pd = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src0_vld^arb_src0_rdy^bpt2arb_req0_valid^bpt2arb_req0_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req0_valid && !bpt2arb_req0_ready), (bpt2arb_req0_valid), (bpt2arb_req0_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src1_pd (arb_src1_vld,arb_src1_rdy) <= bpt2arb_req1_pd[74:0] (bpt2arb_req1_valid,bpt2arb_req1_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src1_rdy
  ,bpt2arb_req1_pd
  ,bpt2arb_req1_valid
  ,arb_src1_pd
  ,arb_src1_vld
  ,bpt2arb_req1_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src1_rdy;
input  [74:0] bpt2arb_req1_pd;
input         bpt2arb_req1_valid;
output [74:0] arb_src1_pd;
output        arb_src1_vld;
output        bpt2arb_req1_ready;
reg    [74:0] arb_src1_pd;
reg           arb_src1_vld;
reg           bpt2arb_req1_ready;
reg    [74:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg    [74:0] p2_pipe_skid_data;
reg           p2_pipe_skid_ready;
reg           p2_pipe_skid_valid;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [74:0] p2_skid_data;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? bpt2arb_req1_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && bpt2arb_req1_valid)? bpt2arb_req1_pd[74:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  bpt2arb_req1_ready = p2_pipe_ready_bc;
end
//## pipe (2) skid buffer
always @(
  p2_pipe_valid
  or p2_skid_ready_flop
  or p2_pipe_skid_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_valid && p2_skid_ready_flop && !p2_pipe_skid_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_pipe_skid_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_pipe_skid_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_valid
  or p2_skid_valid
  or p2_pipe_data
  or p2_skid_data
  ) begin
  p2_pipe_skid_valid = (p2_skid_ready_flop)? p2_pipe_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_pipe_skid_data = (p2_skid_ready_flop)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) output
always @(
  p2_pipe_skid_valid
  or arb_src1_rdy
  or p2_pipe_skid_data
  ) begin
  arb_src1_vld = p2_pipe_skid_valid;
  p2_pipe_skid_ready = arb_src1_rdy;
  arb_src1_pd = p2_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src1_vld^arb_src1_rdy^bpt2arb_req1_valid^bpt2arb_req1_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req1_valid && !bpt2arb_req1_ready), (bpt2arb_req1_valid), (bpt2arb_req1_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src2_pd (arb_src2_vld,arb_src2_rdy) <= bpt2arb_req2_pd[74:0] (bpt2arb_req2_valid,bpt2arb_req2_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src2_rdy
  ,bpt2arb_req2_pd
  ,bpt2arb_req2_valid
  ,arb_src2_pd
  ,arb_src2_vld
  ,bpt2arb_req2_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src2_rdy;
input  [74:0] bpt2arb_req2_pd;
input         bpt2arb_req2_valid;
output [74:0] arb_src2_pd;
output        arb_src2_vld;
output        bpt2arb_req2_ready;
reg    [74:0] arb_src2_pd;
reg           arb_src2_vld;
reg           bpt2arb_req2_ready;
reg    [74:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg    [74:0] p3_pipe_skid_data;
reg           p3_pipe_skid_ready;
reg           p3_pipe_skid_valid;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [74:0] p3_skid_data;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? bpt2arb_req2_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && bpt2arb_req2_valid)? bpt2arb_req2_pd[74:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  bpt2arb_req2_ready = p3_pipe_ready_bc;
end
//## pipe (3) skid buffer
always @(
  p3_pipe_valid
  or p3_skid_ready_flop
  or p3_pipe_skid_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = p3_pipe_valid && p3_skid_ready_flop && !p3_pipe_skid_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_pipe_skid_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    p3_pipe_ready <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_pipe_skid_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  p3_pipe_ready <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or p3_pipe_valid
  or p3_skid_valid
  or p3_pipe_data
  or p3_skid_data
  ) begin
  p3_pipe_skid_valid = (p3_skid_ready_flop)? p3_pipe_valid : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_pipe_skid_data = (p3_skid_ready_flop)? p3_pipe_data : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) output
always @(
  p3_pipe_skid_valid
  or arb_src2_rdy
  or p3_pipe_skid_data
  ) begin
  arb_src2_vld = p3_pipe_skid_valid;
  p3_pipe_skid_ready = arb_src2_rdy;
  arb_src2_pd = p3_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src2_vld^arb_src2_rdy^bpt2arb_req2_valid^bpt2arb_req2_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req2_valid && !bpt2arb_req2_ready), (bpt2arb_req2_valid), (bpt2arb_req2_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src3_pd (arb_src3_vld,arb_src3_rdy) <= bpt2arb_req3_pd[74:0] (bpt2arb_req3_valid,bpt2arb_req3_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src3_rdy
  ,bpt2arb_req3_pd
  ,bpt2arb_req3_valid
  ,arb_src3_pd
  ,arb_src3_vld
  ,bpt2arb_req3_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src3_rdy;
input  [74:0] bpt2arb_req3_pd;
input         bpt2arb_req3_valid;
output [74:0] arb_src3_pd;
output        arb_src3_vld;
output        bpt2arb_req3_ready;
reg    [74:0] arb_src3_pd;
reg           arb_src3_vld;
reg           bpt2arb_req3_ready;
reg    [74:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg    [74:0] p4_pipe_skid_data;
reg           p4_pipe_skid_ready;
reg           p4_pipe_skid_valid;
reg           p4_pipe_valid;
reg           p4_skid_catch;
reg    [74:0] p4_skid_data;
reg           p4_skid_ready;
reg           p4_skid_ready_flop;
reg           p4_skid_valid;
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? bpt2arb_req3_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && bpt2arb_req3_valid)? bpt2arb_req3_pd[74:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  bpt2arb_req3_ready = p4_pipe_ready_bc;
end
//## pipe (4) skid buffer
always @(
  p4_pipe_valid
  or p4_skid_ready_flop
  or p4_pipe_skid_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = p4_pipe_valid && p4_skid_ready_flop && !p4_pipe_skid_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_pipe_skid_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    p4_pipe_ready <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_pipe_skid_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  p4_pipe_ready <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or p4_pipe_valid
  or p4_skid_valid
  or p4_pipe_data
  or p4_skid_data
  ) begin
  p4_pipe_skid_valid = (p4_skid_ready_flop)? p4_pipe_valid : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_pipe_skid_data = (p4_skid_ready_flop)? p4_pipe_data : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) output
always @(
  p4_pipe_skid_valid
  or arb_src3_rdy
  or p4_pipe_skid_data
  ) begin
  arb_src3_vld = p4_pipe_skid_valid;
  p4_pipe_skid_ready = arb_src3_rdy;
  arb_src3_pd = p4_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src3_vld^arb_src3_rdy^bpt2arb_req3_valid^bpt2arb_req3_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req3_valid && !bpt2arb_req3_ready), (bpt2arb_req3_valid), (bpt2arb_req3_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src4_pd (arb_src4_vld,arb_src4_rdy) <= bpt2arb_req4_pd[74:0] (bpt2arb_req4_valid,bpt2arb_req4_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src4_rdy
  ,bpt2arb_req4_pd
  ,bpt2arb_req4_valid
  ,arb_src4_pd
  ,arb_src4_vld
  ,bpt2arb_req4_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src4_rdy;
input  [74:0] bpt2arb_req4_pd;
input         bpt2arb_req4_valid;
output [74:0] arb_src4_pd;
output        arb_src4_vld;
output        bpt2arb_req4_ready;
reg    [74:0] arb_src4_pd;
reg           arb_src4_vld;
reg           bpt2arb_req4_ready;
reg    [74:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg    [74:0] p5_pipe_skid_data;
reg           p5_pipe_skid_ready;
reg           p5_pipe_skid_valid;
reg           p5_pipe_valid;
reg           p5_skid_catch;
reg    [74:0] p5_skid_data;
reg           p5_skid_ready;
reg           p5_skid_ready_flop;
reg           p5_skid_valid;
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
  p5_pipe_valid <= (p5_pipe_ready_bc)? bpt2arb_req4_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && bpt2arb_req4_valid)? bpt2arb_req4_pd[74:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  bpt2arb_req4_ready = p5_pipe_ready_bc;
end
//## pipe (5) skid buffer
always @(
  p5_pipe_valid
  or p5_skid_ready_flop
  or p5_pipe_skid_ready
  or p5_skid_valid
  ) begin
  p5_skid_catch = p5_pipe_valid && p5_skid_ready_flop && !p5_pipe_skid_ready;  
  p5_skid_ready = (p5_skid_valid)? p5_pipe_skid_ready : !p5_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_skid_valid <= 1'b0;
    p5_skid_ready_flop <= 1'b1;
    p5_pipe_ready <= 1'b1;
  end else begin
  p5_skid_valid <= (p5_skid_valid)? !p5_pipe_skid_ready : p5_skid_catch;
  p5_skid_ready_flop <= p5_skid_ready;
  p5_pipe_ready <= p5_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_skid_data <= (p5_skid_catch)? p5_pipe_data : p5_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p5_skid_ready_flop
  or p5_pipe_valid
  or p5_skid_valid
  or p5_pipe_data
  or p5_skid_data
  ) begin
  p5_pipe_skid_valid = (p5_skid_ready_flop)? p5_pipe_valid : p5_skid_valid; 
  // VCS sop_coverage_off start
  p5_pipe_skid_data = (p5_skid_ready_flop)? p5_pipe_data : p5_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (5) output
always @(
  p5_pipe_skid_valid
  or arb_src4_rdy
  or p5_pipe_skid_data
  ) begin
  arb_src4_vld = p5_pipe_skid_valid;
  p5_pipe_skid_ready = arb_src4_rdy;
  arb_src4_pd = p5_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src4_vld^arb_src4_rdy^bpt2arb_req4_valid^bpt2arb_req4_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req4_valid && !bpt2arb_req4_ready), (bpt2arb_req4_valid), (bpt2arb_req4_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p5




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src5_pd (arb_src5_vld,arb_src5_rdy) <= bpt2arb_req5_pd[74:0] (bpt2arb_req5_valid,bpt2arb_req5_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p6 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src5_rdy
  ,bpt2arb_req5_pd
  ,bpt2arb_req5_valid
  ,arb_src5_pd
  ,arb_src5_vld
  ,bpt2arb_req5_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src5_rdy;
input  [74:0] bpt2arb_req5_pd;
input         bpt2arb_req5_valid;
output [74:0] arb_src5_pd;
output        arb_src5_vld;
output        bpt2arb_req5_ready;
reg    [74:0] arb_src5_pd;
reg           arb_src5_vld;
reg           bpt2arb_req5_ready;
reg    [74:0] p6_pipe_data;
reg           p6_pipe_ready;
reg           p6_pipe_ready_bc;
reg    [74:0] p6_pipe_skid_data;
reg           p6_pipe_skid_ready;
reg           p6_pipe_skid_valid;
reg           p6_pipe_valid;
reg           p6_skid_catch;
reg    [74:0] p6_skid_data;
reg           p6_skid_ready;
reg           p6_skid_ready_flop;
reg           p6_skid_valid;
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
  p6_pipe_valid <= (p6_pipe_ready_bc)? bpt2arb_req5_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_pipe_data <= (p6_pipe_ready_bc && bpt2arb_req5_valid)? bpt2arb_req5_pd[74:0] : p6_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p6_pipe_ready_bc
  ) begin
  bpt2arb_req5_ready = p6_pipe_ready_bc;
end
//## pipe (6) skid buffer
always @(
  p6_pipe_valid
  or p6_skid_ready_flop
  or p6_pipe_skid_ready
  or p6_skid_valid
  ) begin
  p6_skid_catch = p6_pipe_valid && p6_skid_ready_flop && !p6_pipe_skid_ready;  
  p6_skid_ready = (p6_skid_valid)? p6_pipe_skid_ready : !p6_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p6_skid_valid <= 1'b0;
    p6_skid_ready_flop <= 1'b1;
    p6_pipe_ready <= 1'b1;
  end else begin
  p6_skid_valid <= (p6_skid_valid)? !p6_pipe_skid_ready : p6_skid_catch;
  p6_skid_ready_flop <= p6_skid_ready;
  p6_pipe_ready <= p6_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p6_skid_data <= (p6_skid_catch)? p6_pipe_data : p6_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p6_skid_ready_flop
  or p6_pipe_valid
  or p6_skid_valid
  or p6_pipe_data
  or p6_skid_data
  ) begin
  p6_pipe_skid_valid = (p6_skid_ready_flop)? p6_pipe_valid : p6_skid_valid; 
  // VCS sop_coverage_off start
  p6_pipe_skid_data = (p6_skid_ready_flop)? p6_pipe_data : p6_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (6) output
always @(
  p6_pipe_skid_valid
  or arb_src5_rdy
  or p6_pipe_skid_data
  ) begin
  arb_src5_vld = p6_pipe_skid_valid;
  p6_pipe_skid_ready = arb_src5_rdy;
  arb_src5_pd = p6_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src5_vld^arb_src5_rdy^bpt2arb_req5_valid^bpt2arb_req5_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req5_valid && !bpt2arb_req5_ready), (bpt2arb_req5_valid), (bpt2arb_req5_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p6




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src6_pd (arb_src6_vld,arb_src6_rdy) <= bpt2arb_req6_pd[74:0] (bpt2arb_req6_valid,bpt2arb_req6_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p7 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src6_rdy
  ,bpt2arb_req6_pd
  ,bpt2arb_req6_valid
  ,arb_src6_pd
  ,arb_src6_vld
  ,bpt2arb_req6_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src6_rdy;
input  [74:0] bpt2arb_req6_pd;
input         bpt2arb_req6_valid;
output [74:0] arb_src6_pd;
output        arb_src6_vld;
output        bpt2arb_req6_ready;
reg    [74:0] arb_src6_pd;
reg           arb_src6_vld;
reg           bpt2arb_req6_ready;
reg    [74:0] p7_pipe_data;
reg           p7_pipe_ready;
reg           p7_pipe_ready_bc;
reg    [74:0] p7_pipe_skid_data;
reg           p7_pipe_skid_ready;
reg           p7_pipe_skid_valid;
reg           p7_pipe_valid;
reg           p7_skid_catch;
reg    [74:0] p7_skid_data;
reg           p7_skid_ready;
reg           p7_skid_ready_flop;
reg           p7_skid_valid;
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
  p7_pipe_valid <= (p7_pipe_ready_bc)? bpt2arb_req6_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_pipe_data <= (p7_pipe_ready_bc && bpt2arb_req6_valid)? bpt2arb_req6_pd[74:0] : p7_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p7_pipe_ready_bc
  ) begin
  bpt2arb_req6_ready = p7_pipe_ready_bc;
end
//## pipe (7) skid buffer
always @(
  p7_pipe_valid
  or p7_skid_ready_flop
  or p7_pipe_skid_ready
  or p7_skid_valid
  ) begin
  p7_skid_catch = p7_pipe_valid && p7_skid_ready_flop && !p7_pipe_skid_ready;  
  p7_skid_ready = (p7_skid_valid)? p7_pipe_skid_ready : !p7_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p7_skid_valid <= 1'b0;
    p7_skid_ready_flop <= 1'b1;
    p7_pipe_ready <= 1'b1;
  end else begin
  p7_skid_valid <= (p7_skid_valid)? !p7_pipe_skid_ready : p7_skid_catch;
  p7_skid_ready_flop <= p7_skid_ready;
  p7_pipe_ready <= p7_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p7_skid_data <= (p7_skid_catch)? p7_pipe_data : p7_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p7_skid_ready_flop
  or p7_pipe_valid
  or p7_skid_valid
  or p7_pipe_data
  or p7_skid_data
  ) begin
  p7_pipe_skid_valid = (p7_skid_ready_flop)? p7_pipe_valid : p7_skid_valid; 
  // VCS sop_coverage_off start
  p7_pipe_skid_data = (p7_skid_ready_flop)? p7_pipe_data : p7_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (7) output
always @(
  p7_pipe_skid_valid
  or arb_src6_rdy
  or p7_pipe_skid_data
  ) begin
  arb_src6_vld = p7_pipe_skid_valid;
  p7_pipe_skid_ready = arb_src6_rdy;
  arb_src6_pd = p7_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src6_vld^arb_src6_rdy^bpt2arb_req6_valid^bpt2arb_req6_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req6_valid && !bpt2arb_req6_ready), (bpt2arb_req6_valid), (bpt2arb_req6_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p7




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src7_pd (arb_src7_vld,arb_src7_rdy) <= bpt2arb_req7_pd[74:0] (bpt2arb_req7_valid,bpt2arb_req7_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p8 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src7_rdy
  ,bpt2arb_req7_pd
  ,bpt2arb_req7_valid
  ,arb_src7_pd
  ,arb_src7_vld
  ,bpt2arb_req7_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src7_rdy;
input  [74:0] bpt2arb_req7_pd;
input         bpt2arb_req7_valid;
output [74:0] arb_src7_pd;
output        arb_src7_vld;
output        bpt2arb_req7_ready;
reg    [74:0] arb_src7_pd;
reg           arb_src7_vld;
reg           bpt2arb_req7_ready;
reg    [74:0] p8_pipe_data;
reg           p8_pipe_ready;
reg           p8_pipe_ready_bc;
reg    [74:0] p8_pipe_skid_data;
reg           p8_pipe_skid_ready;
reg           p8_pipe_skid_valid;
reg           p8_pipe_valid;
reg           p8_skid_catch;
reg    [74:0] p8_skid_data;
reg           p8_skid_ready;
reg           p8_skid_ready_flop;
reg           p8_skid_valid;
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
  p8_pipe_valid <= (p8_pipe_ready_bc)? bpt2arb_req7_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_pipe_data <= (p8_pipe_ready_bc && bpt2arb_req7_valid)? bpt2arb_req7_pd[74:0] : p8_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p8_pipe_ready_bc
  ) begin
  bpt2arb_req7_ready = p8_pipe_ready_bc;
end
//## pipe (8) skid buffer
always @(
  p8_pipe_valid
  or p8_skid_ready_flop
  or p8_pipe_skid_ready
  or p8_skid_valid
  ) begin
  p8_skid_catch = p8_pipe_valid && p8_skid_ready_flop && !p8_pipe_skid_ready;  
  p8_skid_ready = (p8_skid_valid)? p8_pipe_skid_ready : !p8_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p8_skid_valid <= 1'b0;
    p8_skid_ready_flop <= 1'b1;
    p8_pipe_ready <= 1'b1;
  end else begin
  p8_skid_valid <= (p8_skid_valid)? !p8_pipe_skid_ready : p8_skid_catch;
  p8_skid_ready_flop <= p8_skid_ready;
  p8_pipe_ready <= p8_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p8_skid_data <= (p8_skid_catch)? p8_pipe_data : p8_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p8_skid_ready_flop
  or p8_pipe_valid
  or p8_skid_valid
  or p8_pipe_data
  or p8_skid_data
  ) begin
  p8_pipe_skid_valid = (p8_skid_ready_flop)? p8_pipe_valid : p8_skid_valid; 
  // VCS sop_coverage_off start
  p8_pipe_skid_data = (p8_skid_ready_flop)? p8_pipe_data : p8_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (8) output
always @(
  p8_pipe_skid_valid
  or arb_src7_rdy
  or p8_pipe_skid_data
  ) begin
  arb_src7_vld = p8_pipe_skid_valid;
  p8_pipe_skid_ready = arb_src7_rdy;
  arb_src7_pd = p8_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src7_vld^arb_src7_rdy^bpt2arb_req7_valid^bpt2arb_req7_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req7_valid && !bpt2arb_req7_ready), (bpt2arb_req7_valid), (bpt2arb_req7_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p8




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src8_pd (arb_src8_vld,arb_src8_rdy) <= bpt2arb_req8_pd[74:0] (bpt2arb_req8_valid,bpt2arb_req8_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p9 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src8_rdy
  ,bpt2arb_req8_pd
  ,bpt2arb_req8_valid
  ,arb_src8_pd
  ,arb_src8_vld
  ,bpt2arb_req8_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src8_rdy;
input  [74:0] bpt2arb_req8_pd;
input         bpt2arb_req8_valid;
output [74:0] arb_src8_pd;
output        arb_src8_vld;
output        bpt2arb_req8_ready;
reg    [74:0] arb_src8_pd;
reg           arb_src8_vld;
reg           bpt2arb_req8_ready;
reg    [74:0] p9_pipe_data;
reg           p9_pipe_ready;
reg           p9_pipe_ready_bc;
reg    [74:0] p9_pipe_skid_data;
reg           p9_pipe_skid_ready;
reg           p9_pipe_skid_valid;
reg           p9_pipe_valid;
reg           p9_skid_catch;
reg    [74:0] p9_skid_data;
reg           p9_skid_ready;
reg           p9_skid_ready_flop;
reg           p9_skid_valid;
//## pipe (9) valid-ready-bubble-collapse
always @(
  p9_pipe_ready
  or p9_pipe_valid
  ) begin
  p9_pipe_ready_bc = p9_pipe_ready || !p9_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_pipe_valid <= 1'b0;
  end else begin
  p9_pipe_valid <= (p9_pipe_ready_bc)? bpt2arb_req8_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_pipe_data <= (p9_pipe_ready_bc && bpt2arb_req8_valid)? bpt2arb_req8_pd[74:0] : p9_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p9_pipe_ready_bc
  ) begin
  bpt2arb_req8_ready = p9_pipe_ready_bc;
end
//## pipe (9) skid buffer
always @(
  p9_pipe_valid
  or p9_skid_ready_flop
  or p9_pipe_skid_ready
  or p9_skid_valid
  ) begin
  p9_skid_catch = p9_pipe_valid && p9_skid_ready_flop && !p9_pipe_skid_ready;  
  p9_skid_ready = (p9_skid_valid)? p9_pipe_skid_ready : !p9_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p9_skid_valid <= 1'b0;
    p9_skid_ready_flop <= 1'b1;
    p9_pipe_ready <= 1'b1;
  end else begin
  p9_skid_valid <= (p9_skid_valid)? !p9_pipe_skid_ready : p9_skid_catch;
  p9_skid_ready_flop <= p9_skid_ready;
  p9_pipe_ready <= p9_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p9_skid_data <= (p9_skid_catch)? p9_pipe_data : p9_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p9_skid_ready_flop
  or p9_pipe_valid
  or p9_skid_valid
  or p9_pipe_data
  or p9_skid_data
  ) begin
  p9_pipe_skid_valid = (p9_skid_ready_flop)? p9_pipe_valid : p9_skid_valid; 
  // VCS sop_coverage_off start
  p9_pipe_skid_data = (p9_skid_ready_flop)? p9_pipe_data : p9_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (9) output
always @(
  p9_pipe_skid_valid
  or arb_src8_rdy
  or p9_pipe_skid_data
  ) begin
  arb_src8_vld = p9_pipe_skid_valid;
  p9_pipe_skid_ready = arb_src8_rdy;
  arb_src8_pd = p9_pipe_skid_data;
end
//## pipe (9) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p9_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src8_vld^arb_src8_rdy^bpt2arb_req8_valid^bpt2arb_req8_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req8_valid && !bpt2arb_req8_ready), (bpt2arb_req8_valid), (bpt2arb_req8_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p9




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os arb_src9_pd (arb_src9_vld,arb_src9_rdy) <= bpt2arb_req9_pd[74:0] (bpt2arb_req9_valid,bpt2arb_req9_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_ARB_pipe_p10 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_src9_rdy
  ,bpt2arb_req9_pd
  ,bpt2arb_req9_valid
  ,arb_src9_pd
  ,arb_src9_vld
  ,bpt2arb_req9_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         arb_src9_rdy;
input  [74:0] bpt2arb_req9_pd;
input         bpt2arb_req9_valid;
output [74:0] arb_src9_pd;
output        arb_src9_vld;
output        bpt2arb_req9_ready;
reg    [74:0] arb_src9_pd;
reg           arb_src9_vld;
reg           bpt2arb_req9_ready;
reg    [74:0] p10_pipe_data;
reg           p10_pipe_ready;
reg           p10_pipe_ready_bc;
reg    [74:0] p10_pipe_skid_data;
reg           p10_pipe_skid_ready;
reg           p10_pipe_skid_valid;
reg           p10_pipe_valid;
reg           p10_skid_catch;
reg    [74:0] p10_skid_data;
reg           p10_skid_ready;
reg           p10_skid_ready_flop;
reg           p10_skid_valid;
//## pipe (10) valid-ready-bubble-collapse
always @(
  p10_pipe_ready
  or p10_pipe_valid
  ) begin
  p10_pipe_ready_bc = p10_pipe_ready || !p10_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_pipe_valid <= 1'b0;
  end else begin
  p10_pipe_valid <= (p10_pipe_ready_bc)? bpt2arb_req9_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_pipe_data <= (p10_pipe_ready_bc && bpt2arb_req9_valid)? bpt2arb_req9_pd[74:0] : p10_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p10_pipe_ready_bc
  ) begin
  bpt2arb_req9_ready = p10_pipe_ready_bc;
end
//## pipe (10) skid buffer
always @(
  p10_pipe_valid
  or p10_skid_ready_flop
  or p10_pipe_skid_ready
  or p10_skid_valid
  ) begin
  p10_skid_catch = p10_pipe_valid && p10_skid_ready_flop && !p10_pipe_skid_ready;  
  p10_skid_ready = (p10_skid_valid)? p10_pipe_skid_ready : !p10_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p10_skid_valid <= 1'b0;
    p10_skid_ready_flop <= 1'b1;
    p10_pipe_ready <= 1'b1;
  end else begin
  p10_skid_valid <= (p10_skid_valid)? !p10_pipe_skid_ready : p10_skid_catch;
  p10_skid_ready_flop <= p10_skid_ready;
  p10_pipe_ready <= p10_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p10_skid_data <= (p10_skid_catch)? p10_pipe_data : p10_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p10_skid_ready_flop
  or p10_pipe_valid
  or p10_skid_valid
  or p10_pipe_data
  or p10_skid_data
  ) begin
  p10_pipe_skid_valid = (p10_skid_ready_flop)? p10_pipe_valid : p10_skid_valid; 
  // VCS sop_coverage_off start
  p10_pipe_skid_data = (p10_skid_ready_flop)? p10_pipe_data : p10_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (10) output
always @(
  p10_pipe_skid_valid
  or arb_src9_rdy
  or p10_pipe_skid_data
  ) begin
  arb_src9_vld = p10_pipe_skid_valid;
  p10_pipe_skid_ready = arb_src9_rdy;
  arb_src9_pd = p10_pipe_skid_data;
end
//## pipe (10) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p10_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (arb_src9_vld^arb_src9_rdy^bpt2arb_req9_valid^bpt2arb_req9_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_req9_valid && !bpt2arb_req9_ready), (bpt2arb_req9_valid), (bpt2arb_req9_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_ARB_pipe_p10


