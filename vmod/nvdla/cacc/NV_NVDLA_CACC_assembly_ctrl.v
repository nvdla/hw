// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_assembly_ctrl.v

#include "NV_NVDLA_CACC.h"

module NV_NVDLA_CACC_assembly_ctrl (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dp2reg_done
  ,mac_a2accu_pd
  ,mac_a2accu_pvld
  ,mac_b2accu_pd
  ,mac_b2accu_pvld
  ,reg2dp_clip_truncate
  ,reg2dp_conv_mode
  ,reg2dp_op_en
  ,reg2dp_proc_precision
  ,abuf_rd_addr
  ,abuf_rd_en
  ,accu_ctrl_pd
  ,accu_ctrl_ram_valid
  ,accu_ctrl_valid
  ,cfg_in_en_mask
  ,cfg_is_wg
  ,cfg_truncate
  ,slcg_cell_en
  ,wait_for_op_en
  );


input [0:0]                 reg2dp_op_en;
input [0:0]                 reg2dp_conv_mode;
input [1:0]                 reg2dp_proc_precision;
input [4:0]                 reg2dp_clip_truncate;

output[CACC_ABUF_AWIDTH-1:0]abuf_rd_addr;
output                      abuf_rd_en;
input                       nvdla_core_clk;
input                       nvdla_core_rstn;
input                       dp2reg_done;
input    [8:0]              mac_a2accu_pd;
input                       mac_a2accu_pvld;
input    [8:0]              mac_b2accu_pd;   //always equal mac_a2accu_pd
input                       mac_b2accu_pvld;
output   [12:0]             accu_ctrl_pd;
output                      accu_ctrl_ram_valid;
output                      accu_ctrl_valid;
output                      cfg_in_en_mask;
output                      cfg_is_wg;
output   [4:0]              cfg_truncate;
output                      slcg_cell_en;
output                      wait_for_op_en;
// spyglass disable_block NoWidthInBasedNum-ML
// spyglass disable_block STARC-2.10.1.6
// cross partition,1T
//: &eperl::flop("-q  accu_valid  -d \"mac_a2accu_pvld\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 9 -q  accu_pd  -en \"mac_a2accu_pvld\" -d  \"mac_a2accu_pd\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 


//////////////////////////////////////////////////////////////
///// generator input status signal                      /////
//////////////////////////////////////////////////////////////
wire         accu_stripe_st   =     accu_pd[5];
wire         accu_stripe_end  =     accu_pd[6];
wire         accu_channel_end =     accu_pd[7];
wire         accu_layer_end   =     accu_pd[8];

wire    is_int8 = (reg2dp_proc_precision == NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT8);
wire    is_winograd = 1'b0;


// SLCG
wire    slcg_cell_en_w = reg2dp_op_en;
//: &eperl::flop(" -q  slcg_cell_en_d1  -d \"slcg_cell_en_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  slcg_cell_en_d2  -d \"slcg_cell_en_d1\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  slcg_cell_en_d3  -d \"slcg_cell_en_d2\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
wire    slcg_cell_en = slcg_cell_en_d3;


// get layer operation begin
wire    wait_for_op_en_w = dp2reg_done ? 1'b1 : reg2dp_op_en ? 1'b0 : wait_for_op_en;
//: &eperl::flop(" -q  wait_for_op_en  -d \"wait_for_op_en_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 1"); 


// get address and other contrl
reg         cfg_winograd;
reg  [CACC_ABUF_AWIDTH-1:0]   accu_cnt;   
wire [CACC_ABUF_AWIDTH-1:0]   accu_cnt_w;
wire [CACC_ABUF_AWIDTH-1:0]   accu_cnt_inc;
wire mon_accu_cnt_inc;
reg         accu_channel_st;
wire        layer_st                            = wait_for_op_en & reg2dp_op_en;
assign      {mon_accu_cnt_inc, accu_cnt_inc}    = accu_cnt + 1'b1;
assign      accu_cnt_w                          = (layer_st | accu_stripe_end) ? {CACC_ABUF_AWIDTH{1'b0}} :  accu_cnt_inc;
wire [CACC_ABUF_AWIDTH-1:0] accu_addr           = accu_cnt;
wire      accu_channel_st_w                     = layer_st ? 1'b1 : (accu_valid & accu_stripe_end) ? accu_channel_end : accu_channel_st;
wire      accu_rd_en                            = accu_valid & (~accu_channel_st);
wire      cfg_in_en_mask_w  = 1'b1; 
//: &eperl::flop("-q accu_ram_valid -d accu_rd_en");
//: &eperl::flop("-nodeclare -q  accu_cnt  -en \"layer_st | accu_valid\" -d  \"accu_cnt_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare -q  accu_channel_st  -en \"layer_st | accu_valid\" -d  \"accu_channel_st_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 1"); 
wire accu_ctrl_valid_d0   = accu_valid;
wire accu_ram_valid_d0    = accu_ram_valid;
wire [CACC_ABUF_AWIDTH-1:0] accu_addr_d0    = accu_addr;
wire accu_stripe_end_d0   = accu_stripe_end;
wire accu_channel_end_d0  = accu_channel_end;
wire accu_layer_end_d0    = accu_layer_end;
//: &eperl::flop("-nodeclare -q  cfg_winograd  -en \"layer_st\" -d  \"is_winograd\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 5 -q  cfg_truncate  -en \"layer_st\" -d  \"reg2dp_clip_truncate\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  cfg_is_wg  -en \"layer_st\" -d  \"is_winograd\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  cfg_in_en_mask  -en \"layer_st\" -d  \"cfg_in_en_mask_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
wire abuf_rd_en = accu_rd_en;
wire [CACC_ABUF_AWIDTH-1:0] abuf_rd_addr = accu_addr;


// regout
//: my $kk=CACC_ABUF_AWIDTH;
//: &eperl::flop(" -q  accu_ctrl_valid  -d \"accu_ctrl_valid_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  accu_ctrl_ram_valid  -d \"accu_ram_valid_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid ${kk} -q  accu_ctrl_addr  -en \"accu_ctrl_valid_d0\" -d  \"accu_addr_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  accu_ctrl_stripe_end  -en \"accu_ctrl_valid_d0\" -d  \"accu_stripe_end_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  accu_ctrl_channel_end  -en \"accu_ctrl_valid_d0\" -d  \"accu_channel_end_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  accu_ctrl_layer_end  -en \"accu_ctrl_valid_d0\" -d  \"accu_layer_end_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  accu_ctrl_dlv_elem_mask  -en \"accu_ctrl_valid_d0\" -d  \"accu_channel_end_d0\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: my $jj=6-$kk;
//: if ($jj==0) {
//: print "assign       accu_ctrl_pd[5:0]  =     {accu_ctrl_addr}; \n";
//: }
//: elsif ($jj>0) {
//: print "assign       accu_ctrl_pd[5:0]  =     {{${jj}{1'b0}},accu_ctrl_addr}; \n";
//: }

// spyglass enable_block NoWidthInBasedNum-ML
// spyglass enable_block STARC-2.10.1.6

assign       accu_ctrl_pd[8:6]  =     3'b1;   //reserve
assign       accu_ctrl_pd[9]    =     accu_ctrl_stripe_end ;
assign       accu_ctrl_pd[10]   =     accu_ctrl_channel_end ;
assign       accu_ctrl_pd[11]   =     accu_ctrl_layer_end ;
assign       accu_ctrl_pd[12]   =     accu_ctrl_dlv_elem_mask;


endmodule
