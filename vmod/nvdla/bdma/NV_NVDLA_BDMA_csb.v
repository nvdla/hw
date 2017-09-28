// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_BDMA_csb.v

`include "simulate_x_tick.vh"
module NV_NVDLA_BDMA_csb (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,csb2bdma_req_pd           //|< i
  ,csb2bdma_req_pvld         //|< i
  ,csb2ld_rdy                //|< i
  ,dma_write_stall_count     //|< i
  ,ld2csb_grp0_dma_stall_inc //|< i
  ,ld2csb_grp1_dma_stall_inc //|< i
  ,ld2csb_idle               //|< i
  ,pwrbus_ram_pd             //|< i
  ,st2csb_grp0_done          //|< i
  ,st2csb_grp1_done          //|< i
  ,st2csb_idle               //|< i
  ,bdma2csb_resp_pd          //|> o
  ,bdma2csb_resp_valid       //|> o
  ,bdma2glb_done_intr_pd     //|> o
  ,csb2bdma_req_prdy         //|> o
  ,csb2gate_slcg_en          //|> o
  ,csb2ld_vld                //|> o
  ,dma_write_stall_count_cen //|> o
  ,reg2dp_cmd_dst_ram_type   //|> o
  ,reg2dp_cmd_interrupt      //|> o
  ,reg2dp_cmd_interrupt_ptr  //|> o
  ,reg2dp_cmd_src_ram_type   //|> o
  ,reg2dp_dst_addr_high_v8   //|> o
  ,reg2dp_dst_addr_low_v32   //|> o
  ,reg2dp_dst_line_stride    //|> o
  ,reg2dp_dst_surf_stride    //|> o
  ,reg2dp_line_repeat_number //|> o
  ,reg2dp_line_size          //|> o
  ,reg2dp_src_addr_high_v8   //|> o
  ,reg2dp_src_addr_low_v32   //|> o
  ,reg2dp_src_line_stride    //|> o
  ,reg2dp_src_surf_stride    //|> o
  ,reg2dp_surf_repeat_number //|> o
  );
//
// NV_NVDLA_BDMA_csb_ports.v
//
input  nvdla_core_clk;   /* csb2bdma_req, bdma2csb_resp, bdma2glb_done_intr */
input  nvdla_core_rstn;  /* csb2bdma_req, bdma2csb_resp, bdma2glb_done_intr */

input         csb2bdma_req_pvld;  /* data valid */
output        csb2bdma_req_prdy;  /* data return handshake */
input  [62:0] csb2bdma_req_pd;

output        bdma2csb_resp_valid;  /* data valid */
output [33:0] bdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output [1:0] bdma2glb_done_intr_pd;

input [31:0] pwrbus_ram_pd;

//&Ports /^obs_bus/;
input          st2csb_grp0_done;
input          st2csb_grp1_done;
input          st2csb_idle;
output         reg2dp_cmd_dst_ram_type;
output         reg2dp_cmd_interrupt;
output         reg2dp_cmd_interrupt_ptr;
output         reg2dp_cmd_src_ram_type;
output  [31:0] reg2dp_dst_addr_high_v8;
output  [26:0] reg2dp_dst_addr_low_v32;
output  [26:0] reg2dp_dst_line_stride;
output  [26:0] reg2dp_dst_surf_stride;
output  [23:0] reg2dp_line_repeat_number;
output  [12:0] reg2dp_line_size;
output  [31:0] reg2dp_src_addr_high_v8;
output  [26:0] reg2dp_src_addr_low_v32;
output  [26:0] reg2dp_src_line_stride;
output  [26:0] reg2dp_src_surf_stride;
output  [23:0] reg2dp_surf_repeat_number;
input          csb2ld_rdy;
input          ld2csb_grp0_dma_stall_inc;
input          ld2csb_grp1_dma_stall_inc;
input          ld2csb_idle;
output         csb2ld_vld;
output         csb2gate_slcg_en;

input [31:0] dma_write_stall_count;
output              dma_write_stall_count_cen;

reg     [33:0] bdma2csb_resp_pd;
reg            bdma2csb_resp_valid;
reg      [1:0] bdma2glb_done_intr_pd;
reg            csb_processing_d;
reg      [4:0] gather_count;
reg            gather_ptr;
reg            gather_vld;
reg            grp0_cmd_launch_trigger;
reg            grp0_read_stall_cnt_adv;
reg     [31:0] grp0_read_stall_cnt_cnt_cur;
reg     [33:0] grp0_read_stall_cnt_cnt_dec;
reg     [33:0] grp0_read_stall_cnt_cnt_ext;
reg     [33:0] grp0_read_stall_cnt_cnt_inc;
reg     [33:0] grp0_read_stall_cnt_cnt_mod;
reg     [33:0] grp0_read_stall_cnt_cnt_new;
reg     [33:0] grp0_read_stall_cnt_cnt_nxt;
reg     [31:0] grp0_read_stall_count;
reg            grp1_cmd_launch_trigger;
reg            grp1_read_stall_cnt_adv;
reg     [31:0] grp1_read_stall_cnt_cnt_cur;
reg     [33:0] grp1_read_stall_cnt_cnt_dec;
reg     [33:0] grp1_read_stall_cnt_cnt_ext;
reg     [33:0] grp1_read_stall_cnt_cnt_inc;
reg     [33:0] grp1_read_stall_cnt_cnt_mod;
reg     [33:0] grp1_read_stall_cnt_cnt_new;
reg     [33:0] grp1_read_stall_cnt_cnt_nxt;
reg     [31:0] grp1_read_stall_count;
reg      [4:0] launch_count;
reg            launch_ptr;
reg            op_en_trigger;
reg     [62:0] req_pd;
reg            req_vld;
reg            slcg_en;
reg            status_grp0_busy;
reg     [31:0] status_grp0_read_stall_count;
reg     [31:0] status_grp0_write_stall_count;
reg            status_grp1_busy;
reg     [31:0] status_grp1_read_stall_count;
reg     [31:0] status_grp1_write_stall_count;
wire           cmd_launch_rdy;
wire           cmd_launch_vld;
wire   [288:0] csb_fifo_rd_pd;
wire           csb_fifo_rd_prdy;
wire           csb_fifo_rd_pvld;
wire     [4:0] csb_fifo_wr_count;
wire           csb_fifo_wr_idle;
wire   [288:0] csb_fifo_wr_pd;
wire           csb_fifo_wr_prdy;
wire           csb_fifo_wr_pvld;
wire           csb_idle;
wire           csb_processing;
wire           dma_read_stall_count_cen;
wire           gather_rdy;
wire           gather_to_launch;
wire           grp0_cmd_launch;
wire           grp0_read_stall_count_dec;
wire           grp1_cmd_launch;
wire           grp1_read_stall_count_dec;
wire           is_last_cmd;
wire           is_last_cmd_rdy;
wire           launch_rdy;
wire           launch_vld;
wire           load_idle;
wire           mon_csb_fifo_rd_pvld;
wire           mon_csb_fifo_wr_prdy;
wire           nvdla_bdma_cfg_cmd_0_dst_ram_type;
wire           nvdla_bdma_cfg_cmd_0_src_ram_type;
wire    [31:0] nvdla_bdma_cfg_dst_addr_high_0_v8;
wire    [26:0] nvdla_bdma_cfg_dst_addr_low_0_v32;
wire    [26:0] nvdla_bdma_cfg_dst_line_0_stride;
wire    [26:0] nvdla_bdma_cfg_dst_surf_0_stride;
wire           nvdla_bdma_cfg_launch0_0_grp0_launch;
wire           nvdla_bdma_cfg_launch0_0_grp0_launch_trigger;
wire           nvdla_bdma_cfg_launch1_0_grp1_launch;
wire           nvdla_bdma_cfg_launch1_0_grp1_launch_trigger;
wire    [12:0] nvdla_bdma_cfg_line_0_size;
wire    [23:0] nvdla_bdma_cfg_line_repeat_0_number;
wire           nvdla_bdma_cfg_op_0_en;
wire           nvdla_bdma_cfg_op_0_en_trigger;
wire    [31:0] nvdla_bdma_cfg_src_addr_high_0_v8;
wire    [26:0] nvdla_bdma_cfg_src_addr_low_0_v32;
wire    [26:0] nvdla_bdma_cfg_src_line_0_stride;
wire    [26:0] nvdla_bdma_cfg_src_surf_0_stride;
wire           nvdla_bdma_cfg_status_0_stall_count_en;
wire    [23:0] nvdla_bdma_cfg_surf_repeat_0_number;
wire     [7:0] nvdla_bdma_status_0_free_slot;
wire           nvdla_bdma_status_0_grp0_busy;
wire           nvdla_bdma_status_0_grp1_busy;
wire           nvdla_bdma_status_0_idle;
wire    [31:0] nvdla_bdma_status_grp0_read_stall_0_count;
wire    [31:0] nvdla_bdma_status_grp0_write_stall_0_count;
wire    [31:0] nvdla_bdma_status_grp1_read_stall_0_count;
wire    [31:0] nvdla_bdma_status_grp1_write_stall_0_count;
wire    [11:0] reg_offset;
wire    [31:0] reg_rd_data;
wire    [31:0] reg_wr_data;
wire           reg_wr_en;
wire    [21:0] req_addr;
wire     [1:0] req_level_NC;
wire           req_nposted;
wire           req_srcpriv_NC;
wire    [31:0] req_wdat;
wire     [3:0] req_wrbe_NC;
wire           req_write;
wire    [33:0] rsp_pd;
wire           rsp_rd_error;
wire    [32:0] rsp_rd_pd;
wire    [31:0] rsp_rd_rdat;
wire           rsp_rd_vld;
wire           rsp_vld;
wire           rsp_wr_error;
wire    [32:0] rsp_wr_pd;
wire    [31:0] rsp_wr_rdat;
wire           rsp_wr_vld;
wire           status_grp0_clr;
wire           status_grp0_set;
wire           status_grp1_clr;
wire           status_grp1_set;
wire           store_idle;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    //==============
// CSB
//==============
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    // &Viva width_learning_on;
// REQ INTERFACE

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_vld <= 1'b0;
  end else begin
  req_vld <= csb2bdma_req_pvld;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((csb2bdma_req_pvld) == 1'b1) begin
    req_pd <= csb2bdma_req_pd;
  // VCS coverage off
  end else if ((csb2bdma_req_pvld) == 1'b0) begin
  end else begin
    req_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign csb2bdma_req_prdy = 1'b1;

// ========
// REQUEST
// ========
// flow=pvld_prdy 
assign req_level_NC = req_pd[62:61];
assign req_nposted = req_pd[55:55];
assign req_addr = req_pd[21:0];
assign req_wrbe_NC = req_pd[60:57];
assign req_srcpriv_NC = req_pd[56:56];
assign req_write = req_pd[54:54];
assign req_wdat = req_pd[53:22];
// ========
// RESPONSE
// ========
// flow=valid 
// packet=dla_xx2csb_rd_erpt 
assign rsp_rd_pd[32:32] = rsp_rd_error;
assign rsp_rd_pd[31:0] = rsp_rd_rdat;
// packet=dla_xx2csb_wr_erpt 
assign rsp_wr_pd[32:32] = rsp_wr_error;
assign rsp_wr_pd[31:0] = rsp_wr_rdat;


assign rsp_rd_vld  = req_vld & ~req_write;
assign rsp_rd_rdat = {32{rsp_rd_vld}} & reg_rd_data;
assign rsp_rd_error  = 1'b0;

assign rsp_wr_vld  = req_vld & req_write & req_nposted;
assign rsp_wr_rdat = {32{1'b0}};
assign rsp_wr_error  = 1'b0;

// ========
// REQUEST
// ========
assign rsp_vld = rsp_rd_vld | rsp_wr_vld;
assign rsp_pd[33:33] = ({1{rsp_rd_vld}} & {1'h0}) 
                                | ({1{rsp_wr_vld}} & {1'h1});

assign rsp_pd[32:0] = ({33{rsp_rd_vld}} & rsp_rd_pd)
                                | ({33{rsp_wr_vld}} & rsp_wr_pd);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma2csb_resp_valid <= 1'b0;
  end else begin
  bdma2csb_resp_valid <= rsp_vld;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((rsp_vld) == 1'b1) begin
    bdma2csb_resp_pd <= rsp_pd;
  // VCS coverage off
  end else if ((rsp_vld) == 1'b0) begin
  end else begin
    bdma2csb_resp_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
assign reg_offset = {req_addr[9:0],{2{1'b0}}};
assign reg_wr_en = req_vld & req_write;
assign reg_wr_data = req_wdat;
NV_NVDLA_BDMA_reg u_NV_NVDLA_BDMA_reg (
   .reg_rd_data                                  (reg_rd_data[31:0])                                //|> w
  ,.reg_offset                                   (reg_offset[11:0])                                 //|< w
  ,.reg_wr_data                                  (reg_wr_data[31:0])                                //|< w
  ,.reg_wr_en                                    (reg_wr_en)                                        //|< w
  ,.nvdla_core_clk                               (nvdla_core_clk)                                   //|< i
  ,.nvdla_core_rstn                              (nvdla_core_rstn)                                  //|< i
  ,.nvdla_bdma_cfg_cmd_0_dst_ram_type            (nvdla_bdma_cfg_cmd_0_dst_ram_type)                //|> w
  ,.nvdla_bdma_cfg_cmd_0_src_ram_type            (nvdla_bdma_cfg_cmd_0_src_ram_type)                //|> w
  ,.nvdla_bdma_cfg_dst_addr_high_0_v8            (nvdla_bdma_cfg_dst_addr_high_0_v8[31:0])          //|> w
  ,.nvdla_bdma_cfg_dst_addr_low_0_v32            (nvdla_bdma_cfg_dst_addr_low_0_v32[26:0])          //|> w
  ,.nvdla_bdma_cfg_dst_line_0_stride             (nvdla_bdma_cfg_dst_line_0_stride[26:0])           //|> w
  ,.nvdla_bdma_cfg_dst_surf_0_stride             (nvdla_bdma_cfg_dst_surf_0_stride[26:0])           //|> w
  ,.nvdla_bdma_cfg_launch0_0_grp0_launch         (nvdla_bdma_cfg_launch0_0_grp0_launch)             //|> w
  ,.nvdla_bdma_cfg_launch0_0_grp0_launch_trigger (nvdla_bdma_cfg_launch0_0_grp0_launch_trigger)     //|> w
  ,.nvdla_bdma_cfg_launch1_0_grp1_launch         (nvdla_bdma_cfg_launch1_0_grp1_launch)             //|> w
  ,.nvdla_bdma_cfg_launch1_0_grp1_launch_trigger (nvdla_bdma_cfg_launch1_0_grp1_launch_trigger)     //|> w
  ,.nvdla_bdma_cfg_line_0_size                   (nvdla_bdma_cfg_line_0_size[12:0])                 //|> w
  ,.nvdla_bdma_cfg_line_repeat_0_number          (nvdla_bdma_cfg_line_repeat_0_number[23:0])        //|> w
  ,.nvdla_bdma_cfg_op_0_en                       (nvdla_bdma_cfg_op_0_en)                           //|> w
  ,.nvdla_bdma_cfg_op_0_en_trigger               (nvdla_bdma_cfg_op_0_en_trigger)                   //|> w
  ,.nvdla_bdma_cfg_src_addr_high_0_v8            (nvdla_bdma_cfg_src_addr_high_0_v8[31:0])          //|> w
  ,.nvdla_bdma_cfg_src_addr_low_0_v32            (nvdla_bdma_cfg_src_addr_low_0_v32[26:0])          //|> w
  ,.nvdla_bdma_cfg_src_line_0_stride             (nvdla_bdma_cfg_src_line_0_stride[26:0])           //|> w
  ,.nvdla_bdma_cfg_src_surf_0_stride             (nvdla_bdma_cfg_src_surf_0_stride[26:0])           //|> w
  ,.nvdla_bdma_cfg_status_0_stall_count_en       (nvdla_bdma_cfg_status_0_stall_count_en)           //|> w
  ,.nvdla_bdma_cfg_surf_repeat_0_number          (nvdla_bdma_cfg_surf_repeat_0_number[23:0])        //|> w
  ,.nvdla_bdma_status_0_free_slot                (nvdla_bdma_status_0_free_slot[7:0])               //|< w
  ,.nvdla_bdma_status_0_grp0_busy                (nvdla_bdma_status_0_grp0_busy)                    //|< w
  ,.nvdla_bdma_status_0_grp1_busy                (nvdla_bdma_status_0_grp1_busy)                    //|< w
  ,.nvdla_bdma_status_0_idle                     (nvdla_bdma_status_0_idle)                         //|< w
  ,.nvdla_bdma_status_grp0_read_stall_0_count    (nvdla_bdma_status_grp0_read_stall_0_count[31:0])  //|< w
  ,.nvdla_bdma_status_grp0_write_stall_0_count   (nvdla_bdma_status_grp0_write_stall_0_count[31:0]) //|< w
  ,.nvdla_bdma_status_grp1_read_stall_0_count    (nvdla_bdma_status_grp1_read_stall_0_count[31:0])  //|< w
  ,.nvdla_bdma_status_grp1_write_stall_0_count   (nvdla_bdma_status_grp1_write_stall_0_count[31:0]) //|< w
  );




assign csb_fifo_wr_pd = {nvdla_bdma_cfg_src_addr_low_0_v32,
nvdla_bdma_cfg_src_addr_high_0_v8,
nvdla_bdma_cfg_dst_addr_low_0_v32,
nvdla_bdma_cfg_dst_addr_high_0_v8,
nvdla_bdma_cfg_line_0_size,
nvdla_bdma_cfg_cmd_0_src_ram_type,
nvdla_bdma_cfg_cmd_0_dst_ram_type,
nvdla_bdma_cfg_line_repeat_0_number,
nvdla_bdma_cfg_src_line_0_stride,
nvdla_bdma_cfg_dst_line_0_stride,
nvdla_bdma_cfg_surf_repeat_0_number,
nvdla_bdma_cfg_src_surf_0_stride,
nvdla_bdma_cfg_dst_surf_0_stride};

NV_NVDLA_BDMA_LOAD_csb_fifo csb_fifo (
   .nvdla_core_clk                               (nvdla_core_clk)                                   //|< i
  ,.nvdla_core_rstn                              (nvdla_core_rstn)                                  //|< i
  ,.csb_fifo_wr_count                            (csb_fifo_wr_count[4:0])                           //|> w
  ,.csb_fifo_wr_prdy                             (csb_fifo_wr_prdy)                                 //|> w
  ,.csb_fifo_wr_idle                             (csb_fifo_wr_idle)                                 //|> w
  ,.csb_fifo_wr_pvld                             (csb_fifo_wr_pvld)                                 //|< w
  ,.csb_fifo_wr_pd                               (csb_fifo_wr_pd[288:0])                            //|< w
  ,.csb_fifo_rd_prdy                             (csb_fifo_rd_prdy)                                 //|< w
  ,.csb_fifo_rd_pvld                             (csb_fifo_rd_pvld)                                 //|> w
  ,.csb_fifo_rd_pd                               (csb_fifo_rd_pd[288:0])                            //|> w
  ,.pwrbus_ram_pd                                (pwrbus_ram_pd[31:0])                              //|< i
  );
assign {reg2dp_src_addr_low_v32,
reg2dp_src_addr_high_v8,
reg2dp_dst_addr_low_v32,
reg2dp_dst_addr_high_v8,
reg2dp_line_size,
reg2dp_cmd_src_ram_type,
reg2dp_cmd_dst_ram_type,
reg2dp_line_repeat_number,
reg2dp_src_line_stride,
reg2dp_dst_line_stride,
reg2dp_surf_repeat_number,
reg2dp_src_surf_stride,
reg2dp_dst_surf_stride} = csb_fifo_rd_pd;

// Status Gen
assign mon_csb_fifo_wr_prdy = csb_fifo_wr_prdy;
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
  nv_assert_never #(0,0,"memory copy command is dropped")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, csb_fifo_wr_pvld && !mon_csb_fifo_wr_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign nvdla_bdma_status_0_free_slot[7:0] = 20  - csb_fifo_wr_count;

//==================
// cmd -> gather_count --(when intr) -> launch_count -> pop from csb_fifo
//==================
// CSB CMD FIFO
// Memory copy command consists of content from several BDMA registers, and when BDMA_CFG_CMD register is written
// a launch of command is triggered, and this command is pushed into CSB cmd FIFO, and wait there for next pop and execution
// nvdla_bdma_cfg_op_0_en_trigger is one cycle ahead of nvdla_bdma_cfg_op_0_en in arreggen, so need flop it before using
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_en_trigger <= 1'b0;
  end else begin
  op_en_trigger <= nvdla_bdma_cfg_op_0_en_trigger;
  end
end
assign csb_fifo_wr_pvld = op_en_trigger & nvdla_bdma_cfg_op_0_en;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    grp0_cmd_launch_trigger <= 1'b0;
  end else begin
  grp0_cmd_launch_trigger <= nvdla_bdma_cfg_launch0_0_grp0_launch_trigger;
  end
end
assign grp0_cmd_launch = grp0_cmd_launch_trigger & nvdla_bdma_cfg_launch0_0_grp0_launch;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    grp1_cmd_launch_trigger <= 1'b0;
  end else begin
  grp1_cmd_launch_trigger <= nvdla_bdma_cfg_launch1_0_grp1_launch_trigger;
  end
end
assign grp1_cmd_launch = grp1_cmd_launch_trigger & nvdla_bdma_cfg_launch1_0_grp1_launch;

assign cmd_launch_vld = grp0_cmd_launch | grp1_cmd_launch;
// command stalling: commands will only be popped from csb_fifo when the the last one with interrupt needed
//==================
assign gather_to_launch = gather_vld & gather_rdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gather_count <= {5{1'b0}};
  end else begin
    if (gather_to_launch) begin
        if (csb_fifo_wr_pvld) begin
            gather_count <= 1;
        end else begin
            gather_count <= 0;
        end
    end else begin
        if (csb_fifo_wr_pvld) begin
            gather_count <= gather_count + 1;
        end
    end
  end
end

assign cmd_launch_rdy = gather_rdy || !gather_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    gather_vld <= 1'b0;
  end else begin
  if ((cmd_launch_rdy) == 1'b1) begin
    gather_vld <= cmd_launch_vld;
  // VCS coverage off
  end else if ((cmd_launch_rdy) == 1'b0) begin
  end else begin
    gather_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_launch_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    gather_ptr <= 1'b0;
  end else begin
    if (grp0_cmd_launch) begin
        gather_ptr <= 1'b0;
    end else if (grp1_cmd_launch) begin
        gather_ptr <= 1'b1;
    end
  end
end
assign gather_rdy = (!launch_vld) || is_last_cmd_rdy;
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
  nv_assert_never #(0,0,"gather must be ready when there is a launch command")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, cmd_launch_vld & !cmd_launch_rdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property bdma_load__two_groups_are_launched_continously__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        launch_vld & gather_vld;
    endproperty
    // Cover 0 : "launch_vld & gather_vld"
    FUNCPOINT_bdma_load__two_groups_are_launched_continously__0_COV : cover property (bdma_load__two_groups_are_launched_continously__0_cov);

  `endif
`endif
//VCS coverage on


assign mon_csb_fifo_rd_pvld = csb_fifo_rd_pvld;
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
  nv_assert_never #(0,0,"when launch is valid, csb_fifo must have valid data")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, launch_vld & !mon_csb_fifo_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign launch_rdy = csb2ld_rdy;
assign csb_fifo_rd_prdy = csb2ld_rdy;

assign launch_vld = launch_count!=0;
assign csb2ld_vld = launch_vld;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    launch_count <= {5{1'b0}};
    launch_ptr <= 1'b0;
  end else begin
    if (launch_vld) begin
        if (launch_rdy) begin
            if (is_last_cmd) begin
                if (gather_vld) begin
                    launch_count <= gather_count;
                    launch_ptr   <= gather_ptr;
                end else begin
                    launch_count <= launch_count - 1;
                end
            end else begin
                launch_count <= launch_count - 1;
            end
        end
    end else begin
        if (gather_vld) begin
            launch_count <= gather_count;
            launch_ptr   <= gather_ptr;
        end
    end
  end
end
assign is_last_cmd = (launch_count==1);
assign is_last_cmd_rdy = launch_rdy & is_last_cmd;

assign reg2dp_cmd_interrupt = is_last_cmd_rdy;
assign reg2dp_cmd_interrupt_ptr  = launch_ptr;

//==================
// STATUS SET/CLR
//==================
assign status_grp0_set = grp0_cmd_launch;
assign status_grp0_clr = st2csb_grp0_done;
assign status_grp1_set = grp1_cmd_launch;
assign status_grp1_clr = st2csb_grp1_done;

//==================
// STATUS IDLE
//==================
assign store_idle = st2csb_idle;
assign load_idle  = ld2csb_idle;
assign csb_idle   = csb_fifo_wr_idle;
assign nvdla_bdma_status_0_idle = store_idle & load_idle & csb_idle;

//==================
// STATUS BUSY
//==================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp0_busy <= 1'b0;
  end else begin
    if (status_grp0_set) begin
        status_grp0_busy <= 1'b1;
    end else if (status_grp0_clr) begin
        status_grp0_busy <= 1'b0;
    end
  end
end
assign nvdla_bdma_status_0_grp0_busy = status_grp0_busy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp1_busy <= 1'b0;
  end else begin
    if (status_grp1_set) begin
        status_grp1_busy <= 1'b1;
    end else if (status_grp1_clr) begin
        status_grp1_busy <= 1'b0;
    end
  end
end
assign nvdla_bdma_status_0_grp1_busy = status_grp1_busy;

//==================
// STATUS STATISTIC
//==================
assign dma_write_stall_count_cen = nvdla_bdma_cfg_status_0_stall_count_en;
assign dma_read_stall_count_cen = nvdla_bdma_cfg_status_0_stall_count_en;




    assign grp0_read_stall_count_dec = 1'b0;

    // grp0_read_stall_cnt adv logic

    always @(
      ld2csb_grp0_dma_stall_inc
      or grp0_read_stall_count_dec
      ) begin
      grp0_read_stall_cnt_adv = ld2csb_grp0_dma_stall_inc ^ grp0_read_stall_count_dec;
    end
        
    // grp0_read_stall_cnt cnt logic
    always @(
      grp0_read_stall_cnt_cnt_cur
      or ld2csb_grp0_dma_stall_inc
      or grp0_read_stall_count_dec
      or grp0_read_stall_cnt_adv
      or status_grp0_clr
      ) begin
      // VCS sop_coverage_off start
      grp0_read_stall_cnt_cnt_ext[33:0] = {1'b0, 1'b0, grp0_read_stall_cnt_cnt_cur};
      grp0_read_stall_cnt_cnt_inc[33:0] = grp0_read_stall_cnt_cnt_cur + 1'b1; // spyglass disable W164b
      grp0_read_stall_cnt_cnt_dec[33:0] = grp0_read_stall_cnt_cnt_cur - 1'b1; // spyglass disable W164b
      grp0_read_stall_cnt_cnt_mod[33:0] = (ld2csb_grp0_dma_stall_inc && !grp0_read_stall_count_dec)? grp0_read_stall_cnt_cnt_inc : (!ld2csb_grp0_dma_stall_inc && grp0_read_stall_count_dec)? grp0_read_stall_cnt_cnt_dec : grp0_read_stall_cnt_cnt_ext;
      grp0_read_stall_cnt_cnt_new[33:0] = (grp0_read_stall_cnt_adv)? grp0_read_stall_cnt_cnt_mod[33:0] : grp0_read_stall_cnt_cnt_ext[33:0];
      grp0_read_stall_cnt_cnt_nxt[33:0] = (status_grp0_clr)? 34'd0 : grp0_read_stall_cnt_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // grp0_read_stall_cnt flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        grp0_read_stall_cnt_cnt_cur[31:0] <= 0;
      end else begin
      if (dma_read_stall_count_cen) begin
      grp0_read_stall_cnt_cnt_cur[31:0] <= grp0_read_stall_cnt_cnt_nxt[31:0];
      end
      end
    end

    // grp0_read_stall_cnt output logic

    always @(
      grp0_read_stall_cnt_cnt_cur
      ) begin
      grp0_read_stall_count[31:0] = grp0_read_stall_cnt_cnt_cur[31:0];
    end
        
      




    assign grp1_read_stall_count_dec = 1'b0;

    // grp1_read_stall_cnt adv logic

    always @(
      ld2csb_grp1_dma_stall_inc
      or grp1_read_stall_count_dec
      ) begin
      grp1_read_stall_cnt_adv = ld2csb_grp1_dma_stall_inc ^ grp1_read_stall_count_dec;
    end
        
    // grp1_read_stall_cnt cnt logic
    always @(
      grp1_read_stall_cnt_cnt_cur
      or ld2csb_grp1_dma_stall_inc
      or grp1_read_stall_count_dec
      or grp1_read_stall_cnt_adv
      or status_grp1_clr
      ) begin
      // VCS sop_coverage_off start
      grp1_read_stall_cnt_cnt_ext[33:0] = {1'b0, 1'b0, grp1_read_stall_cnt_cnt_cur};
      grp1_read_stall_cnt_cnt_inc[33:0] = grp1_read_stall_cnt_cnt_cur + 1'b1; // spyglass disable W164b
      grp1_read_stall_cnt_cnt_dec[33:0] = grp1_read_stall_cnt_cnt_cur - 1'b1; // spyglass disable W164b
      grp1_read_stall_cnt_cnt_mod[33:0] = (ld2csb_grp1_dma_stall_inc && !grp1_read_stall_count_dec)? grp1_read_stall_cnt_cnt_inc : (!ld2csb_grp1_dma_stall_inc && grp1_read_stall_count_dec)? grp1_read_stall_cnt_cnt_dec : grp1_read_stall_cnt_cnt_ext;
      grp1_read_stall_cnt_cnt_new[33:0] = (grp1_read_stall_cnt_adv)? grp1_read_stall_cnt_cnt_mod[33:0] : grp1_read_stall_cnt_cnt_ext[33:0];
      grp1_read_stall_cnt_cnt_nxt[33:0] = (status_grp1_clr)? 34'd0 : grp1_read_stall_cnt_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // grp1_read_stall_cnt flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        grp1_read_stall_cnt_cnt_cur[31:0] <= 0;
      end else begin
      if (dma_read_stall_count_cen) begin
      grp1_read_stall_cnt_cnt_cur[31:0] <= grp1_read_stall_cnt_cnt_nxt[31:0];
      end
      end
    end

    // grp1_read_stall_cnt output logic

    always @(
      grp1_read_stall_cnt_cnt_cur
      ) begin
      grp1_read_stall_count[31:0] = grp1_read_stall_cnt_cnt_cur[31:0];
    end
        
      
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp0_read_stall_count <= {32{1'b0}};
  end else begin
    if (status_grp0_set) begin
        status_grp0_read_stall_count <= 0;
    end else if (status_grp0_clr) begin
        status_grp0_read_stall_count <= grp0_read_stall_count;
    end
  end
end
assign nvdla_bdma_status_grp0_read_stall_0_count = status_grp0_read_stall_count;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp1_read_stall_count <= {32{1'b0}};
  end else begin
    if (status_grp1_set) begin
        status_grp1_read_stall_count <= 0;
    end else if (status_grp1_clr) begin
        status_grp1_read_stall_count <= grp1_read_stall_count;
    end
  end
end
assign nvdla_bdma_status_grp1_read_stall_0_count = status_grp1_read_stall_count;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp0_write_stall_count <= {32{1'b0}};
  end else begin
    if (status_grp0_set) begin
        status_grp0_write_stall_count <= 0;
    end else if (status_grp0_clr) begin
        status_grp0_write_stall_count <= dma_write_stall_count;
    end
  end
end
assign nvdla_bdma_status_grp0_write_stall_0_count = status_grp0_write_stall_count;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    status_grp1_write_stall_count <= {32{1'b0}};
  end else begin
    if (status_grp1_set) begin
        status_grp1_write_stall_count <= 0;
    end else if (status_grp1_clr) begin
        status_grp1_write_stall_count <= dma_write_stall_count;
    end
  end
end
assign nvdla_bdma_status_grp1_write_stall_0_count = status_grp1_write_stall_count;

//==============
// Interrupt to GLB
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  bdma2glb_done_intr_pd[0] <= status_grp0_clr;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  bdma2glb_done_intr_pd[1] <= status_grp1_clr;
  end
end

//======================================
// OBS
//assign obs_bus_bdma_csb_idle = nvdla_bdma_status_0_idle;
//assign obs_bus_bdma_csb_busy = csb_processing;
//assign obs_bus_bdma_csb_fifo_rd_pvld = csb_fifo_rd_pvld;
//assign obs_bus_bdma_csb_fifo_wr_idle = csb_fifo_wr_idle;
//assign obs_bus_bdma_csb_fifo_wr_prdy = csb_fifo_wr_prdy;
//assign obs_bus_bdma_csb_fifo_wr_pvld = csb_fifo_wr_pvld;
//assign obs_bus_bdma_csb_gather_rdy = gather_rdy;
//assign obs_bus_bdma_csb_gather_vld = gather_vld;
//assign obs_bus_bdma_csb_launch_rdy = launch_rdy;
//assign obs_bus_bdma_csb_launch_vld = launch_vld;
//assign obs_bus_bdma_csb2gate_slcg_en = slcg_en;

//======================================
// SLCG
assign csb_processing = cmd_launch_vld | gather_vld | launch_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csb_processing_d <= 1'b0;
  end else begin
  csb_processing_d <= csb_processing;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_en <= 1'b0;
  end else begin
  slcg_en <= csb_processing | csb_processing_d;
  end
end
assign csb2gate_slcg_en = slcg_en;

endmodule // NV_NVDLA_BDMA_csb

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_BDMA_LOAD_csb_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus csb_fifo_wr -rd_pipebus csb_fifo_rd -rd_reg -wr_idle -wr_count -d 20 -w 289 -rand_none -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_BDMA_LOAD_csb_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , csb_fifo_wr_count
    , csb_fifo_wr_prdy
    , csb_fifo_wr_idle
    , csb_fifo_wr_pvld
    , csb_fifo_wr_pd
    , csb_fifo_rd_prdy
    , csb_fifo_rd_pvld
    , csb_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output [4:0] csb_fifo_wr_count;
output        csb_fifo_wr_prdy;
output        csb_fifo_wr_idle;
input         csb_fifo_wr_pvld;
input  [288:0] csb_fifo_wr_pd;
input         csb_fifo_rd_prdy;
output        csb_fifo_rd_pvld;
output [288:0] csb_fifo_rd_pd;
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
reg        csb_fifo_wr_busy_int;		        	// copy for internal use
assign     csb_fifo_wr_prdy = !csb_fifo_wr_busy_int;
assign       wr_reserving = csb_fifo_wr_pvld && !csb_fifo_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [4:0] csb_fifo_wr_count;			// write-side count

wire [4:0] wr_count_next_wr_popping = wr_reserving ? csb_fifo_wr_count : (csb_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [4:0] wr_count_next_no_wr_popping = wr_reserving ? (csb_fifo_wr_count + 1'd1) : csb_fifo_wr_count; // spyglass disable W164a W484
wire [4:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_20 = ( wr_count_next_no_wr_popping == 5'd20 );
wire wr_count_next_is_20 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_20;
wire [4:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [4:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       csb_fifo_wr_busy_next = wr_count_next_is_20 || // busy next cycle?
                          (wr_limit_reg != 5'd0 &&      // check csb_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        csb_fifo_wr_busy_int <=  1'b0;
        csb_fifo_wr_count <=  5'd0;
    end else begin
	csb_fifo_wr_busy_int <=  csb_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    csb_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            csb_fifo_wr_count <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as csb_fifo_wr_pvld

//
// RAM
//

reg  [4:0] csb_fifo_wr_adr;			// current write address
wire [4:0] csb_fifo_rd_adr_p;		// read address to use for ram
wire [288:0] csb_fifo_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_20x289 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( csb_fifo_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( csb_fifo_wr_pd )
    , .ra        ( csb_fifo_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( csb_fifo_rd_pd_p )
    , .ore        ( ore )
    );
// next csb_fifo_wr_adr if wr_pushing=1
wire [4:0] wr_adr_next = (csb_fifo_wr_adr == 5'd19) ? 5'd0 : (csb_fifo_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        csb_fifo_wr_adr <=  5'd0;
    end else begin
        if ( wr_pushing ) begin
            csb_fifo_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            csb_fifo_wr_adr   <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [4:0] csb_fifo_rd_adr;		// current read address
// next    read address
wire [4:0] rd_adr_next = (csb_fifo_rd_adr == 5'd19) ? 5'd0 : (csb_fifo_rd_adr + 1'd1);   // spyglass disable W484
assign         csb_fifo_rd_adr_p = rd_popping ? rd_adr_next : csb_fifo_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        csb_fifo_rd_adr <=  5'd0;
    end else begin
        if ( rd_popping ) begin
	    csb_fifo_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            csb_fifo_rd_adr <=  {5{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        csb_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        csb_fifo_rd_pvld_int;			// internal copy of csb_fifo_rd_pvld
assign     csb_fifo_rd_pvld = csb_fifo_rd_pvld_int;
assign     rd_popping = csb_fifo_rd_pvld_p && !(csb_fifo_rd_pvld_int && !csb_fifo_rd_prdy);

reg  [4:0] csb_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [4:0] rd_count_p_next_rd_popping = rd_pushing ? csb_fifo_rd_count_p : 
                                                                (csb_fifo_rd_count_p - 1'd1);
wire [4:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (csb_fifo_rd_count_p + 1'd1) : 
                                                                    csb_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [4:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~csb_fifo_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        csb_fifo_rd_count_p <=  5'd0;
        csb_fifo_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    csb_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            csb_fifo_rd_count_p <=  {5{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    csb_fifo_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            csb_fifo_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (csb_fifo_rd_pvld_p || (csb_fifo_rd_pvld_int && !csb_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        csb_fifo_rd_pvld_int <=  1'b0;
    end else begin
        csb_fifo_rd_pvld_int <=  rd_req_next;
    end
end
assign csb_fifo_rd_pd = csb_fifo_rd_pd_p;
assign ore = rd_popping;
//
// Read-side Idle Calculation
//
wire   rd_idle = !csb_fifo_rd_pvld_int && !rd_pushing && csb_fifo_rd_count_p == 0;


//
// Write-Side Idle Calculation
//
wire csb_fifo_wr_idle_d0 = !csb_fifo_wr_pvld && rd_idle && !wr_pushing && csb_fifo_wr_count == 0;
wire csb_fifo_wr_idle = csb_fifo_wr_idle_d0;


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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (csb_fifo_wr_pvld && !csb_fifo_wr_busy_int) || (csb_fifo_wr_busy_int != csb_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (csb_fifo_rd_pvld_int && csb_fifo_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_BDMA_LOAD_csb_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_BDMA_LOAD_csb_fifo_wr_limit : 5'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 5'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 5'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 5'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [4:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 5'd0;
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_LOAD_csb_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_BDMA_LOAD_csb_fifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {27'd0, (wr_limit_reg == 5'd0) ? 5'd20 : wr_limit_reg} )
    , .curr	( {27'd0, csb_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_BDMA_LOAD_csb_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_BDMA_LOAD_csb_fifo



