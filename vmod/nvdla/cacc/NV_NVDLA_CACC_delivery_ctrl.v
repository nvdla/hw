// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_delivery_ctrl.v

#include "NV_NVDLA_CACC.h"

module NV_NVDLA_CACC_delivery_ctrl (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2sdp_ready
  ,cacc2sdp_valid
  ,dbuf_rd_ready
  ,dlv_data
  ,dlv_mask
  ,dlv_pd
  ,dlv_valid
  ,reg2dp_batches
  ,reg2dp_conv_mode
  ,reg2dp_dataout_addr
  ,reg2dp_dataout_channel
  ,reg2dp_dataout_height
  ,reg2dp_dataout_width
  ,reg2dp_line_packed
  ,reg2dp_line_stride
  ,reg2dp_op_en
  ,reg2dp_proc_precision
  ,reg2dp_surf_packed
  ,reg2dp_surf_stride
  ,wait_for_op_en
  ,dbuf_rd_addr
  ,dbuf_rd_en
  ,dbuf_rd_layer_end
  ,dbuf_wr_addr
  ,dbuf_wr_data
  ,dbuf_wr_en
  ,dp2reg_done
  );


input [0:0]                 reg2dp_op_en;
input [0:0]                 reg2dp_conv_mode;
input [1:0]                 reg2dp_proc_precision;
input [12:0]                reg2dp_dataout_width;
input [12:0]                reg2dp_dataout_height;
input [12:0]                reg2dp_dataout_channel;
input [31-NVDLA_MEMORY_ATOMIC_LOG2:0]                reg2dp_dataout_addr;
input [0:0]                 reg2dp_line_packed;
input [0:0]                 reg2dp_surf_packed;
input [4:0]                 reg2dp_batches;
input [23:0]                reg2dp_line_stride;
input [23:0]                reg2dp_surf_stride;

input                       nvdla_core_clk;
input                       nvdla_core_rstn;
input                       cacc2sdp_ready;
input                       cacc2sdp_valid;
input                       dbuf_rd_ready;
input[CACC_DBUF_WIDTH-1:0]  dlv_data;
input                       dlv_mask;
input    [1:0]              dlv_pd;
input                       dlv_valid;
input                       wait_for_op_en;
output   [CACC_DBUF_AWIDTH-1:0]              dbuf_rd_addr;
output                      dbuf_rd_en;
output                      dbuf_rd_layer_end;
output   [CACC_DBUF_AWIDTH-1:0]             dbuf_wr_addr;
output   [CACC_DBUF_WIDTH-1:0]              dbuf_wr_data;
output                      dbuf_wr_en;
output                      dp2reg_done;

// spyglass disable_block NoWidthInBasedNum-ML
// spyglass disable_block STARC-2.10.1.6


//////////////////////////////////////////////////////////////
///// parse input status signal                          /////
//////////////////////////////////////////////////////////////
wire         dlv_stripe_end  =     dlv_pd[0];
wire         dlv_layer_end   =     dlv_pd[1];

//////////////////////////////////////////////////////////////
///// register input signal from regfile                 /////
//////////////////////////////////////////////////////////////
wire  [CACC_CHANNEL_BITS-6:0]  cur_channel_w =  {reg2dp_dataout_channel[CACC_CHANNEL_BITS-1:5]} ;
//: my $kk = CACC_CHANNEL_BITS-5;
//: my $aw = 32-NVDLA_MEMORY_ATOMIC_LOG2;
//: &eperl::flop(" -q  cur_op_en  -en wait_for_op_en & \"reg2dp_op_en\" -d  \"reg2dp_op_en\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  cur_conv_mode  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_conv_mode\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 2 -q  cur_proc_precision  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_proc_precision\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 13 -q  cur_width  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_dataout_width\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 13 -q  cur_height  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_dataout_height\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid ${kk} -q  cur_channel  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"cur_channel_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid $aw -q  cur_dataout_addr  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_dataout_addr\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 5 -q  cur_batches  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_batches\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 24 -q  cur_line_stride  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_line_stride\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 24 -q  cur_surf_stride  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_surf_stride\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  cur_line_packed  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_line_packed\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  cur_surf_packed  -en \"wait_for_op_en & reg2dp_op_en\" -d  \"reg2dp_surf_packed\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 

//////////////////////////////////////////////////////////////
///// generate current status signals                    /////
//////////////////////////////////////////////////////////////
wire    is_int8_w = (reg2dp_proc_precision == NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT8);
wire    is_int8 = (cur_proc_precision == NVDLA_CACC_D_MISC_CFG_0_PROC_PRECISION_INT8);
wire    is_winograd = 1'b0;


//////////////////////////////////////////////////////////////
///// generate write signal, 1 pipe for write data
//////////////////////////////////////////////////////////////
wire  dbuf_wr_en_w = dlv_valid;
wire [CACC_DBUF_WIDTH-1:0]  dbuf_wr_data_w = dlv_data;
reg [CACC_DBUF_AWIDTH-1:0] dbuf_wr_addr_pre;
reg [CACC_DBUF_AWIDTH-1:0] dbuf_wr_addr;
wire [CACC_DBUF_AWIDTH-1:0] dbuf_wr_addr_w;
wire mon_dbuf_wr_addr_w;
assign    {mon_dbuf_wr_addr_w, dbuf_wr_addr_w} =  dbuf_wr_addr_pre + 1'b1;
//: my $kk=CACC_DBUF_WIDTH;
//: &eperl::flop("-nodeclare -q  dbuf_wr_addr_pre  -en \"dlv_valid\" -d  \"dbuf_wr_addr_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare -q  dbuf_wr_addr  -en \"dlv_valid\" -d  \"dbuf_wr_addr_pre\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dbuf_wr_en -d  \"dbuf_wr_en_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid ${kk} -q  dbuf_wr_data  -en \"dbuf_wr_en_w\" -d  \"dbuf_wr_data_w\" -clk nvdla_core_clk -rst nvdla_core_rstn"); 



///// generate stored data size, add delay for write, due to ecc,could set 0 currently.
wire    dlv_push_valid = dlv_valid;
wire    dlv_push_size = 1'b1; 
//:     my $latency = CACC_D_RAM_WRITE_LATENCY;
//:     print "wire dlv_push_valid_d0 = dlv_push_valid;\n";
//:     print "wire dlv_push_size_d0 = dlv_push_size;\n";
//: 
//:     for(my $i = 0; $i < $latency; $i ++) {
//:         my $j = $i + 1;
//: &eperl::flop(" -q  dlv_push_valid_d${j}  -d \"dlv_push_valid_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dlv_push_size_d${j}  -en \"dlv_push_valid_d${i}\" -d  \"dlv_push_size_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//:     }
//: 
//:     print "wire dlv_data_add_valid = dlv_push_valid_d${latency};\n";
//:     print "wire dlv_data_add_size = dlv_push_size_d${latency};\n";


//// dbuffer data counter 
wire dlv_pop;
wire [CACC_DBUF_DEPTH-1:0] dlv_data_avl_w;
wire mon_dlv_data_avl_w;
reg [CACC_DBUF_DEPTH-1:0] dlv_data_avl;
wire    dlv_data_avl_add = dlv_data_add_valid ? dlv_data_add_size : 1'h0;
wire    dlv_data_avl_sub = dlv_pop ? 1'b1 : 1'b0;
wire    dlv_data_sub_valid = dlv_pop;
assign {mon_dlv_data_avl_w,dlv_data_avl_w} = dlv_data_avl + dlv_data_avl_add - dlv_data_avl_sub;
//: my $kk=CACC_DBUF_DEPTH;
//: &eperl::flop("-nodeclare -wid ${kk} -q  dlv_data_avl  -en \"dlv_data_add_valid | dlv_data_sub_valid\" -d  \"dlv_data_avl_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 


///// generate dbuf read request                
reg  [CACC_DBUF_AWIDTH-1:0]  dbuf_rd_addr_cnt;
wire [CACC_DBUF_AWIDTH-1:0]  dbuf_rd_addr_cnt_inc;
wire mon_dbuf_rd_addr_cnt_inc;
assign    dlv_pop       = dbuf_rd_en & dbuf_rd_ready;
assign    {mon_dbuf_rd_addr_cnt_inc,dbuf_rd_addr_cnt_inc} = dbuf_rd_addr_cnt + 1'b1;
wire      dbuf_empty    = ~(|dlv_data_avl);
assign    dbuf_rd_en    = ~dbuf_empty;
assign    dbuf_rd_addr  = dbuf_rd_addr_cnt;
//: &eperl::flop("-nodeclare -q  dbuf_rd_addr_cnt  -en \"dlv_pop\" -d  \"dbuf_rd_addr_cnt_inc\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 


/////// generate dp2reg_done signal
wire  dp2reg_done_w = dlv_valid & dlv_stripe_end & dlv_layer_end;
//: &eperl::flop(" -q  dp2reg_done  -d \"dp2reg_done_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 



/////// generate output package for sdp             
reg [CACC_DBUF_AWIDTH-1:0] dlv_end_tag0_addr;
reg [CACC_DBUF_AWIDTH-1:0] dlv_end_tag1_addr;
reg dlv_end_tag0_vld;
reg dlv_end_tag1_vld;
wire    dlv_end_set         = dlv_valid & dlv_stripe_end & dlv_layer_end;
wire [CACC_DBUF_AWIDTH-1:0]    dlv_end_addr_w = dbuf_wr_addr_pre;
wire    dlv_end_clr         = dlv_pop & (dbuf_rd_addr == dlv_end_tag0_addr) & dlv_end_tag0_vld;
wire    dlv_end_tag0_vld_w  = (dlv_end_tag1_vld | dlv_end_set) ? 1'b1 : dlv_end_clr ? 1'b0 : dlv_end_tag0_vld;
wire    dlv_end_tag1_vld_w  = (dlv_end_tag0_vld & dlv_end_set) ? 1'b1 : dlv_end_clr ? 1'b0 : dlv_end_tag1_vld;
wire    dlv_end_tag0_en     = (dlv_end_set & ~dlv_end_tag0_vld) | (dlv_end_set & dlv_end_clr) |(dlv_end_clr & dlv_end_tag1_vld);
wire    dlv_end_tag1_en     = (dlv_end_set & dlv_end_tag0_vld & ~dlv_end_clr);
wire [CACC_DBUF_AWIDTH-1:0]   dlv_end_tag0_addr_w = dlv_end_tag1_vld ? dlv_end_tag1_addr : dlv_end_addr_w;
wire [CACC_DBUF_AWIDTH-1:0]   dlv_end_tag1_addr_w = dlv_end_addr_w;
wire    dbuf_rd_layer_end   = dlv_end_clr;
//: &eperl::flop("-nodeclare -q  dlv_end_tag0_vld  -d \"dlv_end_tag0_vld_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare -q  dlv_end_tag1_vld  -d \"dlv_end_tag1_vld_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare -q  dlv_end_tag0_addr  -en \"dlv_end_tag0_en\" -d  \"dlv_end_tag0_addr_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare -q  dlv_end_tag1_addr  -en \"dlv_end_tag1_en\" -d  \"dlv_end_tag1_addr_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
// spyglass enable_block NoWidthInBasedNum-ML
// spyglass enable_block STARC-2.10.1.6

endmodule
