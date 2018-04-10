// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_status.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_status (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dc2status_dat_entries
  ,dc2status_dat_slices
  ,dc2status_dat_updt
  ,dc2status_state
  ,dp2reg_consumer
  ,img2status_dat_entries
  ,img2status_dat_slices
  ,img2status_dat_updt
  ,img2status_state
  ,reg2dp_data_bank
  ,reg2dp_op_en
  ,sc2cdma_dat_entries
  ,sc2cdma_dat_pending_req
  ,sc2cdma_dat_slices
  ,sc2cdma_dat_updt
#ifdef NVDLA_WINOGRAD_ENABLE
  ,wg2status_dat_entries
  ,wg2status_dat_slices
  ,wg2status_dat_updt
  ,wg2status_state
#endif
  ,wt2status_state
  ,cdma2sc_dat_entries
  ,cdma2sc_dat_pending_ack
  ,cdma2sc_dat_slices
  ,cdma2sc_dat_updt
  ,cdma_dat2glb_done_intr_pd
  ,cdma_wt2glb_done_intr_pd
  ,dp2reg_done
  ,status2dma_free_entries
  ,status2dma_fsm_switch
  ,status2dma_valid_slices
  ,status2dma_wr_idx
  );
/////////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

input        dc2status_dat_updt;
input [14:0] dc2status_dat_entries;
input [13:0] dc2status_dat_slices;

#ifdef NVDLA_WINOGRAD_ENABLE
input        wg2status_dat_updt; 
input [14:0] wg2status_dat_entries;
input [13:0] wg2status_dat_slices;
#endif

input        img2status_dat_updt; 
input [14:0] img2status_dat_entries;
input [13:0] img2status_dat_slices;

input        sc2cdma_dat_updt;
input [14:0] sc2cdma_dat_entries;
input [13:0] sc2cdma_dat_slices;

output        cdma2sc_dat_updt;
output [14:0] cdma2sc_dat_entries;
output [13:0] cdma2sc_dat_slices;

output [13:0] status2dma_valid_slices;
output [14:0] status2dma_free_entries;
output [14:0] status2dma_wr_idx;

input [1:0] dc2status_state;
#ifdef NVDLA_WINOGRAD_ENABLE
input [1:0] wg2status_state;
#endif
input [1:0] img2status_state;
input [1:0] wt2status_state;

output  dp2reg_done;

output  status2dma_fsm_switch;

output [1:0] cdma_wt2glb_done_intr_pd;
output [1:0] cdma_dat2glb_done_intr_pd;

input  sc2cdma_dat_pending_req;
output  cdma2sc_dat_pending_ack;

input [0:0]                     reg2dp_op_en;
input [4:0]                      reg2dp_data_bank;
/////////////////////////////////////////////////////////

reg           dat2status_done_d1;
reg     [1:0] dat_done_intr;
reg    [14:0] dat_entries_d1;
reg    [14:0] dat_entries_d2;
reg    [14:0] dat_entries_d3;
reg    [14:0] dat_entries_d4;
reg    [14:0] dat_entries_d5;
reg    [14:0] dat_entries_d6;
reg    [14:0] dat_entries_d7;
reg    [14:0] dat_entries_d8;
reg    [14:0] dat_entries_d9;
reg    [13:0] dat_slices_d1;
reg    [13:0] dat_slices_d2;
reg    [13:0] dat_slices_d3;
reg    [13:0] dat_slices_d4;
reg    [13:0] dat_slices_d5;
reg    [13:0] dat_slices_d6;
reg    [13:0] dat_slices_d7;
reg    [13:0] dat_slices_d8;
reg    [13:0] dat_slices_d9;
reg           dat_updt_d1;
reg           dat_updt_d2;
reg           dat_updt_d3;
reg           dat_updt_d4;
reg           dat_updt_d5;
reg           dat_updt_d6;
reg           dat_updt_d7;
reg           dat_updt_d8;
reg           dat_updt_d9;
reg           layer_end;
reg           pending_ack;
reg           pending_req;
reg     [5:0] real_bank;
reg    [14:0] status2dma_free_entries;
reg           status2dma_fsm_switch;
reg    [14:0] status2dma_valid_entries;
reg    [13:0] status2dma_valid_slices;
reg    [14:0] status2dma_wr_idx;
reg           wt2status_done_d1;
reg     [1:0] wt_done_intr;
wire          dat2status_done;
wire    [1:0] dat_done_intr_w;
wire   [14:0] dat_entries_d0;
wire   [13:0] dat_slices_d0;
wire          dat_updt_d0;
wire          dc2status_done;
wire          dc2status_pend;
wire   [14:0] entries_add;
wire          entries_reg_en;
wire   [14:0] entries_sub;
wire          img2status_done;
wire          img2status_pend;
wire          layer_end_w;
wire          mon_status2dma_free_entries_w;
wire          mon_status2dma_valid_entries_w;
wire          mon_status2dma_valid_slices_w;
wire          mon_status2dma_wr_idx_inc_wrap;
wire          pending_ack_w;
wire          real_bank_reg_en;
wire    [5:0] real_bank_w;
wire   [13:0] slices_add;
wire   [13:0] slices_sub;
wire   [14:0] status2dma_free_entries_w;
wire          status2dma_fsm_switch_w;
wire   [14:0] status2dma_valid_entries_w;
wire   [13:0] status2dma_valid_slices_w;
wire   [15:0] status2dma_wr_idx_inc;
wire   [14:0] status2dma_wr_idx_inc_wrap;
wire          status2dma_wr_idx_overflow;
wire   [14:0] status2dma_wr_idx_w;
wire          update_all;
wire          update_dma;
#ifdef NVDLA_WINOGRAD_ENABLE
wire          wg2status_done;
wire          wg2status_pend;
#endif
wire          wt2status_done;
wire    [1:0] wt_done_intr_w;
input dp2reg_consumer;

////////////////////////////////////////////////////////////////////////
//  control CDMA working status                                       //
////////////////////////////////////////////////////////////////////////
assign wt2status_done = (wt2status_state == 3 );
assign dc2status_done = (dc2status_state == 3 );
assign dc2status_pend = (dc2status_state == 1 );
#ifdef NVDLA_WINOGRAD_ENABLE
assign wg2status_done = (wg2status_state == 3 );
assign wg2status_pend = (wg2status_state == 1 );
#endif
assign img2status_done = (img2status_state == 3 );
assign img2status_pend = (img2status_state == 1 );

#ifdef NVDLA_WINOGRAD_ENABLE
assign dat2status_done = (dc2status_done | wg2status_done | img2status_done);
#else
assign dat2status_done = (dc2status_done | img2status_done);
#endif
assign status2dma_fsm_switch_w = reg2dp_op_en & ~status2dma_fsm_switch & wt2status_done & dat2status_done;

assign wt_done_intr_w[0] = reg2dp_op_en & ~dp2reg_consumer & ~wt2status_done_d1 & wt2status_done;
assign wt_done_intr_w[1] = reg2dp_op_en & dp2reg_consumer & ~wt2status_done_d1 & wt2status_done;

assign dat_done_intr_w[0] = reg2dp_op_en & ~dp2reg_consumer & ~dat2status_done_d1 & dat2status_done;
assign dat_done_intr_w[1] = reg2dp_op_en & dp2reg_consumer & ~dat2status_done_d1 & dat2status_done;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"status2dma_fsm_switch_w\" -q status2dma_fsm_switch");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"reg2dp_op_en & wt2status_done\" -q wt2status_done_d1");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"reg2dp_op_en & dat2status_done\" -q dat2status_done_d1");
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"   -d \"wt_done_intr_w\" -q wt_done_intr");
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"   -d \"dat_done_intr_w\" -q dat_done_intr");

assign dp2reg_done = status2dma_fsm_switch;
assign cdma_wt2glb_done_intr_pd = wt_done_intr;
assign cdma_dat2glb_done_intr_pd = dat_done_intr;

////////////////////////////////////////////////////////////////////////
//  manage data bank status                                           //
////////////////////////////////////////////////////////////////////////

assign layer_end_w = status2dma_fsm_switch ? 1'b1 :
                     reg2dp_op_en ? 1'b0 :
                     layer_end;
assign real_bank_w = reg2dp_data_bank + 1'b1;
assign real_bank_reg_en = reg2dp_op_en && (real_bank_w != real_bank);
#ifdef NVDLA_WINOGRAD_ENABLE
assign pending_ack_w = (reg2dp_op_en & (dc2status_pend | wg2status_pend | img2status_pend));
assign update_dma = dc2status_dat_updt | wg2status_dat_updt | img2status_dat_updt;
#else
assign pending_ack_w = (reg2dp_op_en & (dc2status_pend | img2status_pend));
assign update_dma = dc2status_dat_updt | img2status_dat_updt;
#endif
assign update_all = update_dma | sc2cdma_dat_updt | (pending_ack & pending_req);

assign entries_add = ({15{dc2status_dat_updt}} & dc2status_dat_entries) |
#ifdef NVDLA_WINOGRAD_ENABLE
                     ({15{wg2status_dat_updt}} & wg2status_dat_entries) |
#endif
                     ({15{img2status_dat_updt}} & img2status_dat_entries);

assign entries_sub = sc2cdma_dat_updt ? sc2cdma_dat_entries : 15'b0;
assign {mon_status2dma_valid_entries_w,
        status2dma_valid_entries_w} = (pending_ack & pending_req) ? 15'b0 :
                                     status2dma_valid_entries + entries_add - entries_sub;

assign slices_add = ({14{dc2status_dat_updt}} & dc2status_dat_slices) |
#ifdef NVDLA_WINOGRAD_ENABLE
                    ({14{wg2status_dat_updt}} & wg2status_dat_slices) |
#endif
                    ({14{img2status_dat_updt}} & img2status_dat_slices);

assign slices_sub = sc2cdma_dat_updt ? sc2cdma_dat_slices : 14'b0;
assign {mon_status2dma_valid_slices_w,
        status2dma_valid_slices_w} = (pending_ack & pending_req) ?  15'b0 :
                                    status2dma_valid_slices + slices_add - slices_sub;
//: my $bank_depth = NVDLA_CBUF_BANK_DEPTH ;
//: my $bankdep_bw = int( log($bank_depth)/log(2) );
//: print qq(
//:     assign {mon_status2dma_free_entries_w,
//:             status2dma_free_entries_w} = {real_bank, ${bankdep_bw}'b0} - status2dma_valid_entries_w;
//: );
assign entries_reg_en = (status2dma_free_entries_w != status2dma_free_entries);
assign status2dma_wr_idx_inc = status2dma_wr_idx + entries_add;
//: my $bank_depth = NVDLA_CBUF_BANK_DEPTH ;
//: my $bankdep_bw = int( log($bank_depth)/log(2) );
//: print qq( assign {mon_status2dma_wr_idx_inc_wrap,
//:                   status2dma_wr_idx_inc_wrap} = status2dma_wr_idx + entries_add - {real_bank, ${bankdep_bw}'b0};
//:           assign status2dma_wr_idx_overflow = (status2dma_wr_idx_inc >= {1'b0, real_bank, ${bankdep_bw}'b0});
//: );
assign status2dma_wr_idx_w = (pending_ack & pending_req) ? 15'b0 :
                             (~update_dma) ? status2dma_wr_idx :
                             status2dma_wr_idx_overflow ? status2dma_wr_idx_inc_wrap :
                             status2dma_wr_idx_inc[15 -1:0];

//: &eperl::flop("-nodeclare   -rval \"1'b1\"   -d \"layer_end_w\" -q layer_end");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"update_all\" -d \"status2dma_valid_entries_w\" -q status2dma_valid_entries");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"update_all\" -d \"status2dma_valid_slices_w\" -q status2dma_valid_slices");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"entries_reg_en\" -d \"status2dma_free_entries_w\" -q status2dma_free_entries");
//: &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"update_all\" -d \"status2dma_wr_idx_w\" -q status2dma_wr_idx");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"real_bank_reg_en\" -d \"real_bank_w\" -q real_bank");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pending_ack_w\" -q pending_ack");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sc2cdma_dat_pending_req\" -q pending_req");

assign cdma2sc_dat_pending_ack = pending_ack;

//: my $latency = CDMA_STATUS_LATENCY;
//: print "assign dat_updt_d0 = update_dma;\n";
//: print "assign dat_entries_d0 = entries_add;\n";
//: print "assign dat_slices_d0 = slices_add;\n";
//: for(my $i = 0; $i < $latency; $i ++) {
//:     my $j = $i + 1;
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_updt_d${i}\" -q dat_updt_d${j}");
//:     &eperl::flop("-nodeclare   -rval \"{15{1'b0}}\"  -en \"dat_updt_d${i}\" -d \"dat_entries_d${i}\" -q dat_entries_d${j}");
//:     &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"dat_updt_d${i}\" -d \"dat_slices_d${i}\" -q dat_slices_d${j}");
//: }
//: my $k = $latency;
//: print "assign cdma2sc_dat_updt = dat_updt_d${k};\n";
//: print "assign cdma2sc_dat_entries = dat_entries_d${k};\n";
//: print "assign cdma2sc_dat_slices = dat_slices_d${k};\n";


//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property cdma_status__status_base_overflow__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (update_dma & status2dma_wr_idx_overflow);
    endproperty
    // Cover 0 : "(update_dma & status2dma_wr_idx_overflow)"
    FUNCPOINT_cdma_status__status_base_overflow__0_COV : cover property (cdma_status__status_base_overflow__0_cov);

  `endif
`endif
//VCS coverage on


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

  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(update_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(update_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(entries_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(update_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(real_bank_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d6))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d6))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d7))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d7))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_updt_d8))); // spyglass disable W504 SelfDeterminedExpr-ML 

  nv_assert_never #(0,0,"CDMA submodule done when op_en is invalid")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (~reg2dp_op_en & (wt2status_done | dc2status_done | wg2status_done | img2status_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Two of DC, WG and IMG are done")      zzz_assert_zero_one_hot_2x (nvdla_core_clk, `ASSERT_RESET, ({dc2status_done, wg2status_done, img2status_done})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Two of DC, WG and IMG are updating")      zzz_assert_zero_one_hot_26x (nvdla_core_clk, `ASSERT_RESET, ({dc2status_dat_updt, wg2status_dat_updt, img2status_dat_updt})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Two of DC, WG and IMG are done")      zzz_assert_zero_one_hot_27x (nvdla_core_clk, `ASSERT_RESET, ({dc2status_done, wg2status_done, img2status_done})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_zero_one_hot #(0,3,0,"Two of DC, WG and IMG are pend")      zzz_assert_zero_one_hot_28x (nvdla_core_clk, `ASSERT_RESET, ({dc2status_pend, wg2status_pend, img2status_pend})); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"DMA increase when pending")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (pending_ack & update_dma)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error clear")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (sc2cdma_dat_updt & ((sc2cdma_dat_entries == status2dma_valid_entries) ^ (sc2cdma_dat_slices == status2dma_valid_slices)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! status2dma_valid_entries_w is overflow!")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (update_all & mon_status2dma_valid_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! status2dma_valid_entries_w is out of range!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (update_all && (status2dma_valid_entries_w > 16384))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! status2dma_valid_slices_w is overflow!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (update_all & mon_status2dma_valid_slices_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! status2dma_valid_slices_w is out of range!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (update_all && (status2dma_valid_slices_w > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 

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

endmodule // NV_NVDLA_CDMA_status
