// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_IG_cvt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_IG_cvt (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,cq_wr_prdy              //|< i
  ,eg2ig_axi_len           //|< i
  ,eg2ig_axi_vld           //|< i
  ,mcif2noc_axi_aw_awready //|< i
  ,mcif2noc_axi_w_wready   //|< i
  ,reg2dp_wr_os_cnt        //|< i
  ,spt2cvt_cmd_pd          //|< i
  ,spt2cvt_cmd_valid       //|< i
  ,spt2cvt_dat_pd          //|< i
  ,spt2cvt_dat_valid       //|< i
  ,cq_wr_pd                //|> o
  ,cq_wr_pvld              //|> o
  ,cq_wr_thread_id         //|> o
  ,mcif2noc_axi_aw_awaddr  //|> o
  ,mcif2noc_axi_aw_awid    //|> o
  ,mcif2noc_axi_aw_awlen   //|> o
  ,mcif2noc_axi_aw_awvalid //|> o
  ,mcif2noc_axi_w_wdata    //|> o
  ,mcif2noc_axi_w_wlast    //|> o
  ,mcif2noc_axi_w_wstrb    //|> o
  ,mcif2noc_axi_w_wvalid   //|> o
  ,spt2cvt_cmd_ready       //|> o
  ,spt2cvt_dat_ready       //|> o
  );
//
// NV_NVDLA_MCIF_WRITE_IG_cvt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         spt2cvt_cmd_valid;  /* data valid */
output        spt2cvt_cmd_ready;  /* data return handshake */
input  [76:0] spt2cvt_cmd_pd;

input          spt2cvt_dat_valid;  /* data valid */
output         spt2cvt_dat_ready;  /* data return handshake */
input  [513:0] spt2cvt_dat_pd;

output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [2:0] cq_wr_thread_id;
output [2:0] cq_wr_pd;

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [63:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [511:0] mcif2noc_axi_w_wdata;
output  [63:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;

//&Ports /streamid/;
input   [1:0] eg2ig_axi_len;
input         eg2ig_axi_vld;
input   [7:0] reg2dp_wr_os_cnt;

reg     [1:0] eg2ig_axi_len_d;
reg           eg2ig_axi_vld_d;
reg           os_adv;
reg     [8:0] os_cnt;
reg     [8:0] os_cnt_cur;
reg    [10:0] os_cnt_ext;
reg    [10:0] os_cnt_mod;
reg    [10:0] os_cnt_new;
reg    [10:0] os_cnt_nxt;
wire          all_downs_rdy;
wire   [63:0] axi_addr;
wire   [69:0] axi_aw_pd;
wire    [3:0] axi_axid;
wire          axi_both_rdy;
wire   [69:0] axi_cmd_pd;
wire          axi_cmd_rdy;
wire          axi_cmd_vld;
wire  [576:0] axi_dat_pd;
wire          axi_dat_rdy;
wire          axi_dat_vld;
wire  [511:0] axi_data;
wire          axi_last;
wire    [1:0] axi_len;
wire   [63:0] axi_strb;
wire  [576:0] axi_w_pd;
wire    [7:0] cfg_wr_os_cnt;
wire   [63:0] cmd_addr;
wire    [3:0] cmd_axid;
wire          cmd_ftran;
wire          cmd_ftran_NC;
wire          cmd_inc;
wire          cmd_ltran;
wire          cmd_odd;
wire          cmd_odd_NC;
wire   [76:0] cmd_pd;
wire          cmd_rdy;
wire          cmd_require_ack;
wire    [2:0] cmd_size;
wire          cmd_swizzle;
wire          cmd_swizzle_NC;
wire          cmd_vld;
wire   [76:0] cmd_vld_pd;
wire    [1:0] cq_wr_len;
wire          cq_wr_require_ack;
wire  [511:0] dat_data;
wire    [1:0] dat_mask;
wire  [513:0] dat_pd;
wire          dat_rdy;
wire          dat_vld;
wire    [2:0] end_offset;
wire    [1:0] end_offset_bit_2_1_NC;
wire          is_first_cmd_dat_vld;
wire          mon_axi_len_c;
wire          mon_end_pos_c;
wire    [0:0] mon_thread_id_c;
wire   [63:0] opipe_axi_addr;
wire    [3:0] opipe_axi_axid;
wire  [511:0] opipe_axi_data;
wire          opipe_axi_last;
wire    [1:0] opipe_axi_len;
wire   [63:0] opipe_axi_strb;
wire          os_cmd_vld;
wire    [2:0] os_cnt_add;
wire          os_cnt_add_en;
wire          os_cnt_cen;
wire          os_cnt_full;
wire    [2:0] os_cnt_sub;
wire          os_cnt_sub_en;
wire    [2:0] os_inp_add_nxt;
wire    [9:0] os_inp_nxt;
wire    [2:0] os_inp_sub_nxt;
wire    [2:0] stt_offset;
wire    [8:0] wr_os_cnt_ext;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
// AXI address channel signals
// IG_cvt===flop In first
//&Vector SIG_nvdla_dma_wr_req_pd_WIDTH /wr_req_pd/;

//IG_cvt===upack : none-flop-in
NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p1 pipe_p1 (
   .nvdla_core_clk          (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.cmd_rdy                 (cmd_rdy)                 //|< w
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[76:0])    //|< i
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)       //|< i
  ,.cmd_pd                  (cmd_pd[76:0])            //|> w
  ,.cmd_vld                 (cmd_vld)                 //|> w
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)       //|> o
  );
NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p2 pipe_p2 (
   .nvdla_core_clk          (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.dat_rdy                 (dat_rdy)                 //|< w
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd[513:0])   //|< i
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)       //|< i
  ,.dat_pd                  (dat_pd[513:0])           //|> w
  ,.dat_vld                 (dat_vld)                 //|> w
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)       //|> o
  );

assign os_cmd_vld = cmd_vld & !os_cnt_full;

//IG_cvt=== push into the cq on first beat of data
assign dat_rdy = (os_cmd_vld & all_downs_rdy);
//IG_cvt=== will release cmd on the acception of last beat of data
assign cmd_rdy = dat_vld & all_downs_rdy & !os_cnt_full;

//IG_cvt===UNPACK after ipipe
assign cmd_vld_pd = {77{cmd_vld}} & cmd_pd;

// PKT_UNPACK_WIRE( cvt_write_cmd ,  cmd_ , cmd_vld_pd )
assign        cmd_axid[3:0] =    cmd_vld_pd[3:0];
assign         cmd_require_ack  =    cmd_vld_pd[4];
assign        cmd_addr[63:0] =    cmd_vld_pd[68:5];
assign        cmd_size[2:0] =    cmd_vld_pd[71:69];
assign         cmd_swizzle  =    cmd_vld_pd[72];
assign         cmd_odd  =    cmd_vld_pd[73];
assign         cmd_inc  =    cmd_vld_pd[74];
assign         cmd_ltran  =    cmd_vld_pd[75];
assign         cmd_ftran  =    cmd_vld_pd[76];
assign cmd_ftran_NC = cmd_ftran;
assign cmd_swizzle_NC = cmd_swizzle;
assign cmd_odd_NC = cmd_odd;


// PKT_UNPACK_WIRE( cvt_write_data , dat_ , dat_pd )
assign       dat_data[511:0] =    dat_pd[511:0];
assign       dat_mask[1:0] =    dat_pd[513:512];

// NOTE: this is for write strobe
// IG_cvt===address calculation
assign stt_offset = cmd_addr[7:5]; // start position within a 256B block
//assign is_start_addr_32_align = (stt_offset[0]==1'b1); //stepheng
assign {mon_end_pos_c,end_offset[2:0]} = stt_offset + cmd_size;
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
  nv_assert_never #(0,0,"CVT:end_offset can not cross 256B boundary, which should be split in IG_SPT")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mon_end_pos_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//assign is_end_addr_64_align = (end_offset[0]==1'b0); //stepheng.
assign end_offset_bit_2_1_NC = end_offset[2:1];

//==============
// AXI: AXID
//==============
// Gen axi_ signals: size/len/axid/addr
assign axi_axid = cmd_axid[3:0];

//==============
// AXI: USER: STREAMID
//==============
//assign axi_streamid = falcon2mcif_streamid; //stepheng.
//==============
// AXI: USER: SIZE
//==============
//assign axi_user_size = cmd_user_size; //stepheng.

//==============
// AXI: SIZE
//==============
// NOTE: if no STOBE is allowed, will need split into single 32B transaction
//assign is_32_trans = 1'b0 & (is_start_addr_32_align || is_end_addr_64_align); //stepheng.

//assign axi_size = is_32_trans ? AXSIZE_32 : AXSIZE_64; //stepheng.
//==============
// AXI: ADDR
//==============
assign axi_addr = cmd_addr;

// CACHE
//assign axi_cache = AWCACHE_LAST; //stepheng

//=========================================================================================
//                          NOTICE 
// each axi cmd need be sent together with the first beat of data in that transaction, 
// and push "ack" into OQ in the same cycle
//=========================================================================================
// beat_count is to count the data per cmd
//==============
// AXI: LEN
//==============
assign {mon_axi_len_c,axi_len[1:0]} = cmd_size[2:1] + cmd_inc;
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
  nv_assert_never #(0,0,"CVT: we can only send 4 burst at most in one AXI trans")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_axi_len_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign is_first_cmd_dat_vld = os_cmd_vld & dat_vld;
//&Always posedge;
//    if (is_first_cmd_dat_vld && all_downs_rdy) begin
//        beat_count <0= axi_len;
//    end else if (beat_count!=0 && axi_dat_rdy) begin
//        beat_count <0= beat_count - 1;
//    end
//&End;
//assign is_first_beat = (beat_count==0);

//assign is_not_first_beat = (beat_count!=0);
//assign is_not_first_beat_vld = dat_vld && is_not_first_beat;

//assign is_single_beat = (axi_len==0);
//assign is_last_beat  = (beat_count==1 || (beat_count==0 && is_single_beat));

// IG_cvt===W Channel : DATA
assign axi_data = dat_data;

// IG_cvt===W Channel : LAST
assign axi_last = is_first_cmd_dat_vld;

assign axi_strb = {{32{dat_mask[1]}},{32{dat_mask[0]}}};

//=====================================
// AXI Output Pipe
//=====================================
//stepheng,remove
// IG_cvt===AXI OUT TIEOFF
//assign mcif2noc_axi_aw_awburst  = AXBURST;
//assign mcif2noc_axi_aw_awlock   = AXLOCK;
////assign mcif2noc_axi_aw_awcache  = AXCACHE;
//assign mcif2noc_axi_aw_awprot   = AXPROT;
//assign mcif2noc_axi_aw_awqos    = AXQOS;
//assign mcif2noc_axi_aw_awregion = AXREGION;

assign os_inp_add_nxt[2:0] = cmd_vld ? (axi_len + 1) : 3'd0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg2ig_axi_vld_d <= 1'b0;
  end else begin
  eg2ig_axi_vld_d <= eg2ig_axi_vld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    eg2ig_axi_len_d <= {2{1'b0}};
  end else begin
  if ((eg2ig_axi_vld) == 1'b1) begin
    eg2ig_axi_len_d <= eg2ig_axi_len;
  // VCS coverage off
  end else if ((eg2ig_axi_vld) == 1'b0) begin
  end else begin
    eg2ig_axi_len_d <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(eg2ig_axi_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign os_inp_sub_nxt[2:0] = eg2ig_axi_vld_d ? (eg2ig_axi_len_d+1) : 3'd0;
assign os_inp_nxt[9:0] = os_cnt + os_inp_add_nxt - os_inp_sub_nxt;

// IG_cvt=== 256 outstanding trans
assign os_cnt_add_en = axi_cmd_vld & axi_cmd_rdy;
assign os_cnt_sub_en = eg2ig_axi_vld_d;
assign os_cnt_cen = os_cnt_add_en | os_cnt_sub_en;
assign os_cnt_add = os_cnt_add_en ? (axi_len + 1) : 3'd0;
assign os_cnt_sub = os_cnt_sub_en ? (eg2ig_axi_len_d+1) : 3'd0;
assign cfg_wr_os_cnt = reg2dp_wr_os_cnt[7:0];
assign wr_os_cnt_ext = {{1{1'b0}}, cfg_wr_os_cnt};
assign os_cnt_full = os_inp_nxt>(wr_os_cnt_ext+1);

// os adv logic

always @(
  os_cnt_add
  or os_cnt_sub
  ) begin
  os_adv = os_cnt_add[2:0] != os_cnt_sub[2:0];
end
    
// os cnt logic
always @(
  os_cnt_cur
  or os_cnt_add
  or os_cnt_sub
  or os_adv
  ) begin
  // VCS sop_coverage_off start
  os_cnt_ext[10:0] = {1'b0, 1'b0, os_cnt_cur};
  os_cnt_mod[10:0] = os_cnt_cur + os_cnt_add[2:0] - os_cnt_sub[2:0]; // spyglass disable W164b
  os_cnt_new[10:0] = (os_adv)? os_cnt_mod[10:0] : os_cnt_ext[10:0];
  os_cnt_nxt[10:0] = os_cnt_new[10:0];
  // VCS sop_coverage_off end
end

// os flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    os_cnt_cur[8:0] <= 0;
  end else begin
  if (os_cnt_cen) begin
  os_cnt_cur[8:0] <= os_cnt_nxt[8:0];
  end
  end
end

// os output logic

always @(
  os_cnt_cur
  ) begin
  os_cnt[8:0] = os_cnt_cur[8:0];
end
    
// os asserts

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
  nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (os_cnt_nxt > 256 && os_cnt_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

  
//IG_cvt=== PIPE for $NOC ADDR Channel
// cmd will be pushed into pipe with the 1st beat of data in that cmd, 
// and when *_beat_vld is high, *_cmd_vld should always be there.
// addr+streamid+user_size
//stepheng.
assign axi_cmd_vld = is_first_cmd_dat_vld & cq_wr_prdy & axi_dat_rdy;
NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p3 pipe_p3 (
   .nvdla_core_clk          (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.axi_cmd_pd              (axi_cmd_pd[69:0])        //|< w
  ,.axi_cmd_vld             (axi_cmd_vld)             //|< w
  ,.mcif2noc_axi_aw_awready (mcif2noc_axi_aw_awready) //|< i
  ,.axi_aw_pd               (axi_aw_pd[69:0])         //|> w
  ,.axi_cmd_rdy             (axi_cmd_rdy)             //|> w
  ,.mcif2noc_axi_aw_awvalid (mcif2noc_axi_aw_awvalid) //|> o
  );

//IG_cvt=== PIPE for $NOC DATA Channel
// first beat of data also need cq and cmd rdy, this is because we also need push ack/cmd into cq fifo and cmd pipe on first beat of data
assign axi_dat_vld = dat_vld & (os_cmd_vld & cq_wr_prdy & axi_cmd_rdy);
NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p4 pipe_p4 (
   .nvdla_core_clk          (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)         //|< i
  ,.axi_dat_pd              (axi_dat_pd[576:0])       //|< w
  ,.axi_dat_vld             (axi_dat_vld)             //|< w
  ,.mcif2noc_axi_w_wready   (mcif2noc_axi_w_wready)   //|< i
  ,.axi_dat_rdy             (axi_dat_rdy)             //|> w
  ,.axi_w_pd                (axi_w_pd[576:0])         //|> w
  ,.mcif2noc_axi_w_wvalid   (mcif2noc_axi_w_wvalid)   //|> o
  );

//stepheng,remove streamid & user_size & cache & size
 assign axi_cmd_pd = {axi_axid,axi_addr,axi_len};

assign {opipe_axi_axid,opipe_axi_addr,opipe_axi_len} = axi_aw_pd;

 assign axi_dat_pd = {axi_data,axi_strb,axi_last};

assign {opipe_axi_data,opipe_axi_strb,opipe_axi_last} = axi_w_pd;


// IG_cvt===AXI OUT ZERO EXT
assign mcif2noc_axi_aw_awid     = {{4{1'b0}}, opipe_axi_axid};
assign mcif2noc_axi_aw_awaddr   = opipe_axi_addr;
assign mcif2noc_axi_aw_awlen    = {{2{1'b0}}, opipe_axi_len}; //stepheng.
//assign mcif2noc_axi_aw_awsize   = opipe_axi_size;
//assign mcif2noc_axi_aw_awcache  = opipe_axi_cache; //stepheng.
assign mcif2noc_axi_w_wlast     = opipe_axi_last;
assign mcif2noc_axi_w_wdata     = opipe_axi_data;
assign mcif2noc_axi_w_wstrb     = opipe_axi_strb;

//stepheng.
////IG_cvt===axi trans variables : semi-static
//&Always;
//    mcif2noc_axi_aw_awuser[SIG_axi4_aw_awuser_DECL] = {SIG_axi4_aw_awuser_WIDTH{BIT_LOW}}; 
//    mcif2noc_axi_aw_awuser[PKT_awnv_user_t_StreamID_FIELD]  = opipe_axi_streamid; 
//    mcif2noc_axi_aw_awuser[PKT_awnv_user_t_user_size_FIELD] = opipe_axi_user_size; 
//    mcif2noc_axi_aw_awuser[PKT_awnv_user_t_vpr_wr_FIELD] = USER_VPR_WR; // vpr_wr 
//    mcif2noc_axi_aw_awuser[PKT_awnv_user_t_wsb_ns_FIELD] = USER_WSB_NS; // wsb_ns
//&End;

//=====================================
// DownStream readiness
//=====================================
assign axi_both_rdy  = axi_cmd_rdy & axi_dat_rdy;
assign all_downs_rdy = cq_wr_prdy & axi_both_rdy;

//=====================================
// Outstanding Queue
//=====================================
// IG_cvt===valid for axi_cmd and oq, inter-lock
assign cq_wr_pvld = is_first_cmd_dat_vld & axi_both_rdy & !os_cnt_full;
assign cq_wr_require_ack = cmd_ltran & cmd_require_ack;
assign cq_wr_len = axi_len;


// PKT_PACK_WIRE( mcif_write_ig2eg ,  cq_wr_ , cq_wr_pd )
assign      cq_wr_pd[0] =     cq_wr_require_ack ;
assign      cq_wr_pd[2:1] =     cq_wr_len[1:0];
assign {mon_thread_id_c[0:0],cq_wr_thread_id[2:0]} = cmd_axid;

//====================================
// OBS
//====================================
//assign obs_bus_mcif_write_ig_cvt_axi_cmd_rdy = axi_cmd_rdy;
//assign obs_bus_mcif_write_ig_cvt_axi_cmd_vld = axi_cmd_vld;
//assign obs_bus_mcif_write_ig_cvt_ig2cq_pvld  = cq_wr_pvld;
//assign obs_bus_mcif_write_ig_cvt_ig2cq_prdy  = cq_wr_prdy;
//assign obs_bus_mcif_write_ig_cvt_ig2cq_require_ack = cq_wr_require_ack;

`ifdef NVDLA_PRINT_AXI
reg [63:0] mon_axi_count;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        mon_axi_count <= 0;
    end else begin
        mon_axi_count <= mon_axi_count + 1'b1;
    end
    
    if (mcif2noc_axi_aw_awvalid & mcif2noc_axi_aw_awready) begin
        $display("NVDLA MCIF WRITE ADDR:time=%0d:cycle=%0d:addr=0x%0h:id=%0d:cache=%0d:size=%0d:len=%0d:usid=%0d:usize=%0d",$stime,mon_axi_count,mcif2noc_axi_aw_awaddr,mcif2noc_axi_aw_awid,mcif2noc_axi_aw_awcache,mcif2noc_axi_aw_awsize,mcif2noc_axi_aw_awlen,mcif2noc_axi_aw_awuser[7:0],mcif2noc_axi_aw_awuser[28:26]);
    end
end

//always @(posedge nvdla_core_clk) begin
//    if (mcif2noc_axi_w_wvalid & mcif2noc_axi_w_wready) begin
//        $display("NVDLA MCIF WRITE DATA:time=%0dns:data=%0h;strb=%0h;last=%0d;", $stime, mcif2noc_axi_w_wdata,mcif2noc_axi_w_wstrb,mcif2noc_axi_w_wlast);
//    end
//end
`endif

endmodule // NV_NVDLA_MCIF_WRITE_IG_cvt



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc cmd_pd (cmd_vld,cmd_rdy) <= spt2cvt_cmd_pd[76:0] (spt2cvt_cmd_valid,spt2cvt_cmd_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cmd_rdy
  ,spt2cvt_cmd_pd
  ,spt2cvt_cmd_valid
  ,cmd_pd
  ,cmd_vld
  ,spt2cvt_cmd_ready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         cmd_rdy;
input  [76:0] spt2cvt_cmd_pd;
input         spt2cvt_cmd_valid;
output [76:0] cmd_pd;
output        cmd_vld;
output        spt2cvt_cmd_ready;
reg    [76:0] cmd_pd;
reg           cmd_vld;
reg    [76:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           spt2cvt_cmd_ready;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? spt2cvt_cmd_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && spt2cvt_cmd_valid)? spt2cvt_cmd_pd[76:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  spt2cvt_cmd_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or cmd_rdy
  or p1_pipe_data
  ) begin
  cmd_vld = p1_pipe_valid;
  p1_pipe_ready = cmd_rdy;
  cmd_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cmd_vld^cmd_rdy^spt2cvt_cmd_valid^spt2cvt_cmd_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (spt2cvt_cmd_valid && !spt2cvt_cmd_ready), (spt2cvt_cmd_valid), (spt2cvt_cmd_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc dat_pd (dat_vld,dat_rdy) <= spt2cvt_dat_pd[513:0] (spt2cvt_dat_valid,spt2cvt_dat_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dat_rdy
  ,spt2cvt_dat_pd
  ,spt2cvt_dat_valid
  ,dat_pd
  ,dat_vld
  ,spt2cvt_dat_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dat_rdy;
input  [513:0] spt2cvt_dat_pd;
input          spt2cvt_dat_valid;
output [513:0] dat_pd;
output         dat_vld;
output         spt2cvt_dat_ready;
reg    [513:0] dat_pd;
reg            dat_vld;
reg    [513:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            spt2cvt_dat_ready;
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? spt2cvt_dat_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && spt2cvt_dat_valid)? spt2cvt_dat_pd[513:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  spt2cvt_dat_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or dat_rdy
  or p2_pipe_data
  ) begin
  dat_vld = p2_pipe_valid;
  p2_pipe_ready = dat_rdy;
  dat_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (dat_vld^dat_rdy^spt2cvt_dat_valid^spt2cvt_dat_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (spt2cvt_dat_valid && !spt2cvt_dat_ready), (spt2cvt_dat_valid), (spt2cvt_dat_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is axi_aw_pd (mcif2noc_axi_aw_awvalid,mcif2noc_axi_aw_awready) <= axi_cmd_pd[69:0] (axi_cmd_vld,axi_cmd_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,axi_cmd_pd
  ,axi_cmd_vld
  ,mcif2noc_axi_aw_awready
  ,axi_aw_pd
  ,axi_cmd_rdy
  ,mcif2noc_axi_aw_awvalid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [69:0] axi_cmd_pd;
input         axi_cmd_vld;
input         mcif2noc_axi_aw_awready;
output [69:0] axi_aw_pd;
output        axi_cmd_rdy;
output        mcif2noc_axi_aw_awvalid;
reg    [69:0] axi_aw_pd;
reg           axi_cmd_rdy;
reg           mcif2noc_axi_aw_awvalid;
reg    [69:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [69:0] p3_skid_data;
reg    [69:0] p3_skid_pipe_data;
reg           p3_skid_pipe_ready;
reg           p3_skid_pipe_valid;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
//## pipe (3) skid buffer
always @(
  axi_cmd_vld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = axi_cmd_vld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    axi_cmd_rdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  axi_cmd_rdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? axi_cmd_pd[69:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or axi_cmd_vld
  or p3_skid_valid
  or axi_cmd_pd
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? axi_cmd_vld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? axi_cmd_pd[69:0] : p3_skid_data;
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
  or mcif2noc_axi_aw_awready
  or p3_pipe_data
  ) begin
  mcif2noc_axi_aw_awvalid = p3_pipe_valid;
  p3_pipe_ready = mcif2noc_axi_aw_awready;
  axi_aw_pd = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2noc_axi_aw_awvalid^mcif2noc_axi_aw_awready^axi_cmd_vld^axi_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (axi_cmd_vld && !axi_cmd_rdy), (axi_cmd_vld), (axi_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is axi_w_pd (mcif2noc_axi_w_wvalid,mcif2noc_axi_w_wready) <= axi_dat_pd[576:0] (axi_dat_vld,axi_dat_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,axi_dat_pd
  ,axi_dat_vld
  ,mcif2noc_axi_w_wready
  ,axi_dat_rdy
  ,axi_w_pd
  ,mcif2noc_axi_w_wvalid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [576:0] axi_dat_pd;
input          axi_dat_vld;
input          mcif2noc_axi_w_wready;
output         axi_dat_rdy;
output [576:0] axi_w_pd;
output         mcif2noc_axi_w_wvalid;
reg            axi_dat_rdy;
reg    [576:0] axi_w_pd;
reg            mcif2noc_axi_w_wvalid;
reg    [576:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [576:0] p4_skid_data;
reg    [576:0] p4_skid_pipe_data;
reg            p4_skid_pipe_ready;
reg            p4_skid_pipe_valid;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
//## pipe (4) skid buffer
always @(
  axi_dat_vld
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = axi_dat_vld && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    axi_dat_rdy <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  axi_dat_rdy <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? axi_dat_pd[576:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or axi_dat_vld
  or p4_skid_valid
  or axi_dat_pd
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? axi_dat_vld : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? axi_dat_pd[576:0] : p4_skid_data;
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
  or mcif2noc_axi_w_wready
  or p4_pipe_data
  ) begin
  mcif2noc_axi_w_wvalid = p4_pipe_valid;
  p4_pipe_ready = mcif2noc_axi_w_wready;
  axi_w_pd = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mcif2noc_axi_w_wvalid^mcif2noc_axi_w_wready^axi_dat_vld^axi_dat_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_12x (nvdla_core_clk, `ASSERT_RESET, (axi_dat_vld && !axi_dat_rdy), (axi_dat_vld), (axi_dat_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_MCIF_WRITE_IG_CVT_pipe_p4


