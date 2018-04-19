// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_RDMA_ig.v

#include "NV_NVDLA_PDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_RDMA_ig (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,eg2ig_done                    //|< i
  ,ig2cq_prdy                    //|< i
  ,pdp2mcif_rd_req_ready         //|< i
  ,reg2dp_cube_in_channel        //|< i
  ,reg2dp_cube_in_height         //|< i
  ,reg2dp_cube_in_width          //|< i
  ,reg2dp_dma_en                 //|< i
  ,reg2dp_kernel_stride_width    //|< i
  ,reg2dp_kernel_width           //|< i
  ,reg2dp_op_en                  //|< i
  ,reg2dp_partial_width_in_first //|< i
  ,reg2dp_partial_width_in_last  //|< i
  ,reg2dp_partial_width_in_mid   //|< i
  ,reg2dp_split_num              //|< i
  ,reg2dp_src_base_addr_high     //|< i
  ,reg2dp_src_base_addr_low      //|< i
  ,reg2dp_src_line_stride        //|< i
  ,reg2dp_src_ram_type           //|< i
  ,reg2dp_src_surface_stride     //|< i
  ,dp2reg_d0_perf_read_stall     //|> o
  ,dp2reg_d1_perf_read_stall     //|> o
  ,ig2cq_pd                      //|> o
  ,ig2cq_pvld                    //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,pdp2cvif_rd_req_pd            //|> o
  ,pdp2cvif_rd_req_valid         //|> o
  ,pdp2cvif_rd_req_ready         //|< i
#endif
  ,pdp2mcif_rd_req_pd            //|> o
  ,pdp2mcif_rd_req_valid         //|> o
  ,reg2dp_surf_stride            //|> o
  );
///////////////////////////////////////////////////////////////////////////////
input  [12:0] reg2dp_cube_in_channel;
input  [12:0] reg2dp_cube_in_height;
input  [12:0] reg2dp_cube_in_width;
input   [0:0] reg2dp_dma_en;
input   [3:0] reg2dp_kernel_stride_width;
input   [3:0] reg2dp_kernel_width;
input   [0:0] reg2dp_op_en;
input   [9:0] reg2dp_partial_width_in_first;
input   [9:0] reg2dp_partial_width_in_last;
input   [9:0] reg2dp_partial_width_in_mid;
input   [7:0] reg2dp_split_num;
input  [31:0] reg2dp_src_base_addr_high;
input  [31:0] reg2dp_src_base_addr_low;
input  [31:0] reg2dp_src_line_stride;
input   [0:0] reg2dp_src_ram_type;
input  [31:0] reg2dp_src_surface_stride;
output [31:0] dp2reg_d0_perf_read_stall;
output [31:0] dp2reg_d1_perf_read_stall;
output [31:0] reg2dp_surf_stride;
input         eg2ig_done;
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output        pdp2mcif_rd_req_valid;  /* data valid */
input         pdp2mcif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2mcif_rd_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        pdp2cvif_rd_req_valid;  /* data valid */
input         pdp2cvif_rd_req_ready;  /* data return handshake */
output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2cvif_rd_req_pd;
#endif
output        ig2cq_pvld;  /* data valid */
input         ig2cq_prdy;  /* data return handshake */
output [17:0] ig2cq_pd;
///////////////////////////////////////////////////////////////////////////////

reg           after_op_done;
reg    [63:0] base_addr_esurf;
reg    [63:0] base_addr_line;
reg    [63:0] base_addr_split;
reg    [63:0] base_addr_width;
reg    [10:0] count_c;
reg    [12:0] count_h;
reg     [9:0] count_wg;
reg    [31:0] dp2reg_d0_perf_read_stall;
reg    [31:0] dp2reg_d1_perf_read_stall;
reg           layer_flag;
reg           mon_base_addr_line_c;
reg           mon_base_addr_split_c;
reg           mon_base_addr_surf_c;
reg           mon_base_addr_width_c;
reg    [31:0] mon_gap_between_layers;
reg           mon_layer_end_flg;
reg           mon_op_en_dly;
reg    [14:0] number_of_byte_in_c;
reg           op_process;
reg    [31:0] pdp_rd_stall_count;
reg    [12:0] req_size;
reg           stl_adv;
reg    [31:0] stl_cnt_cur;
reg    [33:0] stl_cnt_dec;
reg    [33:0] stl_cnt_ext;
reg    [33:0] stl_cnt_inc;
reg    [33:0] stl_cnt_mod;
reg    [33:0] stl_cnt_new;
reg    [33:0] stl_cnt_nxt;
reg    [13:0] width_stride;
wire   [13:0] cfg_channel;
wire    [9:0] cfg_fspt_width;
wire   [10:0] cfg_fspt_width_use;
wire    [9:0] cfg_lspt_width;
wire   [10:0] cfg_lspt_width_use;
wire          cfg_mode_split;
wire    [9:0] cfg_mspt_width;
wire   [10:0] cfg_mspt_width_use;
wire    [8:0] cfg_split_num;
wire   [13:0] cfg_width;
wire          cmd_accept;
wire          cnt_cen;
wire          cnt_clr;
wire          cnt_inc;
wire          cv_dma_rd_req_rdy;
wire          cv_dma_rd_req_vld;
wire   [78:0] cv_int_rd_req_pd;
wire   [78:0] cv_int_rd_req_pd_d0;
wire   [78:0] cv_int_rd_req_pd_d1;
wire          cv_int_rd_req_ready;
wire          cv_int_rd_req_ready_d0;
wire          cv_int_rd_req_ready_d1;
wire          cv_int_rd_req_valid;
wire          cv_int_rd_req_valid_d0;
wire          cv_int_rd_req_valid_d1;
wire          cv_rd_req_rdyi;
wire   [NVDLA_MEM_ADDRESS_WIDTH+14:0] dma_rd_req_pd;
wire          dma_rd_req_ram_type;
wire          dma_rd_req_rdy;
wire          dma_rd_req_vld;
wire   [63:0] dma_req_addr;
wire   [14:0] dma_req_size;
wire          ig2eg_align;
wire          ig2eg_cube_end;
wire          ig2eg_line_end;
wire   [12:0] ig2eg_size;
wire          ig2eg_split_end;
wire          ig2eg_surf_end;
wire          is_cube_end;
wire          is_fspt;
wire          is_last_c;
wire          is_last_h;
wire          is_line_end;
wire          is_lspt;
wire          is_split_end;
wire          is_surf_end;
wire          mc_dma_rd_req_rdy;
wire          mc_dma_rd_req_vld;
wire   [78:0] mc_int_rd_req_pd;
wire   [78:0] mc_int_rd_req_pd_d0;
wire   [78:0] mc_int_rd_req_pd_d1;
wire          mc_int_rd_req_ready;
wire          mc_int_rd_req_ready_d0;
wire          mc_int_rd_req_ready_d1;
wire          mc_int_rd_req_valid;
wire          mc_int_rd_req_valid_d0;
wire          mc_int_rd_req_valid_d1;
wire          mc_rd_req_rdyi;
wire   [1:0]  mon_number_of_block_in_c;
wire          mon_op_en_neg;
wire          mon_op_en_pos;
wire          mon_overlap;
//: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
//: if($k==32) {
//:     print " wire    [9:0] number_of_block_in_c; \n";
//: }
//: elsif($k==8) {
//:     print " wire    [10:0] number_of_block_in_c; \n";
//: } 
wire          op_done;
wire          op_load;
wire    [3:0] overlap;
wire          pdp_rd_stall_count_dec;
wire          rd_req_rdyi;
wire   [63:0] reg2dp_base_addr;
wire   [31:0] reg2dp_esurf_stride;
wire   [31:0] reg2dp_line_stride;
wire   [63:0] reg2dp_src_base_addr;
wire    [8:0] wg_num;
///////////////////////////////////////////////////////////////////////////////
    

//==============
// Work Processing
//==============
// one bubble between operation on two layers to let ARREG to switch to the next configration group
assign op_load = reg2dp_op_en & !op_process;
assign op_done = cmd_accept & is_cube_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_process <= 1'b0;
  end else begin
    if (op_done) begin
        op_process <= 1'b0;
    end else if (after_op_done) begin
        op_process <= 1'b0;
    end else if (op_load) begin
        op_process <= 1'b1;
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
  nv_assert_never #(0,0,"PDP-RDMA: get an op-done without starting the op")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, !reg2dp_op_en && op_done); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// Address catenate and offset calc
//==============
assign reg2dp_src_base_addr = {reg2dp_src_base_addr_high,reg2dp_src_base_addr_low};

//==============
// CFG:
//==============
assign cfg_width  = reg2dp_cube_in_width + 1'b1;

assign cfg_channel  = reg2dp_cube_in_channel + 1'b1;

assign cfg_fspt_width = reg2dp_partial_width_in_first;
assign cfg_mspt_width = reg2dp_partial_width_in_mid;
assign cfg_lspt_width = reg2dp_partial_width_in_last;
assign cfg_fspt_width_use[10:0] = reg2dp_partial_width_in_first[9:0] + 1'b1;
assign cfg_mspt_width_use[10:0] = reg2dp_partial_width_in_mid[9:0] + 1'b1;
assign cfg_lspt_width_use[10:0] = reg2dp_partial_width_in_last[9:0] + 1'b1;
assign cfg_mode_split = (reg2dp_split_num != 8'd0);

assign cfg_split_num  = reg2dp_split_num + 1'b1;

//==============
// CHANNEL Direction
// calculate how many 32x8 blocks in channel direction
//==============
assign        number_of_byte_in_c = {1'b0,cfg_channel};
//: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
//: if($k == 32) {
//:     print " assign {mon_number_of_block_in_c,number_of_block_in_c[9:0]} = number_of_byte_in_c[14:5] + (|number_of_byte_in_c[4:0]);    \n";
//: }
//: elsif($k == 8) {
//:     print " assign {mon_number_of_block_in_c[1:0],number_of_block_in_c[10:0]} = number_of_byte_in_c[14:3] + {11'd0,(|number_of_byte_in_c[2:0])};    \n";
//: }

//==============
// WIDTH calculation
// Always has FTRAN with size 0~7
// then will LTRAN with size 0~7
// then will have MTEAN with fixed size 7
//==============
always @(
  cfg_mode_split
  or is_fspt
  or cfg_fspt_width_use
  or is_lspt
  or cfg_lspt_width_use
  or cfg_mspt_width_use
  or cfg_width
  ) begin
    if (cfg_mode_split) begin
        if (is_fspt) begin
            width_stride = {{3{1'b0}}, cfg_fspt_width_use};
        end else if (is_lspt) begin
            width_stride = {{3{1'b0}}, cfg_lspt_width_use};
        end else begin
            width_stride = {{3{1'b0}}, cfg_mspt_width_use};
        end
    end else begin
        width_stride = cfg_width[13:0];
    end
end

//==============
// ENDing of line/surf/split/cube
//==============
assign is_line_end = 1'b1;//is_last_w;
assign is_surf_end = is_line_end & is_last_h;
assign is_split_end = is_surf_end & is_last_c;
assign is_cube_end = cfg_mode_split? (is_split_end & is_lspt) : is_split_end;

//==============
// WGROUP Count: width group: number of window after split-w. equal to 1 in non-split-w mode
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_wg <= {10{1'b0}};
  end else begin
    if (cmd_accept & is_split_end & cfg_mode_split) begin
        if(count_wg == wg_num-1)
            count_wg <= 0;
        else
            count_wg <= count_wg + 1'b1;
    end
  end
end
assign wg_num = cfg_mode_split ? cfg_split_num : 1;

assign is_fspt = cfg_mode_split & (count_wg==0);
assign is_lspt = cfg_mode_split & (count_wg==wg_num-1);

//==============
// CHANNEL Count: with inital value of total number in C direction, and will count-- when moving in chn direction
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_c <= {11{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_split_end) begin
            count_c <= 11'd0;
        end else if (is_surf_end) begin
            count_c <= count_c + 1'b1;
        end
    end
  end
end
assign is_last_c = (count_c==number_of_block_in_c - 1);

//==============
// HEIGHT Count: move to next line after one line is done
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (op_load) begin
        count_h <= 13'd0;
    end else if (cmd_accept) begin
        if (is_surf_end) begin
            count_h <= 0;
        end else if (is_line_end) begin
            count_h <= count_h + 1'b1;
        end
    end
  end
end
assign is_last_h = (count_h==reg2dp_cube_in_height);

//==========================================
// DMA Req : ADDR
//==========================================
assign reg2dp_base_addr   = reg2dp_src_base_addr;
assign reg2dp_line_stride = reg2dp_src_line_stride;
assign reg2dp_surf_stride = reg2dp_src_surface_stride;
assign reg2dp_esurf_stride = reg2dp_src_surface_stride;
//==============
// DMA Req : ADDR : Prepration
// DMA Req: go through the CUBE: W8->C->H
//==============
// ELEMENT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_width <= {64{1'b0}};
    {mon_base_addr_width_c,base_addr_width} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_width <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_split_end & (~is_cube_end)) begin
            if(is_fspt) begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //:     print " {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,${m}'d0} + {overlap[3:0],${m}'d0};     \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //:     print " {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,${m}'d0} - {overlap[3:0],${m}'d0};     \n";
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //:     print " {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,${m}'d0};     \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //:     print " {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,${m}'d0};     \n";
            end
        end else if (is_surf_end) begin
            {mon_base_addr_width_c,base_addr_width} <= base_addr_esurf + reg2dp_esurf_stride;
        end else if (is_line_end) begin
            {mon_base_addr_width_c,base_addr_width} <= base_addr_line + reg2dp_line_stride;
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
  nv_assert_never #(0,0,"PDP_RDMA: no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_width_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// LINE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_line <= {64{1'b0}};
    {mon_base_addr_line_c,base_addr_line} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_line <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if(is_split_end & (~is_cube_end)) begin
            if(is_fspt) begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,${m}'d0} + {overlap[3:0],${m}'d0};  \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,${m}'d0} - {overlap[3:0],${m}'d0};   \n";
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print"  {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,${m}'d0};   \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,${m}'d0};   \n";
            end
        end else if(is_surf_end)
            {mon_base_addr_line_c,base_addr_line} <= base_addr_esurf + reg2dp_esurf_stride;
        else if(is_line_end) begin
            {mon_base_addr_line_c,base_addr_line} <= base_addr_line + reg2dp_line_stride;
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
  nv_assert_never #(0,0,"PDP_RDMA: no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_line_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// SURF
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_esurf <= {64{1'b0}};
    {mon_base_addr_surf_c,base_addr_esurf} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_esurf <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if(is_split_end & (~is_cube_end)) begin
            if(is_fspt) begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,${m}'d0} + {overlap[3:0],${m}'d0};   \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,${m}'d0} - {overlap[3:0],${m}'d0};  \n";
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,${m}'d0};    \n";
                else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,${m}'d0};    \n";
            end
        end else if (is_surf_end)
            {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_esurf + reg2dp_esurf_stride;
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
  nv_assert_never #(0,0,"PDP_RDMA: no overflow is allowed")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_surf_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// SPLIT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_split <= {64{1'b0}};
    {mon_base_addr_split_c,base_addr_split} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_split <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_split_end & (~is_cube_end)) begin
          if(is_fspt) begin
            if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,${m}'d0} + {overlap[3:0],${m}'d0}; \n";
            else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
         //: print "{mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,${m}'d0} - {overlap[3:0],${m}'d0}; \n";
          end else begin
            if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,${m}'d0}; \n";
            else
        //: my $k=NVDLA_MEMORY_ATOMIC_SIZE;
        //: my $m = int(log($k)/log(2));
        //: print " {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,${m}'d0}; \n";
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
  nv_assert_never #(0,0,"PDP_RDMA: no overflow is allowed")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_split_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dma_req_addr = base_addr_width;

//==============
// DMA Req : SIZE : Generation
//==============
assign {mon_overlap,overlap[3:0]} = (reg2dp_kernel_width < reg2dp_kernel_stride_width) ? (reg2dp_kernel_stride_width[3:0] - {1'b0,reg2dp_kernel_width[2:0]}) : ({1'b0,reg2dp_kernel_width[2:0]} - reg2dp_kernel_stride_width[3:0]);
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
  nv_assert_never #(0,0,"PDP-CORE: should not overflow")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, mon_overlap); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(
  cfg_mode_split
  or is_fspt
  or cfg_fspt_width
  or is_lspt
  or reg2dp_kernel_width
  or reg2dp_kernel_stride_width
  or cfg_lspt_width
  or overlap
  or cfg_mspt_width
  or reg2dp_cube_in_width
  ) begin
    if(cfg_mode_split) begin
        if (is_fspt)
            req_size = {{3{1'b0}}, cfg_fspt_width};
        else if (is_lspt) begin
            if(reg2dp_kernel_width < reg2dp_kernel_stride_width)
                req_size = {{3{1'b0}}, cfg_lspt_width} - {8'd0,overlap[3:0]};
            else
                req_size = {{3{1'b0}}, cfg_lspt_width} + {8'd0,overlap[3:0]};
        end else begin
            if(reg2dp_kernel_width < reg2dp_kernel_stride_width)
                req_size = {{3{1'b0}}, cfg_mspt_width} - {8'd0,overlap[3:0]};
            else
                req_size = {{3{1'b0}}, cfg_mspt_width} + {8'd0,overlap[3:0]};
        end
    end else
        req_size = reg2dp_cube_in_width[12:0];//cfg_width;
end
assign dma_req_size = {{2{1'b0}}, req_size};

//==============
// Context Qeueu : Beats
//==============
//{s,e}-> 11 10 01 00
//     --------------
//size | 
// 0:  |  x  0  0  x
// 1:  |  1  x  x  0
// 2:  |  x  1  1  x
// 3:  |  2  x  x  1
// 4:  |  x  2  2  x
// 5:  |  3  x  x  2
// 6:  |  x  3  3  x
// 7:  |  4  x  x  3

// 64.size = ((32.size>>1) + &mask)
// 64.cnt = 64.size + 1

assign ig2eg_size = dma_req_size[12:0];
assign ig2eg_align = 1'b0; // can be elimnated after mcif update for re-alignment
assign ig2eg_line_end  = is_line_end;
assign ig2eg_surf_end  = is_surf_end;
assign ig2eg_split_end = is_split_end;
assign ig2eg_cube_end  = is_cube_end;

// PKT_PACK_WIRE( pdp_rdma_ig2eg ,  ig2eg_ ,  ig2cq_pd )
assign       ig2cq_pd[12:0] =     ig2eg_size[12:0];
assign       ig2cq_pd[13] =     ig2eg_align ;
assign       ig2cq_pd[14] =     ig2eg_line_end ;
assign       ig2cq_pd[15] =     ig2eg_surf_end ;
assign       ig2cq_pd[16] =     ig2eg_split_end ;
assign       ig2cq_pd[17] =     ig2eg_cube_end ;
assign ig2cq_pvld = op_process & dma_rd_req_rdy;
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
  nv_assert_never #(0,0,"PDP-RDMA: CQ and DMA should accept or reject together")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (ig2cq_pvld & ig2cq_prdy) ^ (dma_rd_req_vld & dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dma_rd_req_vld = op_process & ig2cq_prdy;

// PayLoad

assign       dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0] =     dma_req_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign       dma_rd_req_pd[NVDLA_MEM_ADDRESS_WIDTH+14:NVDLA_MEM_ADDRESS_WIDTH] =     dma_req_size[14:0];

assign dma_rd_req_ram_type   = reg2dp_src_ram_type;
// Accept
assign cmd_accept = dma_rd_req_vld & dma_rd_req_rdy;

//==============
// reading stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = cmd_accept & is_cube_end;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_rd_req_vld & (~dma_rd_req_rdy));



    assign pdp_rd_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or pdp_rd_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ pdp_rd_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or pdp_rd_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !pdp_rd_stall_count_dec)? stl_cnt_inc : (!cnt_inc && pdp_rd_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
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
      pdp_rd_stall_count[31:0] = stl_cnt_cur[31:0];
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
    dp2reg_d0_perf_read_stall <= pdp_rd_stall_count[31:0];
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
    dp2reg_d1_perf_read_stall <= pdp_rd_stall_count[31:0];
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

NV_NVDLA_DMAIF_rdreq NV_NVDLA_PDP_RDMA_rdreq(
  .nvdla_core_clk         (nvdla_core_clk     )
 ,.nvdla_core_rstn        (nvdla_core_rstn    )
 ,.reg2dp_src_ram_type    (reg2dp_src_ram_type)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 ,.cvif_rd_req_pd         (pdp2cvif_rd_req_pd   )
 ,.cvif_rd_req_valid      (pdp2cvif_rd_req_valid)
 ,.cvif_rd_req_ready      (pdp2cvif_rd_req_ready)
#endif
 ,.mcif_rd_req_pd         (pdp2mcif_rd_req_pd   ) 
 ,.mcif_rd_req_valid      (pdp2mcif_rd_req_valid) 
 ,.mcif_rd_req_ready      (pdp2mcif_rd_req_ready) 

 ,.dmaif_rd_req_pd        (dma_rd_req_pd    ) 
 ,.dmaif_rd_req_vld       (dma_rd_req_vld   )
 ,.dmaif_rd_req_rdy       (dma_rd_req_rdy   )
);

////==============
////OBS signals
////==============
//assign obs_bus_pdp_rdma_proc_en = op_process;
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

    property PDP_RDMA_ig__dma_IF_reading_stall__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (((dma_rd_req_vld)) && nvdla_core_rstn) |-> ((~dma_rd_req_rdy & reg2dp_op_en));
    endproperty
    // Cover 0 : "(~dma_rd_req_rdy & reg2dp_op_en)"
    FUNCPOINT_PDP_RDMA_ig__dma_IF_reading_stall__0_COV : cover property (PDP_RDMA_ig__dma_IF_reading_stall__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_ig__surf_end_stall__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_surf_end & (~dma_rd_req_rdy);
    endproperty
    // Cover 1 : "is_surf_end & (~dma_rd_req_rdy)"
    FUNCPOINT_PDP_RDMA_ig__surf_end_stall__1_COV : cover property (PDP_RDMA_ig__surf_end_stall__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_ig__split_end_stall__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_split_end & (~dma_rd_req_rdy);
    endproperty
    // Cover 2 : "is_split_end & (~dma_rd_req_rdy)"
    FUNCPOINT_PDP_RDMA_ig__split_end_stall__2_COV : cover property (PDP_RDMA_ig__split_end_stall__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_ig__cube_end_stall__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_cube_end & (~dma_rd_req_rdy);
    endproperty
    // Cover 3 : "is_cube_end & (~dma_rd_req_rdy)"
    FUNCPOINT_PDP_RDMA_ig__cube_end_stall__3_COV : cover property (PDP_RDMA_ig__cube_end_stall__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_ig__ig2eg_stall__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((ig2cq_pvld) && nvdla_core_rstn) |-> ((~ig2cq_prdy & reg2dp_op_en));
    endproperty
    // Cover 4 : "(~ig2cq_prdy & reg2dp_op_en)"
    FUNCPOINT_PDP_RDMA_ig__ig2eg_stall__4_COV : cover property (PDP_RDMA_ig__ig2eg_stall__4_cov);

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

    property PDP_RDMA_two_continuous_layer__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (mon_gap_between_layers==32'd2) & mon_op_en_pos;
    endproperty
    // Cover 5 : "(mon_gap_between_layers==32'd2) & mon_op_en_pos"
    FUNCPOINT_PDP_RDMA_two_continuous_layer__5_COV : cover property (PDP_RDMA_two_continuous_layer__5_cov);

  `endif
`endif
//VCS coverage on

//3 cycles means continuous layer

//==============
// Context Queue Interface
//==============

endmodule // NV_NVDLA_PDP_RDMA_ig



