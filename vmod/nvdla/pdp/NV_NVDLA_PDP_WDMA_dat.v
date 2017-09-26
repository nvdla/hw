// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_WDMA_dat.v

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_WDMA_dat (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,dat0_fifo0_rd_prdy             //|< i
  ,dat0_fifo1_rd_prdy             //|< i
  ,dat0_fifo2_rd_prdy             //|< i
  ,dat0_fifo3_rd_prdy             //|< i
  ,dat1_fifo0_rd_prdy             //|< i
  ,dat1_fifo1_rd_prdy             //|< i
  ,dat1_fifo2_rd_prdy             //|< i
  ,dat1_fifo3_rd_prdy             //|< i
  ,dp2wdma_pd                     //|< i
  ,dp2wdma_vld                    //|< i
  ,op_load                        //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_cube_out_channel        //|< i
  ,reg2dp_cube_out_height         //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_input_data              //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_split_num               //|< i
  ,wdma_done                      //|< i
  ,dat0_fifo0_rd_pd               //|> o
  ,dat0_fifo0_rd_pvld             //|> o
  ,dat0_fifo1_rd_pd               //|> o
  ,dat0_fifo1_rd_pvld             //|> o
  ,dat0_fifo2_rd_pd               //|> o
  ,dat0_fifo2_rd_pvld             //|> o
  ,dat0_fifo3_rd_pd               //|> o
  ,dat0_fifo3_rd_pvld             //|> o
  ,dat1_fifo0_rd_pd               //|> o
  ,dat1_fifo0_rd_pvld             //|> o
  ,dat1_fifo1_rd_pd               //|> o
  ,dat1_fifo1_rd_pvld             //|> o
  ,dat1_fifo2_rd_pd               //|> o
  ,dat1_fifo2_rd_pvld             //|> o
  ,dat1_fifo3_rd_pd               //|> o
  ,dat1_fifo3_rd_pvld             //|> o
  ,dp2wdma_rdy                    //|> o
  );
//&Catenate "NV_NVDLA_PDP_wdma_ports.v";
input  [12:0] reg2dp_cube_out_channel;
input  [12:0] reg2dp_cube_out_height;
input  [12:0] reg2dp_cube_out_width;
input   [1:0] reg2dp_input_data;
input   [9:0] reg2dp_partial_width_out_first;
input   [9:0] reg2dp_partial_width_out_last;
input   [9:0] reg2dp_partial_width_out_mid;
input   [7:0] reg2dp_split_num;
input  [63:0] dp2wdma_pd;
input         dp2wdma_vld;
output        dp2wdma_rdy;
//&Ports /^spt/;
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] pwrbus_ram_pd;
input         dat0_fifo0_rd_prdy;
input         dat0_fifo1_rd_prdy;
input         dat0_fifo2_rd_prdy;
input         dat0_fifo3_rd_prdy;
input         dat1_fifo0_rd_prdy;
input         dat1_fifo1_rd_prdy;
input         dat1_fifo2_rd_prdy;
input         dat1_fifo3_rd_prdy;
output [63:0] dat0_fifo0_rd_pd;
output        dat0_fifo0_rd_pvld;
output [63:0] dat0_fifo1_rd_pd;
output        dat0_fifo1_rd_pvld;
output [63:0] dat0_fifo2_rd_pd;
output        dat0_fifo2_rd_pvld;
output [63:0] dat0_fifo3_rd_pd;
output        dat0_fifo3_rd_pvld;
output [63:0] dat1_fifo0_rd_pd;
output        dat1_fifo0_rd_pvld;
output [63:0] dat1_fifo1_rd_pd;
output        dat1_fifo1_rd_pvld;
output [63:0] dat1_fifo2_rd_pd;
output        dat1_fifo2_rd_pvld;
output [63:0] dat1_fifo3_rd_pd;
output        dat1_fifo3_rd_pvld;

input wdma_done;
input op_load;
reg           cfg_do_fp16;
reg           cfg_do_int16;
reg           cfg_do_int8;
reg     [1:0] count_b;
reg    [12:0] count_h;
reg     [9:0] count_surf;
reg    [12:0] count_w;
reg     [7:0] count_wg;
reg           mon_nan_in_count;
reg    [31:0] nan_in_count;
reg    [31:0] nan_out_num;
reg    [31:0] nan_output_num;
reg    [14:0] size_of_byte_in_c;
wire          cfg_mode_split;
wire   [13:0] cube_out_channel_use;
wire   [63:0] dat0_fifo0_wr_pd;
wire          dat0_fifo0_wr_prdy;
wire          dat0_fifo0_wr_pvld;
wire   [63:0] dat0_fifo1_wr_pd;
wire          dat0_fifo1_wr_prdy;
wire          dat0_fifo1_wr_pvld;
wire   [63:0] dat0_fifo2_wr_pd;
wire          dat0_fifo2_wr_prdy;
wire          dat0_fifo2_wr_pvld;
wire   [63:0] dat0_fifo3_wr_pd;
wire          dat0_fifo3_wr_prdy;
wire          dat0_fifo3_wr_pvld;
wire   [63:0] dat1_fifo0_wr_pd;
wire          dat1_fifo0_wr_prdy;
wire          dat1_fifo0_wr_pvld;
wire   [63:0] dat1_fifo1_wr_pd;
wire          dat1_fifo1_wr_prdy;
wire          dat1_fifo1_wr_pvld;
wire   [63:0] dat1_fifo2_wr_pd;
wire          dat1_fifo2_wr_prdy;
wire          dat1_fifo2_wr_pvld;
wire   [63:0] dat1_fifo3_wr_pd;
wire          dat1_fifo3_wr_prdy;
wire          dat1_fifo3_wr_pvld;
wire          dat_fifo_wr_prdy;
wire          dat_fifo_wr_pvld;
wire    [3:0] dat_is_nan;
wire   [63:0] dp2wdma_dat_pd;
wire   [63:0] dp2wdma_data;
wire   [15:0] fp16_in_pd_0;
wire   [15:0] fp16_in_pd_1;
wire   [15:0] fp16_in_pd_2;
wire   [15:0] fp16_in_pd_3;
wire          is_blk_end;
wire          is_cube_end;
wire          is_first_wg;
wire          is_fspt;
wire          is_last_b;
wire          is_last_h;
wire          is_last_surf;
wire          is_last_w;
wire          is_last_wg;
wire          is_line_end;
wire          is_lspt;
wire          is_mspt;
wire          is_split_end;
wire          is_surf_end;
wire          mon_size_of_surf;
wire    [2:0] nan_num_in_8byte;
wire    [1:0] nan_num_in_8byte_0;
wire    [1:0] nan_num_in_8byte_1;
wire    [1:0] size_of_b;
wire    [9:0] size_of_surf;
wire   [10:0] size_of_surf_use;
wire   [12:0] size_of_width;
wire    [9:0] split_size_of_width;
wire          spt_dat_accept;
wire    [1:0] spt_posb;
wire          spt_posw;
wire          wdma_loadin;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
// SPLIT MODE

assign cfg_mode_split = (reg2dp_split_num!=0);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_do_int8 <= 1'b0;
  end else begin
  cfg_do_int8 <= reg2dp_input_data== 0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_do_int16 <= 1'b0;
  end else begin
  cfg_do_int16 <= reg2dp_input_data== 2'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_do_fp16 <= 1'b0;
  end else begin
  cfg_do_fp16 <= reg2dp_input_data== 2'h2;
  end
end
 
//==============
//NaN counter
//==============
assign wdma_loadin = spt_dat_accept;//dp2wdma_vld & dp2wdma_rdy;
assign fp16_in_pd_0 = dp2wdma_pd[15:0];
assign fp16_in_pd_1 = dp2wdma_pd[31:16];
assign fp16_in_pd_2 = dp2wdma_pd[47:32];
assign fp16_in_pd_3 = dp2wdma_pd[63:48];
assign dat_is_nan[0] = cfg_do_fp16 & (&fp16_in_pd_0[14:10]) & (|fp16_in_pd_0[9:0]);
assign dat_is_nan[1] = cfg_do_fp16 & (&fp16_in_pd_1[14:10]) & (|fp16_in_pd_1[9:0]);
assign dat_is_nan[2] = cfg_do_fp16 & (&fp16_in_pd_2[14:10]) & (|fp16_in_pd_2[9:0]);
assign dat_is_nan[3] = cfg_do_fp16 & (&fp16_in_pd_3[14:10]) & (|fp16_in_pd_3[9:0]);

assign nan_num_in_8byte_0[1:0] = dat_is_nan[0] + dat_is_nan[1];
assign nan_num_in_8byte_1[1:0] = dat_is_nan[2] + dat_is_nan[3];
assign nan_num_in_8byte[2:0]   = nan_num_in_8byte_0 + nan_num_in_8byte_1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_nan_in_count,nan_in_count[31:0]} <= {33{1'b0}};
  end else begin
    if(wdma_loadin) begin
        if(is_cube_end)
            {mon_nan_in_count,nan_in_count[31:0]} <= 33'd0;
        else
            {mon_nan_in_count,nan_in_count[31:0]} <= nan_in_count + nan_num_in_8byte;
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
  nv_assert_never #(0,0,"PDP WDMA: no overflow is allowed")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mon_nan_in_count); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    nan_out_num <= {32{1'b0}};
  end else begin
    if(is_cube_end)
        nan_out_num <= nan_in_count;
  end
end
//assign wdma_done = dp2reg_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    nan_output_num <= {32{1'b0}};
  end else begin
    if(wdma_done) begin
            nan_output_num <= nan_out_num;
    end
  end
end

//==============
// CUBE DRAW
//==============
assign is_blk_end   = is_last_b;
assign is_line_end  = is_blk_end & is_last_w;
assign is_surf_end  = is_line_end & is_last_h;
assign is_split_end = is_surf_end & is_last_surf;
assign is_cube_end  = is_split_end & is_last_wg;

// WIDTH COUNT: in width direction, indidate one block 
assign split_size_of_width = is_fspt ? reg2dp_partial_width_out_first :
                             is_lspt ? reg2dp_partial_width_out_last :
                             is_mspt ? reg2dp_partial_width_out_mid :  {10{`x_or_0}};

assign size_of_width = cfg_mode_split ? {3'd0,split_size_of_width} : reg2dp_cube_out_width;

// WG: WidthGroup, including one FSPT, one LSPT, and many MSPT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_wg <= {8{1'b0}};
  end else begin
    if (op_load) begin
        count_wg <= 0;
    end else if (spt_dat_accept) begin
        if (is_cube_end) begin
            count_wg <= 0;
        end else if (is_split_end) begin
            count_wg <= count_wg + 1;
        end
    end
  end
end
assign is_last_wg  = (count_wg==reg2dp_split_num);
assign is_first_wg = (count_wg==0);

assign is_fspt = cfg_mode_split & is_first_wg;
assign is_lspt = cfg_mode_split & is_last_wg;
assign is_mspt = cfg_mode_split & !is_fspt & !is_lspt;

assign cube_out_channel_use[13:0] = reg2dp_cube_out_channel[12:0] + 1'b1;
always @(
  cfg_do_int8
  or cube_out_channel_use
  or cfg_do_int16
  ) begin
    if (cfg_do_int8) begin
        size_of_byte_in_c = {1'b0,cube_out_channel_use};
    end else if (cfg_do_int16) begin
        size_of_byte_in_c = {cube_out_channel_use,1'b0};
    end else begin
        size_of_byte_in_c = {cube_out_channel_use,1'b0};
    end
end
//assign size_of_surf = size_of_byte_in_c[::range(14-5,5)]; // include the last unaligned channels
//assign size_of_b = is_last_surf ? size_of_byte_in_c[::range(2,3)] : 2'd3;
assign size_of_surf_use[10:0] = size_of_byte_in_c[14:5] + (|size_of_byte_in_c[4:0]); // include the last unaligned channels
assign {mon_size_of_surf,size_of_surf[9:0]} = size_of_surf_use - 1'b1;
assign size_of_b =  2'd3;

//================================================================
// C direction: count_b + count_surf
// count_b: in each W in line, will go 4 step in c first
// count_surf: when one surf with 4c is done, will go to next surf
//================================================================
//==============
// COUNT B
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_b <= {2{1'b0}};
  end else begin
    if (spt_dat_accept) begin
        if (is_blk_end) begin
            count_b <= 0;
        end else begin
            count_b <= count_b + 1;
        end
    end
  end
end
assign is_last_b = (count_b==size_of_b);

//==============
// COUNT W
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {13{1'b0}};
  end else begin
    if (spt_dat_accept) begin
        if (is_line_end) begin
            count_w <= 0;
        end else if (is_blk_end) begin
            count_w <= count_w + 1;
        end
    end
  end
end
assign is_last_w = (count_w==size_of_width);

//==============
// COUNT SURF
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_surf <= {10{1'b0}};
  end else begin
    if (spt_dat_accept) begin
        if (is_split_end) begin
            count_surf <= 0;
        end else if (is_surf_end) begin
            count_surf <= count_surf + 1;
        end
    end
  end
end
assign is_last_surf = (count_surf==size_of_surf);

//==============
// COUNT HEIGHT 
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (spt_dat_accept) begin
        if (is_surf_end) begin
            count_h <= 0;
        end else if (is_line_end) begin
            count_h <= count_h + 1;
        end
    end
  end
end
assign is_last_h = (count_h==reg2dp_cube_out_height);

//==============
// spt information gen
//==============
assign spt_posb = count_b;
assign spt_posw = count_w[0];

//==============
// Data FIFO WRITE contrl
//==============

assign dp2wdma_data[63:0] = dp2wdma_pd[63:0];

// PKT_PACK_WIRE( pdp_dp2wdma_dat , dp2wdma_ , dp2wdma_dat_pd )
assign      dp2wdma_dat_pd[63:0] =    dp2wdma_data[63:0];
assign dat_fifo_wr_pvld = dp2wdma_vld;
assign dp2wdma_rdy = dat_fifo_wr_prdy;

// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat0_fifo0_wr_pvld = dat_fifo_wr_pvld & (spt_posw==0) & (spt_posb == 0);
assign dat0_fifo0_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat0_fifo0 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat0_fifo0_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat0_fifo0_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat0_fifo0_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat0_fifo0_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat0_fifo0_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat0_fifo0_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo0_wr_prdy & !dat0_fifo0_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo0_wr_prdy & !dat0_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat0_fifo1_wr_pvld = dat_fifo_wr_pvld & (spt_posw==0) & (spt_posb == 1);
assign dat0_fifo1_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat0_fifo1 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat0_fifo1_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat0_fifo1_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat0_fifo1_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat0_fifo1_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat0_fifo1_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat0_fifo1_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo0_wr_prdy & !dat0_fifo1_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo1_wr_prdy & !dat0_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat0_fifo2_wr_pvld = dat_fifo_wr_pvld & (spt_posw==0) & (spt_posb == 2);
assign dat0_fifo2_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat0_fifo2 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat0_fifo2_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat0_fifo2_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat0_fifo2_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat0_fifo2_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat0_fifo2_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat0_fifo2_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo0_wr_prdy & !dat0_fifo2_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo2_wr_prdy & !dat0_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat0_fifo3_wr_pvld = dat_fifo_wr_pvld & (spt_posw==0) & (spt_posb == 3);
assign dat0_fifo3_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat0_fifo3 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat0_fifo3_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat0_fifo3_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat0_fifo3_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat0_fifo3_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat0_fifo3_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat0_fifo3_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo0_wr_prdy & !dat0_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, dat0_fifo3_wr_prdy & !dat0_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat1_fifo0_wr_pvld = dat_fifo_wr_pvld & (spt_posw==1) & (spt_posb == 0);
assign dat1_fifo0_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat1_fifo0 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat1_fifo0_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat1_fifo0_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat1_fifo0_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat1_fifo0_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat1_fifo0_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat1_fifo0_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo0_wr_prdy & !dat1_fifo0_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo0_wr_prdy & !dat1_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat1_fifo1_wr_pvld = dat_fifo_wr_pvld & (spt_posw==1) & (spt_posb == 1);
assign dat1_fifo1_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat1_fifo1 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat1_fifo1_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat1_fifo1_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat1_fifo1_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat1_fifo1_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat1_fifo1_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat1_fifo1_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_12x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo0_wr_prdy & !dat1_fifo1_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_13x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo1_wr_prdy & !dat1_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat1_fifo2_wr_pvld = dat_fifo_wr_pvld & (spt_posw==1) & (spt_posb == 2);
assign dat1_fifo2_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat1_fifo2 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat1_fifo2_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat1_fifo2_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat1_fifo2_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat1_fifo2_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat1_fifo2_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat1_fifo2_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo0_wr_prdy & !dat1_fifo2_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_15x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo2_wr_prdy & !dat1_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DATA FIFO WRITE SIDE
// is last_b, then fifo idx large than count_b will need a push to fill in fake data to make up a full 32B(8Bx4)
assign dat1_fifo3_wr_pvld = dat_fifo_wr_pvld & (spt_posw==1) & (spt_posb == 3);
assign dat1_fifo3_wr_pd   = dp2wdma_dat_pd[63:0];

// DATA FIFO INSTANCE
NV_NVDLA_PDP_WDMA_DAT_fifo u_dat1_fifo3 (
   .nvdla_core_clk   (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)        //|< i
  ,.dat_fifo_wr_prdy (dat1_fifo3_wr_prdy)     //|> w
  ,.dat_fifo_wr_pvld (dat1_fifo3_wr_pvld)     //|< w
  ,.dat_fifo_wr_pd   (dat1_fifo3_wr_pd[63:0]) //|< w
  ,.dat_fifo_rd_prdy (dat1_fifo3_rd_prdy)     //|< i
  ,.dat_fifo_rd_pvld (dat1_fifo3_rd_pvld)     //|> o
  ,.dat_fifo_rd_pd   (dat1_fifo3_rd_pd[63:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"when the first fifo is ready, all the left fifo should be ready")      zzz_assert_never_16x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo0_wr_prdy & !dat1_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"when the last fifo is not ready, all the previous fifo should not be ready")      zzz_assert_never_17x (nvdla_core_clk, `ASSERT_RESET, dat1_fifo3_wr_prdy & !dat1_fifo3_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dat_fifo_wr_prdy = ( dat0_fifo0_wr_prdy & (spt_posw==0) & (spt_posb == 0) ) 
| ( dat0_fifo1_wr_prdy & (spt_posw==0) & (spt_posb == 1) ) 
| ( dat0_fifo2_wr_prdy & (spt_posw==0) & (spt_posb == 2) ) 
| ( dat0_fifo3_wr_prdy & (spt_posw==0) & (spt_posb == 3) ) 
| ( dat1_fifo0_wr_prdy & (spt_posw==1) & (spt_posb == 0) ) 
| ( dat1_fifo1_wr_prdy & (spt_posw==1) & (spt_posb == 1) ) 
| ( dat1_fifo2_wr_prdy & (spt_posw==1) & (spt_posb == 2) ) 
| ( dat1_fifo3_wr_prdy & (spt_posw==1) & (spt_posb == 3) );
assign spt_dat_accept = dat_fifo_wr_pvld & dat_fifo_wr_prdy;

////==============
////OBS signals
////==============
//assign obs_bus_pdp_wdma_wr_00_vld = dat0_fifo0_wr_pvld; 
//assign obs_bus_pdp_wdma_wr_10_vld = dat1_fifo0_wr_pvld;
//assign obs_bus_pdp_wdma_rd_0x_rdy = dat0_fifo0_rd_prdy;
//assign obs_bus_pdp_wdma_rd_1x_rdy = dat1_fifo0_rd_prdy;

endmodule // NV_NVDLA_PDP_WDMA_dat

// -w 64, 8byte each fifo
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_WDMA_DAT_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dat_fifo_wr -rd_pipebus dat_fifo_rd -rand_none -rd_reg -ram_bypass -d 3 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_WDMA_DAT_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_prdy
    , dat_fifo_wr_pvld
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dat_fifo_wr_prdy;
input         dat_fifo_wr_pvld;
input  [63:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [63:0] dat_fifo_rd_pd;
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
reg        dat_fifo_wr_busy_int;		        	// copy for internal use
assign     dat_fifo_wr_prdy = !dat_fifo_wr_busy_int;
assign       wr_reserving = dat_fifo_wr_pvld && !dat_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] dat_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_busy_int <=  1'b0;
        dat_fifo_wr_count <=  2'd0;
    end else begin
	dat_fifo_wr_busy_int <=  dat_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg  [1:0] dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  (dat_fifo_wr_adr == 2'd2) ? 2'd0 : (dat_fifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 2'd3 : dat_fifo_rd_adr )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (dat_fifo_rd_adr == 2'd2) ? 2'd0 : (dat_fifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {2{`x_or_0}};
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

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [1:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [63:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {64{`x_or_0}};
    end
    //synopsys translate_on

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dat_fifo_wr_pvld && !dat_fifo_wr_busy_int) || (dat_fifo_wr_busy_int != dat_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_WDMA_DAT_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_WDMA_DAT_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_WDMA_DAT_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_WDMA_DAT_fifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, dat_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_WDMA_DAT_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_WDMA_DAT_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64 (
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
input  [63:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [63:0] dout;

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


wire [63:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [63:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [63:0] ram_ff0;
reg [63:0] ram_ff1;
reg [63:0] ram_ff2;

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
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [63:0] Di0;
input  [1:0] Ra0;
output [63:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 64'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [63:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [63:0] Q0 = mem[0];
wire [63:0] Q1 = mem[1];
wire [63:0] Q2 = mem[2];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64] }
endmodule // vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64

//vmw: Memory vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64
//vmw: Address-size 2
//vmw: Data-size 64
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[63:0] data0[63:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[63:0] data1[63:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_PDP_WDMA_DAT_fifo_flopram_rwsa_3x64
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

