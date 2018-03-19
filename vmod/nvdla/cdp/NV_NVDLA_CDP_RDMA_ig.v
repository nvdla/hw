// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_RDMA_ig.v

#include "NV_NVDLA_CDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_RDMA_ig (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,cdp2mcif_rd_req_ready     //|< i
  ,cq_wr_prdy                //|< i
  ,eg2ig_done                //|< i
  ,reg2dp_channel            //|< i
  ,reg2dp_dma_en             //|< i
  ,reg2dp_height             //|< i
  ,reg2dp_input_data         //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_src_base_addr_high //|< i
  ,reg2dp_src_base_addr_low  //|< i
  ,reg2dp_src_line_stride    //|< i
  ,reg2dp_src_ram_type       //|< i
  ,reg2dp_src_surface_stride //|< i
  ,reg2dp_width              //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdp2cvif_rd_req_pd        //|> o
  ,cdp2cvif_rd_req_valid     //|> o
  ,cdp2cvif_rd_req_ready     //|< i
  #endif
  ,cdp2mcif_rd_req_pd        //|> o
  ,cdp2mcif_rd_req_valid     //|> o
  ,cq_wr_pd                  //|> o
  ,cq_wr_pvld                //|> o
  ,dp2reg_d0_perf_read_stall //|> o
  ,dp2reg_d1_perf_read_stall //|> o
  );
//////////////////////////////////////////////////////////////////////////////////
input  [12:0] reg2dp_channel;
input         reg2dp_dma_en;
input  [12:0] reg2dp_height;
input   [1:0] reg2dp_input_data;
input         reg2dp_op_en;
input  [31:0] reg2dp_src_base_addr_high;
input  [31:0] reg2dp_src_base_addr_low;
input  [31:0] reg2dp_src_line_stride;
input         reg2dp_src_ram_type;
input  [31:0] reg2dp_src_surface_stride;
input  [12:0] reg2dp_width;
output [31:0] dp2reg_d0_perf_read_stall;
output [31:0] dp2reg_d1_perf_read_stall;
input         eg2ig_done;
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output        cdp2mcif_rd_req_valid;  /* data valid */
input         cdp2mcif_rd_req_ready;  /* data return handshake */
output [NVDLA_DMA_RD_REQ-1:0] cdp2mcif_rd_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        cdp2cvif_rd_req_valid;  /* data valid */
input         cdp2cvif_rd_req_ready;  /* data return handshake */
output [78:0] cdp2cvif_rd_req_pd;
#endif

output       cq_wr_pvld;  /* data valid */
input        cq_wr_prdy;  /* data return handshake */
output [6:0] cq_wr_pd;
//////////////////////////////////////////////////////////////////////////////////

reg           after_op_done;
reg    [63:0] base_addr_c;
reg    [63:0] base_addr_w;
reg    [31:0] cdp_rd_stall_count;
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int( log($atomicm)/log(2) );
//:     print qq(
//:         reg     [12-${k}:0] channel_count;
//:     );
reg    [63:0] dma_req_addr;
reg    [31:0] dp2reg_d0_perf_read_stall;
reg    [31:0] dp2reg_d1_perf_read_stall;
reg    [12:0] height_count;
reg           layer_flag;
reg           mon_base_addr_c_c;
reg           mon_base_addr_w_c;
reg           mon_dma_req_addr_c;
reg    [31:0] mon_gap_between_layers;
reg           mon_layer_end_flg;
reg           mon_op_en_dly;
reg           mon_size_of_32x1_in_first_block_in_width_c;
reg    [10:0] number_of_total_trans_in_width;
reg     [2:0] req_size;
reg     [2:0] size_of_32x1_in_first_block_in_width;
reg           stl_adv;
reg    [31:0] stl_cnt_cur;
reg    [33:0] stl_cnt_dec;
reg    [33:0] stl_cnt_ext;
reg    [33:0] stl_cnt_inc;
reg    [33:0] stl_cnt_mod;
reg    [33:0] stl_cnt_new;
reg    [33:0] stl_cnt_nxt;
reg           tran_vld;
reg    [10:0] width_count;
wire          cdp_rd_stall_count_dec;
wire          cmd_accept;
wire          cnt_cen;
wire          cnt_clr;
wire          cnt_inc;
wire          cv_dma_rd_req_rdy;
wire          cv_dma_rd_req_vld;
wire   [78:0] cv_int_rd_req_pd;
wire   [78:0] cv_int_rd_req_pd_d0;
wire          cv_int_rd_req_ready;
wire          cv_int_rd_req_ready_d0;
wire          cv_int_rd_req_valid;
wire          cv_int_rd_req_valid_d0;
wire          cv_rd_req_rdyi;
wire   [NVDLA_CDP_MEM_ADDR_BW+14:0] dma_rd_req_pd;
wire          dma_rd_req_ram_type;
wire          dma_rd_req_rdy;
wire          dma_rd_req_vld;
wire   [14:0] dma_req_size;
wire          ig2eg_align;
wire          ig2eg_last_c;
wire          ig2eg_last_h;
wire          ig2eg_last_w;
wire   [14:0] ig2eg_width;
wire          is_chn_end;
wire          is_cube_end;
wire          is_first_w;
wire          is_last_c;
wire          is_last_h;
wire          is_last_w;
wire          is_slice_end;
wire          mc_dma_rd_req_rdy;
wire          mc_dma_rd_req_vld;
wire   [78:0] mc_int_rd_req_pd;
wire   [78:0] mc_int_rd_req_pd_d0;
wire          mc_int_rd_req_ready;
wire          mc_int_rd_req_ready_d0;
wire          mc_int_rd_req_valid;
wire          mc_int_rd_req_valid_d0;
wire          mc_rd_req_rdyi;
wire          mon_number_of_32x1_block_in_channel_c;
wire          mon_op_en_neg;
wire          mon_op_en_pos;
wire          op_done;
wire          op_load;
wire          rd_req_rdyi;
wire   [63:0] reg2dp_base_addr;
wire   [31:0] reg2dp_line_stride;
wire   [63:0] reg2dp_src_base_addr;
wire   [31:0] reg2dp_surf_stride;
wire   [13:0] reg2dp_width_use;
wire    [2:0] size_of_32x1_in_last_block_in_width;
wire    [2:0] width_size;
wire    [3:0] width_size_use;
////////////////////////////////////////////////////////////////////////////////////
//==============
// Work Processing
//==============
// one bubble between operation on two layers to let ARREG to switch to the next configration group
assign op_load = reg2dp_op_en & !tran_vld;
assign op_done = cmd_accept & is_cube_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    tran_vld <= 1'b0;
  end else begin
    if (op_done) begin
        tran_vld <= 1'b0;
    end else if (after_op_done) begin
        tran_vld <= 1'b0;
    end else if (op_load) begin
        tran_vld <= 1'b1;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    after_op_done <= 1'b0;
  end else begin
    if (op_done) begin
        after_op_done <= 1'b1;
    end else if (eg2ig_done) begin
        after_op_done <= 1'b0;
    end
  end
end
//NOTE!!! assert begin
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
  nv_assert_never #(0,0,"CDP-RDMA: get an op-done without starting the op")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, !tran_vld && op_done); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//NOTE!!! assert end

//==============
// Address catenate and offset calc
//==============
assign reg2dp_src_base_addr = {reg2dp_src_base_addr_high,reg2dp_src_base_addr_low};
assign reg2dp_width_use[13:0] = reg2dp_width + 1'b1;
//==============

//==============
// WIDTH Direction
// calculate how many atomic_m x8 blocks in width direction, also get the first and last block, which may be less than 8
//==============
wire    mon_number_of_total_trans_in_width;
assign {mon_number_of_total_trans_in_width,number_of_total_trans_in_width[10:0]} = reg2dp_width_use[13:3] + {10'd0,(|reg2dp_width_use[2:0])};

//==============
// Positioning
//==============
assign is_first_w = (width_count==0);

assign is_chn_end = is_last_c;
assign is_slice_end = is_last_w & is_last_c;
assign is_cube_end = is_last_w & is_last_h & is_last_c;
//==============
// CHANNEL Count: with inital value of total number in C direction, and will count-- when moving in chn direction
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    channel_count <= 0;
  end else begin
    if (cmd_accept) begin
        if (is_last_c) begin
            channel_count <= 0;
        end else begin
            channel_count <= channel_count + 1'b1;
        end
    end
  end
end
//: my $atomicm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int( log($atomicm)/log(2) );
//:     print qq(
//:         assign is_last_c = (channel_count==reg2dp_channel[12:${k}]);
//:     );

// assign is_last_c = (channel_count==number_of_block_in_channel-1);

//==============
// WID Count: with inital value of total number in W direction, and will count-- when moving in wid direction
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_count <= {11{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_slice_end) begin
            width_count <= 0;
        end else if (is_chn_end) begin
            width_count <= width_count + 1'b1;
        end
    end
  end
end
assign is_last_w = (width_count==number_of_total_trans_in_width-1);
//==============
// HEIGHT Count: move to next line after one wx1xc plane done
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    height_count <= {13{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_cube_end) begin
            height_count <= 0;
        end else if (is_slice_end) begin
            height_count <= height_count + 1'b1;
        end
    end
  end
end
assign is_last_h = (height_count==reg2dp_height);

//==========================================
// DMA: addr | size 
//==========================================
assign reg2dp_base_addr   = reg2dp_src_base_addr;
assign reg2dp_line_stride = reg2dp_src_line_stride;
assign reg2dp_surf_stride = reg2dp_src_surface_stride;
//==============
// DMA Req : ADDR : Prepration
// DMA Req: go through the CUBE: W8->C->H
//==============
// Width: need be updated when move to next line 
// Trigger Condition: (is_last_c & is_last_w)
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_w <= {64{1'b0}};
    {mon_base_addr_w_c,base_addr_w} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_w <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c && is_last_w) begin
            {mon_base_addr_w_c,base_addr_w} <= base_addr_w + reg2dp_line_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_w_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// base_Chn: need be updated when move to next w.group 
// Trigger Condition: (is_last_c)
//  1, jump to next line when is_last_w
//  2, jump to next w.group when !is_last_w
assign width_size_use[3:0] = width_size + 1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_c <= {64{1'b0}};
    {mon_base_addr_c_c,base_addr_c} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_c <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_base_addr_c_c,base_addr_c} <= base_addr_w + reg2dp_line_stride;
            end else begin
//: my $atm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log($atm)/log(2));
//: print "                {mon_base_addr_c_c,base_addr_c} <= base_addr_c + {width_size_use,${atmbw}'d0}; \n";
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_c_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// DMA Req : ADDR : Generation
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_req_addr <= {64{1'b0}};
    {mon_dma_req_addr_c,dma_req_addr} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        dma_req_addr <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_w + reg2dp_line_stride;
            end else begin
//: my $atm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $atmbw = int(log($atm)/log(2));
//: print "                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_c + {width_size_use,${atmbw}'d0};  \n";
            end
        end else begin
            {mon_dma_req_addr_c,dma_req_addr} <= dma_req_addr + reg2dp_surf_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, mon_dma_req_addr_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
////==============
// DMA Req : SIZE : Prepration
//==============
// if there is only trans in total width, this one will be counted into the first trans, so is_first_w should take prior to is_last_w
always @(*) begin
    mon_size_of_32x1_in_first_block_in_width_c = 1'b0;
    if (number_of_total_trans_in_width==1) begin
        size_of_32x1_in_first_block_in_width[2:0] =   reg2dp_width[2:0];
    end else begin
        {mon_size_of_32x1_in_first_block_in_width_c,size_of_32x1_in_first_block_in_width[2:0]} =   3'd7;
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & mon_size_of_32x1_in_first_block_in_width_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// when there is no L trans, still need calc the size for last trans which belongs to middle trans
// end_addr: 0 1 2 3 4 5 6 7 
// size    : 0 1 2 3 4 5 6 7 
assign size_of_32x1_in_last_block_in_width[2:0] = reg2dp_width[2:0];
//==============
// DMA Req : SIZE : Generation
//==============
always @(*) begin
    if (is_first_w) begin
        req_size = size_of_32x1_in_first_block_in_width;
    end else if (is_last_w) begin
        req_size = size_of_32x1_in_last_block_in_width;
    end else begin
        req_size = 3'd7;
    end
end
assign width_size = req_size; // 1~8
assign dma_req_size = {{12{1'b0}}, req_size};

//==============
// Context Qeueu : Beats
//==============

//assign dma_req_align = (dma_req_addr[5]==0);
assign ig2eg_width = dma_req_size;
assign ig2eg_align = 1'b0;//dma_req_align;
assign ig2eg_last_w  = is_last_w;
assign ig2eg_last_h  = is_last_h;
assign ig2eg_last_c  = is_last_c;

assign       cq_wr_pd[2:0] =   ig2eg_width[2:0];
assign       cq_wr_pd[3] =     ig2eg_align ;
assign       cq_wr_pd[4] =     ig2eg_last_w ;
assign       cq_wr_pd[5] =     ig2eg_last_h ;
assign       cq_wr_pd[6] =     ig2eg_last_c ;
assign cq_wr_pvld = tran_vld & dma_rd_req_rdy;

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
  nv_assert_never #(0,0,"CDP-RDMA: CQ and DMA should accept or reject together")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (cq_wr_pvld & cq_wr_prdy) ^ (dma_rd_req_vld & dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// DMA Req : PIPE
//==============
// VALID: clamp when when cq is not ready
assign dma_rd_req_vld = tran_vld & cq_wr_prdy;

// PayLoad

assign dma_rd_req_pd[NVDLA_CDP_MEM_ADDR_BW-1:0] =     dma_req_addr[NVDLA_CDP_MEM_ADDR_BW-1:0];
assign dma_rd_req_pd[NVDLA_CDP_MEM_ADDR_BW+14:NVDLA_CDP_MEM_ADDR_BW] =     dma_req_size[14:0];
assign dma_rd_req_ram_type      = reg2dp_src_ram_type;

// Accept
assign cmd_accept = dma_rd_req_vld & dma_rd_req_rdy;

//==============
// reading stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = is_cube_end & cmd_accept;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_rd_req_vld & (~dma_rd_req_rdy));



    assign cdp_rd_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or cdp_rd_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ cdp_rd_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or cdp_rd_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !cdp_rd_stall_count_dec)? stl_cnt_inc : (!cnt_inc && cdp_rd_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (cnt_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (cnt_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      cdp_rd_stall_count[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flag <= 1'b0;
  end else begin
  if ((cnt_clr) == 1'b1) begin
    layer_flag <= ~layer_flag;
  // VCS coverage off
  end else if ((cnt_clr) == 1'b0) begin
  end else begin
    layer_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_read_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr & (~layer_flag)) == 1'b1) begin
    dp2reg_d0_perf_read_stall <= cdp_rd_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr & (~layer_flag)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_read_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr & (~layer_flag)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_read_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr &   layer_flag ) == 1'b1) begin
    dp2reg_d1_perf_read_stall <= cdp_rd_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr &   layer_flag ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_read_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr &   layer_flag ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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



//==============
// DMA Interface
//==============
NV_NVDLA_DMAIF_rdreq NV_NVDLA_PDP_RDMA_rdreq(
  .nvdla_core_clk         (nvdla_core_clk     )
 ,.nvdla_core_rstn        (nvdla_core_rstn    )
 ,.reg2dp_src_ram_type    (reg2dp_src_ram_type)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 ,.cvif_rd_req_pd         (cdp2cvif_rd_req_pd   )
 ,.cvif_rd_req_valid      (cdp2cvif_rd_req_valid)
 ,.cvif_rd_req_ready      (cdp2cvif_rd_req_ready)
#endif
 ,.mcif_rd_req_pd         (cdp2mcif_rd_req_pd   ) 
 ,.mcif_rd_req_valid      (cdp2mcif_rd_req_valid) 
 ,.mcif_rd_req_ready      (cdp2mcif_rd_req_ready) 

 ,.dmaif_rd_req_pd        (dma_rd_req_pd    ) 
 ,.dmaif_rd_req_vld       (dma_rd_req_vld   )
 ,.dmaif_rd_req_rdy       (dma_rd_req_rdy   )
);


////==============
////OBS signals
////==============
//assign obs_bus_cdp_rdma_proc_en = tran_vld;

//==============
//function point
//==============

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

    property CDP_RDMA_ig__dma_IF_reading_stall__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (((dma_rd_req_vld)) && nvdla_core_rstn) |-> ((~dma_rd_req_rdy & reg2dp_op_en));
    endproperty
    // Cover 0 : "(~dma_rd_req_rdy & reg2dp_op_en)"
    FUNCPOINT_CDP_RDMA_ig__dma_IF_reading_stall__0_COV : cover property (CDP_RDMA_ig__dma_IF_reading_stall__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_RDMA_ig__width_end_stall__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_last_w & (~dma_rd_req_rdy);
    endproperty
    // Cover 1 : "is_last_w & (~dma_rd_req_rdy)"
    FUNCPOINT_CDP_RDMA_ig__width_end_stall__1_COV : cover property (CDP_RDMA_ig__width_end_stall__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_RDMA_ig__last_slice_stall__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_last_h & (~dma_rd_req_rdy);
    endproperty
    // Cover 2 : "is_last_h & (~dma_rd_req_rdy)"
    FUNCPOINT_CDP_RDMA_ig__last_slice_stall__2_COV : cover property (CDP_RDMA_ig__last_slice_stall__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_RDMA_ig__channnel_end_stall__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_last_c & (~dma_rd_req_rdy);
    endproperty
    // Cover 3 : "is_last_c & (~dma_rd_req_rdy)"
    FUNCPOINT_CDP_RDMA_ig__channnel_end_stall__3_COV : cover property (CDP_RDMA_ig__channnel_end_stall__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_RDMA_ig__ig2eg_stall__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cq_wr_pvld) && nvdla_core_rstn) |-> ((~cq_wr_prdy & reg2dp_op_en));
    endproperty
    // Cover 4 : "(~cq_wr_prdy & reg2dp_op_en)"
    FUNCPOINT_CDP_RDMA_ig__ig2eg_stall__4_COV : cover property (CDP_RDMA_ig__ig2eg_stall__4_cov);

  `endif
`endif
//VCS coverage on

//two continuous layers
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_op_en_dly <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  mon_op_en_dly <= reg2dp_op_en;
  end
end
assign mon_op_en_pos = reg2dp_op_en & (~mon_op_en_dly);
assign mon_op_en_neg = (~reg2dp_op_en) & mon_op_en_dly;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_layer_end_flg <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
    if(mon_op_en_neg)
        mon_layer_end_flg <= 1'b1;
    else if(mon_op_en_pos)
        mon_layer_end_flg <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_gap_between_layers[31:0] <= {32{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
    if(mon_layer_end_flg)
        mon_gap_between_layers[31:0] <= mon_gap_between_layers + 1'b1;
    else
        mon_gap_between_layers[31:0] <= 32'd0;
  end
end

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_RDMA_two_continuous_layer__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (mon_gap_between_layers==32'd2) & mon_op_en_pos;
    endproperty
    // Cover 5 : "(mon_gap_between_layers==32'd2) & mon_op_en_pos"
    FUNCPOINT_CDP_RDMA_two_continuous_layer__5_COV : cover property (CDP_RDMA_two_continuous_layer__5_cov);

  `endif
`endif
//VCS coverage on

//3 cycles means continuous layer

//==============
// Context Queue Interface
//==============

endmodule // NV_NVDLA_CDP_RDMA_ig



