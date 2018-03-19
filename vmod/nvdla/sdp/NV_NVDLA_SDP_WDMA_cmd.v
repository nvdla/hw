// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_cmd.v

#include "NV_NVDLA_SDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_WDMA_cmd (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,pwrbus_ram_pd             //|< i
  ,op_load                   //|< i
  ,cmd2dat_dma_pd            //|> o
  ,cmd2dat_dma_pvld          //|> o
  ,cmd2dat_dma_prdy          //|< i
  ,cmd2dat_spt_pd            //|> o
  ,cmd2dat_spt_pvld          //|> o
  ,cmd2dat_spt_prdy          //|< i
  ,reg2dp_batch_number       //|< i
  ,reg2dp_winograd           //|< i
  ,reg2dp_channel            //|< i
  ,reg2dp_height             //|< i
  ,reg2dp_width              //|< i
  ,reg2dp_output_dst         //|< i
  ,reg2dp_out_precision      //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_dst_base_addr_high //|< i
  ,reg2dp_dst_base_addr_low  //|< i
  ,reg2dp_dst_batch_stride   //|< i
  ,reg2dp_dst_line_stride    //|< i
  ,reg2dp_dst_surface_stride //|< i
  ,reg2dp_ew_alu_algo        //|< i
  ,reg2dp_ew_alu_bypass      //|< i
  ,reg2dp_ew_bypass          //|< i
  );
//
// NV_NVDLA_SDP_WDMA_cmd_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;
input [31:0] pwrbus_ram_pd;
input        op_load;

output        cmd2dat_spt_pvld;  
input         cmd2dat_spt_prdy;  
output [14:0] cmd2dat_spt_pd;

output        cmd2dat_dma_pvld;  
input         cmd2dat_dma_prdy;  
output [SDP_WR_CMD_DW+1:0] cmd2dat_dma_pd;

input  [4:0] reg2dp_batch_number;
input        reg2dp_winograd;
input [12:0] reg2dp_channel;
input [12:0] reg2dp_height;
input [12:0] reg2dp_width;
input        reg2dp_output_dst;
input  [1:0] reg2dp_out_precision;
input  [1:0] reg2dp_proc_precision;
input [31:0] reg2dp_dst_base_addr_high;
input [31-AM_AW:0] reg2dp_dst_base_addr_low;
input [31-AM_AW:0] reg2dp_dst_batch_stride;
input [31-AM_AW:0] reg2dp_dst_line_stride;
input [31-AM_AW:0] reg2dp_dst_surface_stride;
input  [1:0] reg2dp_ew_alu_algo;
input        reg2dp_ew_alu_bypass;
input        reg2dp_ew_bypass;

#ifdef NVDLA_BATCH_ENABLE
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_batch;
#endif
#ifdef NVDLA_WINOGRAD_ENABLE
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_winog;
#endif
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_line;
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_surf;
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_width;
#ifdef NVDLA_BATCH_ENABLE
reg          mon_base_addr_batch_c;
#endif
#ifdef NVDLA_WINOGRAD_ENABLE
reg          mon_base_addr_winog_c;
#endif
reg          mon_base_addr_line_c;
reg          mon_base_addr_surf_c;
reg          mon_base_addr_width_c;
wire         cfg_addr_en;
wire         cfg_di_int16;
wire         cfg_di_int8;
wire         cfg_do_int16;
wire         cfg_do_int8;
wire         cfg_mode_8to16;
wire         cfg_mode_1x1_nbatch;
wire         cfg_mode_batch;
wire  [31-AM_AW:0] cfg_dst_batch_stride;
wire         cfg_mode_winog;
wire  [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] cfg_dst_addr;
wire  [31-AM_AW:0] cfg_dst_line_stride;
wire  [31-AM_AW:0] cfg_dst_surf_stride;
wire         cfg_mode_1x1_pack;
wire         cfg_mode_eql;
wire         cfg_mode_norml;
wire         cfg_mode_pdp;
wire         cfg_mode_quite;

#ifdef NVDLA_BATCH_ENABLE
reg    [4:0] count_batch;
wire   [4:0] size_of_batch;
#endif
#ifdef NVDLA_WINOGRAD_ENABLE
reg    [1:0] count_wg;
wire   [1:0] size_of_wg;
#endif
reg    [13-AM_AW:0] count_c;
reg   [12:0] count_h;
reg   [13:0] count_w;
reg    [13-AM_AW:0] size_of_surf;
wire  [12:0] size_of_height;
reg   [13:0] size_of_width;
wire         is_cube_end;
wire         is_elem_end;
wire         is_last_e;
wire         is_last_c;
wire         is_last_h;
wire         is_last_w;
wire         is_line_end;
wire         is_surf_end;
wire         is_last_wg;
wire         is_winog_end;
wire         is_last_batch;

wire         cmd_accept;
reg          cmd_vld;
wire         cmd_rdy;
wire  [SDP_WR_CMD_DW+1:0] dma_fifo_pd;
wire         dma_fifo_prdy;
wire         dma_fifo_pvld;
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] dma_addr;
reg   [12:0] dma_size;
reg   [13:0] spt_size;
wire   [13-AM_AW:0] mode_1x1_dma_size;
wire   [13-AM_AW:0] mode_1x1_spt_size;
wire         is_ftrans;
wire         is_ltrans;
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
reg    [2:0] mode_8to16_size_of_ftrans_2nd;
reg    [2:0] mode_8to16_size_of_ltrans_2nd;
reg    [2:0] mode_8to16_size_of_trans;
wire   [2:0] mode_8to16_dma_size;
wire   [2:0] mode_8to16_size_of_ftrans;
wire   [2:0] mode_8to16_size_of_ftrans_1st;
wire   [2:0] mode_8to16_size_of_ltrans;
wire   [2:0] mode_8to16_size_of_ltrans_1st;
wire   [2:0] mode_8to16_size_of_mtrans;
wire   [2:0] mode_8to16_size_of_mtrans_1st;
wire   [2:0] mode_8to16_size_of_mtrans_2nd;
wire  [13:0] mode_8to16_size_of_reqs;
wire  [13:0] mode_8to16_size_of_reqs_p;
wire   [0:0] mode_8to16_spt_size;
#endif
#ifdef NVDLA_BATCH_ENABLE
reg    [2:0] mode_batch_size_of_trans;
wire   [2:0] mode_batch_dma_size;
wire   [2:0] mode_batch_size_of_ftrans;
wire   [2:0] mode_batch_size_of_ltrans;
wire   [2:0] mode_batch_size_of_mtrans;
wire  [12:0] mode_batch_size_of_reqs;
wire  [12:0] mode_batch_size_of_reqs_p;
wire   [1:0] mode_batch_spt_size;
#endif
#ifdef NVDLA_WINOGRAD_ENABLE
reg    [2:0] mode_winog_size_of_trans;
wire         mode_winog_dma_size;
wire   [2:0] mode_winog_size_of_ftrans;
wire   [2:0] mode_winog_size_of_ltrans;
wire   [2:0] mode_winog_size_of_mtrans;
wire  [11:0] mode_winog_size_of_reqs;
wire   [1:0] mode_winog_spt_size;
#endif
wire  [12:0] mode_norml_dma_size;
wire  [13:0] mode_norml_spt_size;
wire  [14:0] spt_fifo_pd;
wire         spt_fifo_prdy;
wire         spt_fifo_pvld;


////////cfg reg////////////    
#if (NVDLA_MEM_ADDRESS_WIDTH > 32)
assign cfg_dst_addr = {reg2dp_dst_base_addr_high,reg2dp_dst_base_addr_low};
#else
assign cfg_dst_addr = reg2dp_dst_base_addr_low;
#endif
assign cfg_dst_surf_stride = {reg2dp_dst_surface_stride};
assign cfg_dst_line_stride = {reg2dp_dst_line_stride};
#ifdef NVDLA_BATCH_ENABLE
assign cfg_dst_batch_stride = {reg2dp_dst_batch_stride};
assign cfg_mode_batch = (reg2dp_batch_number!=0);
#else 
assign cfg_mode_batch = 1'b0; 
#endif
#ifdef NVDLA_WINOGRAD_ENABLE
assign cfg_mode_winog = reg2dp_winograd== 1'h1 ;
#else 
assign cfg_mode_winog = 1'b0 ;
#endif

assign cfg_di_int8  = reg2dp_proc_precision  == 0 ;
assign cfg_di_int16 = reg2dp_proc_precision  == 1 ;
assign cfg_do_int8  = reg2dp_out_precision == 0 ;
assign cfg_do_int16 = reg2dp_out_precision == 1 ;

#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
assign cfg_mode_8to16 = cfg_di_int8 & cfg_do_int16;
#else 
assign cfg_mode_8to16 = 1'b0;
#endif
assign cfg_mode_norml = !(cfg_mode_batch | cfg_mode_winog | cfg_mode_8to16);

assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);
assign cfg_mode_1x1_nbatch = cfg_mode_1x1_pack & !cfg_mode_batch ;

assign cfg_mode_eql   = (reg2dp_ew_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_algo== 2'h3 );

assign cfg_mode_pdp   = reg2dp_output_dst== 1'h1 ;

assign cfg_mode_quite = cfg_mode_eql | cfg_mode_pdp;
assign cfg_addr_en = !cfg_mode_quite;

//==============
// Surf is always in unit of ATOMIC (1x1x32B)
always @(
  cfg_di_int8
  or reg2dp_channel
  or cfg_di_int16
  ) begin
    if (cfg_di_int8) begin
        size_of_surf = {1'b0,reg2dp_channel[12:AM_AW]};
    end else if (cfg_di_int16) begin
        size_of_surf = reg2dp_channel[12:AM_AW2];
    end else begin
        size_of_surf = reg2dp_channel[12:AM_AW2];
    end
end

//=================================================
// Cube Shape
//=================================================
assign is_winog_end  = is_last_wg;
assign is_elem_end  = cfg_mode_1x1_nbatch | is_last_e;
assign is_line_end  = cfg_mode_1x1_nbatch | cfg_mode_norml | (is_last_batch & is_elem_end & is_last_w & is_winog_end);
assign is_surf_end  = cfg_mode_1x1_nbatch | is_line_end & is_last_h;
assign is_cube_end  = cfg_mode_1x1_nbatch | is_surf_end & is_last_c;

//==============
// Width Count;
//==============
// Norml Mode
#ifndef NVDLA_SDP_BATCH_1ATOM   //fixme
wire [2:0] beg_addr_offset = base_addr_line[2:0];
wire       is_beg_addr_odd = beg_addr_offset[0]==1'b1;
wire [3:0] end_addr_offset = beg_addr_offset + reg2dp_width[2:0];
wire       is_end_addr_odd = end_addr_offset[0]==1'b0;
wire       odd = ((is_ftrans & is_beg_addr_odd) || (is_ltrans && is_end_addr_odd));
#else
wire       odd = 1'b0;
#endif
          
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
// 8to16
assign mode_8to16_size_of_ftrans_1st = (odd) ? 3'd0 : 3'd1;
assign mode_8to16_size_of_mtrans_1st = 3'd1;
assign mode_8to16_size_of_ltrans_1st = is_end_addr_odd ? 3'd0 : 3'd1;
always @(posedge nvdla_core_clk) begin
  if ((cmd_accept & !is_elem_end) == 1'b1) begin
    mode_8to16_size_of_ftrans_2nd <= mode_8to16_size_of_ftrans_1st;
  end else if ((cmd_accept & !is_elem_end) == 1'b0) begin
  end else begin
    mode_8to16_size_of_ftrans_2nd <= 'bx; 
  end
end
assign mode_8to16_size_of_mtrans_2nd = mode_8to16_size_of_mtrans_1st; 
always @(posedge nvdla_core_clk) begin
  if ((cmd_accept & !is_elem_end) == 1'b1) begin
    mode_8to16_size_of_ltrans_2nd <= mode_8to16_size_of_ltrans_1st;
  end else if ((cmd_accept & !is_elem_end) == 1'b0) begin
  end else begin
    mode_8to16_size_of_ltrans_2nd <= 'bx;  
  end
end
assign mode_8to16_size_of_ftrans = is_elem_end ? mode_8to16_size_of_ftrans_2nd : mode_8to16_size_of_ftrans_1st;
assign mode_8to16_size_of_mtrans = is_elem_end ? mode_8to16_size_of_mtrans_2nd : mode_8to16_size_of_mtrans_1st;
assign mode_8to16_size_of_ltrans = is_elem_end ? mode_8to16_size_of_ltrans_2nd : mode_8to16_size_of_ltrans_1st;

assign mode_8to16_size_of_reqs_p[13:0] = reg2dp_width+is_beg_addr_odd+is_end_addr_odd;
assign mode_8to16_size_of_reqs[13:0]   = (mode_8to16_size_of_reqs_p[13:1]<<1) + 1; // 2 surf each
#endif

#ifdef NVDLA_WINOGRAD_ENABLE 
// winog
assign mode_winog_size_of_ftrans = 3'd1;
assign mode_winog_size_of_mtrans = 3'd1;
assign mode_winog_size_of_ltrans = 3'd1;
assign mode_winog_size_of_reqs[11:0] = reg2dp_width[12:1];
#endif

#ifdef NVDLA_BATCH_ENABLE
// batch
#ifndef NVDLA_SDP_BATCH_1ATOM
assign mode_batch_size_of_ftrans = (odd) ? 3'd0 : 3'd1;
assign mode_batch_size_of_mtrans = 3'd1;
assign mode_batch_size_of_ltrans = is_end_addr_odd ? 3'd0 : 3'd1;
assign {mon_mode_batch_size_of_reqs_p_c,mode_batch_size_of_reqs_p[12:0]} = reg2dp_width+is_beg_addr_odd+is_end_addr_odd;
assign mode_batch_size_of_reqs[12:0]   = mode_batch_size_of_reqs_p[12:1]; 
#else
assign mode_batch_size_of_ftrans = 3'd0; 
assign mode_batch_size_of_mtrans = 3'd0;
assign mode_batch_size_of_ltrans = 3'd0;
assign mode_batch_size_of_reqs[12:0] = reg2dp_width[12:0];; 
#endif
#endif

//================================
// SIZE of Trans
//================================
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
always @(
  is_ftrans
  or mode_8to16_size_of_ftrans
  or is_ltrans
  or mode_8to16_size_of_ltrans
  or mode_8to16_size_of_mtrans
  ) begin
   if (is_ftrans) begin
       mode_8to16_size_of_trans = mode_8to16_size_of_ftrans;
   end else if (is_ltrans) begin
       mode_8to16_size_of_trans = mode_8to16_size_of_ltrans;
   end else begin
       mode_8to16_size_of_trans = mode_8to16_size_of_mtrans;
   end
end
#endif

#ifdef NVDLA_WINOGRAD_ENABLE 
always @(
  is_ftrans
  or mode_winog_size_of_ftrans
  or is_ltrans
  or mode_winog_size_of_ltrans
  or mode_winog_size_of_mtrans
  ) begin
   if (is_ftrans) begin
       mode_winog_size_of_trans = mode_winog_size_of_ftrans;
   end else if (is_ltrans) begin
       mode_winog_size_of_trans = mode_winog_size_of_ltrans;
   end else begin
       mode_winog_size_of_trans = mode_winog_size_of_mtrans;
   end
end
#endif

#ifdef NVDLA_BATCH_ENABLE
always @(
  is_ftrans
  or mode_batch_size_of_ftrans
  or is_ltrans
  or mode_batch_size_of_ltrans
  or mode_batch_size_of_mtrans
  ) begin
   if (is_ftrans) begin
       mode_batch_size_of_trans = mode_batch_size_of_ftrans;
   end else if (is_ltrans) begin
       mode_batch_size_of_trans = mode_batch_size_of_ltrans;
   end else begin
       mode_batch_size_of_trans = mode_batch_size_of_mtrans;
   end
end
#endif

#ifdef NVDLA_WINOGRAD_ENABLE 
// COUNT WG
assign size_of_wg = cfg_mode_winog ? 2'd3 : 2'd0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_wg <= {2{1'b0}};
  end else begin
    if (cfg_mode_winog) begin
        if (cmd_accept) begin
            if (is_last_wg) begin
                count_wg <= 0;
            end else begin
                count_wg <= count_wg + 1'b1;
            end
        end
    end
  end
end
assign is_last_wg = count_wg==size_of_wg;
#else
assign is_last_wg = 1'b1;
#endif

always @(
  reg2dp_width
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
  or cfg_mode_8to16
  or mode_8to16_size_of_reqs
#endif 
#ifdef NVDLA_WINOGRAD_ENABLE 
  or cfg_mode_winog
  or mode_winog_size_of_reqs
#endif
#ifdef NVDLA_BATCH_ENABLE
  or cfg_mode_batch
  or mode_batch_size_of_reqs
#endif
  ) begin
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
    if (cfg_mode_8to16) 
        size_of_width = mode_8to16_size_of_reqs;
    else
#endif
#ifdef NVDLA_WINOGRAD_ENABLE 
    if (cfg_mode_winog)
        size_of_width = {2'b0, mode_winog_size_of_reqs};
    else
#endif
#ifdef NVDLA_BATCH_ENABLE
    if (cfg_mode_batch) 
        size_of_width = {1'b0, mode_batch_size_of_reqs};
    else
#endif 
        size_of_width = {1'b0, reg2dp_width};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {14{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_line_end) begin
            count_w <= 0;
        end else if (is_last_batch & is_winog_end) begin
            count_w <= count_w + 1'b1;
        end
    end
  end
end
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
assign is_ltrans = cfg_mode_8to16 ? (count_w==size_of_width || count_w==size_of_width-1) : (count_w==size_of_width);
assign is_ftrans = cfg_mode_8to16 ? (count_w==0 || count_w==1) : (count_w==0);
#else
assign is_ltrans = (count_w==size_of_width);
assign is_ftrans = (count_w==0);
#endif
assign is_last_w = is_ltrans;

#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
//==============
// Element Count: for 8to16 only
//==============
reg    count_e;
wire   size_of_elem = cfg_mode_8to16 ? 1'h1 : 1'h0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_e <= 1'b0;
  end else begin
    if (cfg_mode_8to16) begin
        if (cmd_accept) begin
            if (is_elem_end) begin
                count_e <= 0;
            end else begin
                count_e <= count_e + 1'b1;
            end
        end
    end
  end
end
assign is_last_e = (count_e == size_of_elem);
#else
assign is_last_e = 1'b1;
#endif

//==============
// HEIGHT Count:
//==============
#ifdef NVDLA_WINOGRAD_ENABLE 
assign size_of_height = cfg_mode_winog ? reg2dp_height>>2 : reg2dp_height;
#else
assign size_of_height = reg2dp_height;
#endif
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_last_batch) begin
            if (is_surf_end) begin
                count_h <= 0;
            end else if (is_line_end) begin
                count_h <= count_h + 1;
            end
        end
    end
  end
end
assign is_last_h = count_h==size_of_height;

//==============
// CHANNEL Count
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_c <= {9{1'b0}};
  end else begin
    if (cmd_accept) begin
        if (is_last_batch) begin
            if (is_cube_end) begin
                count_c <= 0;
            end else if (is_surf_end) begin
                count_c <= count_c + 1;
            end
        end
    end
  end
end
assign is_last_c = (count_c==size_of_surf);

#ifdef NVDLA_BATCH_ENABLE
//==============
// BATCH Count: 
//==============
assign size_of_batch = reg2dp_batch_number;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_batch <= {5{1'b0}};
  end else begin
    if (cfg_mode_batch) begin // this to gate count_batch in batch mode
        if (cmd_accept) begin
            if (is_last_batch) begin
                count_batch <= 0;
            end else begin
                count_batch <= count_batch + 1;
            end
        end
    end
  end
end
assign is_last_batch = (count_batch==size_of_batch);
#else
assign is_last_batch = 1'b1; 
#endif

//==========================================
// DMA Req : ADDR PREPARE
//==========================================
#ifdef NVDLA_BATCH_ENABLE
// BATCH
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_batch_c,base_addr_batch} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_mode_batch & cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_batch_c,base_addr_batch} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            if (is_last_batch) begin
                if (is_surf_end) begin
                    {mon_base_addr_batch_c,base_addr_batch} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_batch_c,base_addr_batch} <= base_addr_line + cfg_dst_line_stride;
                end else begin
                    {mon_base_addr_batch_c,base_addr_batch} <= base_addr_width + (mode_batch_size_of_trans+1);
                end
            end else begin
                {mon_base_addr_batch_c,base_addr_batch} <= base_addr_batch + cfg_dst_batch_stride;
            end
        end
    end
  end
end
#endif

#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
reg   [NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] base_addr_elem;
reg          mon_base_addr_elem_c;
// ELEM
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_elem_c,base_addr_elem} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_mode_8to16 & cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_elem_c,base_addr_elem} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            if (is_surf_end) begin
                {mon_base_addr_elem_c,base_addr_elem} <= base_addr_surf + (cfg_dst_surf_stride<<1);
            end else if (is_line_end) begin
                {mon_base_addr_elem_c,base_addr_elem} <= base_addr_line + cfg_dst_line_stride;
            end else if (is_elem_end) begin
                {mon_base_addr_elem_c,base_addr_elem} <= base_addr_width + (mode_8to16_size_of_trans+1);
            end else begin
                {mon_base_addr_elem_c,base_addr_elem} <= base_addr_width + cfg_dst_surf_stride;
            end
        end
    end
  end
end
#endif

#ifdef NVDLA_WINOGRAD_ENABLE 
// WINOG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_winog_c,base_addr_winog} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_mode_winog & cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_winog_c,base_addr_winog} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            if (is_surf_end) begin
                {mon_base_addr_winog_c,base_addr_winog} <= base_addr_surf + cfg_dst_surf_stride;
            end else if (is_line_end) begin
                {mon_base_addr_winog_c,base_addr_winog} <= base_addr_line + (cfg_dst_line_stride<<2);
            end else if (is_winog_end) begin
                {mon_base_addr_winog_c,base_addr_winog} <= base_addr_width + (mode_winog_size_of_trans+1);
            end else begin
                {mon_base_addr_winog_c,base_addr_winog} <= base_addr_winog + cfg_dst_line_stride;
            end
        end
    end
  end
end
#endif

// WIDTH
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_width_c,base_addr_width} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_width_c,base_addr_width} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
            if (cfg_mode_8to16 ) begin
                if (is_surf_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_surf + (cfg_dst_surf_stride<<1);
                end else if (is_line_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_line + cfg_dst_line_stride;
                end else if (is_elem_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_width + (mode_8to16_size_of_trans+1);
                end
            end else
            #endif 
            #ifdef NVDLA_WINOGRAD_ENABLE 
            if (cfg_mode_winog ) begin
                if (is_surf_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_line + (cfg_dst_line_stride<<2);
                end else if (is_winog_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_width + (mode_winog_size_of_trans+1);
                end
            end else 
            #endif 
            #ifdef NVDLA_BATCH_ENABLE 
            if (cfg_mode_batch & is_last_batch ) begin
                if (is_surf_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_line + cfg_dst_line_stride;
                end else if (is_elem_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_width + (mode_batch_size_of_trans+1);
                end
            end else 
            #endif 
            begin
                if (is_surf_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_width_c,base_addr_width} <= base_addr_line + cfg_dst_line_stride;
                end
            end
        end
    end
  end
end

// LINE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_line_c,base_addr_line} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_line_c,base_addr_line} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
            if (cfg_mode_8to16) begin
                if (is_surf_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + (cfg_dst_surf_stride<<1);
                end else if (is_line_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_line + cfg_dst_line_stride;
                end
            end else 
            #endif
            #ifdef NVDLA_WINOGRAD_ENABLE 
            if (cfg_mode_winog) begin
                if (is_surf_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_line + (cfg_dst_line_stride<<2);
                end
            end else 
            #endif 
            #ifdef NVDLA_BATCH_ENABLE 
            if (cfg_mode_batch && is_last_batch) begin
                if (is_surf_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_line + cfg_dst_line_stride;
                end
            end else 
            #endif 
            begin
                if (is_surf_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_surf + cfg_dst_surf_stride;
                end else if (is_line_end) begin
                    {mon_base_addr_line_c,base_addr_line} <= base_addr_line + cfg_dst_line_stride;
                end
            end
        end
    end
  end
end

// SURF
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_base_addr_surf_c,base_addr_surf} <= {(NVDLA_MEM_ADDRESS_WIDTH-AM_AW+1){1'b0}};
  end else begin
    if (cfg_addr_en) begin
        if (op_load) begin
            {mon_base_addr_surf_c,base_addr_surf} <= {1'b0,cfg_dst_addr};
        end else if (cmd_accept) begin
            #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
            if (cfg_mode_8to16) begin
                if (is_surf_end) begin
                    {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + (cfg_dst_surf_stride<<1);
                end
            end else
            #endif
            #ifdef NVDLA_WINOGRAD_ENABLE 
            if (cfg_mode_winog) begin
                if (is_surf_end) begin
                    {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + cfg_dst_surf_stride;
                end
            end else 
            #endif 
            #ifdef NVDLA_BATCH_ENABLE 
            if (cfg_mode_batch && is_last_batch) begin
                if (is_surf_end) begin
                    {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + cfg_dst_surf_stride;
                end
            end else 
            #endif 
            begin
                if (is_surf_end) begin
                    {mon_base_addr_surf_c,base_addr_surf} <= base_addr_surf + cfg_dst_surf_stride;
                end
            end
        end
    end
  end
end

//==========================================
// DMA Req : SIZE
//==========================================
always @(
  base_addr_line
  #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
  or cfg_mode_8to16
  or base_addr_elem
  #endif
  #ifdef NVDLA_WINOGRAD_ENABLE 
  or cfg_mode_winog
  or base_addr_winog
  #endif
  #ifdef NVDLA_BATCH_ENABLE 
  or cfg_mode_batch
  or base_addr_batch
  #endif
  ) begin
    #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
    if (cfg_mode_8to16) begin
        dma_addr = base_addr_elem;
    end else 
    #endif
    #ifdef NVDLA_WINOGRAD_ENABLE 
    if (cfg_mode_winog) begin
        dma_addr = base_addr_winog;
    end else 
    #endif 
    #ifdef NVDLA_BATCH_ENABLE 
    if (cfg_mode_batch) begin
        dma_addr = base_addr_batch;
    end else 
    #endif 
    begin
        dma_addr = base_addr_line;
    end
end

//========================
// Output: one for data write spt_; and one for data read dma_
//========================
// spt_size is to tell how many data from dp2wdma for a corresponding DMA req to MC/CF if
// spt_size is in unit of cycle on dp2wdma
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
assign mode_8to16_spt_size[0:0] = odd ? 1'b0 : 1'b1;
#ifdef NVDLA_WINOGRAD_ENABLE 
assign mode_winog_spt_size[1:0] = cfg_do_int8 ? 2'd3 : 2'd1;
#endif
#ifdef NVDLA_BATCH_ENABLE 
assign mode_batch_spt_size[1:0] = cfg_do_int8 ? (odd ? 2'd1 : 2'd3)  : (odd ? 2'd0 : 2'd1);
#endif
assign mode_1x1_spt_size = (cfg_do_int8 | cfg_di_int8) ? {reg2dp_channel[12:AM_AW],1'b1} : reg2dp_channel[12:AM_AW2];
assign mode_norml_spt_size[13:0] = cfg_do_int8 ? {reg2dp_width,1'b1} : {1'b0,reg2dp_width};
#else
#ifdef NVDLA_WINOGRAD_ENABLE 
assign mode_winog_spt_size[1:0] = 2'd1;
#endif
#ifdef NVDLA_BATCH_ENABLE 
#ifndef NVDLA_SDP_BATCH_1ATOM
assign mode_batch_spt_size[1:0] = (odd ? 2'd0 : 2'd1);
#else
assign mode_batch_spt_size[1:0] = 2'd0;
#endif
#endif
assign mode_1x1_spt_size = (cfg_do_int8 | cfg_di_int8) ? {1'b0,reg2dp_channel[12:AM_AW]} : reg2dp_channel[12:AM_AW2];
assign mode_norml_spt_size[13:0] = {1'b0,reg2dp_width};
#endif

always @(
  cfg_mode_1x1_nbatch
  or mode_1x1_spt_size
  #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
  or cfg_mode_8to16
  or mode_8to16_spt_size
  #endif
  #ifdef NVDLA_WINOGRAD_ENABLE 
  or cfg_mode_winog
  or mode_winog_spt_size
  #endif
  #ifdef NVDLA_BATCH_ENABLE 
  or cfg_mode_batch
  or mode_batch_spt_size
  #endif
  or mode_norml_spt_size
  ) begin
    if (cfg_mode_1x1_nbatch) 
        spt_size = {{AM_AW{1'b0}}, mode_1x1_spt_size};
    #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
    else if (cfg_mode_8to16) 
        spt_size = {{13{1'b0}}, mode_8to16_spt_size};
    #endif
    #ifdef NVDLA_WINOGRAD_ENABLE 
    else if (cfg_mode_winog) 
        spt_size = {{12{1'b0}}, mode_winog_spt_size};
    #endif
    #ifdef NVDLA_BATCH_ENABLE 
    else if (cfg_mode_batch) 
        spt_size = {{12{1'b0}}, mode_batch_spt_size};
    #endif
    else 
        spt_size = mode_norml_spt_size;
end


//========================
// Output: one for data write spt_; and one for data read dma_
//========================
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
assign mode_8to16_dma_size = mode_8to16_size_of_trans;
#endif
#ifdef NVDLA_WINOGRAD_ENABLE 
assign mode_winog_dma_size = 1'd1;
#endif
#ifdef NVDLA_BATCH_ENABLE 
assign mode_batch_dma_size = mode_batch_size_of_trans;
#endif
#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
assign mode_1x1_dma_size   = cfg_mode_8to16 ? {reg2dp_channel[12:AM_AW],1'b1} : size_of_surf;
#else
assign mode_1x1_dma_size   = size_of_surf;  
#endif
assign mode_norml_dma_size = reg2dp_width;
always @(
  cfg_mode_1x1_nbatch
  or mode_1x1_dma_size
  #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
  or cfg_mode_8to16
  or mode_8to16_dma_size
  #endif
  #ifdef NVDLA_WINOGRAD_ENABLE 
  or cfg_mode_winog
  or mode_winog_dma_size
  #endif
  #ifdef NVDLA_BATCH_ENABLE 
  or cfg_mode_batch
  or mode_batch_dma_size
  #endif
  or mode_norml_dma_size
  ) begin
    if (cfg_mode_1x1_nbatch) 
        dma_size = {{AM_AW2{1'b0}}, mode_1x1_dma_size};
    #ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
    else if (cfg_mode_8to16) 
        dma_size = {{10{1'b0}}, mode_8to16_dma_size};
    #endif 
    #ifdef NVDLA_WINOGRAD_ENABLE 
    else if (cfg_mode_winog) 
        dma_size = {{12{1'b0}}, mode_winog_dma_size};
    #endif 
    #ifdef NVDLA_BATCH_ENABLE 
    else if (cfg_mode_batch)
        dma_size = {{10{1'b0}}, mode_batch_dma_size};
    #endif 
    else
        dma_size = mode_norml_dma_size;
end

//=================================================
// OUTPUT FIFO: SPT & DMA channel
//=================================================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_vld <= 1'b0;
  end else begin
    if (op_load) begin
        cmd_vld <= 1'b1;
    end else if (cmd_accept) begin
        if (is_cube_end) begin
            cmd_vld <= 1'b0;
        end
    end
  end
end

assign spt_fifo_pvld = cmd_vld & dma_fifo_prdy;
assign dma_fifo_pvld = cmd_vld & spt_fifo_prdy;

assign cmd_rdy = dma_fifo_prdy & spt_fifo_prdy;
assign cmd_accept = cmd_vld & cmd_rdy;

assign spt_fifo_pd[13:0] = spt_size[13:0];
assign spt_fifo_pd[14]   = odd ;

assign dma_fifo_pd[NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0] = dma_addr[NVDLA_MEM_ADDRESS_WIDTH-AM_AW-1:0];
assign dma_fifo_pd[SDP_WR_CMD_DW-1:NVDLA_MEM_ADDRESS_WIDTH-AM_AW] = dma_size[12:0];
assign dma_fifo_pd[SDP_WR_CMD_DW] = odd ;
assign dma_fifo_pd[SDP_WR_CMD_DW+1] = is_cube_end ;

NV_NVDLA_SDP_WDMA_CMD_sfifo u_sfifo (
   .nvdla_core_clk   (nvdla_core_clk)       
  ,.nvdla_core_rstn  (nvdla_core_rstn)      
  ,.spt_fifo_prdy    (spt_fifo_prdy)        
  ,.spt_fifo_pvld    (spt_fifo_pvld)        
  ,.spt_fifo_pd      (spt_fifo_pd[14:0])    
  ,.cmd2dat_spt_prdy (cmd2dat_spt_prdy)     
  ,.cmd2dat_spt_pvld (cmd2dat_spt_pvld)     
  ,.cmd2dat_spt_pd   (cmd2dat_spt_pd[14:0]) 
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])  
  );

NV_NVDLA_SDP_WDMA_CMD_dfifo u_dfifo (      
   .nvdla_core_clk   (nvdla_core_clk)       
  ,.nvdla_core_rstn  (nvdla_core_rstn)      
  ,.dma_fifo_prdy    (dma_fifo_prdy)        
  ,.dma_fifo_pvld    (dma_fifo_pvld)        
  ,.dma_fifo_pd      (dma_fifo_pd[SDP_WR_CMD_DW+1:0])    
  ,.cmd2dat_dma_prdy (cmd2dat_dma_prdy)     
  ,.cmd2dat_dma_pvld (cmd2dat_dma_pvld)     
  ,.cmd2dat_dma_pd   (cmd2dat_dma_pd[SDP_WR_CMD_DW+1:0]) 
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])  
  );



#ifdef NVDLA_BATCH_ENABLE 
//========================
// ASSERTIONS
//========================
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
  nv_assert_never #(0,0,"SDP_WDMA: no overflow is allowed")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_batch_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
#endif

#ifdef NVDLA_SDP_DATA_TYPE_INT8TO16
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
  nv_assert_never #(0,0,"SDP_WDMA: no overflow is allowed")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_elem_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
#endif

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
  nv_assert_never #(0,0,"SDP_WDMA: no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_width_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"SDP_WDMA: no overflow is allowed")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_line_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"SDP_WDMA: no overflow is allowed")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_surf_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

#ifdef NVDLA_BATCH_ENABLE 
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
  nv_assert_never #(0,0,"DST ADDR need be 64B aligned in multi-batch mode")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, op_load & cfg_mode_batch & cfg_dst_addr[0]==1); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"DST LINE STRIDE need be 64B aligned in multi-batch mode")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, op_load & cfg_mode_batch & cfg_dst_line_stride[0]==1 & (!cfg_mode_1x1_pack)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"DST SURF STRIDE need be 64B aligned in multi-batch mode")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, op_load & cfg_mode_batch & cfg_dst_surf_stride[0]==1 & (!cfg_mode_1x1_pack)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
#endif


//========================
// FUNCTION POINT
//========================
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

    property sdp_wdma_cmd__odd_address__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cmd_vld) && nvdla_core_rstn) |-> (odd);
    endproperty
    // Cover 0 : "odd"
    FUNCPOINT_sdp_wdma_cmd__odd_address__0_COV : cover property (sdp_wdma_cmd__odd_address__0_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_SDP_WDMA_cmd



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_WDMA_CMD_sfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , spt_fifo_prdy
    , spt_fifo_pvld
    , spt_fifo_pd
    , cmd2dat_spt_prdy
    , cmd2dat_spt_pvld
    , cmd2dat_spt_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        spt_fifo_prdy;
input         spt_fifo_pvld;
input  [14:0] spt_fifo_pd;
input         cmd2dat_spt_prdy;
output        cmd2dat_spt_pvld;
output [14:0] cmd2dat_spt_pd;
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
reg        spt_fifo_busy_int;		        	// copy for internal use
assign     spt_fifo_prdy = !spt_fifo_busy_int;
assign       wr_reserving = spt_fifo_pvld && !spt_fifo_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] spt_fifo_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? spt_fifo_count : (spt_fifo_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (spt_fifo_count + 1'd1) : spt_fifo_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       spt_fifo_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check spt_fifo_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        spt_fifo_busy_int <=  1'b0;
        spt_fifo_count <=  3'd0;
    end else begin
	spt_fifo_busy_int <=  spt_fifo_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    spt_fifo_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            spt_fifo_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as spt_fifo_pvld

//
// RAM
//

reg  [1:0] spt_fifo_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        spt_fifo_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    spt_fifo_adr <=  spt_fifo_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd2dat_spt_adr;          // read address this cycle
wire ram_we = wr_pushing && (spt_fifo_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [14:0] cmd2dat_spt_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( spt_fifo_pd )
    , .we        ( ram_we )
    , .wa        ( spt_fifo_adr )
    , .ra        ( (spt_fifo_count == 0) ? 3'd4 : {1'b0,cmd2dat_spt_adr} )
    , .dout        ( cmd2dat_spt_pd )
    );


wire [1:0] rd_adr_next_popping = cmd2dat_spt_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_spt_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd2dat_spt_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd2dat_spt_adr <=  {2{`x_or_0}};
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

wire       cmd2dat_spt_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd2dat_spt_pvld && cmd2dat_spt_prdy;

reg  [2:0] cmd2dat_spt_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? cmd2dat_spt_count : 
                                                                (cmd2dat_spt_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (cmd2dat_spt_count + 1'd1) : 
                                                                    cmd2dat_spt_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd2dat_spt_pvld = cmd2dat_spt_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_spt_count <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd2dat_spt_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd2dat_spt_count <=  {3{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (spt_fifo_pvld && !spt_fifo_busy_int) || (spt_fifo_busy_int != spt_fifo_busy_next)) || (rd_pushing || rd_popping || (cmd2dat_spt_pvld && cmd2dat_spt_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_sfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_sfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_WDMA_CMD_sfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_WDMA_CMD_sfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, spt_fifo_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_WDMA_CMD_sfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_WDMA_CMD_sfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15 (
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
input  [14:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [14:0] dout;

`ifndef FPGA
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
`endif

`ifdef EMU


wire [14:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [14:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [14:0] ram_ff0;
reg [14:0] ram_ff1;
reg [14:0] ram_ff2;
reg [14:0] ram_ff3;

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
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [14:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {15{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [14:0] Di0;
input  [1:0] Ra0;
output [14:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 15'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [14:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [14:0] Q0 = mem[0];
wire [14:0] Q1 = mem[1];
wire [14:0] Q2 = mem[2];
wire [14:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15] }
endmodule // vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15

//vmw: Memory vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15
//vmw: Address-size 2
//vmw: Data-size 15
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[14:0] data0[14:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[14:0] data1[14:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_WDMA_CMD_sfifo_flopram_rwsa_4x15
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"

#if (NVDLA_MEMORY_ATOMIC_SIZE == 32 &&  NVDLA_MEM_ADDRESS_WIDTH == 64) 

module NV_NVDLA_SDP_WDMA_CMD_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dma_fifo_prdy
    , dma_fifo_pvld
    , dma_fifo_pd
    , cmd2dat_dma_prdy
    , cmd2dat_dma_pvld
    , cmd2dat_dma_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dma_fifo_prdy;
input         dma_fifo_pvld;
input  [73:0] dma_fifo_pd;
input         cmd2dat_dma_prdy;
output        cmd2dat_dma_pvld;
output [73:0] cmd2dat_dma_pd;
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
reg        dma_fifo_busy_int;		        	// copy for internal use
assign     dma_fifo_prdy = !dma_fifo_busy_int;
assign       wr_reserving = dma_fifo_pvld && !dma_fifo_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] dma_fifo_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? dma_fifo_count : (dma_fifo_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (dma_fifo_count + 1'd1) : dma_fifo_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dma_fifo_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check dma_fifo_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_busy_int <=  1'b0;
        dma_fifo_count <=  3'd0;
    end else begin
	dma_fifo_busy_int <=  dma_fifo_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dma_fifo_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dma_fifo_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dma_fifo_pvld

//
// RAM
//

reg  [1:0] dma_fifo_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dma_fifo_adr <=  dma_fifo_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd2dat_dma_adr;          // read address this cycle
wire ram_we = wr_pushing && (dma_fifo_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [73:0] cmd2dat_dma_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dma_fifo_pd )
    , .we        ( ram_we )
    , .wa        ( dma_fifo_adr )
    , .ra        ( (dma_fifo_count == 0) ? 3'd4 : {1'b0,cmd2dat_dma_adr} )
    , .dout        ( cmd2dat_dma_pd )
    );


wire [1:0] rd_adr_next_popping = cmd2dat_dma_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd2dat_dma_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd2dat_dma_adr <=  {2{`x_or_0}};
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

wire       cmd2dat_dma_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd2dat_dma_pvld && cmd2dat_dma_prdy;

reg  [2:0] cmd2dat_dma_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? cmd2dat_dma_count : 
                                                                (cmd2dat_dma_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (cmd2dat_dma_count + 1'd1) : 
                                                                    cmd2dat_dma_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd2dat_dma_pvld = cmd2dat_dma_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_count <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd2dat_dma_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd2dat_dma_count <=  {3{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dma_fifo_pvld && !dma_fifo_busy_int) || (dma_fifo_busy_int != dma_fifo_busy_next)) || (rd_pushing || rd_popping || (cmd2dat_dma_pvld && cmd2dat_dma_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, dma_fifo_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_WDMA_CMD_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_WDMA_CMD_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74 (
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
input  [73:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [73:0] dout;

`ifndef FPGA
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
`endif

`ifdef EMU


wire [73:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [73:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [73:0] ram_ff0;
reg [73:0] ram_ff1;
reg [73:0] ram_ff2;
reg [73:0] ram_ff3;

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
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [73:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {74{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [73:0] Di0;
input  [1:0] Ra0;
output [73:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 74'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [73:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [73:0] Q0 = mem[0];
wire [73:0] Q1 = mem[1];
wire [73:0] Q2 = mem[2];
wire [73:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74] }
endmodule // vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74

//vmw: Memory vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74
//vmw: Address-size 2
//vmw: Data-size 74
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[73:0] data0[73:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[73:0] data1[73:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x74
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU



#elif (NVDLA_MEMORY_ATOMIC_SIZE == 8 &&  NVDLA_MEM_ADDRESS_WIDTH == 32) 

module NV_NVDLA_SDP_WDMA_CMD_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dma_fifo_prdy
    , dma_fifo_pvld
    , dma_fifo_pd
    , cmd2dat_dma_prdy
    , cmd2dat_dma_pvld
    , cmd2dat_dma_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dma_fifo_prdy;
input         dma_fifo_pvld;
input  [43:0] dma_fifo_pd;
input         cmd2dat_dma_prdy;
output        cmd2dat_dma_pvld;
output [43:0] cmd2dat_dma_pd;
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
reg        dma_fifo_busy_int;		        	// copy for internal use
assign     dma_fifo_prdy = !dma_fifo_busy_int;
assign       wr_reserving = dma_fifo_pvld && !dma_fifo_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] dma_fifo_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? dma_fifo_count : (dma_fifo_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (dma_fifo_count + 1'd1) : dma_fifo_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       dma_fifo_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check dma_fifo_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_busy_int <=  1'b0;
        dma_fifo_count <=  3'd0;
    end else begin
	dma_fifo_busy_int <=  dma_fifo_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dma_fifo_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dma_fifo_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dma_fifo_pvld

//
// RAM
//

reg  [1:0] dma_fifo_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dma_fifo_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dma_fifo_adr <=  dma_fifo_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd2dat_dma_adr;          // read address this cycle
wire ram_we = wr_pushing && (dma_fifo_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [43:0] cmd2dat_dma_pd;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dma_fifo_pd )
    , .we        ( ram_we )
    , .wa        ( dma_fifo_adr )
    , .ra        ( (dma_fifo_count == 0) ? 3'd4 : {1'b0,cmd2dat_dma_adr} )
    , .dout        ( cmd2dat_dma_pd )
    );


wire [1:0] rd_adr_next_popping = cmd2dat_dma_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd2dat_dma_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd2dat_dma_adr <=  {2{`x_or_0}};
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

wire       cmd2dat_dma_pvld; 		// data out of fifo is valid

assign     rd_popping = cmd2dat_dma_pvld && cmd2dat_dma_prdy;

reg  [2:0] cmd2dat_dma_count;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_next_rd_popping = rd_pushing ? cmd2dat_dma_count : 
                                                                (cmd2dat_dma_count - 1'd1);
wire [2:0] rd_count_next_no_rd_popping =  rd_pushing ? (cmd2dat_dma_count + 1'd1) : 
                                                                    cmd2dat_dma_count;
// spyglass enable_block W164a W484
wire [2:0] rd_count_next = rd_popping ? rd_count_next_rd_popping :
                                                     rd_count_next_no_rd_popping; 
assign     cmd2dat_dma_pvld = cmd2dat_dma_count != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd2dat_dma_count <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd2dat_dma_count <=  rd_count_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd2dat_dma_count <=  {3{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dma_fifo_pvld && !dma_fifo_busy_int) || (dma_fifo_busy_int != dma_fifo_busy_next)) || (rd_pushing || rd_popping || (cmd2dat_dma_pvld && cmd2dat_dma_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_WDMA_CMD_dfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, dma_fifo_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_WDMA_CMD_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_WDMA_CMD_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44 (
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
input  [43:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [43:0] dout;

`ifndef FPGA
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
`endif

`ifdef EMU


wire [43:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [43:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [43:0] ram_ff0;
reg [43:0] ram_ff1;
reg [43:0] ram_ff2;
reg [43:0] ram_ff3;

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
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [43:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {44{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [43:0] Di0;
input  [1:0] Ra0;
output [43:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 44'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [43:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [43:0] Q0 = mem[0];
wire [43:0] Q1 = mem[1];
wire [43:0] Q2 = mem[2];
wire [43:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44] }
endmodule // vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44

//vmw: Memory vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44
//vmw: Address-size 2
//vmw: Data-size 44
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[43:0] data0[43:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[43:0] data1[43:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_WDMA_CMD_dfifo_flopram_rwsa_4x44
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

