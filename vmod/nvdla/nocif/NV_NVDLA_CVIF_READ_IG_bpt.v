// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_READ_IG_bpt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_READ_IG_bpt (
   nvdla_core_clk           //|< i
  ,nvdla_core_rstn          //|< i
  ,bpt2arb_req_ready        //|< i
  ,dma2bpt_cdt_lat_fifo_pop //|< i
  ,dma2bpt_req_pd           //|< i
  ,dma2bpt_req_valid        //|< i
  ,tieoff_axid              //|< i
  ,tieoff_lat_fifo_depth    //|< i
  ,bpt2arb_req_pd           //|> o
  ,bpt2arb_req_valid        //|> o
  ,dma2bpt_req_ready        //|> o
  );
//
// NV_NVDLA_CVIF_READ_IG_bpt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         dma2bpt_req_valid;  /* data valid */
output        dma2bpt_req_ready;  /* data return handshake */
input  [78:0] dma2bpt_req_pd;

input  dma2bpt_cdt_lat_fifo_pop;

output        bpt2arb_req_valid;  /* data valid */
input         bpt2arb_req_ready;  /* data return handshake */
output [74:0] bpt2arb_req_pd;

input  [3:0] tieoff_axid;
input  [7:0] tieoff_lat_fifo_depth;
reg   [12:0] count_req;
reg          lat_adv;
reg    [7:0] lat_cnt_cur;
reg    [9:0] lat_cnt_ext;
reg    [9:0] lat_cnt_mod;
reg    [9:0] lat_cnt_new;
reg    [9:0] lat_cnt_nxt;
reg    [7:0] lat_count_cnt;
reg    [0:0] lat_count_dec;
reg   [63:0] out_addr;
reg    [2:0] out_size;
reg   [12:0] req_num;
reg    [2:0] slot_needed;
wire   [1:0] beat_size_NC;
wire         bpt2arb_accept;
wire  [63:0] bpt2arb_addr;
wire   [3:0] bpt2arb_axid;
wire         bpt2arb_ftran;
wire         bpt2arb_ltran;
wire         bpt2arb_odd;
wire   [2:0] bpt2arb_size;
wire         bpt2arb_swizzle;
wire   [2:0] end_offset;
wire   [3:0] ftran_num;
wire   [2:0] ftran_size;
wire  [63:0] in_addr;
wire  [78:0] in_pd;
wire  [78:0] in_pd_p;
wire         in_rdy;
wire         in_rdy_p;
wire  [14:0] in_size;
wire         in_vld;
wire         in_vld_p;
wire  [78:0] in_vld_pd;
wire         is_ftran;
wire         is_ltran;
wire         is_mtran;
wire         is_single_tran;
wire   [2:0] lat_count_inc;
wire   [7:0] lat_fifo_free_slot;
wire         lat_fifo_stall_enable;
wire   [3:0] ltran_num;
wire   [2:0] ltran_size;
wire         mon_end_offset_c;
wire         mon_lat_fifo_free_slot_c;
wire         mon_out_beats_c;
wire  [14:0] mtran_num;
wire         out_inc;
wire         out_odd;
wire         out_swizzle;
wire         req_enable;
wire         req_rdy;
wire         req_vld;
wire   [2:0] size_offset;
wire   [2:0] stt_offset;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_CVIF_READ_IG_BPT_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)      //|< i
  ,.dma2bpt_req_pd    (dma2bpt_req_pd[78:0]) //|< i
  ,.dma2bpt_req_valid (dma2bpt_req_valid)    //|< i
  ,.in_rdy_p          (in_rdy_p)             //|< w
  ,.dma2bpt_req_ready (dma2bpt_req_ready)    //|> o
  ,.in_pd_p           (in_pd_p[78:0])        //|> w
  ,.in_vld_p          (in_vld_p)             //|> w
  );
NV_NVDLA_CVIF_READ_IG_BPT_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)       //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)      //|< i
  ,.in_pd_p           (in_pd_p[78:0])        //|< w
  ,.in_rdy            (in_rdy)               //|< w
  ,.in_vld_p          (in_vld_p)             //|< w
  ,.in_pd             (in_pd[78:0])          //|> w
  ,.in_rdy_p          (in_rdy_p)             //|> w
  ,.in_vld            (in_vld)               //|> w
  );
assign in_rdy = req_rdy & is_ltran;

assign in_vld_pd = {79{in_vld}} & in_pd;

// PKT_UNPACK_WIRE( dma_read_cmd , in_ , in_vld_pd )
assign       in_addr[63:0] =    in_vld_pd[63:0];
assign       in_size[14:0] =    in_vld_pd[78:64];
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
  wire cond_zzz_assert_always_1x = (in_addr[4:0] == 0);
  nv_assert_always #(0,0,"lower 5 LSB should always be 0")      zzz_assert_always_1x (.clk(nvdla_core_clk), .reset_(`ASSERT_RESET), .test_expr(cond_zzz_assert_always_1x)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//assign stt_addr = in_addr;
//assign {mon_end_addr_c,end_addr} = stt_addr + in_size<<5;

assign stt_offset[2:0] = in_addr[7:5];
assign size_offset[2:0] = in_size[2:0];
assign {mon_end_offset_c, end_offset[2:0]} = stt_offset + size_offset;

assign is_single_tran = (stt_offset + in_size) < 8;

assign ftran_size[2:0] = is_single_tran ? size_offset : 3'd7-stt_offset;
assign ftran_num[3:0] = ftran_size + 1;

assign ltran_size[2:0] = is_single_tran ? `tick_x_or_0 : end_offset; // when single tran, size of ltran is meanningless
assign ltran_num[3:0]  = is_single_tran ? 0 : end_offset+1;

assign mtran_num = in_size + 1 - ftran_num - ltran_num;

//================
// check the empty entry of lat.fifo
//================
//dma2bpt_cdt_lat_fifo_pop

always @(
  is_single_tran
  or out_size
  or is_ltran
  or out_swizzle
  or is_ftran
  ) begin
    if (is_single_tran) begin
        slot_needed = (out_size>>1) + 1;
    end else if (is_ltran) begin
        slot_needed = ((out_size+out_swizzle)>>1) + 1; //spyglass disable SelfDeterminedExpr-ML
    end else if (is_ftran) begin
        slot_needed = (out_size+1)>>1;
    end else begin
        slot_needed = 3'd4;
    end
end
assign lat_fifo_stall_enable = (tieoff_lat_fifo_depth!=0);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lat_count_dec <= 1'b0;
  end else begin
  lat_count_dec <= dma2bpt_cdt_lat_fifo_pop;
  end
end
assign lat_count_inc = (bpt2arb_accept && lat_fifo_stall_enable ) ? slot_needed : 0;

//&Vector LAT_FIFO_MAX_BITS lat_count_cnt;
//&Always posedge;
//    if (|lat_count_inc || lat_count_dec) begin
//        lat_count_cnt <0= lat_count_cnt + lat_count_inc - lat_count_dec;
//    end
//&End;

// lat adv logic

always @(
  lat_count_inc
  or lat_count_dec
  ) begin
  lat_adv = lat_count_inc[2:0] != {{2{1'b0}}, lat_count_dec[0:0]};
end
    
// lat cnt logic
always @(
  lat_cnt_cur
  or lat_count_inc
  or lat_count_dec
  or lat_adv
  ) begin
  // VCS sop_coverage_off start
  lat_cnt_ext[9:0] = {1'b0, 1'b0, lat_cnt_cur};
  lat_cnt_mod[9:0] = lat_cnt_cur + lat_count_inc[2:0] - lat_count_dec[0:0]; // spyglass disable W164b
  lat_cnt_new[9:0] = (lat_adv)? lat_cnt_mod[9:0] : lat_cnt_ext[9:0];
  lat_cnt_nxt[9:0] = lat_cnt_new[9:0];
  // VCS sop_coverage_off end
end

// lat flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lat_cnt_cur[7:0] <= 0;
  end else begin
  lat_cnt_cur[7:0] <= lat_cnt_nxt[7:0];
  end
end

// lat output logic

always @(
  lat_cnt_cur
  ) begin
  lat_count_cnt[7:0] = lat_cnt_cur[7:0];
end
    
// lat asserts

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
  nv_assert_never #(0,0,"never: counter underflow below <und_cnt>")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (lat_cnt_nxt < 0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

  
assign {mon_lat_fifo_free_slot_c,lat_fifo_free_slot[7:0]} = tieoff_lat_fifo_depth - lat_count_cnt;
assign req_enable = (!lat_fifo_stall_enable) || ({{5{1'b0}}, slot_needed} <= lat_fifo_free_slot);

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
  nv_assert_never #(0,0,"should not over flow")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_lat_fifo_free_slot_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//================
// bsp out: swizzle
//================
assign out_swizzle = (stt_offset[0]==1'b1);
assign out_odd     = (in_size[0]==1'b0);

//================
// bsp out: size
//================
always @(
  is_ftran
  or ftran_size
  or is_mtran
  or is_ltran
  or ltran_size
  ) begin
    out_size = {3{`tick_x_or_0}};
    if (is_ftran) begin
        out_size = ftran_size;
    end else if (is_mtran) begin
        out_size = 3'd7;
    end else if (is_ltran) begin
        out_size = ltran_size;
    end
end

//================
// bsp out: USER: SIZE
//================
assign out_inc = is_ftran & is_ltran & out_swizzle && !out_odd;
assign {mon_out_beats_c,beat_size_NC[1:0]} = out_size[2:1] + out_inc; //stepheng.
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
  nv_assert_never #(0,0,"should never overflow")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, mon_out_beats_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//assign out_user_size = {1'b0,beat_size_NC};//stepheng.

//================
// bpt2arb: addr
//================
always @(posedge nvdla_core_clk) begin
    if (bpt2arb_accept) begin
        if (is_ftran) begin
            out_addr <= in_addr + ((ftran_size+1)<<5);
        end else begin
            out_addr <= out_addr + (8<<5);
        end
    end
end

//================
// tran count
//================
always @(
  is_single_tran
  or mtran_num
  ) begin
    if (is_single_tran) begin
        req_num = 1;
    end else if (mtran_num==0) begin
        req_num = 2;
    end else begin
        req_num = 2 + mtran_num[14:3];
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_req <= {13{1'b0}};
  end else begin
    if (bpt2arb_accept) begin
        if (is_ltran) begin
            count_req <= 0;
        end else begin
            count_req <= count_req + 1;
        end
    end
  end
end

assign is_ftran = (count_req==0);
assign is_mtran = (count_req>0 && count_req<req_num-1);
assign is_ltran = (count_req==req_num-1);

assign bpt2arb_addr = (is_ftran) ? in_addr : out_addr;
assign bpt2arb_size = out_size;
assign bpt2arb_swizzle = out_swizzle;
assign bpt2arb_odd   = out_odd;
assign bpt2arb_ltran = is_ltran;
assign bpt2arb_ftran = is_ftran;
//assign bpt2arb_user_size = out_user_size; //stepheng.
assign bpt2arb_axid  = tieoff_axid[3:0];
//

assign req_rdy = req_enable & bpt2arb_req_ready;
assign req_vld = req_enable & in_vld; 

assign bpt2arb_req_valid = req_vld;
assign bpt2arb_accept = bpt2arb_req_valid & req_rdy;
//

// PKT_PACK_WIRE( cvt_read_cmd , bpt2arb_ , bpt2arb_req_pd )
assign      bpt2arb_req_pd[3:0] =    bpt2arb_axid[3:0];
assign      bpt2arb_req_pd[67:4] =    bpt2arb_addr[63:0];
assign      bpt2arb_req_pd[70:68] =    bpt2arb_size[2:0];
assign      bpt2arb_req_pd[71] =    bpt2arb_swizzle ;
assign      bpt2arb_req_pd[72] =    bpt2arb_odd ;
assign      bpt2arb_req_pd[73] =    bpt2arb_ltran ;
assign      bpt2arb_req_pd[74] =    bpt2arb_ftran ;


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

    property cvif_bpt__is_first_trans__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((req_vld) && nvdla_core_rstn) |-> (is_ftran);
    endproperty
    // Cover 0 : "is_ftran"
    FUNCPOINT_cvif_bpt__is_first_trans__0_COV : cover property (cvif_bpt__is_first_trans__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cvif_bpt__is_middle_trans__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((req_vld) && nvdla_core_rstn) |-> (is_mtran);
    endproperty
    // Cover 1 : "is_mtran"
    FUNCPOINT_cvif_bpt__is_middle_trans__1_COV : cover property (cvif_bpt__is_middle_trans__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cvif_bpt__is_last_trans__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((req_vld) && nvdla_core_rstn) |-> (is_ltran);
    endproperty
    // Cover 2 : "is_ltran"
    FUNCPOINT_cvif_bpt__is_last_trans__2_COV : cover property (cvif_bpt__is_last_trans__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cvif_bpt__is_swizzle_and_odd__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((req_vld) && nvdla_core_rstn) |-> (out_swizzle & out_odd);
    endproperty
    // Cover 3 : "out_swizzle & out_odd"
    FUNCPOINT_cvif_bpt__is_swizzle_and_odd__3_COV : cover property (cvif_bpt__is_swizzle_and_odd__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cvif_bpt__is_odd_not_swizzle__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((req_vld) && nvdla_core_rstn) |-> (out_odd & !out_swizzle);
    endproperty
    // Cover 4 : "out_odd & !out_swizzle"
    FUNCPOINT_cvif_bpt__is_odd_not_swizzle__4_COV : cover property (cvif_bpt__is_odd_not_swizzle__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cvif_bpt__count_inc_and_dec__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        lat_count_inc & lat_count_dec;
    endproperty
    // Cover 5 : "lat_count_inc & lat_count_dec"
    FUNCPOINT_cvif_bpt__count_inc_and_dec__5_COV : cover property (cvif_bpt__count_inc_and_dec__5_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CVIF_READ_IG_bpt



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os in_pd_p (in_vld_p,in_rdy_p) <= dma2bpt_req_pd[78:0] (dma2bpt_req_valid,dma2bpt_req_ready)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_BPT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma2bpt_req_pd
  ,dma2bpt_req_valid
  ,in_rdy_p
  ,dma2bpt_req_ready
  ,in_pd_p
  ,in_vld_p
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] dma2bpt_req_pd;
input         dma2bpt_req_valid;
input         in_rdy_p;
output        dma2bpt_req_ready;
output [78:0] in_pd_p;
output        in_vld_p;
reg           dma2bpt_req_ready;
reg    [78:0] in_pd_p;
reg           in_vld_p;
reg    [78:0] p1_pipe_data;
reg    [78:0] p1_pipe_rand_data;
reg           p1_pipe_rand_ready;
reg           p1_pipe_rand_valid;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg    [78:0] p1_pipe_skid_data;
reg           p1_pipe_skid_ready;
reg           p1_pipe_skid_valid;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [78:0] p1_skid_data;
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
     dma2bpt_req_valid
  or p1_pipe_rand_ready
  or dma2bpt_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = dma2bpt_req_valid;
  dma2bpt_req_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = dma2bpt_req_pd[78:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : dma2bpt_req_valid;
  dma2bpt_req_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dma2bpt_req_pd[78:0];
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
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or dma2bpt_req_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && dma2bpt_req_valid === 1'b1;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or in_rdy_p
  or p1_pipe_skid_data
  ) begin
  in_vld_p = p1_pipe_skid_valid;
  p1_pipe_skid_ready = in_rdy_p;
  in_pd_p = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (in_vld_p^in_rdy_p^dma2bpt_req_valid^dma2bpt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (dma2bpt_req_valid && !dma2bpt_req_ready), (dma2bpt_req_valid), (dma2bpt_req_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_BPT_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is in_pd (in_vld,in_rdy) <= in_pd_p[78:0] (in_vld_p,in_rdy_p)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_BPT_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,in_pd_p
  ,in_rdy
  ,in_vld_p
  ,in_pd
  ,in_rdy_p
  ,in_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] in_pd_p;
input         in_rdy;
input         in_vld_p;
output [78:0] in_pd;
output        in_rdy_p;
output        in_vld;
reg    [78:0] in_pd;
reg           in_rdy_p;
reg           in_vld;
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
     in_vld_p
  or p2_pipe_rand_ready
  or in_pd_p
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = in_vld_p;
  in_rdy_p = p2_pipe_rand_ready;
  p2_pipe_rand_data = in_pd_p[78:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : in_vld_p;
  in_rdy_p = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : in_pd_p[78:0];
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
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CVIF_READ_IG_bpt_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or in_vld_p
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && in_vld_p === 1'b1;
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
  or in_rdy
  or p2_pipe_data
  ) begin
  in_vld = p2_pipe_valid;
  p2_pipe_ready = in_rdy;
  in_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (in_vld^in_rdy^in_vld_p^in_rdy_p)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (in_vld_p && !in_rdy_p), (in_vld_p), (in_rdy_p)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_BPT_pipe_p2


