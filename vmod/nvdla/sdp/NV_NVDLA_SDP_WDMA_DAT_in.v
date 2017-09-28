// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_DAT_in.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_WDMA_DAT_in (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,cmd2dat_spt_pd               //|< i
  ,cmd2dat_spt_pvld             //|< i
  ,dfifo0_rd_prdy               //|< i
  ,dfifo1_rd_prdy               //|< i
  ,dfifo2_rd_prdy               //|< i
  ,dfifo3_rd_prdy               //|< i
  ,op_load                      //|< i
  ,pwrbus_ram_pd                //|< i
  ,reg2dp_batch_number          //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_out_precision         //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_width                 //|< i
  ,reg2dp_winograd              //|< i
  ,sdp_dp2wdma_pd               //|< i
  ,sdp_dp2wdma_valid            //|< i
  ,cmd2dat_spt_prdy             //|> o
  ,dfifo0_rd_pd                 //|> o
  ,dfifo0_rd_pvld               //|> o
  ,dfifo1_rd_pd                 //|> o
  ,dfifo1_rd_pvld               //|> o
  ,dfifo2_rd_pd                 //|> o
  ,dfifo2_rd_pvld               //|> o
  ,dfifo3_rd_pd                 //|> o
  ,dfifo3_rd_pvld               //|> o
  ,dp2reg_status_nan_output_num //|> o
  ,sdp_dp2wdma_ready            //|> o
  );
//
// NV_NVDLA_SDP_WDMA_DAT_in_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         cmd2dat_spt_pvld;  /* data valid */
output        cmd2dat_spt_prdy;  /* data return handshake */
input  [14:0] cmd2dat_spt_pd;

input          sdp_dp2wdma_valid;  /* data valid */
output         sdp_dp2wdma_ready;  /* data return handshake */
input  [255:0] sdp_dp2wdma_pd;

output         dfifo0_rd_pvld;  /* data valid */
input          dfifo0_rd_prdy;  /* data return handshake */
output [127:0] dfifo0_rd_pd;

output         dfifo1_rd_pvld;  /* data valid */
input          dfifo1_rd_prdy;  /* data return handshake */
output [127:0] dfifo1_rd_pd;

output         dfifo2_rd_pvld;  /* data valid */
input          dfifo2_rd_prdy;  /* data return handshake */
output [127:0] dfifo2_rd_pd;

output         dfifo3_rd_pvld;  /* data valid */
input          dfifo3_rd_prdy;  /* data return handshake */
output [127:0] dfifo3_rd_pd;

input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_height;
input    [1:0] reg2dp_out_precision;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
input          reg2dp_winograd;
output  [31:0] dp2reg_status_nan_output_num;
input   [31:0] pwrbus_ram_pd;
input op_load;
reg     [13:0] beat_count;
reg            dfifo0_wr_en;
reg            dfifo1_wr_en;
reg            dfifo2_wr_en;
reg            dfifo3_wr_en;
reg            mode_8to16_flag_twin;
reg     [31:0] nan_output_cnt;
reg            spt_odd;
reg     [13:0] spt_size;
reg            spt_vld;
wire           cfg_di_8;
wire           cfg_do_16;
wire           cfg_do_8;
wire           cfg_do_fp16;
wire           cfg_do_int16;
wire           cfg_mode_1x1_pack;
wire           cfg_mode_8to16;
wire           cfg_mode_batch;
wire           cfg_mode_winograd;
wire           cmd2dat_spt_odd;
wire    [13:0] cmd2dat_spt_size;
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
wire   [127:0] dfifo0_wr_data_16;
wire   [127:0] dfifo0_wr_data_8;
wire   [127:0] dfifo0_wr_pd;
wire           dfifo0_wr_prdy;
wire           dfifo0_wr_pvld;
wire           dfifo0_wr_rdy;
wire   [127:0] dfifo1_wr_data_16;
wire   [127:0] dfifo1_wr_data_8;
wire   [127:0] dfifo1_wr_pd;
wire           dfifo1_wr_prdy;
wire           dfifo1_wr_pvld;
wire           dfifo1_wr_rdy;
wire   [127:0] dfifo2_wr_data_16;
wire   [127:0] dfifo2_wr_data_8;
wire   [127:0] dfifo2_wr_pd;
wire           dfifo2_wr_prdy;
wire           dfifo2_wr_pvld;
wire           dfifo2_wr_rdy;
wire   [127:0] dfifo3_wr_data_16;
wire   [127:0] dfifo3_wr_data_8;
wire   [127:0] dfifo3_wr_pd;
wire           dfifo3_wr_prdy;
wire           dfifo3_wr_pvld;
wire           dfifo3_wr_rdy;
wire   [255:0] dp2wdma_data;
wire   [255:0] dp2wdma_data_16;
wire   [127:0] dp2wdma_data_8;
wire           in_dat_accept;
wire           in_dat_rdy;
wire     [7:0] int8_byte0;
wire     [7:0] int8_byte1;
wire     [7:0] int8_byte10;
wire     [7:0] int8_byte11;
wire     [7:0] int8_byte12;
wire     [7:0] int8_byte13;
wire     [7:0] int8_byte14;
wire     [7:0] int8_byte15;
wire     [7:0] int8_byte2;
wire     [7:0] int8_byte3;
wire     [7:0] int8_byte4;
wire     [7:0] int8_byte5;
wire     [7:0] int8_byte6;
wire     [7:0] int8_byte7;
wire     [7:0] int8_byte8;
wire     [7:0] int8_byte9;
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
wire           is_last_beat;
wire           nan_output_cen;
wire    [31:0] nan_output_cnt_add;
wire           nan_output_cnt_add_c;
wire    [31:0] nan_output_cnt_nxt;
wire     [4:0] nan_output_num;
wire           spt_rdy;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

assign cfg_mode_batch = (reg2dp_batch_number!=0);
assign cfg_mode_winograd = reg2dp_winograd== 1'h1 ;

assign cfg_di_8  = reg2dp_proc_precision== 0 ;
//assign cfg_di_int16 = (reg2dp_proc_precision==NVDLA_GENERIC_PRECISION_ENUM_INT16);
//assign cfg_di_fp16 = (reg2dp_proc_precision==NVDLA_GENERIC_PRECISION_ENUM_FP16);
//assign cfg_di_16 = cfg_di_int16 | cfg_di_fp16;

assign cfg_do_8  = reg2dp_out_precision== 0 ;
assign cfg_do_int16 = (reg2dp_out_precision== 1 );
assign cfg_do_fp16 = (reg2dp_out_precision== 2 );
assign cfg_do_16 = cfg_do_int16 | cfg_do_fp16;

assign cfg_mode_8to16 = cfg_di_8 & cfg_do_16;
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);

//==================================
// DATA split and assembly
//==================================
assign dp2wdma_data = sdp_dp2wdma_pd;

// INT16 | FP16
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

// INT8
 assign int8_byte0 = dp2wdma_data[((16*0) + 8 - 1):16*0];
 assign int8_byte1 = dp2wdma_data[((16*1) + 8 - 1):16*1];
 assign int8_byte2 = dp2wdma_data[((16*2) + 8 - 1):16*2];
 assign int8_byte3 = dp2wdma_data[((16*3) + 8 - 1):16*3];
 assign int8_byte4 = dp2wdma_data[((16*4) + 8 - 1):16*4];
 assign int8_byte5 = dp2wdma_data[((16*5) + 8 - 1):16*5];
 assign int8_byte6 = dp2wdma_data[((16*6) + 8 - 1):16*6];
 assign int8_byte7 = dp2wdma_data[((16*7) + 8 - 1):16*7];
 assign int8_byte8 = dp2wdma_data[((16*8) + 8 - 1):16*8];
 assign int8_byte9 = dp2wdma_data[((16*9) + 8 - 1):16*9];
 assign int8_byte10 = dp2wdma_data[((16*10) + 8 - 1):16*10];
 assign int8_byte11 = dp2wdma_data[((16*11) + 8 - 1):16*11];
 assign int8_byte12 = dp2wdma_data[((16*12) + 8 - 1):16*12];
 assign int8_byte13 = dp2wdma_data[((16*13) + 8 - 1):16*13];
 assign int8_byte14 = dp2wdma_data[((16*14) + 8 - 1):16*14];
 assign int8_byte15 = dp2wdma_data[((16*15) + 8 - 1):16*15];
assign dp2wdma_data_8  = {int8_byte15, int8_byte14, int8_byte13, int8_byte12, int8_byte11, int8_byte10, int8_byte9, int8_byte8, int8_byte7, int8_byte6, int8_byte5, int8_byte4, int8_byte3, int8_byte2, int8_byte1, int8_byte0};

//=====================
assign spt_rdy = in_dat_accept & is_last_beat;
assign sdp_dp2wdma_ready = in_dat_rdy;

//=====================
// info from WDMA_cmd

// PKT_UNPACK_WIRE( sdp_wdma_spt , cmd2dat_spt_ , cmd2dat_spt_pd )
assign       cmd2dat_spt_size[13:0] =    cmd2dat_spt_pd[13:0];
assign        cmd2dat_spt_odd  =    cmd2dat_spt_pd[14];
assign cmd2dat_spt_prdy = spt_rdy || !spt_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    spt_vld <= 1'b0;
  end else begin
  if ((cmd2dat_spt_prdy) == 1'b1) begin
    spt_vld <= cmd2dat_spt_pvld;
  // VCS coverage off
  end else if ((cmd2dat_spt_prdy) == 1'b0) begin
  end else begin
    spt_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  // VCS coverage off
  end else if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b0) begin
  end else begin
    spt_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    spt_odd <= 1'b0;
  end else begin
  if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b1) begin
    spt_odd <= cmd2dat_spt_odd;
  // VCS coverage off
  end else if ((cmd2dat_spt_pvld & cmd2dat_spt_prdy) == 1'b0) begin
  end else begin
    spt_odd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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

// 4 FIFOs, 16B each, 64B in total
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
assign dfifo0_wr_data_8 = dp2wdma_data_8[127:0];
assign dfifo0_wr_data_16= dp2wdma_data_16[127:0];
assign dfifo0_wr_pd   = cfg_do_8 ? dfifo0_wr_data_8 : dfifo0_wr_data_16;

assign dfifo0_wr_rdy = dfifo0_wr_en ? dfifo0_wr_prdy : 1'b1;
NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo0 (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.dfifo_wr_prdy   (dfifo0_wr_prdy)      //|> w
  ,.dfifo_wr_pvld   (dfifo0_wr_pvld)      //|< w
  ,.dfifo_wr_pd     (dfifo0_wr_pd[127:0]) //|< w
  ,.dfifo_rd_prdy   (dfifo0_rd_prdy)      //|< i
  ,.dfifo_rd_pvld   (dfifo0_rd_pvld)      //|> o
  ,.dfifo_rd_pd     (dfifo0_rd_pd[127:0]) //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

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
assign dfifo1_wr_data_8 = dp2wdma_data_8[127:0];
assign dfifo1_wr_data_16= dp2wdma_data_16[255:128];
assign dfifo1_wr_pd   = cfg_do_8 ? dfifo1_wr_data_8 : dfifo1_wr_data_16;

assign dfifo1_wr_rdy = dfifo1_wr_en ? dfifo1_wr_prdy : 1'b1;
NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo1 (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.dfifo_wr_prdy   (dfifo1_wr_prdy)      //|> w
  ,.dfifo_wr_pvld   (dfifo1_wr_pvld)      //|< w
  ,.dfifo_wr_pd     (dfifo1_wr_pd[127:0]) //|< w
  ,.dfifo_rd_prdy   (dfifo1_rd_prdy)      //|< i
  ,.dfifo_rd_pvld   (dfifo1_rd_pvld)      //|> o
  ,.dfifo_rd_pd     (dfifo1_rd_pd[127:0]) //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

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
assign dfifo2_wr_data_8 = dp2wdma_data_8[127:0];
assign dfifo2_wr_data_16= dp2wdma_data_16[127:0];
assign dfifo2_wr_pd   = cfg_do_8 ? dfifo2_wr_data_8 : dfifo2_wr_data_16;

assign dfifo2_wr_rdy = dfifo2_wr_en ? dfifo2_wr_prdy : 1'b1;
NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo2 (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.dfifo_wr_prdy   (dfifo2_wr_prdy)      //|> w
  ,.dfifo_wr_pvld   (dfifo2_wr_pvld)      //|< w
  ,.dfifo_wr_pd     (dfifo2_wr_pd[127:0]) //|< w
  ,.dfifo_rd_prdy   (dfifo2_rd_prdy)      //|< i
  ,.dfifo_rd_pvld   (dfifo2_rd_pvld)      //|> o
  ,.dfifo_rd_pd     (dfifo2_rd_pd[127:0]) //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

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
assign dfifo3_wr_data_8 = dp2wdma_data_8[127:0];
assign dfifo3_wr_data_16= dp2wdma_data_16[255:128];
assign dfifo3_wr_pd   = cfg_do_8 ? dfifo3_wr_data_8 : dfifo3_wr_data_16;

assign dfifo3_wr_rdy = dfifo3_wr_en ? dfifo3_wr_prdy : 1'b1;
NV_NVDLA_SDP_WDMA_DAT_IN_dfifo u_dfifo3 (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.dfifo_wr_prdy   (dfifo3_wr_prdy)      //|> w
  ,.dfifo_wr_pvld   (dfifo3_wr_pvld)      //|< w
  ,.dfifo_wr_pd     (dfifo3_wr_pd[127:0]) //|< w
  ,.dfifo_rd_prdy   (dfifo3_rd_prdy)      //|< i
  ,.dfifo_rd_pvld   (dfifo3_rd_pvld)      //|> o
  ,.dfifo_rd_pd     (dfifo3_rd_pd[127:0]) //|> o
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

assign in_dat_rdy = dfifo0_wr_rdy & dfifo1_wr_rdy & dfifo2_wr_rdy & dfifo3_wr_rdy;
assign in_dat_accept = (dfifo0_wr_pvld & dfifo0_wr_prdy) | (dfifo1_wr_pvld & dfifo1_wr_prdy) | (dfifo2_wr_pvld & dfifo2_wr_prdy) | (dfifo3_wr_pvld & dfifo3_wr_prdy);

//==================================
// OBS
//assign obs_bus_sdp_wdma_dfifo0_rd_prdy  = dfifo0_rd_prdy; 
//assign obs_bus_sdp_wdma_dfifo0_rd_pvld  = dfifo0_rd_pvld; 
//assign obs_bus_sdp_wdma_dfifo0_wr_prdy  = dfifo0_wr_prdy; 
//assign obs_bus_sdp_wdma_dfifo0_wr_pvld  = dfifo0_wr_pvld; 
//assign obs_bus_sdp_wdma_dfifo1_rd_prdy  = dfifo1_rd_prdy; 
//assign obs_bus_sdp_wdma_dfifo1_rd_pvld  = dfifo1_rd_pvld; 
//assign obs_bus_sdp_wdma_dfifo1_wr_prdy  = dfifo1_wr_prdy; 
//assign obs_bus_sdp_wdma_dfifo1_wr_pvld  = dfifo1_wr_pvld; 
//assign obs_bus_sdp_wdma_dfifo2_rd_prdy  = dfifo2_rd_prdy; 
//assign obs_bus_sdp_wdma_dfifo2_rd_pvld  = dfifo2_rd_pvld; 
//assign obs_bus_sdp_wdma_dfifo2_wr_prdy  = dfifo2_wr_prdy; 
//assign obs_bus_sdp_wdma_dfifo2_wr_pvld  = dfifo2_wr_pvld; 
//assign obs_bus_sdp_wdma_dfifo3_rd_prdy  = dfifo3_rd_prdy; 
//assign obs_bus_sdp_wdma_dfifo3_rd_pvld  = dfifo3_rd_pvld; 
//assign obs_bus_sdp_wdma_dfifo3_wr_prdy  = dfifo3_wr_prdy; 
//assign obs_bus_sdp_wdma_dfifo3_wr_pvld  = dfifo3_wr_pvld; 

endmodule // NV_NVDLA_SDP_WDMA_DAT_in

// -w 128, 8byte each fifo
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_WDMA_DAT_IN_dfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dfifo_wr -rd_pipebus dfifo_rd -rd_reg -rand_none -ram_bypass -d 3 -w 128 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_WDMA_DAT_IN_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
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
output        dfifo_wr_prdy;
input         dfifo_wr_pvld;
input  [127:0] dfifo_wr_pd;
input         dfifo_rd_prdy;
output        dfifo_rd_pvld;
output [127:0] dfifo_rd_pd;
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

reg  [1:0] dfifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dfifo_wr_count : (dfifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dfifo_wr_count + 1'd1) : dfifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dfifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dfifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_wr_busy_int <=  1'b0;
        dfifo_wr_count <=  2'd0;
    end else begin
	dfifo_wr_busy_int <=  dfifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dfifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dfifo_wr_count <=  {2{`x_or_0}};
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
	    dfifo_wr_adr <=  (dfifo_wr_adr == 2'd2) ? 2'd0 : (dfifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] dfifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dfifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [127:0] dfifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dfifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dfifo_wr_adr )
    , .ra        ( (dfifo_wr_count == 0) ? 2'd3 : dfifo_rd_adr )
    , .dout        ( dfifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (dfifo_rd_adr == 2'd2) ? 2'd0 : (dfifo_rd_adr + 1'd1); // spyglass disable W484
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

wire       dfifo_rd_pvld_p; 		// data out of fifo is valid

reg        dfifo_rd_pvld_int;	// internal copy of dfifo_rd_pvld
assign     dfifo_rd_pvld = dfifo_rd_pvld_int;
assign     rd_popping = dfifo_rd_pvld_p && !(dfifo_rd_pvld_int && !dfifo_rd_prdy);

reg  [1:0] dfifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dfifo_rd_count_p : 
                                                                (dfifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dfifo_rd_count_p + 1'd1) : 
                                                                    dfifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dfifo_rd_pvld_p = dfifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dfifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dfifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [127:0]  dfifo_rd_pd;         // output data register
wire        rd_req_next = (dfifo_rd_pvld_p || (dfifo_rd_pvld_int && !dfifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dfifo_rd_pvld_int <=  1'b0;
    end else begin
        dfifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dfifo_rd_pd <=  dfifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dfifo_rd_pd <=  {128{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dfifo_wr_pvld && !dfifo_wr_busy_int) || (dfifo_wr_busy_int != dfifo_wr_busy_next)) || (rd_pushing || rd_popping || (dfifo_rd_pvld_int && dfifo_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_wr_limit : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_wr_limit=%d", wr_limit_override_value);
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
    , .curr	( {30'd0, dfifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_WDMA_DAT_IN_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_WDMA_DAT_IN_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128 (
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
input  [127:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [127:0] dout;

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


wire [127:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [127:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [127:0] ram_ff0;
reg [127:0] ram_ff1;
reg [127:0] ram_ff2;

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

reg [127:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {128{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [127:0] Di0;
input  [1:0] Ra0;
output [127:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 128'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [127:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [127:0] Q0 = mem[0];
wire [127:0] Q1 = mem[1];
wire [127:0] Q2 = mem[2];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128] }
endmodule // vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128

//vmw: Memory vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128
//vmw: Address-size 2
//vmw: Data-size 128
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[127:0] data0[127:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[127:0] data1[127:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_WDMA_DAT_IN_dfifo_flopram_rwsa_3x128
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

