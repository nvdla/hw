// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_DAT_in.v

#include "NV_NVDLA_SDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_WDMA_DAT_in (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,pwrbus_ram_pd                //|< i
  ,op_load                      //|< i
  ,cmd2dat_spt_pd               //|< i
  ,cmd2dat_spt_pvld             //|< i
  ,cmd2dat_spt_prdy             //|> o
  ,sdp_dp2wdma_pd               //|< i
  ,sdp_dp2wdma_valid            //|< i
  ,sdp_dp2wdma_ready            //|> o
  ,dfifo0_rd_prdy               //|< i
  ,dfifo1_rd_prdy               //|< i
  ,dfifo2_rd_prdy               //|< i
  ,dfifo3_rd_prdy               //|< i
  ,dfifo0_rd_pd                 //|> o
  ,dfifo0_rd_pvld               //|> o
  ,dfifo1_rd_pd                 //|> o
  ,dfifo1_rd_pvld               //|> o
  ,dfifo2_rd_pd                 //|> o
  ,dfifo2_rd_pvld               //|> o
  ,dfifo3_rd_pd                 //|> o
  ,dfifo3_rd_pvld               //|> o
  ,reg2dp_batch_number          //|< i
  ,reg2dp_winograd              //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_width                 //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_out_precision         //|< i
  ,dp2reg_status_nan_output_num //|> o
  );
//
// NV_NVDLA_SDP_WDMA_DAT_in_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;
input          op_load;

input         cmd2dat_spt_pvld;  
output        cmd2dat_spt_prdy;  
input  [14:0] cmd2dat_spt_pd;

input          sdp_dp2wdma_valid;  
output         sdp_dp2wdma_ready;  
input  [AM_DW-1:0] sdp_dp2wdma_pd;

output         dfifo0_rd_pvld;  
input          dfifo0_rd_prdy; 
output [AM_DW-1:0] dfifo0_rd_pd;

output         dfifo1_rd_pvld; 
input          dfifo1_rd_prdy; 
output [AM_DW-1:0] dfifo1_rd_pd;

output         dfifo2_rd_pvld; 
input          dfifo2_rd_prdy; 
output [AM_DW-1:0] dfifo2_rd_pd;

output         dfifo3_rd_pvld; 
input          dfifo3_rd_prdy; 
output [AM_DW-1:0] dfifo3_rd_pd;

input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_height;
input    [1:0] reg2dp_out_precision;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
input          reg2dp_winograd;
output  [31:0] dp2reg_status_nan_output_num;

wire           cfg_di_8;
wire           cfg_do_16;
wire           cfg_do_8;
wire           cfg_do_fp16;
wire           cfg_do_int16;
wire           cfg_mode_1x1_pack;
wire           cfg_mode_batch;
wire           cfg_mode_winograd;
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
wire           cfg_mode_8to16;
reg            mode_8to16_flag_twin;
#endif
wire   [AM_DW-1:0] dp2wdma_data;
wire   [AM_DW-1:0] dp2wdma_data_16;
wire   [AM_DW-1:0] dp2wdma_data_8;
#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
wire    [15:0] dat16_byte0;
wire    [15:0] dat16_byte1;
wire    [15:0] dat16_byte10;
wire    [15:0] dat16_byte11;
wire    [15:0] dat16_byte12;
wire    [15:0] dat16_byte13;
wire    [15:0] dat16_byte14;
wire    [15:0] dat16_byte15;
wire    [15:0] dat16_byte2;
wire    [15:0] dat16_byte3;
wire    [15:0] dat16_byte4;
wire    [15:0] dat16_byte5;
wire    [15:0] dat16_byte6;
wire    [15:0] dat16_byte7;
wire    [15:0] dat16_byte8;
wire    [15:0] dat16_byte9;
wire     [4:0] data_byte0_expo;
wire     [9:0] data_byte0_mant;
wire     [4:0] data_byte10_expo;
wire     [9:0] data_byte10_mant;
wire     [4:0] data_byte11_expo;
wire     [9:0] data_byte11_mant;
wire     [4:0] data_byte12_expo;
wire     [9:0] data_byte12_mant;
wire     [4:0] data_byte13_expo;
wire     [9:0] data_byte13_mant;
wire     [4:0] data_byte14_expo;
wire     [9:0] data_byte14_mant;
wire     [4:0] data_byte15_expo;
wire     [9:0] data_byte15_mant;
wire     [4:0] data_byte1_expo;
wire     [9:0] data_byte1_mant;
wire     [4:0] data_byte2_expo;
wire     [9:0] data_byte2_mant;
wire     [4:0] data_byte3_expo;
wire     [9:0] data_byte3_mant;
wire     [4:0] data_byte4_expo;
wire     [9:0] data_byte4_mant;
wire     [4:0] data_byte5_expo;
wire     [9:0] data_byte5_mant;
wire     [4:0] data_byte6_expo;
wire     [9:0] data_byte6_mant;
wire     [4:0] data_byte7_expo;
wire     [9:0] data_byte7_mant;
wire     [4:0] data_byte8_expo;
wire     [9:0] data_byte8_mant;
wire     [4:0] data_byte9_expo;
wire     [9:0] data_byte9_mant;
wire           is_data_byte0_nan;
wire           is_data_byte10_nan;
wire           is_data_byte11_nan;
wire           is_data_byte12_nan;
wire           is_data_byte13_nan;
wire           is_data_byte14_nan;
wire           is_data_byte15_nan;
wire           is_data_byte1_nan;
wire           is_data_byte2_nan;
wire           is_data_byte3_nan;
wire           is_data_byte4_nan;
wire           is_data_byte5_nan;
wire           is_data_byte6_nan;
wire           is_data_byte7_nan;
wire           is_data_byte8_nan;
wire           is_data_byte9_nan;
wire           nan_output_cen;
wire    [31:0] nan_output_cnt_add;
wire           nan_output_cnt_add_c;
reg     [31:0] nan_output_cnt;
wire    [31:0] nan_output_cnt_nxt;
wire     [4:0] nan_output_num;
#endif
wire           cmd2dat_spt_odd;
wire    [13:0] cmd2dat_spt_size;
reg     [13:0] spt_size;
reg            spt_vld;
wire           spt_rdy;
wire           in_dat_accept;
wire           in_dat_rdy;
wire           is_last_beat;
reg     [13:0] beat_count;
reg            dfifo0_wr_en;
reg            dfifo1_wr_en;
reg            dfifo2_wr_en;
reg            dfifo3_wr_en;
wire   [AM_DW-1:0] dfifo0_wr_pd;
wire           dfifo0_wr_prdy;
wire           dfifo0_wr_pvld;
wire           dfifo0_wr_rdy;
wire   [AM_DW-1:0] dfifo1_wr_pd;
wire           dfifo1_wr_prdy;
wire           dfifo1_wr_pvld;
wire           dfifo1_wr_rdy;
wire   [AM_DW-1:0] dfifo2_wr_pd;
wire           dfifo2_wr_prdy;
wire           dfifo2_wr_pvld;
wire           dfifo2_wr_rdy;
wire   [AM_DW-1:0] dfifo3_wr_pd;
wire           dfifo3_wr_prdy;
wire           dfifo3_wr_pvld;
wire           dfifo3_wr_rdy;
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16   
wire   [AM_DW-1:0] dfifo0_wr_data_16;
wire   [AM_DW-1:0] dfifo0_wr_data_8;
wire   [AM_DW-1:0] dfifo1_wr_data_16;
wire   [AM_DW-1:0] dfifo1_wr_data_8;
wire   [AM_DW-1:0] dfifo2_wr_data_16;
wire   [AM_DW-1:0] dfifo2_wr_data_8;
wire   [AM_DW-1:0] dfifo3_wr_data_16;
wire   [AM_DW-1:0] dfifo3_wr_data_8;
#endif

assign cfg_mode_batch = (reg2dp_batch_number!=0);
assign cfg_mode_winograd = reg2dp_winograd== 1'h1 ;
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);

assign cfg_di_8  = reg2dp_proc_precision== 0 ;
assign cfg_do_8  = reg2dp_out_precision== 0 ;
assign cfg_do_int16 = (reg2dp_out_precision== 1 );
assign cfg_do_fp16 = (reg2dp_out_precision== 2 );
assign cfg_do_16 = cfg_do_int16 | cfg_do_fp16;


//==================================
// DATA split and assembly
//==================================
assign dp2wdma_data = sdp_dp2wdma_pd;

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
assign dat16_byte0 = dp2wdma_data[((16*0) + 16 - 1):16*0];
assign dat16_byte1 = dp2wdma_data[((16*1) + 16 - 1):16*1];
assign dat16_byte2 = dp2wdma_data[((16*2) + 16 - 1):16*2];
assign dat16_byte3 = dp2wdma_data[((16*3) + 16 - 1):16*3];
assign dat16_byte4 = dp2wdma_data[((16*4) + 16 - 1):16*4];
assign dat16_byte5 = dp2wdma_data[((16*5) + 16 - 1):16*5];
assign dat16_byte6 = dp2wdma_data[((16*6) + 16 - 1):16*6];
assign dat16_byte7 = dp2wdma_data[((16*7) + 16 - 1):16*7];
assign dat16_byte8 = dp2wdma_data[((16*8) + 16 - 1):16*8];
assign dat16_byte9 = dp2wdma_data[((16*9) + 16 - 1):16*9];
assign dat16_byte10 = dp2wdma_data[((16*10) + 16 - 1):16*10];
assign dat16_byte11 = dp2wdma_data[((16*11) + 16 - 1):16*11];
assign dat16_byte12 = dp2wdma_data[((16*12) + 16 - 1):16*12];
assign dat16_byte13 = dp2wdma_data[((16*13) + 16 - 1):16*13];
assign dat16_byte14 = dp2wdma_data[((16*14) + 16 - 1):16*14];
assign dat16_byte15 = dp2wdma_data[((16*15) + 16 - 1):16*15];
assign dp2wdma_data_16 = {dat16_byte15, dat16_byte14, dat16_byte13, dat16_byte12, dat16_byte11, dat16_byte10, dat16_byte9, dat16_byte8, dat16_byte7, dat16_byte6, dat16_byte5, dat16_byte4, dat16_byte3, dat16_byte2, dat16_byte1, dat16_byte0};

// NAN counting
assign data_byte0_expo = dat16_byte0[14:10];
assign data_byte0_mant = dat16_byte0[9:0];
assign is_data_byte0_nan = (data_byte0_expo==5'h1f) & (data_byte0_mant!=0) & cfg_do_fp16;
assign data_byte1_expo = dat16_byte1[14:10];
assign data_byte1_mant = dat16_byte1[9:0];
assign is_data_byte1_nan = (data_byte1_expo==5'h1f) & (data_byte1_mant!=0) & cfg_do_fp16;
assign data_byte2_expo = dat16_byte2[14:10];
assign data_byte2_mant = dat16_byte2[9:0];
assign is_data_byte2_nan = (data_byte2_expo==5'h1f) & (data_byte2_mant!=0) & cfg_do_fp16;
assign data_byte3_expo = dat16_byte3[14:10];
assign data_byte3_mant = dat16_byte3[9:0];
assign is_data_byte3_nan = (data_byte3_expo==5'h1f) & (data_byte3_mant!=0) & cfg_do_fp16;
assign data_byte4_expo = dat16_byte4[14:10];
assign data_byte4_mant = dat16_byte4[9:0];
assign is_data_byte4_nan = (data_byte4_expo==5'h1f) & (data_byte4_mant!=0) & cfg_do_fp16;
assign data_byte5_expo = dat16_byte5[14:10];
assign data_byte5_mant = dat16_byte5[9:0];
assign is_data_byte5_nan = (data_byte5_expo==5'h1f) & (data_byte5_mant!=0) & cfg_do_fp16;
assign data_byte6_expo = dat16_byte6[14:10];
assign data_byte6_mant = dat16_byte6[9:0];
assign is_data_byte6_nan = (data_byte6_expo==5'h1f) & (data_byte6_mant!=0) & cfg_do_fp16;
assign data_byte7_expo = dat16_byte7[14:10];
assign data_byte7_mant = dat16_byte7[9:0];
assign is_data_byte7_nan = (data_byte7_expo==5'h1f) & (data_byte7_mant!=0) & cfg_do_fp16;
assign data_byte8_expo = dat16_byte8[14:10];
assign data_byte8_mant = dat16_byte8[9:0];
assign is_data_byte8_nan = (data_byte8_expo==5'h1f) & (data_byte8_mant!=0) & cfg_do_fp16;
assign data_byte9_expo = dat16_byte9[14:10];
assign data_byte9_mant = dat16_byte9[9:0];
assign is_data_byte9_nan = (data_byte9_expo==5'h1f) & (data_byte9_mant!=0) & cfg_do_fp16;
assign data_byte10_expo = dat16_byte10[14:10];
assign data_byte10_mant = dat16_byte10[9:0];
assign is_data_byte10_nan = (data_byte10_expo==5'h1f) & (data_byte10_mant!=0) & cfg_do_fp16;
assign data_byte11_expo = dat16_byte11[14:10];
assign data_byte11_mant = dat16_byte11[9:0];
assign is_data_byte11_nan = (data_byte11_expo==5'h1f) & (data_byte11_mant!=0) & cfg_do_fp16;
assign data_byte12_expo = dat16_byte12[14:10];
assign data_byte12_mant = dat16_byte12[9:0];
assign is_data_byte12_nan = (data_byte12_expo==5'h1f) & (data_byte12_mant!=0) & cfg_do_fp16;
assign data_byte13_expo = dat16_byte13[14:10];
assign data_byte13_mant = dat16_byte13[9:0];
assign is_data_byte13_nan = (data_byte13_expo==5'h1f) & (data_byte13_mant!=0) & cfg_do_fp16;
assign data_byte14_expo = dat16_byte14[14:10];
assign data_byte14_mant = dat16_byte14[9:0];
assign is_data_byte14_nan = (data_byte14_expo==5'h1f) & (data_byte14_mant!=0) & cfg_do_fp16;
assign data_byte15_expo = dat16_byte15[14:10];
assign data_byte15_mant = dat16_byte15[9:0];
assign is_data_byte15_nan = (data_byte15_expo==5'h1f) & (data_byte15_mant!=0) & cfg_do_fp16;
assign nan_output_num[4:0] = is_data_byte15_nan + is_data_byte14_nan + is_data_byte13_nan + is_data_byte12_nan + is_data_byte11_nan + is_data_byte10_nan + is_data_byte9_nan + is_data_byte8_nan + is_data_byte7_nan + is_data_byte6_nan + is_data_byte5_nan + is_data_byte4_nan + is_data_byte3_nan + is_data_byte2_nan + is_data_byte1_nan + is_data_byte0_nan;
assign nan_output_cen = sdp_dp2wdma_valid & sdp_dp2wdma_ready & (is_data_byte15_nan | is_data_byte14_nan | is_data_byte13_nan | is_data_byte12_nan | is_data_byte11_nan | is_data_byte10_nan | is_data_byte9_nan | is_data_byte8_nan | is_data_byte7_nan | is_data_byte6_nan | is_data_byte5_nan | is_data_byte4_nan | is_data_byte3_nan | is_data_byte2_nan | is_data_byte1_nan | is_data_byte0_nan);

assign {nan_output_cnt_add_c,nan_output_cnt_add[31:0]} = nan_output_cnt[31:0] + nan_output_num;
assign nan_output_cnt_nxt = nan_output_cnt_add_c ? 32'hffff_ffff : nan_output_cnt_add;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    nan_output_cnt <= {32{1'b0}};
  end else begin
    if (op_load) begin
        nan_output_cnt <= 0;
    end else if (nan_output_cen) begin
        nan_output_cnt <= nan_output_cnt_nxt;
    end
  end
end
assign dp2reg_status_nan_output_num = nan_output_cnt;
#else
assign dp2wdma_data_16 = dp2wdma_data; 
assign dp2wdma_data_8  = dp2wdma_data; 
assign dp2reg_status_nan_output_num = 32'h0;
#endif

assign sdp_dp2wdma_ready = in_dat_rdy;

//pop comand
assign spt_rdy = in_dat_accept & is_last_beat;

assign cmd2dat_spt_size[13:0] = cmd2dat_spt_pd[13:0];
assign cmd2dat_spt_odd  =    cmd2dat_spt_pd[14];
assign cmd2dat_spt_prdy = spt_rdy || !spt_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    spt_vld <= 1'b0;
  end else begin
  if ((cmd2dat_spt_prdy) == 1'b1) begin
    spt_vld <= cmd2dat_spt_pvld;
  //end else if ((cmd2dat_spt_prdy) == 1'b0) begin
  //end else begin
  //  spt_vld <= 1'bx;  
  end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {14{1'b0}};
  end else begin
    if (in_dat_accept) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count==spt_size);


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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_spt_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    spt_size <= {14{1'b0}};
  end else begin
  if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b1) begin
    spt_size <= cmd2dat_spt_size;
  //end else if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b0) begin
  //end else begin
  //  spt_size <= 14'bx;  
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_spt_pvld & cmd2dat_spt_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_spt_pvld & cmd2dat_spt_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"spt_vld should be faster than dp2wdma_valid")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (!spt_vld) && sdp_dp2wdma_valid); // spyglass disable W504 SelfDeterminedExpr-ML 
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

#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
reg    spt_odd;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    spt_odd <= 1'b0;
  end else begin
  if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b1) begin
    spt_odd <= cmd2dat_spt_odd;
  //end else if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b0) begin
  //end else begin
  //  spt_odd <= 1'bx;  
  end
  end
end

assign cfg_mode_8to16 = cfg_di_8 & cfg_do_16;
// in m16to8 mode, core2wdma data will have burst8 data, and jump to next surf for another burst8 data
// mode_16to8_flag_surf is to tell in surf0 or surf1
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mode_8to16_flag_twin <= 1'b0;
  end else begin
    if (cfg_mode_8to16) begin
        if (in_dat_accept && is_last_beat && !spt_odd) begin
            mode_8to16_flag_twin <= ~mode_8to16_flag_twin;
        end
    end
  end
end

assign in_dat_rdy = dfifo0_wr_rdy & dfifo1_wr_rdy & dfifo2_wr_rdy & dfifo3_wr_rdy;
assign in_dat_accept = (dfifo0_wr_pvld & dfifo0_wr_prdy) | (dfifo1_wr_pvld & dfifo1_wr_prdy) | (dfifo2_wr_pvld & dfifo2_wr_prdy) | (dfifo3_wr_pvld & dfifo3_wr_prdy);

// 4 FIFOs, 16B each, 64B in total
// DATA FIFO WRITE SIDE
always @(
  cfg_mode_8to16
  or mode_8to16_flag_twin
  or cfg_mode_1x1_pack
  or beat_count
  or cfg_mode_winograd
  or cfg_do_8
  or cfg_mode_batch
  ) begin
   
   if (cfg_mode_8to16) begin
      if (cfg_mode_1x1_pack) begin
          dfifo0_wr_en = (beat_count[0]==0);
      end else begin
          dfifo0_wr_en = mode_8to16_flag_twin==0;
      end
   end else if (cfg_mode_winograd) begin
       if (cfg_do_8) begin
           dfifo0_wr_en = (beat_count[1:0]==0);
       end else begin
           dfifo0_wr_en = (beat_count[0]==0);
       end
   end else if (cfg_mode_batch) begin
       if (cfg_do_8) begin
           dfifo0_wr_en = (beat_count[1:0]==0);
       end else begin
           dfifo0_wr_en = (beat_count[0]==0);
       end
   end else begin
       if (cfg_do_8) begin
           dfifo0_wr_en = (beat_count[1:0]==0);
       end else begin
           dfifo0_wr_en = (beat_count[0]==0);
       end
   end
end
assign dfifo0_wr_pvld = sdp_dp2wdma_valid & dfifo0_wr_en;
assign dfifo0_wr_data_8 = dp2wdma_data_8[AM_DW-1:0];
assign dfifo0_wr_data_16= dp2wdma_data_16[AM_DW-1:0];
assign dfifo0_wr_pd   = cfg_do_8 ? dfifo0_wr_data_8 : dfifo0_wr_data_16;

assign dfifo0_wr_rdy = dfifo0_wr_en ? dfifo0_wr_prdy : 1'b1;

// DATA FIFO WRITE SIDE
always @(
  cfg_mode_8to16
  or cfg_mode_1x1_pack
  or beat_count
  or mode_8to16_flag_twin
  or cfg_mode_winograd
  or cfg_do_8
  or cfg_mode_batch
  ) begin
   
   if (cfg_mode_8to16) begin
      if (cfg_mode_1x1_pack) begin
          dfifo1_wr_en = (beat_count[0]==0);
      end else begin
          dfifo1_wr_en = mode_8to16_flag_twin==0;
      end
   end else if (cfg_mode_winograd) begin
       if (cfg_do_8) begin
           dfifo1_wr_en = (beat_count[1:0]==1);
       end else begin
           dfifo1_wr_en = (beat_count[0]==0);
       end
   end else if (cfg_mode_batch) begin
       if (cfg_do_8) begin
           dfifo1_wr_en = (beat_count[1:0]==1);
       end else begin
           dfifo1_wr_en = (beat_count[0]==0);
       end
   end else begin
       if (cfg_do_8) begin
           dfifo1_wr_en = (beat_count[1:0]==1);
       end else begin
           dfifo1_wr_en = (beat_count[0]==0);
       end
   end
end
assign dfifo1_wr_pvld = sdp_dp2wdma_valid & dfifo1_wr_en;
assign dfifo1_wr_data_8 = dp2wdma_data_8[AM_DW-1:0];
assign dfifo1_wr_data_16= dp2wdma_data_16[255:128];
assign dfifo1_wr_pd   = cfg_do_8 ? dfifo1_wr_data_8 : dfifo1_wr_data_16;

assign dfifo1_wr_rdy = dfifo1_wr_en ? dfifo1_wr_prdy : 1'b1;
// DATA FIFO WRITE SIDE
always @(
  cfg_mode_8to16
  or cfg_mode_1x1_pack
  or beat_count
  or mode_8to16_flag_twin
  or cfg_mode_winograd
  or cfg_do_8
  or cfg_mode_batch
  ) begin
   
   if (cfg_mode_8to16) begin
      if (cfg_mode_1x1_pack) begin
          dfifo2_wr_en = (beat_count[0]==1);
      end else begin
          dfifo2_wr_en = mode_8to16_flag_twin==1;
      end
   end else if (cfg_mode_winograd) begin
       if (cfg_do_8) begin
           dfifo2_wr_en = (beat_count[1:0]==2);
       end else begin
           dfifo2_wr_en = (beat_count[0]==1);
       end
   end else if (cfg_mode_batch) begin
       if (cfg_do_8) begin
           dfifo2_wr_en = (beat_count[1:0]==2);
       end else begin
           dfifo2_wr_en = (beat_count[0]==1);
       end
   end else begin
       if (cfg_do_8) begin
           dfifo2_wr_en = (beat_count[1:0]==2);
       end else begin
           dfifo2_wr_en = (beat_count[0]==1);
       end
   end
end
assign dfifo2_wr_pvld = sdp_dp2wdma_valid & dfifo2_wr_en;
assign dfifo2_wr_data_8 = dp2wdma_data_8[AM_DW-1:0];
assign dfifo2_wr_data_16= dp2wdma_data_16[AM_DW-1:0];
assign dfifo2_wr_pd   = cfg_do_8 ? dfifo2_wr_data_8 : dfifo2_wr_data_16;

assign dfifo2_wr_rdy = dfifo2_wr_en ? dfifo2_wr_prdy : 1'b1;

// DATA FIFO WRITE SIDE
always @(
  cfg_mode_8to16
  or cfg_mode_1x1_pack
  or beat_count
  or mode_8to16_flag_twin
  or cfg_mode_winograd
  or cfg_do_8
  or cfg_mode_batch
  ) begin
   
   if (cfg_mode_8to16) begin
      if (cfg_mode_1x1_pack) begin
          dfifo3_wr_en = (beat_count[0]==1);
      end else begin
          dfifo3_wr_en = mode_8to16_flag_twin==1;
      end
   end else if (cfg_mode_winograd) begin
       if (cfg_do_8) begin
           dfifo3_wr_en = (beat_count[1:0]==3);
       end else begin
           dfifo3_wr_en = (beat_count[0]==1);
       end
   end else if (cfg_mode_batch) begin
       if (cfg_do_8) begin
           dfifo3_wr_en = (beat_count[1:0]==3);
       end else begin
           dfifo3_wr_en = (beat_count[0]==1);
       end
   end else begin
       if (cfg_do_8) begin
           dfifo3_wr_en = (beat_count[1:0]==3);
       end else begin
           dfifo3_wr_en = (beat_count[0]==1);
       end
   end
end
assign dfifo3_wr_pvld = sdp_dp2wdma_valid & dfifo3_wr_en;
assign dfifo3_wr_data_8 = dp2wdma_data_8[AM_DW-1:0];
assign dfifo3_wr_data_16= dp2wdma_data_16[255:128];
assign dfifo3_wr_pd   = cfg_do_8 ? dfifo3_wr_data_8 : dfifo3_wr_data_16;

assign dfifo3_wr_rdy = dfifo3_wr_en ? dfifo3_wr_prdy : 1'b1;
#else
assign in_dat_rdy = dfifo0_wr_rdy & dfifo1_wr_rdy & dfifo2_wr_rdy & dfifo3_wr_rdy;
assign in_dat_accept = (dfifo0_wr_pvld & dfifo0_wr_prdy) | (dfifo1_wr_pvld & dfifo1_wr_prdy) | (dfifo2_wr_pvld & dfifo2_wr_prdy) | (dfifo3_wr_pvld & dfifo3_wr_prdy);

assign dfifo0_wr_en = beat_count[1:0] == 2'h0;
assign dfifo1_wr_en = beat_count[1:0] == 2'h1;
assign dfifo2_wr_en = beat_count[1:0] == 2'h2;
assign dfifo3_wr_en = beat_count[1:0] == 2'h3;

assign dfifo0_wr_pvld = sdp_dp2wdma_valid & dfifo0_wr_en;
assign dfifo0_wr_rdy  = dfifo0_wr_en ? dfifo0_wr_prdy : 1'b1;
assign dfifo0_wr_pd   = dp2wdma_data[AM_DW-1:0];

assign dfifo1_wr_pvld = sdp_dp2wdma_valid & dfifo1_wr_en;
assign dfifo1_wr_rdy  = dfifo1_wr_en ? dfifo1_wr_prdy : 1'b1;
assign dfifo1_wr_pd   = dp2wdma_data[AM_DW-1:0];

assign dfifo2_wr_pvld = sdp_dp2wdma_valid & dfifo2_wr_en;
assign dfifo2_wr_rdy  = dfifo2_wr_en ? dfifo2_wr_prdy : 1'b1;
assign dfifo2_wr_pd   = dp2wdma_data[AM_DW-1:0];

assign dfifo3_wr_pvld = sdp_dp2wdma_valid & dfifo3_wr_en;
assign dfifo3_wr_rdy  = dfifo3_wr_en ? dfifo3_wr_prdy : 1'b1;
assign dfifo3_wr_pd   = dp2wdma_data[AM_DW-1:0];

#endif

NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo0 (
   .nvdla_core_clk  (nvdla_core_clk)      
  ,.nvdla_core_rstn (nvdla_core_rstn)     
  ,.dfifo_wr_prdy   (dfifo0_wr_prdy)      
  ,.dfifo_wr_pvld   (dfifo0_wr_pvld)      
  ,.dfifo_wr_pd     (dfifo0_wr_pd[AM_DW-1:0]) 
  ,.dfifo_rd_prdy   (dfifo0_rd_prdy)      
  ,.dfifo_rd_pvld   (dfifo0_rd_pvld)      
  ,.dfifo_rd_pd     (dfifo0_rd_pd[AM_DW-1:0]) 
  );

NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo1 (
   .nvdla_core_clk  (nvdla_core_clk)      
  ,.nvdla_core_rstn (nvdla_core_rstn)     
  ,.dfifo_wr_prdy   (dfifo1_wr_prdy)      
  ,.dfifo_wr_pvld   (dfifo1_wr_pvld)      
  ,.dfifo_wr_pd     (dfifo1_wr_pd[AM_DW-1:0]) 
  ,.dfifo_rd_prdy   (dfifo1_rd_prdy)      
  ,.dfifo_rd_pvld   (dfifo1_rd_pvld)      
  ,.dfifo_rd_pd     (dfifo1_rd_pd[AM_DW-1:0]) 
  );

NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo2 (
   .nvdla_core_clk  (nvdla_core_clk)      
  ,.nvdla_core_rstn (nvdla_core_rstn)     
  ,.dfifo_wr_prdy   (dfifo2_wr_prdy)      
  ,.dfifo_wr_pvld   (dfifo2_wr_pvld)      
  ,.dfifo_wr_pd     (dfifo2_wr_pd[AM_DW-1:0]) 
  ,.dfifo_rd_prdy   (dfifo2_rd_prdy)      
  ,.dfifo_rd_pvld   (dfifo2_rd_pvld)      
  ,.dfifo_rd_pd     (dfifo2_rd_pd[AM_DW-1:0]) 
  );

NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo3 (
   .nvdla_core_clk  (nvdla_core_clk)      
  ,.nvdla_core_rstn (nvdla_core_rstn)     
  ,.dfifo_wr_prdy   (dfifo3_wr_prdy)      
  ,.dfifo_wr_pvld   (dfifo3_wr_pvld)      
  ,.dfifo_wr_pd     (dfifo3_wr_pd[AM_DW-1:0]) 
  ,.dfifo_rd_prdy   (dfifo3_rd_prdy)      
  ,.dfifo_rd_pvld   (dfifo3_rd_pvld)      
  ,.dfifo_rd_pd     (dfifo3_rd_pd[AM_DW-1:0]) 
  );

endmodule // NV_NVDLA_SDP_WDMA_DAT_in


module NV_NVDLA_SDP_WDMA_DAT_IN_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dfifo_wr_prdy
    , dfifo_wr_pvld
    , dfifo_wr_pd
    , dfifo_rd_prdy
    , dfifo_rd_pvld
    , dfifo_rd_pd
    );

input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dfifo_wr_prdy;
input         dfifo_wr_pvld;
input  [AM_DW-1:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [AM_DW-1:0] dfifo_rd_pd;


//: my $dw = AM_DW;
//: &eperl::pipe("-is -wid $dw -do dfifo_rd_pd -vo dfifo_rd_pvld -ri dfifo_rd_prdy -di dfifo_wr_pd -vi dfifo_wr_pvld -ro dfifo_wr_prdy");


endmodule
