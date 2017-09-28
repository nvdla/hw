// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_IG_arb.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_IG_arb (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,arb2spt_cmd_ready     //|< i
  ,arb2spt_dat_ready     //|< i
  ,bpt2arb_cmd0_pd       //|< i
  ,bpt2arb_cmd0_valid    //|< i
  ,bpt2arb_cmd1_pd       //|< i
  ,bpt2arb_cmd1_valid    //|< i
  ,bpt2arb_cmd2_pd       //|< i
  ,bpt2arb_cmd2_valid    //|< i
  ,bpt2arb_cmd3_pd       //|< i
  ,bpt2arb_cmd3_valid    //|< i
  ,bpt2arb_cmd4_pd       //|< i
  ,bpt2arb_cmd4_valid    //|< i
  ,bpt2arb_dat0_pd       //|< i
  ,bpt2arb_dat0_valid    //|< i
  ,bpt2arb_dat1_pd       //|< i
  ,bpt2arb_dat1_valid    //|< i
  ,bpt2arb_dat2_pd       //|< i
  ,bpt2arb_dat2_valid    //|< i
  ,bpt2arb_dat3_pd       //|< i
  ,bpt2arb_dat3_valid    //|< i
  ,bpt2arb_dat4_pd       //|< i
  ,bpt2arb_dat4_valid    //|< i
  ,pwrbus_ram_pd         //|< i
  ,reg2dp_wr_weight_bdma //|< i
  ,reg2dp_wr_weight_cdp  //|< i
  ,reg2dp_wr_weight_pdp  //|< i
  ,reg2dp_wr_weight_rbk  //|< i
  ,reg2dp_wr_weight_sdp  //|< i
  ,arb2spt_cmd_pd        //|> o
  ,arb2spt_cmd_valid     //|> o
  ,arb2spt_dat_pd        //|> o
  ,arb2spt_dat_valid     //|> o
  ,bpt2arb_cmd0_ready    //|> o
  ,bpt2arb_cmd1_ready    //|> o
  ,bpt2arb_cmd2_ready    //|> o
  ,bpt2arb_cmd3_ready    //|> o
  ,bpt2arb_cmd4_ready    //|> o
  ,bpt2arb_dat0_ready    //|> o
  ,bpt2arb_dat1_ready    //|> o
  ,bpt2arb_dat2_ready    //|> o
  ,bpt2arb_dat3_ready    //|> o
  ,bpt2arb_dat4_ready    //|> o
  );
//
// NV_NVDLA_MCIF_WRITE_IG_arb_ports.v
//
input  nvdla_core_clk;   /* bpt2arb_cmd0, bpt2arb_cmd1, bpt2arb_cmd2, bpt2arb_cmd3, bpt2arb_cmd4, bpt2arb_dat0, bpt2arb_dat1, bpt2arb_dat2, bpt2arb_dat3, bpt2arb_dat4, arb2spt_cmd, arb2spt_dat */
input  nvdla_core_rstn;  /* bpt2arb_cmd0, bpt2arb_cmd1, bpt2arb_cmd2, bpt2arb_cmd3, bpt2arb_cmd4, bpt2arb_dat0, bpt2arb_dat1, bpt2arb_dat2, bpt2arb_dat3, bpt2arb_dat4, arb2spt_cmd, arb2spt_dat */

input         bpt2arb_cmd0_valid;  /* data valid */
output        bpt2arb_cmd0_ready;  /* data return handshake */
input  [76:0] bpt2arb_cmd0_pd;

input         bpt2arb_cmd1_valid;  /* data valid */
output        bpt2arb_cmd1_ready;  /* data return handshake */
input  [76:0] bpt2arb_cmd1_pd;

input         bpt2arb_cmd2_valid;  /* data valid */
output        bpt2arb_cmd2_ready;  /* data return handshake */
input  [76:0] bpt2arb_cmd2_pd;

input         bpt2arb_cmd3_valid;  /* data valid */
output        bpt2arb_cmd3_ready;  /* data return handshake */
input  [76:0] bpt2arb_cmd3_pd;

input         bpt2arb_cmd4_valid;  /* data valid */
output        bpt2arb_cmd4_ready;  /* data return handshake */
input  [76:0] bpt2arb_cmd4_pd;

input          bpt2arb_dat0_valid;  /* data valid */
output         bpt2arb_dat0_ready;  /* data return handshake */
input  [513:0] bpt2arb_dat0_pd;

input          bpt2arb_dat1_valid;  /* data valid */
output         bpt2arb_dat1_ready;  /* data return handshake */
input  [513:0] bpt2arb_dat1_pd;

input          bpt2arb_dat2_valid;  /* data valid */
output         bpt2arb_dat2_ready;  /* data return handshake */
input  [513:0] bpt2arb_dat2_pd;

input          bpt2arb_dat3_valid;  /* data valid */
output         bpt2arb_dat3_ready;  /* data return handshake */
input  [513:0] bpt2arb_dat3_pd;

input          bpt2arb_dat4_valid;  /* data valid */
output         bpt2arb_dat4_ready;  /* data return handshake */
input  [513:0] bpt2arb_dat4_pd;

output        arb2spt_cmd_valid;  /* data valid */
input         arb2spt_cmd_ready;  /* data return handshake */
output [76:0] arb2spt_cmd_pd;

output         arb2spt_dat_valid;  /* data valid */
input          arb2spt_dat_ready;  /* data return handshake */
output [513:0] arb2spt_dat_pd;

input [31:0] pwrbus_ram_pd;

input   [7:0] reg2dp_wr_weight_bdma;
input   [7:0] reg2dp_wr_weight_cdp;
input   [7:0] reg2dp_wr_weight_pdp;
input   [7:0] reg2dp_wr_weight_rbk;
input   [7:0] reg2dp_wr_weight_sdp;
reg    [76:0] arb_cmd_pd;
reg   [513:0] arb_dat_pd;
reg     [1:0] gnt_count;
reg     [4:0] stick_gnts;
reg           sticky;
wire    [4:0] all_gnts;
wire          any_arb_gnt;
wire    [1:0] arb_cmd_beats;
wire          arb_cmd_inc;
wire    [2:0] arb_cmd_size;
wire          arb_cmd_size_bit0_NC;
wire    [4:0] arb_gnts;
wire    [4:0] arb_reqs;
wire    [2:0] dfifo0_wr_count;
wire    [2:0] dfifo1_wr_count;
wire    [2:0] dfifo2_wr_count;
wire    [2:0] dfifo3_wr_count;
wire    [2:0] dfifo4_wr_count;
wire          gnt_busy;
wire          is_last_beat;
wire          mon_arb_cmd_beats_c;
wire          spt_is_busy;
wire    [1:0] src_cmd0_beats;
wire          src_cmd0_beats_c;
wire          src_cmd0_camp_vld;
wire          src_cmd0_inc;
wire   [76:0] src_cmd0_pd;
wire          src_cmd0_rdy;
wire    [2:0] src_cmd0_size;
wire          src_cmd0_size_bit0_NC;
wire          src_cmd0_vld;
wire    [1:0] src_cmd1_beats;
wire          src_cmd1_beats_c;
wire          src_cmd1_camp_vld;
wire          src_cmd1_inc;
wire   [76:0] src_cmd1_pd;
wire          src_cmd1_rdy;
wire    [2:0] src_cmd1_size;
wire          src_cmd1_size_bit0_NC;
wire          src_cmd1_vld;
wire    [1:0] src_cmd2_beats;
wire          src_cmd2_beats_c;
wire          src_cmd2_camp_vld;
wire          src_cmd2_inc;
wire   [76:0] src_cmd2_pd;
wire          src_cmd2_rdy;
wire    [2:0] src_cmd2_size;
wire          src_cmd2_size_bit0_NC;
wire          src_cmd2_vld;
wire    [1:0] src_cmd3_beats;
wire          src_cmd3_beats_c;
wire          src_cmd3_camp_vld;
wire          src_cmd3_inc;
wire   [76:0] src_cmd3_pd;
wire          src_cmd3_rdy;
wire    [2:0] src_cmd3_size;
wire          src_cmd3_size_bit0_NC;
wire          src_cmd3_vld;
wire    [1:0] src_cmd4_beats;
wire          src_cmd4_beats_c;
wire          src_cmd4_camp_vld;
wire          src_cmd4_inc;
wire   [76:0] src_cmd4_pd;
wire          src_cmd4_rdy;
wire    [2:0] src_cmd4_size;
wire          src_cmd4_size_bit0_NC;
wire          src_cmd4_vld;
wire    [4:0] src_cmd_vlds;
wire  [513:0] src_dat0_pd;
wire          src_dat0_rdy;
wire          src_dat0_vld;
wire  [513:0] src_dat1_pd;
wire          src_dat1_rdy;
wire          src_dat1_vld;
wire  [513:0] src_dat2_pd;
wire          src_dat2_rdy;
wire          src_dat2_vld;
wire  [513:0] src_dat3_pd;
wire          src_dat3_rdy;
wire          src_dat3_vld;
wire  [513:0] src_dat4_pd;
wire          src_dat4_rdy;
wire          src_dat4_vld;
wire    [4:0] src_dat_gnts;
wire          src_dat_vld;
wire    [4:0] src_dat_vlds;
wire    [7:0] wt0;
wire    [7:0] wt1;
wire    [7:0] wt2;
wire    [7:0] wt3;
wire    [7:0] wt4;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

// CMD input
NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.bpt2arb_cmd0_pd    (bpt2arb_cmd0_pd[76:0])  //|< i
  ,.bpt2arb_cmd0_valid (bpt2arb_cmd0_valid)     //|< i
  ,.src_cmd0_rdy       (src_cmd0_rdy)           //|< w
  ,.bpt2arb_cmd0_ready (bpt2arb_cmd0_ready)     //|> o
  ,.src_cmd0_pd        (src_cmd0_pd[76:0])      //|> w
  ,.src_cmd0_vld       (src_cmd0_vld)           //|> w
  );
// DAT input
NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo u_dfifo0 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count     (dfifo0_wr_count[2:0])   //|> w
  ,.dfifo_wr_prdy      (bpt2arb_dat0_ready)     //|> o
  ,.dfifo_wr_pvld      (bpt2arb_dat0_valid)     //|< i
  ,.dfifo_wr_pd        (bpt2arb_dat0_pd[513:0]) //|< i
  ,.dfifo_rd_prdy      (src_dat0_rdy)           //|< w
  ,.dfifo_rd_pvld      (src_dat0_vld)           //|> w
  ,.dfifo_rd_pd        (src_dat0_pd[513:0])     //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );
// CMD input
NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p2 pipe_p2 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.bpt2arb_cmd1_pd    (bpt2arb_cmd1_pd[76:0])  //|< i
  ,.bpt2arb_cmd1_valid (bpt2arb_cmd1_valid)     //|< i
  ,.src_cmd1_rdy       (src_cmd1_rdy)           //|< w
  ,.bpt2arb_cmd1_ready (bpt2arb_cmd1_ready)     //|> o
  ,.src_cmd1_pd        (src_cmd1_pd[76:0])      //|> w
  ,.src_cmd1_vld       (src_cmd1_vld)           //|> w
  );
// DAT input
NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo u_dfifo1 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count     (dfifo1_wr_count[2:0])   //|> w
  ,.dfifo_wr_prdy      (bpt2arb_dat1_ready)     //|> o
  ,.dfifo_wr_pvld      (bpt2arb_dat1_valid)     //|< i
  ,.dfifo_wr_pd        (bpt2arb_dat1_pd[513:0]) //|< i
  ,.dfifo_rd_prdy      (src_dat1_rdy)           //|< w
  ,.dfifo_rd_pvld      (src_dat1_vld)           //|> w
  ,.dfifo_rd_pd        (src_dat1_pd[513:0])     //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );
// CMD input
NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p3 pipe_p3 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.bpt2arb_cmd2_pd    (bpt2arb_cmd2_pd[76:0])  //|< i
  ,.bpt2arb_cmd2_valid (bpt2arb_cmd2_valid)     //|< i
  ,.src_cmd2_rdy       (src_cmd2_rdy)           //|< w
  ,.bpt2arb_cmd2_ready (bpt2arb_cmd2_ready)     //|> o
  ,.src_cmd2_pd        (src_cmd2_pd[76:0])      //|> w
  ,.src_cmd2_vld       (src_cmd2_vld)           //|> w
  );
// DAT input
NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo u_dfifo2 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count     (dfifo2_wr_count[2:0])   //|> w
  ,.dfifo_wr_prdy      (bpt2arb_dat2_ready)     //|> o
  ,.dfifo_wr_pvld      (bpt2arb_dat2_valid)     //|< i
  ,.dfifo_wr_pd        (bpt2arb_dat2_pd[513:0]) //|< i
  ,.dfifo_rd_prdy      (src_dat2_rdy)           //|< w
  ,.dfifo_rd_pvld      (src_dat2_vld)           //|> w
  ,.dfifo_rd_pd        (src_dat2_pd[513:0])     //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );
// CMD input
NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p4 pipe_p4 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.bpt2arb_cmd3_pd    (bpt2arb_cmd3_pd[76:0])  //|< i
  ,.bpt2arb_cmd3_valid (bpt2arb_cmd3_valid)     //|< i
  ,.src_cmd3_rdy       (src_cmd3_rdy)           //|< w
  ,.bpt2arb_cmd3_ready (bpt2arb_cmd3_ready)     //|> o
  ,.src_cmd3_pd        (src_cmd3_pd[76:0])      //|> w
  ,.src_cmd3_vld       (src_cmd3_vld)           //|> w
  );
// DAT input
NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo u_dfifo3 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count     (dfifo3_wr_count[2:0])   //|> w
  ,.dfifo_wr_prdy      (bpt2arb_dat3_ready)     //|> o
  ,.dfifo_wr_pvld      (bpt2arb_dat3_valid)     //|< i
  ,.dfifo_wr_pd        (bpt2arb_dat3_pd[513:0]) //|< i
  ,.dfifo_rd_prdy      (src_dat3_rdy)           //|< w
  ,.dfifo_rd_pvld      (src_dat3_vld)           //|> w
  ,.dfifo_rd_pd        (src_dat3_pd[513:0])     //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );
// CMD input
NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p5 pipe_p5 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.bpt2arb_cmd4_pd    (bpt2arb_cmd4_pd[76:0])  //|< i
  ,.bpt2arb_cmd4_valid (bpt2arb_cmd4_valid)     //|< i
  ,.src_cmd4_rdy       (src_cmd4_rdy)           //|< w
  ,.bpt2arb_cmd4_ready (bpt2arb_cmd4_ready)     //|> o
  ,.src_cmd4_pd        (src_cmd4_pd[76:0])      //|> w
  ,.src_cmd4_vld       (src_cmd4_vld)           //|> w
  );
// DAT input
NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo u_dfifo4 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.dfifo_wr_count     (dfifo4_wr_count[2:0])   //|> w
  ,.dfifo_wr_prdy      (bpt2arb_dat4_ready)     //|> o
  ,.dfifo_wr_pvld      (bpt2arb_dat4_valid)     //|< i
  ,.dfifo_wr_pd        (bpt2arb_dat4_pd[513:0]) //|< i
  ,.dfifo_rd_prdy      (src_dat4_rdy)           //|< w
  ,.dfifo_rd_pvld      (src_dat4_vld)           //|> w
  ,.dfifo_rd_pd        (src_dat4_pd[513:0])     //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );

assign src_cmd0_size= {3 {src_cmd0_vld}} & src_cmd0_pd[71:69];
assign src_cmd0_inc = {1{src_cmd0_vld}} & src_cmd0_pd[74:74];
assign src_cmd0_rdy = is_last_beat & src_dat_gnts[0];
assign src_dat0_rdy = all_gnts[0];
assign {src_cmd0_beats_c, src_cmd0_beats} = src_cmd0_size[2:1] + src_cmd0_inc;
assign src_cmd0_size_bit0_NC = src_cmd0_size[0]; // bit0 is not used
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, src_cmd0_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_cmd0_camp_vld = src_cmd0_vld & (dfifo0_wr_count > {src_cmd0_beats_c,src_cmd0_beats});
assign src_cmd1_size= {3 {src_cmd1_vld}} & src_cmd1_pd[71:69];
assign src_cmd1_inc = {1{src_cmd1_vld}} & src_cmd1_pd[74:74];
assign src_cmd1_rdy = is_last_beat & src_dat_gnts[1];
assign src_dat1_rdy = all_gnts[1];
assign {src_cmd1_beats_c, src_cmd1_beats} = src_cmd1_size[2:1] + src_cmd1_inc;
assign src_cmd1_size_bit0_NC = src_cmd1_size[0]; // bit0 is not used
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, src_cmd1_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_cmd1_camp_vld = src_cmd1_vld & (dfifo1_wr_count > {src_cmd1_beats_c,src_cmd1_beats});
assign src_cmd2_size= {3 {src_cmd2_vld}} & src_cmd2_pd[71:69];
assign src_cmd2_inc = {1{src_cmd2_vld}} & src_cmd2_pd[74:74];
assign src_cmd2_rdy = is_last_beat & src_dat_gnts[2];
assign src_dat2_rdy = all_gnts[2];
assign {src_cmd2_beats_c, src_cmd2_beats} = src_cmd2_size[2:1] + src_cmd2_inc;
assign src_cmd2_size_bit0_NC = src_cmd2_size[0]; // bit0 is not used
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, src_cmd2_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_cmd2_camp_vld = src_cmd2_vld & (dfifo2_wr_count > {src_cmd2_beats_c,src_cmd2_beats});
assign src_cmd3_size= {3 {src_cmd3_vld}} & src_cmd3_pd[71:69];
assign src_cmd3_inc = {1{src_cmd3_vld}} & src_cmd3_pd[74:74];
assign src_cmd3_rdy = is_last_beat & src_dat_gnts[3];
assign src_dat3_rdy = all_gnts[3];
assign {src_cmd3_beats_c, src_cmd3_beats} = src_cmd3_size[2:1] + src_cmd3_inc;
assign src_cmd3_size_bit0_NC = src_cmd3_size[0]; // bit0 is not used
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, src_cmd3_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_cmd3_camp_vld = src_cmd3_vld & (dfifo3_wr_count > {src_cmd3_beats_c,src_cmd3_beats});
assign src_cmd4_size= {3 {src_cmd4_vld}} & src_cmd4_pd[71:69];
assign src_cmd4_inc = {1{src_cmd4_vld}} & src_cmd4_pd[74:74];
assign src_cmd4_rdy = is_last_beat & src_dat_gnts[4];
assign src_dat4_rdy = all_gnts[4];
assign {src_cmd4_beats_c, src_cmd4_beats} = src_cmd4_size[2:1] + src_cmd4_inc;
assign src_cmd4_size_bit0_NC = src_cmd4_size[0]; // bit0 is not used
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, src_cmd4_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_cmd4_camp_vld = src_cmd4_vld & (dfifo4_wr_count > {src_cmd4_beats_c,src_cmd4_beats});

assign src_cmd_vlds = {src_cmd4_camp_vld , src_cmd3_camp_vld , src_cmd2_camp_vld , src_cmd1_camp_vld , src_cmd0_camp_vld};
assign src_dat_vlds = {src_dat4_vld , src_dat3_vld , src_dat2_vld , src_dat1_vld , src_dat0_vld};

// MUX out based on GNT

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stick_gnts <= {5{1'b0}};
  end else begin
  if ((any_arb_gnt) == 1'b1) begin
    stick_gnts <= arb_gnts;
  // VCS coverage off
  end else if ((any_arb_gnt) == 1'b0) begin
  end else begin
    stick_gnts <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(any_arb_gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign src_dat_gnts = all_gnts & src_dat_vlds;
assign src_dat_vld = |src_dat_gnts;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gnt_count <= {2{1'b0}};
  end else begin
    if (src_dat_vld) begin
        if (is_last_beat) begin
            gnt_count <= 0;
        end else begin
            gnt_count <= gnt_count + 1;
        end
    end
  end
end
assign is_last_beat = (gnt_count==arb_cmd_beats);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sticky <= 1'b0;
  end else begin
    if (any_arb_gnt) begin
        if (src_dat_vld & is_last_beat) begin
            sticky <= 0;
        end else begin
            sticky <= 1;
        end
    end else if (src_dat_vld & is_last_beat) begin
        sticky <= 0;
    end
  end
end

assign {mon_arb_cmd_beats_c,arb_cmd_beats} = arb_cmd_size[2:1] + arb_cmd_inc;
assign arb_cmd_size_bit0_NC = arb_cmd_size[0];
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
  nv_assert_never #(0,0,"no overflow is allowed")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, mon_arb_cmd_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign all_gnts = (sticky) ? (stick_gnts) : arb_gnts;
assign gnt_busy = sticky || spt_is_busy;
assign arb_reqs = src_cmd_vlds;

assign wt0 = reg2dp_wr_weight_bdma;
assign wt1 = reg2dp_wr_weight_sdp;
assign wt2 = reg2dp_wr_weight_pdp;
assign wt3 = reg2dp_wr_weight_cdp;
assign wt4 = reg2dp_wr_weight_rbk;

write_ig_arb u_write_ig_arb (
   .req0               (arb_reqs[0])            //|< w
  ,.req1               (arb_reqs[1])            //|< w
  ,.req2               (arb_reqs[2])            //|< w
  ,.req3               (arb_reqs[3])            //|< w
  ,.req4               (arb_reqs[4])            //|< w
  ,.wt0                (wt0[7:0])               //|< w
  ,.wt1                (wt1[7:0])               //|< w
  ,.wt2                (wt2[7:0])               //|< w
  ,.wt3                (wt3[7:0])               //|< w
  ,.wt4                (wt4[7:0])               //|< w
  ,.gnt_busy           (gnt_busy)               //|< w
  ,.clk                (nvdla_core_clk)         //|< i
  ,.reset_             (nvdla_core_rstn)        //|< i
  ,.gnt0               (arb_gnts[0])            //|> w
  ,.gnt1               (arb_gnts[1])            //|> w
  ,.gnt2               (arb_gnts[2])            //|> w
  ,.gnt3               (arb_gnts[3])            //|> w
  ,.gnt4               (arb_gnts[4])            //|> w
  );

assign any_arb_gnt = |arb_gnts;

// ARB MUX
always @(
  all_gnts
  or src_cmd0_pd
  or src_cmd1_pd
  or src_cmd2_pd
  or src_cmd3_pd
  or src_cmd4_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      all_gnts[0]: arb_cmd_pd = src_cmd0_pd;
      all_gnts[1]: arb_cmd_pd = src_cmd1_pd;
      all_gnts[2]: arb_cmd_pd = src_cmd2_pd;
      all_gnts[3]: arb_cmd_pd = src_cmd3_pd;
      all_gnts[4]: arb_cmd_pd = src_cmd4_pd;
    //VCS coverage off
    default : begin 
                arb_cmd_pd[76:0] = {77{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end
assign arb_cmd_size = arb_cmd_pd[71:69];
assign arb_cmd_inc = arb_cmd_pd[74:74];

always @(
  all_gnts
  or src_dat0_pd
  or src_dat1_pd
  or src_dat2_pd
  or src_dat3_pd
  or src_dat4_pd
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
      all_gnts[0]: arb_dat_pd = src_dat0_pd;
      all_gnts[1]: arb_dat_pd = src_dat1_pd;
      all_gnts[2]: arb_dat_pd = src_dat2_pd;
      all_gnts[3]: arb_dat_pd = src_dat3_pd;
      all_gnts[4]: arb_dat_pd = src_dat4_pd;
    //VCS coverage off
    default : begin 
                arb_dat_pd[513:0] = {514{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//PKT_PACK_WIRE(cvt_write_cmd, pkt_cmd_,arb2spt_cmd_pd)
assign arb2spt_cmd_pd = arb_cmd_pd;

//PKT_PACK_WIRE(cvt_write_data,pkt_dat_,arb2spt_dat_pd)
assign arb2spt_dat_pd = arb_dat_pd;

// arb2spt
assign arb2spt_cmd_valid = any_arb_gnt;
assign arb2spt_dat_valid = src_dat_vld;

assign spt_is_busy = !(arb2spt_cmd_ready & arb2spt_dat_ready);

//========================
// OBS
//assign obs_bus_mcif_write_ig_arb_gnt_busy = gnt_busy;
endmodule // NV_NVDLA_MCIF_WRITE_IG_arb



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os src_cmd0_pd (src_cmd0_vld,src_cmd0_rdy) <= bpt2arb_cmd0_pd[76:0] (bpt2arb_cmd0_valid,bpt2arb_cmd0_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_cmd0_pd
  ,bpt2arb_cmd0_valid
  ,src_cmd0_rdy
  ,bpt2arb_cmd0_ready
  ,src_cmd0_pd
  ,src_cmd0_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [76:0] bpt2arb_cmd0_pd;
input         bpt2arb_cmd0_valid;
input         src_cmd0_rdy;
output        bpt2arb_cmd0_ready;
output [76:0] src_cmd0_pd;
output        src_cmd0_vld;
reg           bpt2arb_cmd0_ready;
reg    [76:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg    [76:0] p1_pipe_skid_data;
reg           p1_pipe_skid_ready;
reg           p1_pipe_skid_valid;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [76:0] p1_skid_data;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
reg    [76:0] src_cmd0_pd;
reg           src_cmd0_vld;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? bpt2arb_cmd0_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && bpt2arb_cmd0_valid)? bpt2arb_cmd0_pd[76:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  bpt2arb_cmd0_ready = p1_pipe_ready_bc;
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
  or src_cmd0_rdy
  or p1_pipe_skid_data
  ) begin
  src_cmd0_vld = p1_pipe_skid_valid;
  p1_pipe_skid_ready = src_cmd0_rdy;
  src_cmd0_pd = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (src_cmd0_vld^src_cmd0_rdy^bpt2arb_cmd0_valid^bpt2arb_cmd0_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_9x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_cmd0_valid && !bpt2arb_cmd0_ready), (bpt2arb_cmd0_valid), (bpt2arb_cmd0_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os src_cmd1_pd (src_cmd1_vld,src_cmd1_rdy) <= bpt2arb_cmd1_pd[76:0] (bpt2arb_cmd1_valid,bpt2arb_cmd1_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_cmd1_pd
  ,bpt2arb_cmd1_valid
  ,src_cmd1_rdy
  ,bpt2arb_cmd1_ready
  ,src_cmd1_pd
  ,src_cmd1_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [76:0] bpt2arb_cmd1_pd;
input         bpt2arb_cmd1_valid;
input         src_cmd1_rdy;
output        bpt2arb_cmd1_ready;
output [76:0] src_cmd1_pd;
output        src_cmd1_vld;
reg           bpt2arb_cmd1_ready;
reg    [76:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg    [76:0] p2_pipe_skid_data;
reg           p2_pipe_skid_ready;
reg           p2_pipe_skid_valid;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [76:0] p2_skid_data;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
reg    [76:0] src_cmd1_pd;
reg           src_cmd1_vld;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? bpt2arb_cmd1_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && bpt2arb_cmd1_valid)? bpt2arb_cmd1_pd[76:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  bpt2arb_cmd1_ready = p2_pipe_ready_bc;
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
  or src_cmd1_rdy
  or p2_pipe_skid_data
  ) begin
  src_cmd1_vld = p2_pipe_skid_valid;
  p2_pipe_skid_ready = src_cmd1_rdy;
  src_cmd1_pd = p2_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (src_cmd1_vld^src_cmd1_rdy^bpt2arb_cmd1_valid^bpt2arb_cmd1_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_11x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_cmd1_valid && !bpt2arb_cmd1_ready), (bpt2arb_cmd1_valid), (bpt2arb_cmd1_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os src_cmd2_pd (src_cmd2_vld,src_cmd2_rdy) <= bpt2arb_cmd2_pd[76:0] (bpt2arb_cmd2_valid,bpt2arb_cmd2_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_cmd2_pd
  ,bpt2arb_cmd2_valid
  ,src_cmd2_rdy
  ,bpt2arb_cmd2_ready
  ,src_cmd2_pd
  ,src_cmd2_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [76:0] bpt2arb_cmd2_pd;
input         bpt2arb_cmd2_valid;
input         src_cmd2_rdy;
output        bpt2arb_cmd2_ready;
output [76:0] src_cmd2_pd;
output        src_cmd2_vld;
reg           bpt2arb_cmd2_ready;
reg    [76:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg    [76:0] p3_pipe_skid_data;
reg           p3_pipe_skid_ready;
reg           p3_pipe_skid_valid;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [76:0] p3_skid_data;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
reg    [76:0] src_cmd2_pd;
reg           src_cmd2_vld;
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? bpt2arb_cmd2_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && bpt2arb_cmd2_valid)? bpt2arb_cmd2_pd[76:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  bpt2arb_cmd2_ready = p3_pipe_ready_bc;
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
  or src_cmd2_rdy
  or p3_pipe_skid_data
  ) begin
  src_cmd2_vld = p3_pipe_skid_valid;
  p3_pipe_skid_ready = src_cmd2_rdy;
  src_cmd2_pd = p3_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (src_cmd2_vld^src_cmd2_rdy^bpt2arb_cmd2_valid^bpt2arb_cmd2_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_13x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_cmd2_valid && !bpt2arb_cmd2_ready), (bpt2arb_cmd2_valid), (bpt2arb_cmd2_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os src_cmd3_pd (src_cmd3_vld,src_cmd3_rdy) <= bpt2arb_cmd3_pd[76:0] (bpt2arb_cmd3_valid,bpt2arb_cmd3_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_cmd3_pd
  ,bpt2arb_cmd3_valid
  ,src_cmd3_rdy
  ,bpt2arb_cmd3_ready
  ,src_cmd3_pd
  ,src_cmd3_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [76:0] bpt2arb_cmd3_pd;
input         bpt2arb_cmd3_valid;
input         src_cmd3_rdy;
output        bpt2arb_cmd3_ready;
output [76:0] src_cmd3_pd;
output        src_cmd3_vld;
reg           bpt2arb_cmd3_ready;
reg    [76:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg    [76:0] p4_pipe_skid_data;
reg           p4_pipe_skid_ready;
reg           p4_pipe_skid_valid;
reg           p4_pipe_valid;
reg           p4_skid_catch;
reg    [76:0] p4_skid_data;
reg           p4_skid_ready;
reg           p4_skid_ready_flop;
reg           p4_skid_valid;
reg    [76:0] src_cmd3_pd;
reg           src_cmd3_vld;
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? bpt2arb_cmd3_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && bpt2arb_cmd3_valid)? bpt2arb_cmd3_pd[76:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  bpt2arb_cmd3_ready = p4_pipe_ready_bc;
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
  or src_cmd3_rdy
  or p4_pipe_skid_data
  ) begin
  src_cmd3_vld = p4_pipe_skid_valid;
  p4_pipe_skid_ready = src_cmd3_rdy;
  src_cmd3_pd = p4_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (src_cmd3_vld^src_cmd3_rdy^bpt2arb_cmd3_valid^bpt2arb_cmd3_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_15x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_cmd3_valid && !bpt2arb_cmd3_ready), (bpt2arb_cmd3_valid), (bpt2arb_cmd3_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -os src_cmd4_pd (src_cmd4_vld,src_cmd4_rdy) <= bpt2arb_cmd4_pd[76:0] (bpt2arb_cmd4_valid,bpt2arb_cmd4_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_cmd4_pd
  ,bpt2arb_cmd4_valid
  ,src_cmd4_rdy
  ,bpt2arb_cmd4_ready
  ,src_cmd4_pd
  ,src_cmd4_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [76:0] bpt2arb_cmd4_pd;
input         bpt2arb_cmd4_valid;
input         src_cmd4_rdy;
output        bpt2arb_cmd4_ready;
output [76:0] src_cmd4_pd;
output        src_cmd4_vld;
reg           bpt2arb_cmd4_ready;
reg    [76:0] p5_pipe_data;
reg           p5_pipe_ready;
reg           p5_pipe_ready_bc;
reg    [76:0] p5_pipe_skid_data;
reg           p5_pipe_skid_ready;
reg           p5_pipe_skid_valid;
reg           p5_pipe_valid;
reg           p5_skid_catch;
reg    [76:0] p5_skid_data;
reg           p5_skid_ready;
reg           p5_skid_ready_flop;
reg           p5_skid_valid;
reg    [76:0] src_cmd4_pd;
reg           src_cmd4_vld;
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
  p5_pipe_valid <= (p5_pipe_ready_bc)? bpt2arb_cmd4_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && bpt2arb_cmd4_valid)? bpt2arb_cmd4_pd[76:0] : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  bpt2arb_cmd4_ready = p5_pipe_ready_bc;
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
  or src_cmd4_rdy
  or p5_pipe_skid_data
  ) begin
  src_cmd4_vld = p5_pipe_skid_valid;
  p5_pipe_skid_ready = src_cmd4_rdy;
  src_cmd4_pd = p5_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (src_cmd4_vld^src_cmd4_rdy^bpt2arb_cmd4_valid^bpt2arb_cmd4_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_17x (nvdla_core_clk, `ASSERT_RESET, (bpt2arb_cmd4_valid && !bpt2arb_cmd4_ready), (bpt2arb_cmd4_valid), (bpt2arb_cmd4_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_pipe_p5


// when use wr_count, should be care full that no -rd_reg and -wr_reg should be used, as -wr_count does not count in the entry in wr|rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dfifo_wr -rd_pipebus dfifo_rd -d 4 -wr_count -rand_none -w 514 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_count
    , dfifo_wr_prdy
    , dfifo_wr_pvld
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output [2:0] dfifo_wr_count;
output        dfifo_wr_prdy;
input         dfifo_wr_pvld;
input  [513:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [513:0] dfifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        dfifo_wr_busy_int;		        	// copy for internal use
assign     dfifo_wr_prdy = !dfifo_wr_busy_int;
assign       wr_reserving = dfifo_wr_pvld && !dfifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] dfifo_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? dfifo_wr_count : (dfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (dfifo_wr_count + 1'd1) : dfifo_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dfifo_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check dfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_busy_int <=  1'b0;
        dfifo_wr_count <=  3'd0;
    end else begin
	dfifo_wr_busy_int <=  dfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dfifo_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dfifo_wr_pvld

//
// RAM
//

reg  [1:0] dfifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dfifo_wr_adr <=  dfifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484


reg [1:0] dfifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [513:0] dfifo_rd_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dfifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dfifo_wr_adr )
    , .ra        ( dfifo_rd_adr )
    , .dout        ( dfifo_rd_pd )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [1:0] rd_adr_next_popping = dfifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    dfifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dfifo_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        dfifo_rd_pvld; 		// data out of fifo is valid

reg        dfifo_rd_pvld_int;			// internal copy of dfifo_rd_pvld
assign     rd_popping = dfifo_rd_pvld_int && dfifo_rd_prdy;

reg  [2:0] dfifo_rd_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? dfifo_rd_count : 
                                                                (dfifo_rd_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (dfifo_rd_count + 1'd1) : 
                                                                    dfifo_rd_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
wire rd_count_next_rd_popping_not_0 = rd_count_next_rd_popping != 0;
wire rd_count_next_no_rd_popping_not_0 = rd_count_next_no_rd_popping != 0;
wire rd_count_next_not_0 = rd_popping ? rd_count_next_rd_popping_not_0 :
                                              rd_count_next_no_rd_popping_not_0;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_count <=  3'd0;
        dfifo_rd_pvld <=  1'b0;
        dfifo_rd_pvld_int <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_pvld   <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_pvld   <=  `x_or_0;
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_pvld_int <=   (rd_count_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on

    end
end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dfifo_wr_pvld && !dfifo_wr_busy_int) || (dfifo_wr_busy_int != dfifo_wr_busy_next)) || (rd_pushing || rd_popping || (dfifo_rd_pvld && dfifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, dfifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [513:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [513:0] dout;

NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));


`ifdef EMU


// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [513:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout )
   );

`else

reg [513:0] ram_ff0;
reg [513:0] ram_ff1;
reg [513:0] ram_ff2;
reg [513:0] ram_ff3;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [513:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = ram_ff3;
    //VCS coverage off
    default:    dout = {514{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [513:0] Di0;
input  [1:0] Ra0;
output [513:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 514'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [513:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [513:0] Q0 = mem[0];
wire [513:0] Q1 = mem[1];
wire [513:0] Q2 = mem[2];
wire [513:0] Q3 = mem[3];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514] }
endmodule // vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514

//vmw: Memory vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514
//vmw: Address-size 2
//vmw: Data-size 514
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[513:0] data0[513:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[513:0] data1[513:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_MCIF_WRITE_IG_ARB_dfifo_flopram_rwsa_4x514
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

