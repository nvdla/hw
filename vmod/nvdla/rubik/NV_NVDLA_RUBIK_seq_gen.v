// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_seq_gen.v

module NV_NVDLA_RUBIK_seq_gen (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_wr_cmd_rdy
  ,dp2reg_consumer
  ,dp2reg_done
  ,rd_req_rdy
  ,reg2dp_contract_stride_0
  ,reg2dp_contract_stride_1
  ,reg2dp_dain_addr_high
  ,reg2dp_dain_addr_low
  ,reg2dp_dain_line_stride
  ,reg2dp_dain_planar_stride
  ,reg2dp_dain_surf_stride
  ,reg2dp_daout_addr_high
  ,reg2dp_daout_addr_low
  ,reg2dp_daout_line_stride
  ,reg2dp_daout_planar_stride
  ,reg2dp_daout_surf_stride
  ,reg2dp_datain_channel
  ,reg2dp_datain_height
  ,reg2dp_datain_ram_type
  ,reg2dp_datain_width
  ,reg2dp_dataout_channel
  ,reg2dp_deconv_x_stride
  ,reg2dp_deconv_y_stride
  ,reg2dp_in_precision
  ,reg2dp_op_en
  ,reg2dp_perf_en
  ,reg2dp_rubik_mode
  ,rf_rd_cmd_rdy
  ,rf_wr_cmd_rdy
  ,contract_lit_dx
  ,dma_wr_cmd_pd
  ,dma_wr_cmd_vld
  ,dp2reg_d0_rd_stall_cnt
  ,dp2reg_d1_rd_stall_cnt
  ,inwidth
  ,rd_req_pd
  ,rd_req_type
  ,rd_req_vld
  ,rf_rd_cmd_pd
  ,rf_rd_cmd_vld
  ,rf_wr_cmd_pd
  ,rf_wr_cmd_vld
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input         dp2reg_consumer;
input         reg2dp_perf_en;
output [31:0] dp2reg_d0_rd_stall_cnt;
output [31:0] dp2reg_d1_rd_stall_cnt;

input  reg2dp_op_en;
input  reg2dp_datain_ram_type;
input  [1:0]            reg2dp_rubik_mode;
input  [1:0]          reg2dp_in_precision;
input  [31:0]                 reg2dp_dain_addr_high;
input  [26:0]                  reg2dp_dain_addr_low;
input  [12:0]   reg2dp_datain_channel;
input  [12:0]    reg2dp_datain_height;
input  [12:0]     reg2dp_datain_width;
input  [4:0]  reg2dp_deconv_x_stride;
input  [4:0]  reg2dp_deconv_y_stride;
input  [26:0]               reg2dp_dain_line_stride;
input  [26:0]             reg2dp_dain_planar_stride;
input  [26:0]               reg2dp_dain_surf_stride;
input  [26:0]              reg2dp_contract_stride_0;
input  [26:0]              reg2dp_contract_stride_1;

//data out register
input  [31:0]                reg2dp_daout_addr_high;
input  [26:0]                 reg2dp_daout_addr_low;
input  [26:0]              reg2dp_daout_line_stride;
input  [26:0]            reg2dp_daout_planar_stride;
input  [26:0]              reg2dp_daout_surf_stride;
input  [12:0] reg2dp_dataout_channel;

input   dp2reg_done;
//output  rd_req_done;

output  rd_req_type;
output  rd_req_vld;
input   rd_req_rdy;
output  [78:0]    rd_req_pd;

output            rf_wr_cmd_vld;
input             rf_wr_cmd_rdy;
output  [10:0]    rf_wr_cmd_pd;
output            rf_rd_cmd_vld;
input             rf_rd_cmd_rdy;
output  [11:0]    rf_rd_cmd_pd;

output            dma_wr_cmd_vld;
input             dma_wr_cmd_rdy;
output  [77:0]    dma_wr_cmd_pd;

output            contract_lit_dx;
output  [13:0]    inwidth;

reg    [31:0] chn_stride;
reg    [31:0] cubey_stride;
reg           dma_wr_cmd_vld_tmp;
reg    [31:0] dp2reg_d0_rd_stall_cnt;
reg    [31:0] dp2reg_d1_rd_stall_cnt;
reg    [17:0] inheight_mul_dy;
reg    [26:0] intern_stride;
reg    [13:0] inwidth_mul_dx;
reg           mon_rd_addr_c;
reg           mon_rd_cbase_c;
reg           mon_rd_chn_cnt;
reg           mon_rd_lbase_c;
reg           mon_rd_wbase_c;
reg           mon_rd_width_cnt;
reg           mon_rd_ybase_c;
reg           mon_wr_addr_c;
reg           mon_wr_cbase_c;
reg           mon_wr_chn_cnt;
reg           mon_wr_dx_cnt;
reg           mon_wr_lbase_c;
reg           mon_wr_wbase_c;
reg           mon_wr_width_cnt;
reg           mon_wr_xbase_c;
reg    [31:0] out_chn_stride;
reg    [26:0] out_intern_stride;
reg     [7:0] out_width_stridem;
reg    [58:0] rd_addr;
reg    [58:0] rd_chn_base;
reg     [8:0] rd_chn_cnt;
reg     [4:0] rd_dx_cnt;
reg    [58:0] rd_dy_base;
reg     [4:0] rd_dy_cnt;
reg    [58:0] rd_line_base;
reg    [12:0] rd_line_cnt;
reg           rd_req_done_hold;
reg           rd_req_tmp;
reg    [31:0] rd_stall_cnt;
reg    [58:0] rd_width_base;
reg     [9:0] rd_width_cnt;
reg     [1:0] reg2dp_in_precision_drv0;
reg     [1:0] reg2dp_rubik_mode_drv0;
reg           rubik_en;
reg           rubik_en_d;
reg           stl_adv;
reg    [31:0] stl_cnt_cur;
reg    [33:0] stl_cnt_dec;
reg    [33:0] stl_cnt_ext;
reg    [33:0] stl_cnt_inc;
reg    [33:0] stl_cnt_mod;
reg    [33:0] stl_cnt_new;
reg    [33:0] stl_cnt_nxt;
reg     [2:0] width_stridem;
reg    [58:0] wr_addr;
reg    [58:0] wr_chn_base;
reg     [8:0] wr_chn_cnt;
reg    [58:0] wr_dx_base;
reg     [1:0] wr_dx_cnt;
reg    [58:0] wr_line_base;
reg    [17:0] wr_line_cnt;
reg     [4:0] wr_plar_cnt;
reg           wr_req_done_hold;
reg    [58:0] wr_width_base;
reg     [9:0] wr_width_cnt;
wire   [12:0] contract_rd_size;
wire   [14:0] contract_rd_size_ext;
wire   [12:0] contract_wr_size;
wire   [26:0] cube_stride;
wire   [58:0] dest_base;
wire    [2:0] dx_stride_num;
wire   [13:0] inchannel;
wire   [12:0] inchannel_raw;
wire   [13:0] inheight;
wire   [12:0] inheight_raw;
wire          init_set;
wire   [12:0] inwidth_raw;
wire   [10:0] inwidthm;
wire    [4:0] kpg_dec;
wire    [1:0] kpgm;
wire   [26:0] line_stride;
wire          m_byte_data;
wire          m_contract;
wire          m_merge;
wire          m_split;
wire   [12:0] merge_rd_size;
wire   [14:0] merge_rd_size_ext;
wire   [12:0] merge_wr_size;
wire   [26:0] mon_block_stride;
wire          mon_dx_stride_num_c;
wire          mon_inwidthm_c;
wire          mon_outchannelm_c;
wire          mon_rd_chn_num_c;
wire          mon_remain_rdc;
wire          mon_remain_rdw;
wire          mon_remain_rdx;
wire          mon_remain_wrc;
wire          mon_remain_wrw;
wire          mon_remain_wrx;
wire   [26:0] out_line_stride;
wire   [26:0] out_planar_stride;
wire   [26:0] out_surf_stride;
wire   [26:0] out_width_stride;
wire   [13:0] outchannel;
wire    [9:0] outchannelm;
wire   [26:0] planar_stride;
wire          rd_channel_end;
wire    [9:0] rd_chn_cnt_inc;
wire   [13:0] rd_chn_num;
wire    [9:0] rd_chn_numm;
wire   [10:0] rd_cwdth_cnt_inc;
wire          rd_cwdth_end;
wire          rd_cx_beg;
wire          rd_dx_end;
wire    [4:0] rd_dx_num;
wire          rd_dy_end;
wire          rd_height_end;
wire   [10:0] rd_mwdth_cnt_inc;
wire          rd_mwdth_end;
wire    [4:0] rd_planar_num;
wire          rd_plar_end;
wire          rd_px_beg;
wire          rd_req_accept;
wire          rd_req_done;
wire          rd_stall_cnt_dec;
wire    [5:0] rd_total_col;
wire    [5:0] rd_total_row;
wire   [12:0] remain_rd_channel;
wire    [4:0] remain_rd_dx;
wire   [12:0] remain_rd_width;
wire   [12:0] remain_wr_channel;
wire    [4:0] remain_wr_dx;
wire   [12:0] remain_wr_width;
wire   [12:0] split_rd_size;
wire   [14:0] split_rd_size_ext;
wire   [12:0] split_wr_size;
wire   [58:0] src_base;
wire   [26:0] surf_stride;
wire   [26:0] width_stride;
wire          wr_channel_end;
wire          wr_cheight_end;
wire    [9:0] wr_chn_cnt_inc;
wire   [10:0] wr_cwdth_cnt_inc;
wire          wr_cwdth_end;
wire    [2:0] wr_dx_cnt_inc;
wire          wr_dx_end;
wire    [4:0] wr_dx_num;
wire          wr_height_end;
wire          wr_hx_beg;
wire          wr_hx_end;
wire          wr_mheight_end;
wire   [10:0] wr_mwdth_cnt_inc;
wire          wr_mwdth_end;
wire    [4:0] wr_planar_num;
wire          wr_plar_beg;
wire          wr_plar_end;
wire          wr_req_accept;
wire          wr_req_done;
wire    [5:0] wr_total_col;
wire    [4:0] wr_total_row;
wire          wr_width_end;
wire    [4:0] wr_width_num;
wire    [4:0] x_stride;
wire    [5:0] x_stride_add;
wire    [4:0] y_stride;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

///////////////////////////////Configuration///////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_rubik_mode_drv0[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_rubik_mode_drv0[1:0] <= reg2dp_rubik_mode[1:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_in_precision_drv0[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_in_precision_drv0[1:0] <= reg2dp_in_precision[1:0];
  end
end

assign  m_contract  = reg2dp_rubik_mode_drv0[1:0] == 2'h0 ;
assign  m_split     = reg2dp_rubik_mode_drv0[1:0] == 2'h1 ;
assign  m_merge     = reg2dp_rubik_mode_drv0[1:0] == 2'h2 ;
assign  m_byte_data = reg2dp_in_precision_drv0[1:0] == 2'h0 ;

assign  src_base  = {reg2dp_dain_addr_high,reg2dp_dain_addr_low};
assign  dest_base = {reg2dp_daout_addr_high,reg2dp_daout_addr_low};

assign  inwidth_raw[12:0]    = reg2dp_datain_width[12:0]   ;  
assign  inheight_raw[12:0]   = reg2dp_datain_height[12:0]  ;
assign  inchannel_raw[12:0]  = reg2dp_datain_channel[12:0] ; 

assign  inwidth[13:0]    = reg2dp_datain_width[12:0]   +1;  
assign  inheight[13:0]   = reg2dp_datain_height[12:0]  +1;
assign  inchannel[13:0]  = reg2dp_datain_channel[12:0] +1; 
assign  outchannel[13:0] = reg2dp_dataout_channel[12:0]+1; 

assign  mon_block_stride[26:0] = reg2dp_contract_stride_1[26:0];

assign  planar_stride[26:0]= reg2dp_dain_planar_stride[26:0];
assign  line_stride[26:0]  = reg2dp_dain_line_stride[26:0];
assign  surf_stride[26:0]  = reg2dp_dain_surf_stride[26:0];
assign  cube_stride[26:0]  = reg2dp_contract_stride_0[26:0];
assign  x_stride[4:0]      = reg2dp_deconv_x_stride[4:0];
assign  y_stride[4:0]      = reg2dp_deconv_y_stride[4:0];
assign  x_stride_add[5:0]  = reg2dp_deconv_x_stride[4:0]+1;

assign  out_planar_stride[26:0] = reg2dp_daout_planar_stride[26:0];
assign  out_line_stride[26:0]   = reg2dp_daout_line_stride[26:0];
assign  out_surf_stride[26:0]   = reg2dp_daout_surf_stride[26:0];

assign  kpgm[1:0] = m_byte_data+1;
assign  kpg_dec[4:0] = {m_byte_data,4'hf}; 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    intern_stride[26:0] <= {27{1'b0}};
  end else begin
  intern_stride[26:0] <= m_contract ? cube_stride : m_merge ? planar_stride : 8'h40;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_stridem[2:0] <= {3{1'b0}};
  end else begin
  width_stridem[2:0] <= m_merge ? m_byte_data ? 3'h1 : 3'h2 : 3'h4;
  end
end
assign  width_stride[26:0] = {23'h0,width_stridem,1'b0};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cubey_stride[31:0] <= {32{1'b0}};
  end else begin
  cubey_stride[31:0] <= cube_stride * (x_stride+1);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    chn_stride[31:0] <= {32{1'b0}};
  end else begin
  chn_stride[31:0] <= (m_split | m_contract ) ? {5'h0,surf_stride} : m_byte_data ? {planar_stride,5'h0} : {1'b0,planar_stride,4'h0};
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(m_split | m_contract ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    out_intern_stride[26:0] <= {27{1'b0}};
  end else begin
  out_intern_stride[26:0] <= m_contract ? |x_stride[4:3] ? x_stride_add : out_line_stride : m_split ? out_planar_stride : 8'h40;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_width_stridem[7:0] <= {8{1'b0}};
  end else begin
  out_width_stridem[7:0] <= m_contract ? {x_stride_add,2'h0} : (m_byte_data ? 2'h1 : 2'h2);
  end
end
assign  out_width_stride[26:0] = {18'h0,out_width_stridem,1'b0};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    out_chn_stride[31:0] <= {32{1'b0}};
  end else begin
  out_chn_stride[31:0] <= (m_merge | m_contract ) ? {5'h0,out_surf_stride} : m_byte_data ? {out_planar_stride,5'h0} : {1'b0,out_planar_stride,4'h0};
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(m_merge | m_contract ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    inwidth_mul_dx[13:0] <= {14{1'b0}};
  end else begin
  inwidth_mul_dx[13:0] <= inwidth * (x_stride+1) -1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    inheight_mul_dy[17:0] <= {18{1'b0}};
  end else begin
  inheight_mul_dy[17:0] <= inheight * (y_stride+1) -1;
  end
end

/////////////////////rubik en////////////////////////
//rubik enable
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rubik_en <= 1'b0;
  end else begin
    if (dp2reg_done)
        rubik_en <= 1'b0;
    else if (reg2dp_op_en) 
        rubik_en <= 1'b1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rubik_en_d <= 1'b0;
  end else begin
  rubik_en_d <= rubik_en;
  end
end
assign  init_set = rubik_en & ~rubik_en_d;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////generate read dma sequence//////////////////////////
//read request valid  
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_req_tmp <= 1'b0;
  end else begin
    if (rd_req_done | rd_req_done_hold | dp2reg_done)
        rd_req_tmp <= 1'b0;   
    else if (rubik_en)
        rd_req_tmp <= 1'b1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_req_done_hold <= 1'b0;
  end else begin
    if (dp2reg_done)
        rd_req_done_hold <= 1'b0;
    else if (rd_req_done)
        rd_req_done_hold <= 1'b1;
  end
end

assign  rd_req_done = rd_channel_end;
assign  rd_req_type = reg2dp_datain_ram_type;
assign  rd_req_vld  = rd_req_tmp & rf_wr_cmd_rdy;        
assign  rd_req_pd[63:0] = {rd_addr,5'h0}; 

assign  contract_rd_size_ext = {{2{1'b0}}, contract_rd_size};
assign  split_rd_size_ext = {{2{1'b0}}, split_rd_size};
assign  merge_rd_size_ext = {{2{1'b0}}, merge_rd_size};
assign  rd_req_pd[78:64] =  m_contract ? contract_rd_size_ext : m_split ? split_rd_size_ext : merge_rd_size_ext ; //rd size 32bytes units and decrease 1
assign  rd_req_accept = rd_req_vld & rd_req_rdy;

//request burst size
assign  {mon_remain_rdw,remain_rd_width[12:0]}   = inwidth_raw - {rd_width_cnt,3'h0};
assign  {mon_remain_rdc,remain_rd_channel[12:0]} = inchannel_raw -{rd_chn_cnt,4'h0};
assign  {mon_remain_rdx,remain_rd_dx[4:0]}       = x_stride - rd_dx_cnt;

assign  contract_rd_size[12:0] = remain_rd_width >= 8'h7   ?  6'h7    : remain_rd_width;
assign  split_rd_size[12:0]    = remain_rd_width >= 8'h3f  ?  6'h3f   : remain_rd_width;
assign  merge_rd_size[12:0]    = m_byte_data ? (remain_rd_width >= 8'h20 ? 1'b1 : 1'b0) :  
                                               (remain_rd_width >= 8'h30 ? 4'h3 : remain_rd_width >= 8'h20 ? 4'h2 : 
                                                remain_rd_width >= 8'h10 ? 4'h1 : 4'h0);

assign  rd_dx_num[4:0]      = remain_rd_dx >= 5'h7 ? 5'h7 : remain_rd_dx;
assign  rd_planar_num[4:0]  = remain_rd_channel >= {8'h0,kpg_dec} ? kpg_dec : remain_rd_channel[4:0];

//caculate ping pong array total row number & total column number
assign  wr_total_col[5:0] = m_contract ? contract_rd_size[5:0] : m_split ? split_rd_size[5:0] : merge_rd_size[5:0] ; 
assign  wr_total_row[4:0] = m_contract ? (|x_stride[4:3] ? rd_dx_num : x_stride) : m_merge ? rd_planar_num[4:0] : 1'b0;

assign  rf_wr_cmd_vld = rd_px_beg | rd_cx_beg | m_split & rd_req_accept;
assign  rf_wr_cmd_pd  = {wr_total_row,wr_total_col};
/*
&Always posedge;
    if(rd_px_beg | rd_cx_beg | m_split & rd_req_accept) begin
        rf_wr_cmd_vld <0=1'b1;
        rf_wr_cmd_pd  <0= {wr_total_row,wr_total_col};
    end
    else if (rf_wr_cmd_vld & rf_wr_cmd_rdy)
        rf_wr_cmd_vld <0=1'b0;
&End;
*/
  
///////generate read sequence address/////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_addr <= {59{1'b0}};
    {mon_rd_addr_c,rd_addr} <= {60{1'b0}};
  end else begin
    if(init_set)
       rd_addr <= src_base;
    else if(rd_height_end)            
       {mon_rd_addr_c,rd_addr} <= rd_chn_base + chn_stride     ; 
    else if(rd_dy_end | rd_mwdth_end) 
       {mon_rd_addr_c,rd_addr} <= rd_line_base + line_stride   ;
    else if(rd_cwdth_end)             
       {mon_rd_addr_c,rd_addr} <= rd_dy_base + cubey_stride    ;
    else if(rd_dx_end | rd_plar_end)  
       {mon_rd_addr_c,rd_addr} <= rd_width_base + width_stride ;
    else if(rd_req_accept)            
       {mon_rd_addr_c,rd_addr} <= rd_addr + intern_stride      ; 
  end
end

//record the pointer base address
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_width_base <= {59{1'b0}};
    {mon_rd_wbase_c,rd_width_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       rd_width_base <= src_base;
    else if(rd_height_end)            
       {mon_rd_wbase_c,rd_width_base} <= rd_chn_base + chn_stride     ; 
    else if(rd_dy_end | rd_mwdth_end) 
       {mon_rd_wbase_c,rd_width_base} <= rd_line_base + line_stride   ;
    else if(rd_cwdth_end)             
       {mon_rd_wbase_c,rd_width_base} <= rd_dy_base + cubey_stride    ;
    else if(rd_dx_end | rd_plar_end)
       {mon_rd_wbase_c,rd_width_base} <= rd_width_base + width_stride ;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_dy_base <= {59{1'b0}};
    {mon_rd_ybase_c,rd_dy_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       rd_dy_base <= src_base;
    else if(rd_height_end)            
       {mon_rd_ybase_c,rd_dy_base} <= rd_chn_base + chn_stride     ; 
    else if(rd_dy_end) 
       {mon_rd_ybase_c,rd_dy_base} <= rd_line_base + line_stride   ;
    else if(rd_cwdth_end)
       {mon_rd_ybase_c,rd_dy_base} <= rd_dy_base + cubey_stride;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_line_base <= {59{1'b0}};
    {mon_rd_lbase_c,rd_line_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       rd_line_base <= src_base;
    else if (rd_height_end)
       {mon_rd_lbase_c,rd_line_base} <= rd_chn_base + chn_stride;
    else if(rd_dy_end | rd_mwdth_end)
       {mon_rd_lbase_c,rd_line_base} <= rd_line_base + line_stride;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_chn_base <= {59{1'b0}};
    {mon_rd_cbase_c,rd_chn_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       rd_chn_base <= src_base;
    else if(rd_height_end)
       {mon_rd_cbase_c,rd_chn_base} <= rd_chn_base + chn_stride;
  end
end

///////////for circle counter/////////////
//deconv x counter
assign  rd_px_beg   = m_merge & rd_req_accept & (rd_dx_cnt == 5'h0);
assign  rd_cx_beg   = m_contract & rd_req_accept & (rd_dx_cnt[2:0] == 3'h0); 
assign  rd_dx_end   = m_contract & rd_req_accept & (rd_dx_cnt == x_stride);
assign  rd_plar_end = m_merge & rd_req_accept & (rd_dx_cnt == rd_planar_num);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_dx_cnt <= {5{1'b0}};
  end else begin
    if (!rubik_en | rd_dx_end | rd_plar_end) begin
        rd_dx_cnt <= 0;
    end 
    else if ((m_contract | m_merge) & rd_req_accept) begin
        rd_dx_cnt <= rd_dx_cnt + 1;
    end
  end
end

//read width counter
assign  rd_cwdth_cnt_inc[10:0] = rd_width_cnt + 1'b1; 
assign  rd_mwdth_cnt_inc[10:0] = rd_width_cnt + 4'h8; 
assign  {mon_inwidthm_c,inwidthm[10:0]} = inwidth[13:3]+|inwidth[2:0];

assign  rd_cwdth_end = rd_dx_end & (rd_cwdth_cnt_inc >= inwidthm);  
assign  rd_mwdth_end = (rd_plar_end | m_split & rd_req_accept) & (rd_mwdth_cnt_inc >= inwidthm);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_width_cnt <= {10{1'b0}};
    {mon_rd_width_cnt,rd_width_cnt} <= {11{1'b0}};
  end else begin
    if (!rubik_en | rd_cwdth_end |rd_mwdth_end) begin
        rd_width_cnt <= 0;
    end 
    else if(rd_dx_end) begin
        {mon_rd_width_cnt,rd_width_cnt} <= rd_cwdth_cnt_inc;
    end
    else if(rd_plar_end | m_split & rd_req_accept) begin
        {mon_rd_width_cnt,rd_width_cnt} <= rd_mwdth_cnt_inc;
    end
  end
end

//read deconv y counter
assign  rd_dy_end = rd_cwdth_end & (rd_dy_cnt == y_stride);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_dy_cnt <= {5{1'b0}};
  end else begin
    if (!rubik_en | rd_dy_end) begin
        rd_dy_cnt <= 0;
    end 
    else if (rd_cwdth_end) begin
        rd_dy_cnt <= rd_dy_cnt + 1;
    end
  end
end

//read height counter
assign  rd_height_end = (rd_dy_end | rd_mwdth_end) & (rd_line_cnt == inheight_raw);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_line_cnt <= {13{1'b0}};
  end else begin
    if (!rubik_en | rd_height_end) begin
        rd_line_cnt <= 0;
    end 
    else if(rd_dy_end | rd_mwdth_end) begin
        rd_line_cnt <= rd_line_cnt + 1;
    end
  end
end

//read outchannel counter
assign  rd_chn_cnt_inc[9:0] = rd_chn_cnt + kpgm;
assign  rd_chn_num[13:0] = m_contract ? outchannel : inchannel;
assign  {mon_rd_chn_num_c,rd_chn_numm[9:0]} = rd_chn_num[13:4]+|rd_chn_num[3:0];
assign  rd_channel_end = rd_height_end & (rd_chn_cnt_inc >= rd_chn_numm);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_chn_cnt <= {9{1'b0}};
    {mon_rd_chn_cnt,rd_chn_cnt} <= {10{1'b0}};
  end else begin
    if (!rubik_en | rd_channel_end) begin
        rd_chn_cnt <= 0;
    end 
    else if(rd_height_end) begin
        {mon_rd_chn_cnt,rd_chn_cnt} <= rd_chn_cnt_inc;
    end
  end
end

////////////////////////////////////////////////////////////////////////////////////
///////////////////////////generate write dma sequence//////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_wr_cmd_vld_tmp <= 1'b0;
  end else begin
    if (wr_req_done | wr_req_done_hold | dp2reg_done)
        dma_wr_cmd_vld_tmp <= 1'b0;   
    else if (rubik_en)
        dma_wr_cmd_vld_tmp <= 1'b1;   
  end
end
assign  dma_wr_cmd_vld = dma_wr_cmd_vld_tmp & rf_rd_cmd_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_req_done_hold <= 1'b0;
  end else begin
    if (dp2reg_done)
        wr_req_done_hold <= 1'b0;
    else if (wr_req_done)
        wr_req_done_hold <= 1'b1;
  end
end

assign  wr_req_done = wr_channel_end;
assign  dma_wr_cmd_pd[77:77] = wr_req_done;
assign  dma_wr_cmd_pd[76:64]        = m_contract ? contract_wr_size : m_merge ? merge_wr_size : split_wr_size;
assign  dma_wr_cmd_pd[63:0]        = {wr_addr,5'b0};
assign  wr_req_accept = dma_wr_cmd_vld & dma_wr_cmd_rdy;

//request burst size
assign  {mon_remain_wrw,remain_wr_width[12:0]}   = inwidth_raw - {wr_width_cnt,3'h0};
assign  {mon_remain_wrc,remain_wr_channel[12:0]} = inchannel_raw -{wr_chn_cnt,4'h0};
assign  {mon_remain_wrx,remain_wr_dx[4:0]}       = x_stride - {wr_dx_cnt,3'h0};

assign  contract_wr_size[12:0] = |x_stride[4:3] ? {8'h0,wr_dx_num[4:0]} : inwidth_mul_dx[12:0]; 
assign  merge_wr_size[12:0]    = remain_wr_width >= 6'h3f ? 6'h3f   : remain_wr_width;
assign  split_wr_size[12:0]    = m_byte_data ? (remain_wr_width >= 6'h20 ? 1'b1 : 1'b0) :  
                                               (remain_wr_width >= 6'h30 ? 4'h3 : remain_wr_width >= 6'h20 ? 4'h2 : 
                                                remain_wr_width >= 6'h10 ? 4'h1 : 4'h0);

assign  wr_dx_num[4:0]     = remain_wr_dx      >= 4'h7  ? 4'h7 : remain_wr_dx ; 
assign  wr_width_num[4:0]  = remain_wr_width   >= 4'h7  ? 4'h7 : remain_wr_width[4:0];
assign  wr_planar_num[4:0] = remain_wr_channel >= {8'h0,kpg_dec} ? kpg_dec : remain_wr_channel[4:0];

//merge and split of read total column unit is element(1byte or 2byte), but contract unit is 32bytes
assign  rd_total_col[5:0] = m_contract ? (|x_stride[4:3] ? {1'b0,wr_dx_num} : {1'b0,x_stride}) : m_merge ? {1'b0,wr_planar_num[4:0]} : merge_wr_size[5:0]; 
assign  rd_total_row[5:0] = m_contract ? (|x_stride[4:3] ? {1'b0,wr_width_num[4:0]} : 1'b0) : m_merge ? merge_wr_size[5:0] : {1'b0,wr_planar_num[4:0]}; 
assign  contract_lit_dx   = m_contract & ~(|x_stride[4:3]); 

assign  rf_rd_cmd_vld = wr_plar_beg | wr_hx_beg | (m_contract & ~(|x_stride[4:3]) | m_merge) & wr_req_accept;
assign  rf_rd_cmd_pd  = {rd_total_row,rd_total_col};
/*
&Always posedge;
    if (wr_plar_beg | wr_hx_beg | (m_contract & ~(|x_stride[4:3]) | m_merge) & wr_req_accept) begin
        rf_rd_cmd_vld <0=1'b1;
        rf_rd_cmd_pd  <0= {rd_total_row,rd_total_col};
    end
    else if (rf_rd_cmd_vld & rf_rd_cmd_rdy)
        rf_rd_cmd_vld <0=1'b0;
&End;
*/

///////generate write sequence address/////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_addr <= {59{1'b0}};
    {mon_wr_addr_c,wr_addr} <= {60{1'b0}};
  end else begin
    if(init_set)
       wr_addr <= dest_base;
    else if(wr_height_end)            
       {mon_wr_addr_c,wr_addr} <= wr_chn_base + out_chn_stride     ; 
    else if(wr_width_end) 
       {mon_wr_addr_c,wr_addr} <= wr_line_base + out_line_stride   ;
    else if(wr_dx_end | wr_plar_end)  
       {mon_wr_addr_c,wr_addr} <= wr_width_base + out_width_stride ;
    else if(wr_hx_end)  
       {mon_wr_addr_c,wr_addr} <= wr_dx_base + 4'h8;
    else if(wr_req_accept)            
       {mon_wr_addr_c,wr_addr} <= wr_addr + out_intern_stride      ; 
  end
end

//record the pointer base address
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_dx_base <= {59{1'b0}};
    {mon_wr_xbase_c,wr_dx_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       wr_dx_base <= dest_base;
    else if(wr_height_end)            
       {mon_wr_xbase_c,wr_dx_base} <= wr_chn_base + out_chn_stride     ; 
    else if(wr_width_end) 
       {mon_wr_xbase_c,wr_dx_base} <= wr_line_base + out_line_stride   ;
    else if(wr_dx_end | wr_plar_end)  
       {mon_wr_xbase_c,wr_dx_base} <= wr_width_base + out_width_stride ;
    else if(wr_hx_end)
       {mon_wr_xbase_c,wr_dx_base} <= wr_dx_base + 4'h8;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_width_base <= {59{1'b0}};
    {mon_wr_wbase_c,wr_width_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       wr_width_base <= dest_base;
    else if(wr_height_end)            
       {mon_wr_wbase_c,wr_width_base} <= wr_chn_base + out_chn_stride     ; 
    else if(wr_width_end) 
       {mon_wr_wbase_c,wr_width_base} <= wr_line_base + out_line_stride   ;
    else if(wr_dx_end | wr_plar_end)
       {mon_wr_wbase_c,wr_width_base} <= wr_width_base + out_width_stride;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_base <= {59{1'b0}};
    {mon_wr_lbase_c,wr_line_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       wr_line_base <= dest_base;
    else if(wr_height_end)            
       {mon_wr_lbase_c,wr_line_base} <= wr_chn_base + out_chn_stride     ; 
    else if(wr_width_end)
       {mon_wr_lbase_c,wr_line_base} <= wr_line_base + out_line_stride;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_chn_base <= {59{1'b0}};
    {mon_wr_cbase_c,wr_chn_base} <= {60{1'b0}};
  end else begin
    if(init_set)
       wr_chn_base <= dest_base;
    else if(wr_height_end)
       {mon_wr_cbase_c,wr_chn_base} <= wr_chn_base + out_chn_stride;
  end
end

///////////for circle counter/////////////
//internal counter
assign  wr_hx_beg   = m_contract & (|x_stride[4:3]) & wr_req_accept & (wr_plar_cnt == 0);
assign  wr_hx_end   = m_contract & (|x_stride[4:3]) & wr_req_accept & (wr_plar_cnt == wr_width_num);
assign  wr_plar_beg = m_split & wr_req_accept & (wr_plar_cnt == 0);
assign  wr_plar_end = m_split & wr_req_accept & (wr_plar_cnt == wr_planar_num);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_plar_cnt <= {5{1'b0}};
  end else begin
    if (!rubik_en | wr_hx_end | wr_plar_end) begin
        wr_plar_cnt <= 0;
    end 
    else if ((m_contract & (|x_stride[4:3]) | m_split) & wr_req_accept) begin
        wr_plar_cnt <= wr_plar_cnt + 1;
    end
  end
end

//deconv x counter
assign  wr_dx_cnt_inc[2:0] = wr_dx_cnt + 1'b1;
assign  {mon_dx_stride_num_c,dx_stride_num[2:0]} = x_stride_add[5:3]+|x_stride_add[2:0];
assign  wr_dx_end = wr_hx_end & (wr_dx_cnt_inc >= dx_stride_num);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_dx_cnt <= {2{1'b0}};
    {mon_wr_dx_cnt,wr_dx_cnt} <= {3{1'b0}};
  end else begin
    if (!rubik_en | wr_dx_end) begin
        wr_dx_cnt <= 0;
    end 
    else if (wr_hx_end) begin
        {mon_wr_dx_cnt,wr_dx_cnt} <= wr_dx_cnt_inc;
    end
  end
end

//write width counter
assign  wr_cwdth_cnt_inc[10:0] = wr_width_cnt + 1'b1; 
assign  wr_mwdth_cnt_inc[10:0] = wr_width_cnt + 4'h8; 
assign  wr_cwdth_end = wr_dx_end & (wr_cwdth_cnt_inc >= inwidthm[10:0]); 
assign  wr_mwdth_end =(wr_plar_end | m_merge & wr_req_accept) & (wr_mwdth_cnt_inc >= inwidthm[10:0]);
assign  wr_width_end = wr_cwdth_end | wr_mwdth_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_width_cnt <= {10{1'b0}};
    {mon_wr_width_cnt,wr_width_cnt} <= {11{1'b0}};
  end else begin
    if (!rubik_en | wr_width_end) begin
        wr_width_cnt <= 0;
    end 
    else if(wr_dx_end) begin
        {mon_wr_width_cnt,wr_width_cnt} <= wr_cwdth_cnt_inc;
    end
    else if(wr_plar_end | m_merge & wr_req_accept) begin
        {mon_wr_width_cnt,wr_width_cnt} <= wr_mwdth_cnt_inc;
    end
  end
end

//write height counter
assign  wr_cheight_end = (wr_cwdth_end | m_contract & ~(|x_stride[4:3]) & wr_req_accept) & (wr_line_cnt == inheight_mul_dy);
assign  wr_mheight_end = wr_mwdth_end & (wr_line_cnt == {5'h0,inheight_raw});
assign  wr_height_end  = wr_cheight_end | wr_mheight_end;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_cnt <= {18{1'b0}};
  end else begin
    if (!rubik_en | wr_height_end) begin
        wr_line_cnt <= 0;
    end 
    else if(wr_width_end | m_contract & ~(|x_stride[4:3]) & wr_req_accept) begin
        wr_line_cnt <= wr_line_cnt + 1;
    end
  end
end

//write channel counter
assign  wr_chn_cnt_inc[9:0] = wr_chn_cnt + kpgm;
assign  {mon_outchannelm_c,outchannelm[9:0]} = outchannel[13:4]+|outchannel[3:0];
assign  wr_channel_end = wr_height_end & (wr_chn_cnt_inc >= outchannelm[9:0]);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_chn_cnt <= {9{1'b0}};
    {mon_wr_chn_cnt,wr_chn_cnt} <= {10{1'b0}};
  end else begin
    if (!rubik_en | wr_channel_end) begin
        wr_chn_cnt <= 0;
    end 
    else if(wr_height_end) begin
        {mon_wr_chn_cnt,wr_chn_cnt} <= wr_chn_cnt_inc;
    end
  end
end


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

    property rubik_seq_gen__read_request_block__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        rd_req_vld & !rd_req_rdy;
    endproperty
    // Cover 0 : "rd_req_vld & !rd_req_rdy"
    FUNCPOINT_rubik_seq_gen__read_request_block__0_COV : cover property (rubik_seq_gen__read_request_block__0_cov);

  `endif
`endif
//VCS coverage on





    assign rd_stall_cnt_dec = 1'b0;

    // stl adv logic

    always @(
      rd_req_vld
      or rd_stall_cnt_dec
      ) begin
      stl_adv = rd_req_vld ^ rd_stall_cnt_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or rd_req_vld
      or rd_stall_cnt_dec
      or stl_adv
      or rd_req_done
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (rd_req_vld && !rd_stall_cnt_dec)? stl_cnt_inc : (!rd_req_vld && rd_stall_cnt_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (rd_req_done)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (reg2dp_perf_en) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      rd_stall_cnt[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_rd_stall_cnt <= {32{1'b0}};
  end else begin
   if (rd_req_done & ~dp2reg_consumer)
       dp2reg_d0_rd_stall_cnt <= rd_stall_cnt; 
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_rd_stall_cnt <= {32{1'b0}};
  end else begin
   if (rd_req_done & dp2reg_consumer)
       dp2reg_d1_rd_stall_cnt <= rd_stall_cnt; 
  end
end

endmodule // NV_NVDLA_RUBIK_seq_gen

