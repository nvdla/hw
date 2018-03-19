// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_dma_mux.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_dma_mux (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dc_dat2mcif_rd_req_valid
  ,dc_dat2mcif_rd_req_ready
  ,dc_dat2mcif_rd_req_pd
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,dc_dat2cvif_rd_req_valid
  ,dc_dat2cvif_rd_req_ready
  ,dc_dat2cvif_rd_req_pd
  #ifdef NVDLA_WINOGRAD_ENABLE
  ,wg_dat2cvif_rd_req_valid
  ,wg_dat2cvif_rd_req_ready
  ,wg_dat2cvif_rd_req_pd
  ,cvif2wg_dat_rd_rsp_valid
  ,cvif2wg_dat_rd_rsp_ready
  ,cvif2wg_dat_rd_rsp_pd
  #endif
  ,img_dat2cvif_rd_req_valid
  ,img_dat2cvif_rd_req_ready
  ,img_dat2cvif_rd_req_pd
  ,cdma_dat2cvif_rd_req_valid
  ,cdma_dat2cvif_rd_req_ready
  ,cdma_dat2cvif_rd_req_pd
  ,cvif2cdma_dat_rd_rsp_valid
  ,cvif2cdma_dat_rd_rsp_ready
  ,cvif2cdma_dat_rd_rsp_pd
  ,cvif2dc_dat_rd_rsp_valid
  ,cvif2dc_dat_rd_rsp_ready
  ,cvif2dc_dat_rd_rsp_pd
  ,cvif2img_dat_rd_rsp_valid
  ,cvif2img_dat_rd_rsp_ready
  ,cvif2img_dat_rd_rsp_pd
#endif

#ifdef NVDLA_WINOGRAD_ENABLE
  ,wg_dat2mcif_rd_req_valid
  ,wg_dat2mcif_rd_req_ready
  ,wg_dat2mcif_rd_req_pd
  ,mcif2wg_dat_rd_rsp_valid
  ,mcif2wg_dat_rd_rsp_ready
  ,mcif2wg_dat_rd_rsp_pd
#endif
  ,img_dat2mcif_rd_req_valid
  ,img_dat2mcif_rd_req_ready
  ,img_dat2mcif_rd_req_pd
  ,cdma_dat2mcif_rd_req_valid
  ,cdma_dat2mcif_rd_req_ready
  ,cdma_dat2mcif_rd_req_pd
  ,mcif2cdma_dat_rd_rsp_valid
  ,mcif2cdma_dat_rd_rsp_ready
  ,mcif2cdma_dat_rd_rsp_pd
  ,mcif2dc_dat_rd_rsp_valid
  ,mcif2dc_dat_rd_rsp_ready
  ,mcif2dc_dat_rd_rsp_pd
  ,mcif2img_dat_rd_rsp_valid
  ,mcif2img_dat_rd_rsp_ready
  ,mcif2img_dat_rd_rsp_pd
  );
////////////////////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    input          dc_dat2cvif_rd_req_valid;  /* data valid */
    output         dc_dat2cvif_rd_req_ready;  /* data return handshake */
    input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  dc_dat2cvif_rd_req_pd;
    output         cvif2dc_dat_rd_rsp_valid;  /* data valid */
    input          cvif2dc_dat_rd_rsp_ready;  /* data return handshake */
    output [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2dc_dat_rd_rsp_pd;
    
    #ifdef NVDLA_WINOGRAD_ENABLE
    input          wg_dat2cvif_rd_req_valid;  /* data valid */
    output         wg_dat2cvif_rd_req_ready;  /* data return handshake */
    input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  wg_dat2cvif_rd_req_pd;
    output         cvif2wg_dat_rd_rsp_valid;  /* data valid */
    input          cvif2wg_dat_rd_rsp_ready;  /* data return handshake */
    output [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2wg_dat_rd_rsp_pd;
    #endif
    
    input          img_dat2cvif_rd_req_valid;  /* data valid */
    output         img_dat2cvif_rd_req_ready;  /* data return handshake */
    input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  img_dat2cvif_rd_req_pd;
    output         cvif2img_dat_rd_rsp_valid;  /* data valid */
    input          cvif2img_dat_rd_rsp_ready;  /* data return handshake */
    output [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2img_dat_rd_rsp_pd;

    output         cdma_dat2cvif_rd_req_valid;  /* data valid */
    input          cdma_dat2cvif_rd_req_ready;  /* data return handshake */
    output [NVDLA_CDMA_MEM_RD_REQ-1:0]  cdma_dat2cvif_rd_req_pd;
    input          cvif2cdma_dat_rd_rsp_valid;  /* data valid */
    output         cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
    input  [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2cdma_dat_rd_rsp_pd;

#endif

#ifdef NVDLA_WINOGRAD_ENABLE
input          wg_dat2mcif_rd_req_valid;  /* data valid */
output         wg_dat2mcif_rd_req_ready;  /* data return handshake */
input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  wg_dat2mcif_rd_req_pd;
output         mcif2wg_dat_rd_rsp_valid;  /* data valid */
input          mcif2wg_dat_rd_rsp_ready;  /* data return handshake */
output [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2wg_dat_rd_rsp_pd;
#endif

input          dc_dat2mcif_rd_req_valid;  /* data valid */
output         dc_dat2mcif_rd_req_ready;  /* data return handshake */
input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  dc_dat2mcif_rd_req_pd;
output         mcif2dc_dat_rd_rsp_valid;  /* data valid */
input          mcif2dc_dat_rd_rsp_ready;  /* data return handshake */
output [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2dc_dat_rd_rsp_pd;

input          img_dat2mcif_rd_req_valid;  /* data valid */
output         img_dat2mcif_rd_req_ready;  /* data return handshake */
input  [NVDLA_CDMA_MEM_RD_REQ-1:0]  img_dat2mcif_rd_req_pd;
output         mcif2img_dat_rd_rsp_valid;  /* data valid */
input          mcif2img_dat_rd_rsp_ready;  /* data return handshake */
output [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2img_dat_rd_rsp_pd;

output         cdma_dat2mcif_rd_req_valid;  /* data valid */
input          cdma_dat2mcif_rd_req_ready;  /* data return handshake */
output [NVDLA_CDMA_MEM_RD_REQ-1:0]  cdma_dat2mcif_rd_req_pd;
input          mcif2cdma_dat_rd_rsp_valid;  /* data valid */
output         mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
input  [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2cdma_dat_rd_rsp_pd;
////////////////////////////////////////////////////////////////////
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire    [NVDLA_CDMA_MEM_RD_REQ-1:0] cdma_dat2cvif_rd_req_pd;
wire           cdma_dat2cvif_rd_req_valid;
wire           cv_sel_dc_w;
wire           cv_sel_img_w;
wire           cvif2cdma_dat_rd_rsp_ready;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2dc_dat_rd_rsp_pd;
wire           cvif2dc_dat_rd_rsp_valid;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2img_dat_rd_rsp_pd;
wire           cvif2img_dat_rd_rsp_valid;
wire           dc_dat2cvif_rd_req_ready;
wire           img_dat2cvif_rd_req_ready;
wire    [NVDLA_CDMA_MEM_RD_REQ-1:0] req_cv_in_pd;
wire           req_cv_in_pvld;
wire           req_cv_out_prdy;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] rsp_cv_in_pd;
wire           rsp_cv_in_pvld;
wire           rsp_cv_out_prdy;
    #ifdef NVDLA_WINOGRAD_ENABLE
    wire           cv_sel_wg_w;
    wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2wg_dat_rd_rsp_pd;
    wire           cvif2wg_dat_rd_rsp_valid;
    wire           wg_dat2cvif_rd_req_ready;
    reg            cv_sel_wg;
    #endif
reg            cv_sel_dc;
reg            cv_sel_img;
#endif

wire    [NVDLA_CDMA_MEM_RD_REQ-1:0] cdma_dat2mcif_rd_req_pd;
wire           cdma_dat2mcif_rd_req_valid;
wire           dc_dat2mcif_rd_req_ready;
wire           img_dat2mcif_rd_req_ready;
wire           mc_sel_dc_w;
wire           mc_sel_img_w;
wire           mcif2cdma_dat_rd_rsp_ready;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2dc_dat_rd_rsp_pd;
wire           mcif2dc_dat_rd_rsp_valid;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2img_dat_rd_rsp_pd;
wire           mcif2img_dat_rd_rsp_valid;
wire    [NVDLA_CDMA_MEM_RD_REQ-1:0] req_mc_in_pd;
wire           req_mc_in_pvld;
wire           req_mc_out_prdy;
wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] rsp_mc_in_pd;
wire           rsp_mc_in_pvld;
wire           rsp_mc_out_prdy;
#ifdef NVDLA_WINOGRAD_ENABLE
    wire           mc_sel_wg_w;
    wire   [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2wg_dat_rd_rsp_pd;
    wire           mcif2wg_dat_rd_rsp_valid;
    wire           wg_dat2mcif_rd_req_ready;
    reg            mc_sel_wg;
#endif
reg            mc_sel_dc;
reg            mc_sel_img;

////////////////////////////////////////////////////////////////////////
// Data request channel                                               //
////////////////////////////////////////////////////////////////////////
//////////////// MCIF interface ////////////////
assign mc_sel_dc_w = dc_dat2mcif_rd_req_valid;
#ifdef NVDLA_WINOGRAD_ENABLE
assign mc_sel_wg_w = wg_dat2mcif_rd_req_valid;
#endif
assign mc_sel_img_w = img_dat2mcif_rd_req_valid;

assign req_mc_in_pvld = dc_dat2mcif_rd_req_valid |
#ifdef NVDLA_WINOGRAD_ENABLE
                        wg_dat2mcif_rd_req_valid |
#endif
                        img_dat2mcif_rd_req_valid;

assign req_mc_in_pd = ({NVDLA_CDMA_MEM_RD_REQ {mc_sel_dc_w}}  & dc_dat2mcif_rd_req_pd) |
#ifdef NVDLA_WINOGRAD_ENABLE
                      ({NVDLA_CDMA_MEM_RD_REQ {mc_sel_wg_w}}  & wg_dat2mcif_rd_req_pd) |
#endif
                      ({NVDLA_CDMA_MEM_RD_REQ {mc_sel_img_w}} & img_dat2mcif_rd_req_pd);

//: my $k = NVDLA_CDMA_MEM_RD_REQ;
//: &eperl::pipe("-is -wid ${k} -do req_mc_out_pd -vo req_mc_out_pvld -ri req_mc_out_prdy -di req_mc_in_pd -vi req_mc_in_pvld -ro req_mc_in_prdy");

assign dc_dat2mcif_rd_req_ready  = req_mc_in_prdy & dc_dat2mcif_rd_req_valid;
#ifdef NVDLA_WINOGRAD_ENABLE
assign wg_dat2mcif_rd_req_ready  = req_mc_in_prdy & wg_dat2mcif_rd_req_valid;
#endif
assign img_dat2mcif_rd_req_ready = req_mc_in_prdy & img_dat2mcif_rd_req_valid;

assign cdma_dat2mcif_rd_req_valid = req_mc_out_pvld;
assign cdma_dat2mcif_rd_req_pd = req_mc_out_pd;
assign req_mc_out_prdy = cdma_dat2mcif_rd_req_ready;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_mc_in_pvld & req_mc_in_prdy\" -d \"mc_sel_dc_w\" -q mc_sel_dc");
#ifdef NVDLA_WINOGRAD_ENABLE
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_mc_in_pvld & req_mc_in_prdy\" -d \"mc_sel_wg_w\" -q mc_sel_wg");
#endif
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_mc_in_pvld & req_mc_in_prdy\" -d \"mc_sel_img_w\" -q mc_sel_img");

//////////////// CVIF interface ////////////////
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_sel_dc_w = dc_dat2cvif_rd_req_valid;
#ifdef NVDLA_WINOGRAD_ENABLE
assign cv_sel_wg_w = wg_dat2cvif_rd_req_valid;
#endif
assign cv_sel_img_w = img_dat2cvif_rd_req_valid;

assign req_cv_in_pvld = dc_dat2cvif_rd_req_valid |
#ifdef NVDLA_WINOGRAD_ENABLE
                        wg_dat2cvif_rd_req_valid |
#endif
                        img_dat2cvif_rd_req_valid;

assign req_cv_in_pd = ({NVDLA_CDMA_MEM_RD_REQ {cv_sel_dc_w}}  & dc_dat2cvif_rd_req_pd) |
#ifdef NVDLA_WINOGRAD_ENABLE
                      ({NVDLA_CDMA_MEM_RD_REQ {cv_sel_wg_w}}  & wg_dat2cvif_rd_req_pd) |
#endif
                      ({NVDLA_CDMA_MEM_RD_REQ {cv_sel_img_w}} & img_dat2cvif_rd_req_pd);
//: my $k = NVDLA_CDMA_MEM_RD_REQ;
//: &eperl::pipe("-is -wid $k -do req_cv_out_pd -vo req_cv_out_pvld -ri req_cv_out_prdy -di req_cv_in_pd -vi req_cv_in_pvld -ro req_cv_in_prdy");

assign dc_dat2cvif_rd_req_ready  = req_cv_in_prdy & dc_dat2cvif_rd_req_valid;
#ifdef NVDLA_WINOGRAD_ENABLE
assign wg_dat2cvif_rd_req_ready  = req_cv_in_prdy & wg_dat2cvif_rd_req_valid;
#endif
assign img_dat2cvif_rd_req_ready = req_cv_in_prdy & img_dat2cvif_rd_req_valid;

assign cdma_dat2cvif_rd_req_valid = req_cv_out_pvld;
assign cdma_dat2cvif_rd_req_pd = req_cv_out_pd;
assign req_cv_out_prdy = cdma_dat2cvif_rd_req_ready;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_cv_in_pvld & req_cv_in_prdy\" -d \"cv_sel_dc_w\" -q cv_sel_dc");
#ifdef NVDLA_WINOGRAD_ENABLE
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_cv_in_pvld & req_cv_in_prdy\" -d \"cv_sel_wg_w\" -q cv_sel_wg");
#endif
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"req_cv_in_pvld & req_cv_in_prdy\" -d \"cv_sel_img_w\" -q cv_sel_img");

//////////////// assertion ////////////////

#endif
////////////////////////////////////////////////////////////////////////
// Data response channel                                              //
////////////////////////////////////////////////////////////////////////
//////////////// MCIF interface ////////////////
assign rsp_mc_in_pvld = mcif2cdma_dat_rd_rsp_valid;
assign rsp_mc_in_pd = mcif2cdma_dat_rd_rsp_pd;
//: my $k = NVDLA_CDMA_MEM_RD_RSP;
//: &eperl::pipe("-is -wid $k -do rsp_mc_out_pd -vo rsp_mc_out_pvld -ri rsp_mc_out_prdy -di rsp_mc_in_pd -vi rsp_mc_in_pvld -ro rsp_mc_in_prdy");
assign mcif2cdma_dat_rd_rsp_ready = rsp_mc_in_prdy;

assign mcif2dc_dat_rd_rsp_valid  = rsp_mc_out_pvld & mc_sel_dc;
#ifdef NVDLA_WINOGRAD_ENABLE
assign mcif2wg_dat_rd_rsp_valid  = rsp_mc_out_pvld & mc_sel_wg;
#endif
assign mcif2img_dat_rd_rsp_valid = rsp_mc_out_pvld & mc_sel_img;

assign mcif2dc_dat_rd_rsp_pd   = {NVDLA_CDMA_MEM_RD_RSP {mc_sel_dc}} & rsp_mc_out_pd;
#ifdef NVDLA_WINOGRAD_ENABLE
assign mcif2wg_dat_rd_rsp_pd   = {NVDLA_CDMA_MEM_RD_RSP {mc_sel_wg}} & rsp_mc_out_pd;
#endif
assign mcif2img_dat_rd_rsp_pd  = {NVDLA_CDMA_MEM_RD_RSP {mc_sel_img}} & rsp_mc_out_pd;

assign rsp_mc_out_prdy = (mc_sel_dc & mcif2dc_dat_rd_rsp_ready) |
#ifdef NVDLA_WINOGRAD_ENABLE
                         (mc_sel_wg & mcif2wg_dat_rd_rsp_ready) |
#endif
                         (mc_sel_img & mcif2img_dat_rd_rsp_ready);

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//////////////// CVIF interface ////////////////
//: my $k = NVDLA_CDMA_MEM_RD_RSP;
//: &eperl::pipe("-is -wid $k -do rsp_cv_out_pd -vo rsp_cv_out_pvld -ri rsp_cv_out_prdy -di rsp_cv_in_pd -vi rsp_cv_in_pvld -ro rsp_cv_in_prdy");

assign rsp_cv_in_pvld = cvif2cdma_dat_rd_rsp_valid;
assign rsp_cv_in_pd = cvif2cdma_dat_rd_rsp_pd;
assign cvif2cdma_dat_rd_rsp_ready = rsp_cv_in_prdy;

assign cvif2dc_dat_rd_rsp_valid  = rsp_cv_out_pvld & cv_sel_dc;
#ifdef NVDLA_WINOGRAD_ENABLE
assign cvif2wg_dat_rd_rsp_valid  = rsp_cv_out_pvld & cv_sel_wg;
#endif
assign cvif2img_dat_rd_rsp_valid = rsp_cv_out_pvld & cv_sel_img;

assign cvif2dc_dat_rd_rsp_pd   = {NVDLA_CDMA_MEM_RD_RSP {cv_sel_dc}} & rsp_cv_out_pd;
#ifdef NVDLA_WINOGRAD_ENABLE
assign cvif2wg_dat_rd_rsp_pd   = {NVDLA_CDMA_MEM_RD_RSP {cv_sel_wg}} & rsp_cv_out_pd;
#endif
assign cvif2img_dat_rd_rsp_pd  = {NVDLA_CDMA_MEM_RD_RSP {cv_sel_img}} & rsp_cv_out_pd;

assign rsp_cv_out_prdy = (cv_sel_dc & cvif2dc_dat_rd_rsp_ready) |
#ifdef NVDLA_WINOGRAD_ENABLE
                         (cv_sel_wg & cvif2wg_dat_rd_rsp_ready) |
#endif
                         (cv_sel_img & cvif2img_dat_rd_rsp_ready);
#endif

////////////////////////////////////////////////////////////////////////
//  Assertion                                                         //
////////////////////////////////////////////////////////////////////////
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

  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (req_mc_out_pvld^req_mc_out_prdy^req_mc_in_pvld^req_mc_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_mc_in_pvld & req_mc_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_mc_in_pvld & req_mc_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_mc_in_pvld & req_mc_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (req_cv_out_pvld^req_cv_out_prdy^req_cv_in_pvld^req_cv_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_cv_in_pvld & req_cv_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_cv_in_pvld & req_cv_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(req_cv_in_pvld & req_cv_in_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (rsp_mc_out_pvld^rsp_mc_out_prdy^rsp_mc_in_pvld^rsp_mc_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (rsp_cv_out_pvld^rsp_cv_out_prdy^rsp_cv_in_pvld^rsp_cv_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 

    #ifdef NVDLA_WINOGRAD_ENABLE
  nv_assert_zero_one_hot #(0,2,0,"Error! MCIF req conflict!")      zzz_assert_zero_one_hot_11x (nvdla_core_clk, `ASSERT_RESET, {dc_dat2mcif_rd_req_valid, img_dat2mcif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,2,0,"Error! MCIF sel conflict!")      zzz_assert_zero_one_hot_16x (nvdla_core_clk, `ASSERT_RESET, {mc_sel_dc, mc_sel_img}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Change mcif source!")      zzz_assert_never_25x (nvdla_core_clk, `ASSERT_RESET, (mcif2cdma_dat_rd_rsp_valid & (|{mc_sel_dc_w, mc_sel_img_w}) & ({mc_sel_dc_w, mc_sel_img_w} != {mc_sel_dc, mc_sel_img}))); // spyglass disable W504 SelfDeterminedExpr-ML 
    #endif
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (req_mc_in_pvld && !req_mc_in_prdy), (req_mc_in_pvld), (req_mc_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_7x (nvdla_core_clk, `ASSERT_RESET, (req_cv_in_pvld && !req_cv_in_prdy), (req_cv_in_pvld), (req_cv_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_19x (nvdla_core_clk, `ASSERT_RESET, (rsp_mc_in_pvld && !rsp_mc_in_prdy), (rsp_mc_in_pvld), (rsp_mc_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,2,0,"Error! DMA resp conflict!")      zzz_assert_zero_one_hot_22x (nvdla_core_clk, `ASSERT_RESET, {mcif2cdma_dat_rd_rsp_valid, cvif2cdma_dat_rd_rsp_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 

  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    #ifdef NVDLA_WINOGRAD_ENABLE
  nv_assert_zero_one_hot #(0,3,0,"Error! CVIF req conflict!")      zzz_assert_zero_one_hot_12x (nvdla_core_clk, `ASSERT_RESET, {dc_dat2cvif_rd_req_valid, wg_dat2cvif_rd_req_valid, img_dat2cvif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,2,0,"Error! WG req conflict!")      zzz_assert_zero_one_hot_14x (nvdla_core_clk, `ASSERT_RESET, {wg_dat2mcif_rd_req_valid, wg_dat2cvif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Error! CVIF sel conflict!")      zzz_assert_zero_one_hot_17x (nvdla_core_clk, `ASSERT_RESET, {cv_sel_dc, cv_sel_wg, cv_sel_img}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Change cvif source!")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (cvif2cdma_dat_rd_rsp_valid & (|{mc_sel_dc_w, mc_sel_wg_w, mc_sel_img_w}) & ({cv_sel_dc_w, cv_sel_wg_w, cv_sel_img_w} != {cv_sel_dc, cv_sel_wg, cv_sel_img}))); // spyglass disable W504 SelfDeterminedExpr-ML 
    #else
  nv_assert_zero_one_hot #(0,2,0,"Error! CVIF req conflict!")      zzz_assert_zero_one_hot_12x (nvdla_core_clk, `ASSERT_RESET, {dc_dat2cvif_rd_req_valid, img_dat2cvif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,2,0,"Error! CVIF sel conflict!")      zzz_assert_zero_one_hot_17x (nvdla_core_clk, `ASSERT_RESET, {cv_sel_dc, cv_sel_img}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Change cvif source!")      zzz_assert_never_26x (nvdla_core_clk, `ASSERT_RESET, (cvif2cdma_dat_rd_rsp_valid & (|{mc_sel_dc_w, mc_sel_img_w}) & ({cv_sel_dc_w, cv_sel_img_w} != {cv_sel_dc, cv_sel_img}))); // spyglass disable W504 SelfDeterminedExpr-ML 
    #endif
  nv_assert_zero_one_hot #(0,2,0,"Error! DC req conflict!")      zzz_assert_zero_one_hot_13x (nvdla_core_clk, `ASSERT_RESET, {dc_dat2mcif_rd_req_valid, dc_dat2cvif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,2,0,"Error! IMG req conflict!")      zzz_assert_zero_one_hot_15x (nvdla_core_clk, `ASSERT_RESET, {img_dat2mcif_rd_req_valid, img_dat2cvif_rd_req_valid}); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_21x (nvdla_core_clk, `ASSERT_RESET, (rsp_cv_in_pvld && !rsp_cv_in_prdy), (rsp_cv_in_pvld), (rsp_cv_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Change dma from mcif to cvif!")      zzz_assert_never_23x (nvdla_core_clk, `ASSERT_RESET, (cdma_dat2cvif_rd_req_valid & mcif2cdma_dat_rd_rsp_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! Change dma from cvif to mcif!")      zzz_assert_never_24x (nvdla_core_clk, `ASSERT_RESET, (cdma_dat2mcif_rd_req_valid & cvif2cdma_dat_rd_rsp_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif

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

endmodule // NV_NVDLA_CDMA_dma_mux


