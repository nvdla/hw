// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_WDMA_cmd.v

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_WDMA_cmd (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,cmd_fifo_rd_prdy               //|< i
  ,op_load                        //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_cube_out_channel        //|< i
  ,reg2dp_cube_out_height         //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_dst_base_addr_high      //|< i
  ,reg2dp_dst_base_addr_low       //|< i
  ,reg2dp_dst_line_stride         //|< i
  ,reg2dp_dst_surface_stride      //|< i
  ,reg2dp_input_data              //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_split_num               //|< i
  ,cmd_fifo_rd_pd                 //|> o
  ,cmd_fifo_rd_pvld               //|> o
  );
//&Catenate "NV_NVDLA_PDP_wdma_ports.v";
input  [12:0] reg2dp_cube_out_channel;
input  [12:0] reg2dp_cube_out_height;
input  [12:0] reg2dp_cube_out_width;
input  [31:0] reg2dp_dst_base_addr_high;
input  [26:0] reg2dp_dst_base_addr_low;
input  [26:0] reg2dp_dst_line_stride;
input  [26:0] reg2dp_dst_surface_stride;
input   [1:0] reg2dp_input_data;
input   [9:0] reg2dp_partial_width_out_first;
input   [9:0] reg2dp_partial_width_out_last;
input   [9:0] reg2dp_partial_width_out_mid;
input   [7:0] reg2dp_split_num;
input         cmd_fifo_rd_prdy;
output [79:0] cmd_fifo_rd_pd;
output        cmd_fifo_rd_pvld;
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] pwrbus_ram_pd;
input op_load;
reg    [63:0] base_addr_line;
reg    [63:0] base_addr_split;
reg    [63:0] base_addr_surf;
reg           cfg_do_int16;
reg           cfg_do_int8;
reg    [12:0] count_h;
reg     [9:0] count_surf;
reg     [7:0] count_wg;
reg           mon_base_addr_line_c;
reg           mon_base_addr_split_c;
reg           mon_base_addr_surf_c;
reg           op_prcess;
reg    [14:0] size_of_byte_in_c;
wire   [63:0] cfg_base_addr;
wire          cfg_mode_split;
wire          cmd_fifo_wr_accpet;
wire   [79:0] cmd_fifo_wr_pd;
wire          cmd_fifo_wr_prdy;
wire          cmd_fifo_wr_pvld;
wire   [13:0] cube_out_channel_use;
wire          is_cube_end;
wire          is_first_wg;
wire          is_fspt;
wire          is_last_h;
wire          is_last_surf;
wire          is_last_wg;
wire          is_line_end;
wire          is_lspt;
wire          is_mspt;
wire          is_split_end;
wire          is_surf_end;
wire          mon_size_of_surf;
wire          op_done;
wire    [1:0] size_of_b;
wire    [9:0] size_of_surf;
wire   [10:0] size_of_surf_use;
wire   [12:0] size_of_width;
wire    [9:0] split_size_of_width;
wire   [18:0] splitw_stride;
wire   [63:0] spt_cmd_addr;
wire          spt_cmd_cube_end;
wire    [1:0] spt_cmd_lenb;
wire   [12:0] spt_cmd_size;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign op_done = op_prcess & cmd_fifo_wr_prdy & is_cube_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_prcess <= 1'b0;
  end else begin
    if (op_load) begin
        op_prcess <= 1'b1;
    end else if (op_done) begin
        op_prcess <= 1'b0;
    end
  end
end
assign cmd_fifo_wr_pvld = op_prcess;

assign cmd_fifo_wr_accpet = cmd_fifo_wr_pvld & cmd_fifo_wr_prdy;

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
 
assign cfg_base_addr = {reg2dp_dst_base_addr_high,reg2dp_dst_base_addr_low,5'd0};

//==============
// CUBE DRAW
//==============
assign is_line_end  = 1'b1;
assign is_surf_end  = is_line_end & is_last_h;
assign is_split_end = is_surf_end & is_last_surf;
assign is_cube_end  = is_split_end & is_last_wg;

// WIDTH COUNT: in width direction, indidate one block 
//assign split_size_of_width = is_fspt ? reg2dp_partial_width_in_first :
//                             is_lspt ? reg2dp_partial_width_in_last :
//                             is_mspt ? reg2dp_partial_width_in_mid :  {10{`x_or_0}};
assign split_size_of_width = is_fspt ? reg2dp_partial_width_out_first :
                             is_lspt ? reg2dp_partial_width_out_last :
                             is_mspt ? reg2dp_partial_width_out_mid :  {10{`x_or_0}};

assign size_of_width = cfg_mode_split ? {3'd0,split_size_of_width} : reg2dp_cube_out_width;

assign splitw_stride = (size_of_width+1)<<5;

// WG: WidthGroup, including one FSPT, one LSPT, and many MSPT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_wg <= {8{1'b0}};
  end else begin
    if (op_load) begin
        count_wg <= 0;
    end else if (cmd_fifo_wr_accpet) begin
        if (is_split_end) begin
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

//==============
// C direction: count_b + count_surf
// count_b: in each W in line, will go 4 step in c first
// count_surf: when one surf with 4c is done, will go to next surf
//==============

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
//&Always;
//    if (cfg_do_int8) begin
//        size_of_byte_in_c = {1'b0,reg2dp_cube_out_channel[::range(13)]};
//    end else if (cfg_do_int16) begin
//        size_of_byte_in_c = {reg2dp_cube_out_channel[::range(13)],1'b0};
//    end else begin
//        size_of_byte_in_c = {reg2dp_cube_out_channel[::range(13)],1'b0};
//    end
//&End;
//assign size_of_surf = size_of_byte_in_c[::range(14-5,5)]; // include the last unaligned channels
//assign size_of_b = is_last_surf ? size_of_byte_in_c[::range(2,3)] : 2'd3;
assign size_of_surf_use[10:0] = size_of_byte_in_c[14:5] + (|size_of_byte_in_c[4:0]); // include the last unaligned channels
assign {mon_size_of_surf,size_of_surf[9:0]} = size_of_surf_use - 1'b1;
assign size_of_b = 2'd3;

//==============
// COUNT SURF
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_surf <= {10{1'b0}};
  end else begin
    if (cmd_fifo_wr_accpet) begin
        if (is_split_end) begin
            count_surf <= 0;
        end else if (is_surf_end) begin
            count_surf <= count_surf + 1;
        end
    end
  end
end
assign is_last_surf = (count_surf==size_of_surf);

// per Surf
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (cmd_fifo_wr_accpet) begin
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
// ADDR
//==============
// LINE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_line <= {64{1'b0}};
    {mon_base_addr_line_c,base_addr_line} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_line <= cfg_base_addr;
    end else if (cmd_fifo_wr_accpet) begin
        if (is_split_end) begin
            {mon_base_addr_line_c,base_addr_line} <= base_addr_split + splitw_stride;
        end else if (is_surf_end) begin
            {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + {reg2dp_dst_surface_stride,5'd0};
        end else if (is_line_end) begin
            {mon_base_addr_line_c,base_addr_line} <= base_addr_line + {reg2dp_dst_line_stride,5'd0};
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
  nv_assert_never #(0,0,"PDP_WDMA: no overflow is allowed")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_line_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    base_addr_surf <= {64{1'b0}};
    {mon_base_addr_surf_c,base_addr_surf} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_surf <= cfg_base_addr;
    end else if (cmd_fifo_wr_accpet) begin
        if (is_split_end) begin
            {mon_base_addr_surf_c,base_addr_surf} <= base_addr_split + splitw_stride;
        end else if (is_surf_end) begin
            {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + {reg2dp_dst_surface_stride,5'd0};
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
  nv_assert_never #(0,0,"PDP_WDMA: no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_surf_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
        base_addr_split <= cfg_base_addr;
    end else if (cmd_fifo_wr_accpet) begin
        if (is_split_end) begin
            {mon_base_addr_split_c,base_addr_split} <= base_addr_split + splitw_stride;
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
  nv_assert_never #(0,0,"PDP_WDMA: no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_split_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// CMD FIFO WRITE 
//==============
NV_NVDLA_PDP_WDMA_CMD_fifo u_fifo (
   .nvdla_core_clk   (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)      //|< i
  ,.cmd_fifo_wr_prdy (cmd_fifo_wr_prdy)     //|> w
  ,.cmd_fifo_wr_pvld (cmd_fifo_wr_pvld)     //|< w
  ,.cmd_fifo_wr_pd   (cmd_fifo_wr_pd[79:0]) //|< w
  ,.cmd_fifo_rd_prdy (cmd_fifo_rd_prdy)     //|< i
  ,.cmd_fifo_rd_pvld (cmd_fifo_rd_pvld)     //|> o
  ,.cmd_fifo_rd_pd   (cmd_fifo_rd_pd[79:0]) //|> o
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])  //|< i
  );
//==============
// DMA Req : ADDR : Generation
//==============
assign spt_cmd_addr = base_addr_line;
assign spt_cmd_size = size_of_width;
assign spt_cmd_lenb = size_of_b;
assign spt_cmd_cube_end = is_cube_end;

// PKT_PACK_WIRE( pdp_wdma_cmd , spt_cmd_ , cmd_fifo_wr_pd )
assign      cmd_fifo_wr_pd[63:0] =    spt_cmd_addr[63:0];
assign      cmd_fifo_wr_pd[76:64] =    spt_cmd_size[12:0];
assign      cmd_fifo_wr_pd[78:77] =    spt_cmd_lenb[1:0];
assign      cmd_fifo_wr_pd[79] =    spt_cmd_cube_end ;

endmodule // NV_NVDLA_PDP_WDMA_cmd

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_WDMA_CMD_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus cmd_fifo_wr -rd_pipebus cmd_fifo_rd -d 1 -wr_reg -ram_bypass -w 80 -ram ff -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_WDMA_CMD_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , cmd_fifo_wr_prdy
    , cmd_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , cmd_fifo_wr_pause
`endif
    , cmd_fifo_wr_pd
    , cmd_fifo_rd_prdy
    , cmd_fifo_rd_pvld
    , cmd_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cmd_fifo_wr_prdy;
input         cmd_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         cmd_fifo_wr_pause;
`endif
input  [79:0] cmd_fifo_wr_pd;
input         cmd_fifo_rd_prdy;
output        cmd_fifo_rd_pvld;
output [79:0] cmd_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        cmd_fifo_wr_pvld_in;                                // registered cmd_fifo_wr_pvld
reg        wr_busy_in;                              // inputs being held this cycle?
assign     cmd_fifo_wr_prdy = !wr_busy_in;
wire       cmd_fifo_wr_busy_next;                           // fwd: fifo busy next?

// factor for better timing with distant cmd_fifo_wr_pvld signal
wire       wr_busy_in_next_wr_req_eq_1 = cmd_fifo_wr_busy_next;
wire       wr_busy_in_next_wr_req_eq_0 = (cmd_fifo_wr_pvld_in && cmd_fifo_wr_busy_next) && !wr_reserving;
`ifdef FV_RAND_WR_PAUSE
wire       wr_busy_in_next = (cmd_fifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                             || cmd_fifo_wr_pause ;
`else
wire       wr_busy_in_next = (cmd_fifo_wr_pvld? wr_busy_in_next_wr_req_eq_1 : wr_busy_in_next_wr_req_eq_0)
                              
                            // synopsys translate_off
                            `ifndef SYNTH_LEVEL1_COMPILE
                            `ifndef SYNTHESIS
                            || wr_pause_rand
                            `endif
                            `endif
                            // synopsys translate_on
                             ;
`endif
wire       wr_busy_in_int;
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_pvld_in <=  1'b0;
        wr_busy_in <=  1'b0;
    end else begin
        wr_busy_in <=  wr_busy_in_next;
        if ( !wr_busy_in_int ) begin
            cmd_fifo_wr_pvld_in  <=  cmd_fifo_wr_pvld && !wr_busy_in;
        end
        //synopsys translate_off
            else if ( wr_busy_in_int ) begin
        end else begin
            cmd_fifo_wr_pvld_in  <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

reg        cmd_fifo_wr_busy_int;		        	// copy for internal use
assign       wr_reserving = cmd_fifo_wr_pvld_in && !cmd_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg        cmd_fifo_wr_count;			// write-side count

wire       wr_count_next_wr_popping = wr_reserving ? cmd_fifo_wr_count : (cmd_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire       wr_count_next_no_wr_popping = wr_reserving ? (cmd_fifo_wr_count + 1'd1) : cmd_fifo_wr_count; // spyglass disable W164a W484
wire       wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_1 = ( wr_count_next_no_wr_popping == 1'd1 );
wire wr_count_next_is_1 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_1;
wire       wr_limit_muxed;  // muxed with simulation/emulation overrides
wire       wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
assign     cmd_fifo_wr_busy_next = wr_count_next_is_1 || // busy next cycle?
                          (wr_limit_reg != 1'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
assign     wr_busy_in_int = cmd_fifo_wr_pvld_in && cmd_fifo_wr_busy_int;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_busy_int <=  1'b0;
        cmd_fifo_wr_count <=  1'd0;
    end else begin
	cmd_fifo_wr_busy_int <=  cmd_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    cmd_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            cmd_fifo_wr_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as cmd_fifo_wr_pvld_in

//
// RAM
//

wire rd_popping;

wire ram_we = wr_pushing && (cmd_fifo_wr_count > 1'd0 || !rd_popping);   // note: write occurs next cycle
wire ram_iwe = !wr_busy_in && cmd_fifo_wr_pvld;  
wire [79:0] cmd_fifo_rd_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_WDMA_CMD_fifo_flopram_rwsa_1x80 ram (
      .clk( nvdla_core_clk )
    , .clk_mgated( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( cmd_fifo_wr_pd )
    , .iwe        ( ram_iwe )
    , .we        ( ram_we )
    , .ra        ( (cmd_fifo_wr_count == 0) ? 1'd1 : 1'b0 )
    , .dout        ( cmd_fifo_rd_pd )
    );


//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       cmd_fifo_rd_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd_fifo_rd_pvld && cmd_fifo_rd_prdy;

reg        cmd_fifo_rd_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire       rd_count_next_rd_popping = rd_pushing ? cmd_fifo_rd_count : 
                                                                (cmd_fifo_rd_count - 1'd1);
wire       rd_count_next_no_rd_popping =  rd_pushing ? (cmd_fifo_rd_count + 1'd1) : 
                                                                    cmd_fifo_rd_count;
// spyglass enable_block W164a W484
wire       rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd_fifo_rd_pvld = cmd_fifo_rd_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_count <=  1'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd_fifo_rd_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd_fifo_rd_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cmd_fifo_wr_pvld_in && !cmd_fifo_wr_busy_int) || (cmd_fifo_wr_busy_int != cmd_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (cmd_fifo_rd_pvld && cmd_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_WDMA_CMD_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_WDMA_CMD_fifo_wr_limit : 1'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 1'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 1'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 1'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg       wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 1'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_PDP_WDMA_CMD_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( cmd_fifo_wr_pvld && !(!cmd_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
    , .max      ( {31'd0, (wr_limit_reg == 1'd0) ? 1'd1 : wr_limit_reg} )
    , .curr	( {31'd0, cmd_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_WDMA_CMD_fifo") true
// synopsys dc_script_end


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


endmodule // NV_NVDLA_PDP_WDMA_CMD_fifo

// 
// Flop-Based RAM (with internal wr_reg)
//
module NV_NVDLA_PDP_WDMA_CMD_fifo_flopram_rwsa_1x80 (
      clk
    , clk_mgated
    , pwrbus_ram_pd
    , di
    , iwe
    , we
    , ra
    , dout
    );

input  clk;  // write clock
input  clk_mgated;  // write clock mgated
input [31 : 0] pwrbus_ram_pd;
input  [79:0] di;
input  iwe;
input  we;
input  [0:0] ra;
output [79:0] dout;

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

reg [79:0] di_d;  // -wr_reg

always @( posedge clk ) begin
    if ( iwe ) begin
        di_d <=  di; // -wr_reg
    end
end
reg [79:0] ram_ff0;

always @( posedge clk_mgated ) begin
    if ( we ) begin
	ram_ff0 <=  di_d;
    end
end

reg [79:0] dout;

always @(*) begin
    case( ra ) 
    1'd0:       dout = ram_ff0;
    1'd1:       dout = di_d;
    //VCS coverage off
    default:    dout = {80{`x_or_0}};
    //VCS coverage on
    endcase
end

endmodule // NV_NVDLA_PDP_WDMA_CMD_fifo_flopram_rwsa_1x80

