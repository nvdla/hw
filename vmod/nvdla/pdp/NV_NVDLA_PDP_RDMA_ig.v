// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_RDMA_ig.v

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_RDMA_ig (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,eg2ig_done                    //|< i
  ,ig2cq_prdy                    //|< i
  ,pdp2cvif_rd_req_ready         //|< i
  ,pdp2mcif_rd_req_ready         //|< i
  ,reg2dp_cube_in_channel        //|< i
  ,reg2dp_cube_in_height         //|< i
  ,reg2dp_cube_in_width          //|< i
  ,reg2dp_dma_en                 //|< i
  ,reg2dp_input_data             //|< i
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
  ,pdp2cvif_rd_req_pd            //|> o
  ,pdp2cvif_rd_req_valid         //|> o
  ,pdp2mcif_rd_req_pd            //|> o
  ,pdp2mcif_rd_req_valid         //|> o
  ,reg2dp_surf_stride            //|> o
  );
input  [12:0] reg2dp_cube_in_channel;
input  [12:0] reg2dp_cube_in_height;
input  [12:0] reg2dp_cube_in_width;
input   [0:0] reg2dp_dma_en;
input   [1:0] reg2dp_input_data;
input   [3:0] reg2dp_kernel_stride_width;
input   [3:0] reg2dp_kernel_width;
input   [0:0] reg2dp_op_en;
input   [9:0] reg2dp_partial_width_in_first;
input   [9:0] reg2dp_partial_width_in_last;
input   [9:0] reg2dp_partial_width_in_mid;
input   [7:0] reg2dp_split_num;
input  [31:0] reg2dp_src_base_addr_high;
input  [26:0] reg2dp_src_base_addr_low;
input  [26:0] reg2dp_src_line_stride;
input   [0:0] reg2dp_src_ram_type;
input  [26:0] reg2dp_src_surface_stride;
output [31:0] dp2reg_d0_perf_read_stall;
output [31:0] dp2reg_d1_perf_read_stall;
output [31:0] reg2dp_surf_stride;
input         eg2ig_done;
//
// NV_NVDLA_PDP_RDMA_ig_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output        pdp2mcif_rd_req_valid;  /* data valid */
input         pdp2mcif_rd_req_ready;  /* data return handshake */
output [78:0] pdp2mcif_rd_req_pd;

output        pdp2cvif_rd_req_valid;  /* data valid */
input         pdp2cvif_rd_req_ready;  /* data return handshake */
output [78:0] pdp2cvif_rd_req_pd;

output        ig2cq_pvld;  /* data valid */
input         ig2cq_prdy;  /* data return handshake */
output [17:0] ig2cq_pd;

reg           after_op_done;
reg    [63:0] base_addr_esurf;
reg    [63:0] base_addr_line;
reg    [63:0] base_addr_split;
reg    [63:0] base_addr_width;
reg     [9:0] count_c;
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
wire          cfg_di_int16;
wire          cfg_di_int8;
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
wire   [78:0] dma_rd_req_pd;
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
wire          mon_number_of_32x1_block_in_c;
wire          mon_op_en_neg;
wire          mon_op_en_pos;
wire          mon_overlap;
wire    [9:0] number_of_32x1_block_in_c;
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
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

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
assign reg2dp_src_base_addr = {reg2dp_src_base_addr_high,reg2dp_src_base_addr_low,5'd0};

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
assign cfg_mode_split = (reg2dp_split_num != 8'd0);//~reg2dp_mode_split;

assign cfg_split_num  = reg2dp_split_num + 1'b1;

assign cfg_di_int8  = reg2dp_input_data == 0 ;
assign cfg_di_int16 = reg2dp_input_data == 1 ;

//==============
// CHANNEL Direction
// calculate how many 32x8 blocks in channel direction
//==============
always @(
  cfg_di_int8
  or cfg_channel
  or cfg_di_int16
  ) begin
    if (cfg_di_int8) begin
        number_of_byte_in_c = {1'b0,cfg_channel};
    end else if (cfg_di_int16) begin
        number_of_byte_in_c = {cfg_channel,1'b0};
    end else begin
        number_of_byte_in_c = {cfg_channel,1'b0};
    end
end
assign {mon_number_of_32x1_block_in_c,number_of_32x1_block_in_c[9:0]} = number_of_byte_in_c[14:5] + (|number_of_byte_in_c[4:0]);

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
        //width_stride = cfg_width[::range(10)];
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
    count_c <= {10{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_split_end) begin
            count_c <= 10'd0;
        end else if (is_surf_end) begin
            count_c <= count_c + 1'b1;
        end
    end
  end
end
assign is_last_c = (count_c==number_of_32x1_block_in_c - 1);

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
assign reg2dp_line_stride = {reg2dp_src_line_stride,5'd0};
assign reg2dp_surf_stride = {reg2dp_src_surface_stride,5'd0};
assign reg2dp_esurf_stride = {reg2dp_src_surface_stride,5'd0};
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
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,5'd0} + {overlap[3:0],5'd0};
                else
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,5'd0} - {overlap[3:0],5'd0};
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,5'd0};
                else
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_split + {width_stride,5'd0};
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
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,5'd0} + {overlap[3:0],5'd0};
                else
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,5'd0} - {overlap[3:0],5'd0};
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,5'd0};
                else
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_split + {width_stride,5'd0};
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
                    {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,5'd0} + {overlap[3:0],5'd0};
                else
                    {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,5'd0} - {overlap[3:0],5'd0};
            end else begin
                if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
                    {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,5'd0};
                else
                    {mon_base_addr_surf_c,base_addr_esurf} <= base_addr_split + {width_stride,5'd0};
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
                {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,5'd0} + {overlap[3:0],5'd0};
            else
                {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,5'd0} - {overlap[3:0],5'd0};
          end else begin
            if({1'b0,reg2dp_kernel_width[2:0]} < reg2dp_kernel_stride_width)
                {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,5'd0};
            else
                {mon_base_addr_split_c,base_addr_split} <= base_addr_split + {width_stride,5'd0};
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
            //req_size = ::zero_extend(cfg_lspt_width, 10, 13);
            if(reg2dp_kernel_width < reg2dp_kernel_stride_width)
                req_size = {{3{1'b0}}, cfg_lspt_width} - {8'd0,overlap[3:0]};
            else
                req_size = {{3{1'b0}}, cfg_lspt_width} + {8'd0,overlap[3:0]};
        end else begin
            //req_size = ::zero_extend(cfg_mspt_width, 10, 13);
            if(reg2dp_kernel_width < reg2dp_kernel_stride_width)
                req_size = {{3{1'b0}}, cfg_mspt_width} - {8'd0,overlap[3:0]};
            else
                req_size = {{3{1'b0}}, cfg_mspt_width} + {8'd0,overlap[3:0]};
        end
    end else
        req_size = reg2dp_cube_in_width[12:0];//cfg_width;
end
//assign {mon_dma_req_size, dma_req_size[::range(13)]} = req_size - 1'b1;
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

// PKT_PACK_WIRE( dma_read_cmd ,  dma_req_ ,  dma_rd_req_pd )
assign       dma_rd_req_pd[63:0] =     dma_req_addr[63:0];
assign       dma_rd_req_pd[78:64] =     dma_req_size[14:0];

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
//==============
// DMA Interface
//==============
//dma_rd_req_vld dma_rd_req_rdy dma_rd_req_ram_type
// rd Channel: Request 
assign cv_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_ram_type == 1'b0);
assign mc_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_ram_type == 1'b1);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_ram_type == 1'b0);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_ram_type == 1'b1);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;
assign dma_rd_req_rdy= rd_req_rdyi;
NV_NVDLA_PDP_RDMA_IG_pipe_p1 pipe_p1 (
   .nvdla_core_clk         (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn        (nvdla_core_rstn)           //|< i
  ,.dma_rd_req_pd          (dma_rd_req_pd[78:0])       //|< w
  ,.mc_dma_rd_req_vld      (mc_dma_rd_req_vld)         //|< w
  ,.mc_int_rd_req_ready    (mc_int_rd_req_ready)       //|< w
  ,.mc_dma_rd_req_rdy      (mc_dma_rd_req_rdy)         //|> w
  ,.mc_int_rd_req_pd       (mc_int_rd_req_pd[78:0])    //|> w
  ,.mc_int_rd_req_valid    (mc_int_rd_req_valid)       //|> w
  );
NV_NVDLA_PDP_RDMA_IG_pipe_p2 pipe_p2 (
   .nvdla_core_clk         (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn        (nvdla_core_rstn)           //|< i
  ,.cv_dma_rd_req_vld      (cv_dma_rd_req_vld)         //|< w
  ,.cv_int_rd_req_ready    (cv_int_rd_req_ready)       //|< w
  ,.dma_rd_req_pd          (dma_rd_req_pd[78:0])       //|< w
  ,.cv_dma_rd_req_rdy      (cv_dma_rd_req_rdy)         //|> w
  ,.cv_int_rd_req_pd       (cv_int_rd_req_pd[78:0])    //|> w
  ,.cv_int_rd_req_valid    (cv_int_rd_req_valid)       //|> w
  );

assign mc_int_rd_req_valid_d0 = mc_int_rd_req_valid;
assign mc_int_rd_req_ready = mc_int_rd_req_ready_d0;
assign mc_int_rd_req_pd_d0[78:0] = mc_int_rd_req_pd[78:0];
NV_NVDLA_PDP_RDMA_IG_pipe_p3 pipe_p3 (
   .nvdla_core_clk         (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn        (nvdla_core_rstn)           //|< i
  ,.mc_int_rd_req_pd_d0    (mc_int_rd_req_pd_d0[78:0]) //|< w
  ,.mc_int_rd_req_ready_d1 (mc_int_rd_req_ready_d1)    //|< w
  ,.mc_int_rd_req_valid_d0 (mc_int_rd_req_valid_d0)    //|< w
  ,.mc_int_rd_req_pd_d1    (mc_int_rd_req_pd_d1[78:0]) //|> w
  ,.mc_int_rd_req_ready_d0 (mc_int_rd_req_ready_d0)    //|> w
  ,.mc_int_rd_req_valid_d1 (mc_int_rd_req_valid_d1)    //|> w
  );
assign pdp2mcif_rd_req_valid = mc_int_rd_req_valid_d1;
assign mc_int_rd_req_ready_d1 = pdp2mcif_rd_req_ready;
assign pdp2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d1[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
NV_NVDLA_PDP_RDMA_IG_pipe_p4 pipe_p4 (
   .nvdla_core_clk         (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn        (nvdla_core_rstn)           //|< i
  ,.cv_int_rd_req_pd_d0    (cv_int_rd_req_pd_d0[78:0]) //|< w
  ,.cv_int_rd_req_ready_d1 (cv_int_rd_req_ready_d1)    //|< w
  ,.cv_int_rd_req_valid_d0 (cv_int_rd_req_valid_d0)    //|< w
  ,.cv_int_rd_req_pd_d1    (cv_int_rd_req_pd_d1[78:0]) //|> w
  ,.cv_int_rd_req_ready_d0 (cv_int_rd_req_ready_d0)    //|> w
  ,.cv_int_rd_req_valid_d1 (cv_int_rd_req_valid_d1)    //|> w
  );
assign pdp2cvif_rd_req_valid = cv_int_rd_req_valid_d1;
assign cv_int_rd_req_ready_d1 = pdp2cvif_rd_req_ready;
assign pdp2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d1[78:0];

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



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_PDP_RDMA_IG_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_req_pd
  ,mc_dma_rd_req_vld
  ,mc_int_rd_req_ready
  ,mc_dma_rd_req_rdy
  ,mc_int_rd_req_pd
  ,mc_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] dma_rd_req_pd;
input         mc_dma_rd_req_vld;
input         mc_int_rd_req_ready;
output        mc_dma_rd_req_rdy;
output [78:0] mc_int_rd_req_pd;
output        mc_int_rd_req_valid;
reg           mc_dma_rd_req_rdy;
reg    [78:0] mc_int_rd_req_pd;
reg           mc_int_rd_req_valid;
reg    [78:0] p1_pipe_data;
reg    [78:0] p1_pipe_rand_data;
reg           p1_pipe_rand_ready;
reg           p1_pipe_rand_valid;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [78:0] p1_skid_data;
reg    [78:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     mc_dma_rd_req_vld
  or p1_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or mc_dma_rd_req_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && mc_dma_rd_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or mc_int_rd_req_ready
  or p1_pipe_data
  ) begin
  mc_int_rd_req_valid = p1_pipe_valid;
  p1_pipe_ready = mc_int_rd_req_ready;
  mc_int_rd_req_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_RDMA_IG_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_PDP_RDMA_IG_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_dma_rd_req_vld
  ,cv_int_rd_req_ready
  ,dma_rd_req_pd
  ,cv_dma_rd_req_rdy
  ,cv_int_rd_req_pd
  ,cv_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         cv_dma_rd_req_vld;
input         cv_int_rd_req_ready;
input  [78:0] dma_rd_req_pd;
output        cv_dma_rd_req_rdy;
output [78:0] cv_int_rd_req_pd;
output        cv_int_rd_req_valid;
reg           cv_dma_rd_req_rdy;
reg    [78:0] cv_int_rd_req_pd;
reg           cv_int_rd_req_valid;
reg    [78:0] p2_pipe_data;
reg    [78:0] p2_pipe_rand_data;
reg           p2_pipe_rand_ready;
reg           p2_pipe_rand_valid;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [78:0] p2_skid_data;
reg    [78:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     cv_dma_rd_req_vld
  or p2_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_ig_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or cv_dma_rd_req_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && cv_dma_rd_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or cv_int_rd_req_ready
  or p2_pipe_data
  ) begin
  cv_int_rd_req_valid = p2_pipe_valid;
  p2_pipe_ready = cv_int_rd_req_ready;
  cv_int_rd_req_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_RDMA_IG_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is -rand none mc_int_rd_req_pd_d1[78:0] (mc_int_rd_req_valid_d1,mc_int_rd_req_ready_d1) <= mc_int_rd_req_pd_d0[78:0] (mc_int_rd_req_valid_d0,mc_int_rd_req_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_RDMA_IG_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mc_int_rd_req_pd_d0
  ,mc_int_rd_req_ready_d1
  ,mc_int_rd_req_valid_d0
  ,mc_int_rd_req_pd_d1
  ,mc_int_rd_req_ready_d0
  ,mc_int_rd_req_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] mc_int_rd_req_pd_d0;
input         mc_int_rd_req_ready_d1;
input         mc_int_rd_req_valid_d0;
output [78:0] mc_int_rd_req_pd_d1;
output        mc_int_rd_req_ready_d0;
output        mc_int_rd_req_valid_d1;
reg    [78:0] mc_int_rd_req_pd_d1;
reg           mc_int_rd_req_ready_d0;
reg           mc_int_rd_req_valid_d1;
reg    [78:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [78:0] p3_skid_data;
reg    [78:0] p3_skid_pipe_data;
reg           p3_skid_pipe_ready;
reg           p3_skid_pipe_valid;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
//## pipe (3) skid buffer
always @(
  mc_int_rd_req_valid_d0
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = mc_int_rd_req_valid_d0 && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    mc_int_rd_req_ready_d0 <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  mc_int_rd_req_ready_d0 <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? mc_int_rd_req_pd_d0[78:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or mc_int_rd_req_valid_d0
  or p3_skid_valid
  or mc_int_rd_req_pd_d0
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? mc_int_rd_req_valid_d0 : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? mc_int_rd_req_pd_d0[78:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or mc_int_rd_req_ready_d1
  or p3_pipe_data
  ) begin
  mc_int_rd_req_valid_d1 = p3_pipe_valid;
  p3_pipe_ready = mc_int_rd_req_ready_d1;
  mc_int_rd_req_pd_d1[78:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid_d1^mc_int_rd_req_ready_d1^mc_int_rd_req_valid_d0^mc_int_rd_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_req_valid_d0 && !mc_int_rd_req_ready_d0), (mc_int_rd_req_valid_d0), (mc_int_rd_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_RDMA_IG_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is -rand none cv_int_rd_req_pd_d1[78:0] (cv_int_rd_req_valid_d1,cv_int_rd_req_ready_d1) <= cv_int_rd_req_pd_d0[78:0] (cv_int_rd_req_valid_d0,cv_int_rd_req_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_RDMA_IG_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_int_rd_req_pd_d0
  ,cv_int_rd_req_ready_d1
  ,cv_int_rd_req_valid_d0
  ,cv_int_rd_req_pd_d1
  ,cv_int_rd_req_ready_d0
  ,cv_int_rd_req_valid_d1
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] cv_int_rd_req_pd_d0;
input         cv_int_rd_req_ready_d1;
input         cv_int_rd_req_valid_d0;
output [78:0] cv_int_rd_req_pd_d1;
output        cv_int_rd_req_ready_d0;
output        cv_int_rd_req_valid_d1;
reg    [78:0] cv_int_rd_req_pd_d1;
reg           cv_int_rd_req_ready_d0;
reg           cv_int_rd_req_valid_d1;
reg    [78:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
reg           p4_skid_catch;
reg    [78:0] p4_skid_data;
reg    [78:0] p4_skid_pipe_data;
reg           p4_skid_pipe_ready;
reg           p4_skid_pipe_valid;
reg           p4_skid_ready;
reg           p4_skid_ready_flop;
reg           p4_skid_valid;
//## pipe (4) skid buffer
always @(
  cv_int_rd_req_valid_d0
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = cv_int_rd_req_valid_d0 && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    cv_int_rd_req_ready_d0 <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  cv_int_rd_req_ready_d0 <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? cv_int_rd_req_pd_d0[78:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or cv_int_rd_req_valid_d0
  or p4_skid_valid
  or cv_int_rd_req_pd_d0
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? cv_int_rd_req_valid_d0 : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? cv_int_rd_req_pd_d0[78:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or cv_int_rd_req_ready_d1
  or p4_pipe_data
  ) begin
  cv_int_rd_req_valid_d1 = p4_pipe_valid;
  p4_pipe_ready = cv_int_rd_req_ready_d1;
  cv_int_rd_req_pd_d1[78:0] = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid_d1^cv_int_rd_req_ready_d1^cv_int_rd_req_valid_d0^cv_int_rd_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_req_valid_d0 && !cv_int_rd_req_ready_d0), (cv_int_rd_req_valid_d0), (cv_int_rd_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_RDMA_IG_pipe_p4


