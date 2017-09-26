// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_ctrl.v

module NV_NVDLA_CDMA_IMG_ctrl (
   nvdla_core_clk
  ,nvdla_core_ng_clk
  ,nvdla_core_rstn
  ,pack_is_done
  ,reg2dp_conv_mode
  ,reg2dp_data_bank
  ,reg2dp_data_reuse
  ,reg2dp_datain_format
  ,reg2dp_datain_width
  ,reg2dp_in_precision
  ,reg2dp_op_en
  ,reg2dp_pad_left
  ,reg2dp_pad_right
  ,reg2dp_pixel_format
  ,reg2dp_pixel_mapping
  ,reg2dp_pixel_sign_override
  ,reg2dp_pixel_x_offset
  ,reg2dp_proc_precision
  ,reg2dp_skip_data_rls
  ,sc2cdma_dat_pending_req
  ,sg_is_done
  ,status2dma_fsm_switch
  ,img2status_state
  ,is_running
  ,layer_st
  ,pixel_bank
  ,pixel_data_expand
  ,pixel_data_shrink
  ,pixel_early_end
  ,pixel_order
  ,pixel_packed_10b
  ,pixel_planar
  ,pixel_planar0_bundle_limit
  ,pixel_planar0_bundle_limit_1st
  ,pixel_planar0_byte_sft
  ,pixel_planar0_lp_burst
  ,pixel_planar0_lp_vld
  ,pixel_planar0_rp_burst
  ,pixel_planar0_rp_vld
  ,pixel_planar0_sft
  ,pixel_planar0_width_burst
  ,pixel_planar1_bundle_limit
  ,pixel_planar1_bundle_limit_1st
  ,pixel_planar1_byte_sft
  ,pixel_planar1_lp_burst
  ,pixel_planar1_lp_vld
  ,pixel_planar1_rp_burst
  ,pixel_planar1_rp_vld
  ,pixel_planar1_sft
  ,pixel_planar1_width_burst
  ,pixel_precision
  ,pixel_uint
  ,slcg_img_gate_dc
  ,slcg_img_gate_wg
  );


input         nvdla_core_clk;
input         nvdla_core_ng_clk;
input         nvdla_core_rstn;
input         pack_is_done;
input         sc2cdma_dat_pending_req;
input         sg_is_done;
input         status2dma_fsm_switch;
output  [1:0] img2status_state;
output        is_running;
output        layer_st;
output  [3:0] pixel_bank;
output        pixel_data_expand;
output        pixel_data_shrink;
output        pixel_early_end;
output [10:0] pixel_order;
output        pixel_packed_10b;
output        pixel_planar;
output  [3:0] pixel_planar0_bundle_limit;
output  [3:0] pixel_planar0_bundle_limit_1st;
output  [4:0] pixel_planar0_byte_sft;
output  [3:0] pixel_planar0_lp_burst;
output        pixel_planar0_lp_vld;
output  [3:0] pixel_planar0_rp_burst;
output        pixel_planar0_rp_vld;
output  [2:0] pixel_planar0_sft;
output [11:0] pixel_planar0_width_burst;
output  [4:0] pixel_planar1_bundle_limit;
output  [4:0] pixel_planar1_bundle_limit_1st;
output  [4:0] pixel_planar1_byte_sft;
output  [2:0] pixel_planar1_lp_burst;
output        pixel_planar1_lp_vld;
output  [2:0] pixel_planar1_rp_burst;
output        pixel_planar1_rp_vld;
output  [2:0] pixel_planar1_sft;
output [10:0] pixel_planar1_width_burst;
output  [1:0] pixel_precision;
output        pixel_uint;
output        slcg_img_gate_dc;
output        slcg_img_gate_wg;

input [0:0]                     reg2dp_op_en;
input [0:0]                  reg2dp_conv_mode;
input [1:0]               reg2dp_in_precision;
input [1:0]             reg2dp_proc_precision;
input [0:0]         reg2dp_datain_format;
input [5:0]          reg2dp_pixel_format;
input [0:0]         reg2dp_pixel_mapping;
input [0:0]   reg2dp_pixel_sign_override;
input [12:0]          reg2dp_datain_width;
input [0:0]                 reg2dp_data_reuse;
input [0:0]              reg2dp_skip_data_rls;
input [3:0]                      reg2dp_data_bank;
input [4:0]         reg2dp_pixel_x_offset;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;

wire    [4:0] delay_cnt_end;
wire          pending_req_end;
wire    [3:0] pixel_planar0_bundle_limit_1st_w;
wire    [3:0] pixel_planar0_bundle_limit_w;
wire          pixel_planar0_lp_vld_w;
wire          pixel_planar0_rp_vld_w;
wire    [4:0] pixel_planar0_x_offset;
wire    [4:0] pixel_planar1_bundle_limit_1st_w;
wire    [4:0] pixel_planar1_bundle_limit_w;
wire          pixel_planar1_lp_vld_w;
wire          pixel_planar1_rp_vld_w;
wire          pixel_uint_nxt;
wire          planar1_vld_w;
wire          slcg_img_en_w;
wire    [1:0] slcg_img_gate_w;
reg     [2:0] byte_per_pixel;
reg     [1:0] cur_state;
reg     [4:0] delay_cnt;
reg     [4:0] delay_cnt_w;
reg     [1:0] img2status_state;
reg     [1:0] img2status_state_w;
reg           img_done;
reg           img_en;
reg           img_end;
reg           is_dc;
reg           is_done;
reg           is_first_running;
reg           is_idle;
reg           is_input_int8;
reg           is_int8;
reg           is_pending;
reg           is_pixel;
reg           is_running;
reg           is_running_d1;
reg     [3:0] last_data_bank;
reg           last_img;
reg           last_skip_data_rls;
reg           layer_st;
reg           mode_match;
reg           mon_delay_cnt_w;
reg           mon_pixel_element_sft_w;
reg     [2:0] mon_pixel_planar0_burst_need_w;
reg     [4:0] mon_pixel_planar0_byte_sft_w;
reg     [1:0] mon_pixel_planar0_lp_burst_w;
reg     [8:0] mon_pixel_planar0_rp_burst_w;
reg     [2:0] mon_pixel_planar0_width_burst_w;
reg     [3:0] mon_pixel_planar1_burst_need_w;
reg     [4:0] mon_pixel_planar1_byte_sft_w;
reg     [2:0] mon_pixel_planar1_lp_burst_w;
reg     [9:0] mon_pixel_planar1_rp_burst_w;
reg     [5:0] mon_pixel_planar1_tail_width_w;
reg     [1:0] mon_pixel_planar1_total_burst_w;
reg           mon_pixel_planar1_total_width_w;
reg     [3:0] mon_pixel_planar1_width_burst_w;
reg           need_pending;
reg     [1:0] nxt_state;
reg           pending_req;
reg           pending_req_d1;
reg     [3:0] pixel_bank;
reg           pixel_data_expand;
reg           pixel_data_expand_nxt;
reg           pixel_data_shrink;
reg           pixel_data_shrink_nxt;
reg           pixel_early_end;
reg           pixel_early_end_w;
reg     [4:0] pixel_element_sft_w;
reg    [10:0] pixel_order;
reg    [10:0] pixel_order_nxt;
reg           pixel_packed_10b;
reg           pixel_packed_10b_nxt;
reg           pixel_planar;
reg     [3:0] pixel_planar0_bundle_limit;
reg     [3:0] pixel_planar0_bundle_limit_1st;
reg    [11:0] pixel_planar0_burst_need_w;
reg     [4:0] pixel_planar0_byte_sft;
reg     [4:0] pixel_planar0_byte_sft_w;
reg    [13:0] pixel_planar0_fetch_width;
reg     [3:0] pixel_planar0_lp_burst;
reg     [3:0] pixel_planar0_lp_burst_w;
reg     [4:0] pixel_planar0_lp_filled;
reg           pixel_planar0_lp_vld;
reg     [4:0] pixel_planar0_mask_nxt;
reg     [3:0] pixel_planar0_rp_burst;
reg     [3:0] pixel_planar0_rp_burst_w;
reg           pixel_planar0_rp_vld;
reg     [2:0] pixel_planar0_sft;
reg     [2:0] pixel_planar0_sft_nxt;
reg    [11:0] pixel_planar0_width_burst;
reg    [11:0] pixel_planar0_width_burst_w;
reg     [4:0] pixel_planar1_bundle_limit;
reg     [4:0] pixel_planar1_bundle_limit_1st;
reg    [10:0] pixel_planar1_burst_need_w;
reg     [4:0] pixel_planar1_byte_sft;
reg     [4:0] pixel_planar1_byte_sft_w;
reg    [13:0] pixel_planar1_fetch_width;
reg     [2:0] pixel_planar1_lp_burst;
reg     [2:0] pixel_planar1_lp_burst_w;
reg     [4:0] pixel_planar1_lp_filled;
reg           pixel_planar1_lp_vld;
reg     [4:0] pixel_planar1_mask_nxt;
reg     [2:0] pixel_planar1_rp_burst;
reg     [2:0] pixel_planar1_rp_burst_w;
reg           pixel_planar1_rp_vld;
reg     [2:0] pixel_planar1_sft;
reg     [2:0] pixel_planar1_sft_nxt;
reg     [2:0] pixel_planar1_tail_width_w;
reg     [1:0] pixel_planar1_total_burst_w;
reg     [5:0] pixel_planar1_total_width_w;
reg    [10:0] pixel_planar1_width_burst;
reg    [10:0] pixel_planar1_width_burst_w;
reg     [4:0] pixel_planar1_x_offset;
reg           pixel_planar_nxt;
reg     [1:0] pixel_precision;
reg     [1:0] pixel_precision_nxt;
reg    [13:0] pixel_store_width;
reg           pixel_tail_1_w;
reg           pixel_tail_2_w;
reg           pixel_uint;
reg     [1:0] slcg_img_gate_d1;
reg     [1:0] slcg_img_gate_d2;
reg     [1:0] slcg_img_gate_d3;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// CDMA image input data fetching logic FSM                           //
////////////////////////////////////////////////////////////////////////

//## fsm (1) output

//|)

//## fsm (1) defines

localparam IMG_STATE_IDLE = 2'b00;
localparam IMG_STATE_PEND = 2'b01;
localparam IMG_STATE_BUSY = 2'b10;
localparam IMG_STATE_DONE = 2'b11;

//## fsm (1) com block

always @(
  cur_state
  or img_en
  or need_pending
  or reg2dp_data_reuse
  or last_skip_data_rls
  or mode_match
  or pending_req_end
  or img_done
  or status2dma_fsm_switch
  ) begin
  nxt_state = cur_state;
  begin
    casez (cur_state)
      IMG_STATE_IDLE: begin
        if ((img_en & need_pending)) begin
          nxt_state = IMG_STATE_PEND; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((img_en & need_pending)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if ((img_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) begin
          nxt_state = IMG_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((img_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (img_en) begin
          nxt_state = IMG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((img_en) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      IMG_STATE_PEND: begin
        if ((pending_req_end)) begin
          nxt_state = IMG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((pending_req_end)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      IMG_STATE_BUSY: begin
        if (img_done) begin
          nxt_state = IMG_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((img_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      IMG_STATE_DONE: begin
        if (status2dma_fsm_switch) begin
          nxt_state = IMG_STATE_IDLE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((status2dma_fsm_switch) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      // VCS coverage off
      default: begin
        nxt_state = IMG_STATE_IDLE; 
        `ifndef SYNTHESIS
        nxt_state = {2{1'bx}};
        `endif
      end
      // VCS coverage on
    endcase
  end
end

//## fsm (1) seq block

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_state <= IMG_STATE_IDLE;
  end else begin
  cur_state <= nxt_state;
  end
end

//## fsm (1) reachable testpoints


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_IMG_STATE_IDLE
    `define COVER_OR_TP__state_reachable_IMG_STATE_IDLE_OR_COVER
  `endif // TP__state_reachable_IMG_STATE_IDLE

`ifdef COVER_OR_TP__state_reachable_IMG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_IMG_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_nvdla_core_rstn
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_IDLE ::: cur_state==IMG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_IDLE ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_IDLE ::: testpoint_0_goal_0");
 `endif
            if ((cur_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = ((cur_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_IMG_STATE_IDLE_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_IMG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_IMG_STATE_PEND
    `define COVER_OR_TP__state_reachable_IMG_STATE_PEND_OR_COVER
  `endif // TP__state_reachable_IMG_STATE_PEND

`ifdef COVER_OR_TP__state_reachable_IMG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_IMG_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_nvdla_core_rstn
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_PEND ::: cur_state==IMG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_PEND ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_PEND ::: testpoint_1_goal_0");
 `endif
            if ((cur_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = ((cur_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_IMG_STATE_PEND_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_IMG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_IMG_STATE_BUSY
    `define COVER_OR_TP__state_reachable_IMG_STATE_BUSY_OR_COVER
  `endif // TP__state_reachable_IMG_STATE_BUSY

`ifdef COVER_OR_TP__state_reachable_IMG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_IMG_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_nvdla_core_rstn
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_BUSY ::: cur_state==IMG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_BUSY ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_BUSY ::: testpoint_2_goal_0");
 `endif
            if ((cur_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = ((cur_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_IMG_STATE_BUSY_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_IMG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_IMG_STATE_DONE
    `define COVER_OR_TP__state_reachable_IMG_STATE_DONE_OR_COVER
  `endif // TP__state_reachable_IMG_STATE_DONE

`ifdef COVER_OR_TP__state_reachable_IMG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_IMG_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_nvdla_core_rstn
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_DONE ::: cur_state==IMG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_DONE ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: state_reachable_IMG_STATE_DONE ::: testpoint_3_goal_0");
 `endif
            if ((cur_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = ((cur_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_IMG_STATE_DONE_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_IMG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) transition testpoints

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_OR_COVER
  `endif // TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND

`ifdef COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_IDLE__to__IMG_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_4_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_4_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_4_internal_nvdla_core_rstn
    //  Clock signal: testpoint_4_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_4_internal_nvdla_core_clk or negedge testpoint_4_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_4
        if (~testpoint_4_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_4_count_0;

    reg testpoint_4_goal_0;
    initial testpoint_4_goal_0 = 0;
    initial testpoint_4_count_0 = 0;
    always@(testpoint_4_count_0) begin
        if(testpoint_4_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_4_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_PEND ::: (cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_PEND)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_PEND ::: testpoint_4_goal_0
            testpoint_4_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_4_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_4_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
        if (testpoint_4_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_PEND ::: testpoint_4_goal_0");
 `endif
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                testpoint_4_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk) begin
 `endif
                testpoint_4_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_4_goal_0_active = (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_OR_COVER
  `endif // TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE

`ifdef COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_IDLE__to__IMG_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_5_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_5_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_5_internal_nvdla_core_rstn
    //  Clock signal: testpoint_5_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_5_internal_nvdla_core_clk or negedge testpoint_5_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_5
        if (~testpoint_5_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_5_count_0;

    reg testpoint_5_goal_0;
    initial testpoint_5_goal_0 = 0;
    initial testpoint_5_count_0 = 0;
    always@(testpoint_5_count_0) begin
        if(testpoint_5_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_5_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_DONE ::: (cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_DONE ::: testpoint_5_goal_0
            testpoint_5_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_5_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_5_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
        if (testpoint_5_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_DONE ::: testpoint_5_goal_0");
 `endif
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                testpoint_5_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk) begin
 `endif
                testpoint_5_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_5_goal_0_active = (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY
    `define COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_OR_COVER
  `endif // TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY

`ifdef COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_6_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_6_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_6_internal_nvdla_core_rstn
    //  Clock signal: testpoint_6_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_6_internal_nvdla_core_clk or negedge testpoint_6_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_6
        if (~testpoint_6_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_6_count_0;

    reg testpoint_6_goal_0;
    initial testpoint_6_goal_0 = 0;
    initial testpoint_6_count_0 = 0;
    always@(testpoint_6_count_0) begin
        if(testpoint_6_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_6_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY ::: (cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY ::: testpoint_6_goal_0
            testpoint_6_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_6_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_6_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_6
        if (testpoint_6_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY ::: testpoint_6_goal_0");
 `endif
            if (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                testpoint_6_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk) begin
 `endif
                testpoint_6_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_6_goal_0_active = (((cur_state==IMG_STATE_IDLE) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_IDLE__to__IMG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE
    `define COVER_OR_TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_OR_COVER
  `endif // TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE

`ifdef COVER_OR_TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_7_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_7_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_7_internal_nvdla_core_rstn
    //  Clock signal: testpoint_7_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_7_internal_nvdla_core_clk or negedge testpoint_7_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_7
        if (~testpoint_7_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_7_count_0;

    reg testpoint_7_goal_0;
    initial testpoint_7_goal_0 = 0;
    initial testpoint_7_count_0 = 0;
    always@(testpoint_7_count_0) begin
        if(testpoint_7_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_7_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE ::: cur_state==IMG_STATE_IDLE && nxt_state==IMG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE ::: testpoint_7_goal_0
            testpoint_7_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_7_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_7_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_7
        if (testpoint_7_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_IDLE && nxt_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE ::: testpoint_7_goal_0");
 `endif
            if ((cur_state==IMG_STATE_IDLE && nxt_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                testpoint_7_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk) begin
 `endif
                testpoint_7_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_7_goal_0_active = ((cur_state==IMG_STATE_IDLE && nxt_state==IMG_STATE_IDLE) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_IMG_STATE_IDLE__to__IMG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY
    `define COVER_OR_TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_OR_COVER
  `endif // TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY

`ifdef COVER_OR_TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_PEND__to__IMG_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_8_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_8_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_8_internal_nvdla_core_rstn
    //  Clock signal: testpoint_8_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_8_internal_nvdla_core_clk or negedge testpoint_8_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_8
        if (~testpoint_8_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_8_count_0;

    reg testpoint_8_goal_0;
    initial testpoint_8_goal_0 = 0;
    initial testpoint_8_count_0 = 0;
    always@(testpoint_8_count_0) begin
        if(testpoint_8_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_8_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_PEND__to__IMG_STATE_BUSY ::: (cur_state==IMG_STATE_PEND) && (nxt_state == IMG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_PEND__to__IMG_STATE_BUSY ::: testpoint_8_goal_0
            testpoint_8_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_8_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_8_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_8
        if (testpoint_8_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_PEND) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_PEND__to__IMG_STATE_BUSY ::: testpoint_8_goal_0");
 `endif
            if (((cur_state==IMG_STATE_PEND) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                testpoint_8_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk) begin
 `endif
                testpoint_8_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_8_goal_0_active = (((cur_state==IMG_STATE_PEND) && (nxt_state == IMG_STATE_BUSY)) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_PEND__to__IMG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND
    `define COVER_OR_TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_OR_COVER
  `endif // TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND

`ifdef COVER_OR_TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_9_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_9_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_9_internal_nvdla_core_rstn
    //  Clock signal: testpoint_9_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_9_internal_nvdla_core_clk or negedge testpoint_9_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_9
        if (~testpoint_9_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_9_count_0;

    reg testpoint_9_goal_0;
    initial testpoint_9_goal_0 = 0;
    initial testpoint_9_count_0 = 0;
    always@(testpoint_9_count_0) begin
        if(testpoint_9_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_9_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND ::: cur_state==IMG_STATE_PEND && nxt_state==IMG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND ::: testpoint_9_goal_0
            testpoint_9_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_9_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_9_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_9
        if (testpoint_9_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_PEND && nxt_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND ::: testpoint_9_goal_0");
 `endif
            if ((cur_state==IMG_STATE_PEND && nxt_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                testpoint_9_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk) begin
 `endif
                testpoint_9_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_9_goal_0_active = ((cur_state==IMG_STATE_PEND && nxt_state==IMG_STATE_PEND) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_IMG_STATE_PEND__to__IMG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE
    `define COVER_OR_TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_OR_COVER
  `endif // TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE

`ifdef COVER_OR_TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_BUSY__to__IMG_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_10_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_10_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_10_internal_nvdla_core_rstn
    //  Clock signal: testpoint_10_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_10_internal_nvdla_core_clk or negedge testpoint_10_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_10
        if (~testpoint_10_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_10_count_0;

    reg testpoint_10_goal_0;
    initial testpoint_10_goal_0 = 0;
    initial testpoint_10_count_0 = 0;
    always@(testpoint_10_count_0) begin
        if(testpoint_10_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_10_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_BUSY__to__IMG_STATE_DONE ::: (cur_state==IMG_STATE_BUSY) && (nxt_state == IMG_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_BUSY__to__IMG_STATE_DONE ::: testpoint_10_goal_0
            testpoint_10_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_10_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_10_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_10
        if (testpoint_10_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_BUSY) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_BUSY__to__IMG_STATE_DONE ::: testpoint_10_goal_0");
 `endif
            if (((cur_state==IMG_STATE_BUSY) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                testpoint_10_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk) begin
 `endif
                testpoint_10_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_10_goal_0_active = (((cur_state==IMG_STATE_BUSY) && (nxt_state == IMG_STATE_DONE)) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_BUSY__to__IMG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY
    `define COVER_OR_TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_OR_COVER
  `endif // TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY

`ifdef COVER_OR_TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_11_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_11_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_11_internal_nvdla_core_rstn
    //  Clock signal: testpoint_11_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_11_internal_nvdla_core_clk or negedge testpoint_11_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_11
        if (~testpoint_11_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_11_count_0;

    reg testpoint_11_goal_0;
    initial testpoint_11_goal_0 = 0;
    initial testpoint_11_count_0 = 0;
    always@(testpoint_11_count_0) begin
        if(testpoint_11_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_11_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY ::: cur_state==IMG_STATE_BUSY && nxt_state==IMG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY ::: testpoint_11_goal_0
            testpoint_11_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_11_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_11_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_11
        if (testpoint_11_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_BUSY && nxt_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY ::: testpoint_11_goal_0");
 `endif
            if ((cur_state==IMG_STATE_BUSY && nxt_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                testpoint_11_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk) begin
 `endif
                testpoint_11_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_11_goal_0_active = ((cur_state==IMG_STATE_BUSY && nxt_state==IMG_STATE_BUSY) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_IMG_STATE_BUSY__to__IMG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE
    `define COVER_OR_TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_OR_COVER
  `endif // TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE

`ifdef COVER_OR_TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_IMG_STATE_DONE__to__IMG_STATE_IDLE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_12_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_12_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_12_internal_nvdla_core_rstn
    //  Clock signal: testpoint_12_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_12_internal_nvdla_core_clk or negedge testpoint_12_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_12
        if (~testpoint_12_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_12_count_0;

    reg testpoint_12_goal_0;
    initial testpoint_12_goal_0 = 0;
    initial testpoint_12_count_0 = 0;
    always@(testpoint_12_count_0) begin
        if(testpoint_12_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_12_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_DONE__to__IMG_STATE_IDLE ::: (cur_state==IMG_STATE_DONE) && (nxt_state == IMG_STATE_IDLE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_DONE__to__IMG_STATE_IDLE ::: testpoint_12_goal_0
            testpoint_12_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_12_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_12_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_12
        if (testpoint_12_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((cur_state==IMG_STATE_DONE) && (nxt_state == IMG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: transition_IMG_STATE_DONE__to__IMG_STATE_IDLE ::: testpoint_12_goal_0");
 `endif
            if (((cur_state==IMG_STATE_DONE) && (nxt_state == IMG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                testpoint_12_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk) begin
 `endif
                testpoint_12_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_12_goal_0_active = (((cur_state==IMG_STATE_DONE) && (nxt_state == IMG_STATE_IDLE)) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_IMG_STATE_DONE__to__IMG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE
    `define COVER_OR_TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_OR_COVER
  `endif // TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE

`ifdef COVER_OR_TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_13_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_13_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_13_internal_nvdla_core_rstn
    //  Clock signal: testpoint_13_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_13_internal_nvdla_core_clk or negedge testpoint_13_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_13
        if (~testpoint_13_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_13_count_0;

    reg testpoint_13_goal_0;
    initial testpoint_13_goal_0 = 0;
    initial testpoint_13_count_0 = 0;
    always@(testpoint_13_count_0) begin
        if(testpoint_13_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_13_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE ::: cur_state==IMG_STATE_DONE && nxt_state==IMG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE ::: testpoint_13_goal_0
            testpoint_13_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_13_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_13_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_13
        if (testpoint_13_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((cur_state==IMG_STATE_DONE && nxt_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_IMG_ctrl ::: self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE ::: testpoint_13_goal_0");
 `endif
            if ((cur_state==IMG_STATE_DONE && nxt_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk)
                testpoint_13_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk) begin
 `endif
                testpoint_13_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_13_goal_0_active = ((cur_state==IMG_STATE_DONE && nxt_state==IMG_STATE_DONE) && testpoint_got_reset_testpoint_13_internal_nvdla_core_rstn_with_clock_testpoint_13_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_0 (.clk (testpoint_13_internal_nvdla_core_clk), .tp(testpoint_13_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_IMG_STATE_DONE__to__IMG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) assertions

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
  nv_assert_no_x #(0,2,0,"No Xs allowed on cur_state")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1, cur_state); // spyglass disable W504 SelfDeterminedExpr-ML 
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


////////////////////////////////////////////////////////////////////////
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////


always @(
  img_en
  or is_idle
  ) begin
    layer_st = img_en & is_idle;
end

//&Always;
//    layer_end = status2dma_fsm_switch;
//&End;

always @(
  cur_state
  ) begin
    is_idle = (cur_state == IMG_STATE_IDLE);
end

always @(
  cur_state
  ) begin
    is_pending = (cur_state == IMG_STATE_PEND);
end

always @(
  cur_state
  ) begin
    is_running = (cur_state == IMG_STATE_BUSY);
end

always @(
  cur_state
  ) begin
    is_done = (cur_state == IMG_STATE_DONE);
end

always @(
  nxt_state
  ) begin
    img2status_state_w = (nxt_state == IMG_STATE_PEND) ? 1  : 
                         (nxt_state == IMG_STATE_BUSY) ? 2  : 
                         (nxt_state == IMG_STATE_DONE) ? 3  :
                         0 ;
end

always @(
  is_running
  or is_running_d1
  ) begin
    is_first_running = is_running & ~is_running_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    img2status_state <= 0;
  end else begin
  img2status_state <= img2status_state_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_running_d1 <= 1'b0;
  end else begin
  is_running_d1 <= is_running;
  end
end

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
assign pending_req_end = pending_req_d1 & ~pending_req;

//================  Non-SLCG clock domain ================//
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_img <= 1'b0;
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_img <= img_en;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_img <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_data_bank <= {4{1'b1}};
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_data_bank <= reg2dp_data_bank;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_data_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_skip_data_rls <= 1'b0;
  end else begin
  if ((reg2dp_op_en & is_idle) == 1'b1) begin
    last_skip_data_rls <= img_en & reg2dp_skip_data_rls;
  // VCS coverage off
  end else if ((reg2dp_op_en & is_idle) == 1'b0) begin
  end else begin
    last_skip_data_rls <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pending_req <= 1'b0;
  end else begin
  pending_req <= sc2cdma_dat_pending_req;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pending_req_d1 <= 1'b0;
  end else begin
  pending_req_d1 <= pending_req;
  end
end

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_img_en_w = img_en & (is_running | is_pending | is_done);
assign slcg_img_gate_w = {2{~slcg_img_en_w}};

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_img_gate_d1 <= {2{1'b1}};
  end else begin
  slcg_img_gate_d1 <= slcg_img_gate_w;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_img_gate_d2 <= {2{1'b1}};
  end else begin
  slcg_img_gate_d2 <= slcg_img_gate_d1;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_img_gate_d3 <= {2{1'b1}};
  end else begin
  slcg_img_gate_d3 <= slcg_img_gate_d2;
  end
end

assign slcg_img_gate_dc = slcg_img_gate_d3[0];
assign slcg_img_gate_wg = slcg_img_gate_d3[1];

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////

always @(
  is_running
  or is_first_running
  or sg_is_done
  or pack_is_done
  ) begin
    img_end = is_running & ~is_first_running & sg_is_done & pack_is_done;
end

always @(
  img_end
  or delay_cnt
  or delay_cnt_end
  ) begin
    img_done = img_end & (delay_cnt == delay_cnt_end);
end

assign delay_cnt_end = (3   + 3   + 3 ) ;

always @(
  is_running
  or img_end
  or delay_cnt
  ) begin
    {mon_delay_cnt_w,
     delay_cnt_w} = ~is_running ? 6'b0 :
                    img_end ? delay_cnt + 1'b1 :
                    {1'b0, delay_cnt};
end

always @(
  last_data_bank
  or reg2dp_data_bank
  ) begin
    need_pending = (last_data_bank != reg2dp_data_bank);
end

always @(
  img_en
  or last_img
  ) begin
    mode_match = img_en & last_img;
end

always @(
  reg2dp_conv_mode
  ) begin
    is_dc = (reg2dp_conv_mode == 1'h0 );
end

always @(
  reg2dp_datain_format
  ) begin
    is_pixel = (reg2dp_datain_format == 1'h1 );
end

always @(
  reg2dp_op_en
  or is_dc
  or is_pixel
  ) begin
    img_en = reg2dp_op_en & is_dc & is_pixel;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    delay_cnt <= {5{1'b0}};
  end else begin
  if ((img_end | is_done) == 1'b1) begin
    delay_cnt <= delay_cnt_w;
  // VCS coverage off
  end else if ((img_end | is_done) == 1'b0) begin
  end else begin
    delay_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(img_end | is_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error config! PIXEL for non-DC")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~is_dc & is_pixel)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error config! Invalid image type")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & img_en & (reg2dp_pixel_format > 6'h23 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  pixel format parser                                               //
////////////////////////////////////////////////////////////////////////

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
  nv_assert_never #(0,0,"Error Config! Pixel format is not pitch linear!")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (reg2dp_pixel_mapping != 1'h0 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(
  reg2dp_pixel_format
  ) begin
    //planar number - 1
    pixel_planar_nxt = 1'h0;
    //2'h0: unit8; 2'h1: unit16; 2'h2: int16; 2'h3: fp16;
    pixel_precision_nxt = 2'h0;
    //10'h1     ABGR, VU, single, unchange
    //10'h2     ARGB, AYUV, 8bpp
    //10'h4     ARGB, AYUV, 16bpp
    //10'h8     BGRA, VUYA, 8bpp
    //10'h10    BGRA, VUYA, 16bpp
    //10'h20    RGBA, YUVA, 8bpp
    //10'h40    ARGB, AYUV, packed_10b
    //10'h80    BGRA, YUVA, packed_10b
    //10'h100   RGBA, packed_10b
    //10'h200   UV, 8bpp
    //10'h400   UV, 16bpp
    pixel_order_nxt = 11'h1;
    //for packed 10bit case
    pixel_packed_10b_nxt = 1'b0;
    //pixel is uint
    //pixel_uint_nxt = 1'b1;
    //pixel request calcualtion registers
    pixel_planar0_sft_nxt = 3'h3;
    pixel_planar1_sft_nxt = 3'h5;
    pixel_planar0_mask_nxt = 5'h7;
    pixel_planar1_mask_nxt = 5'h1f;
    case(reg2dp_pixel_format)
        6'h0 :
        begin
            pixel_planar0_sft_nxt = 3'h5;
            pixel_planar0_mask_nxt = 5'h1f;
        end
        6'h1 ,
        6'h2 ,
        6'h3 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_planar0_sft_nxt = 3'h4;
            pixel_planar0_mask_nxt = 5'hf;
        end
        6'h4 :
        begin
            pixel_precision_nxt = 2'h2;
            pixel_planar0_sft_nxt = 3'h4;
            pixel_planar0_mask_nxt = 5'hf;
        end
        6'h5 :
        begin
            pixel_precision_nxt = 2'h3;
            pixel_planar0_sft_nxt = 3'h4;
            pixel_planar0_mask_nxt = 5'hf;
        end
        6'h6 ,
        6'h7 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_planar0_sft_nxt = 3'h2;
            pixel_planar0_mask_nxt = 5'h3;
        end
        6'h8 :
        begin
            pixel_precision_nxt = 2'h3;
            pixel_planar0_sft_nxt = 3'h2;
            pixel_planar0_mask_nxt = 5'h3;
        end
        6'h9 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h4;
            pixel_planar0_sft_nxt = 3'h2;
            pixel_planar0_mask_nxt = 5'h3;
        end
        6'ha :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h10;
            pixel_planar0_sft_nxt = 3'h2;
            pixel_planar0_mask_nxt = 5'h3;
        end
        6'hb :
        begin
            pixel_precision_nxt = 2'h3;
            pixel_order_nxt = 11'h4;
            pixel_planar0_sft_nxt = 3'h2;
            pixel_planar0_mask_nxt = 5'h3;
        end
        6'hc ,
        6'h10 :
        begin
            pixel_order_nxt = 11'h1;
        end
        6'hd ,
        6'h11 ,
        6'h1a :
        begin
            pixel_order_nxt = 11'h2;
        end
        6'he ,
        6'h12 ,
        6'h1b :
        begin
            pixel_order_nxt = 11'h8;
        end
        6'hf ,
        6'h13 :
        begin
            pixel_order_nxt = 11'h20;
        end
        6'h14 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_packed_10b_nxt = 1'b1;
        end
        6'h15 ,
        6'h18 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h40;
            pixel_packed_10b_nxt = 1'b1;
        end
        6'h16 ,
        6'h19 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h80;
            pixel_packed_10b_nxt = 1'b1;
        end
        6'h17 :
        begin
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h100;
            pixel_packed_10b_nxt = 1'b1;
        end
        6'h1c :
        begin
            pixel_planar_nxt = 1'h1;
            pixel_order_nxt = 11'h200;
            pixel_planar0_sft_nxt = 3'h5;
            pixel_planar1_sft_nxt = 3'h4;
            pixel_planar0_mask_nxt = 5'h1f;
            pixel_planar1_mask_nxt = 5'hf;
        end
        6'h1d :
        begin
            pixel_planar_nxt = 1'h1;
            pixel_planar0_sft_nxt = 3'h5;
            pixel_planar1_sft_nxt = 3'h4;
            pixel_planar0_mask_nxt = 5'h1f;
            pixel_planar1_mask_nxt = 5'hf;
        end
        6'h1e ,
        6'h20 ,
        6'h22 :
        begin
            pixel_planar_nxt = 1'h1;
            pixel_precision_nxt = 2'h1;
            pixel_order_nxt = 11'h400;
            pixel_planar0_sft_nxt = 3'h4;
            pixel_planar1_sft_nxt = 3'h3;
            pixel_planar0_mask_nxt = 5'hf;
            pixel_planar1_mask_nxt = 5'h7;
        end
        6'h1f ,
        6'h21 ,
        6'h23 :
        begin
            pixel_planar_nxt = 1'h1;
            pixel_precision_nxt = 2'h1;
            pixel_planar0_sft_nxt = 3'h4;
            pixel_planar1_sft_nxt = 3'h3;
            pixel_planar0_mask_nxt = 5'hf;
            pixel_planar1_mask_nxt = 5'h7;
        end
    endcase
end

always @(
  reg2dp_proc_precision
  ) begin
    is_int8 = (reg2dp_proc_precision == 2'h0 );
end

always @(
  reg2dp_in_precision
  ) begin
    is_input_int8 = (reg2dp_in_precision == 2'h0 );
end

always @(
  is_int8
  or is_input_int8
  ) begin
    pixel_data_expand_nxt = ~is_int8 & is_input_int8;
end

always @(
  is_int8
  or is_input_int8
  ) begin
    pixel_data_shrink_nxt = is_int8 & ~is_input_int8;
end

//////// pixel_lp_burst, pixel_width_burst, pixel_rp_burst ////////

assign pixel_planar0_x_offset = reg2dp_pixel_x_offset;
assign pixel_uint_nxt = (reg2dp_pixel_sign_override == 1'h0 );

always @(
  reg2dp_pixel_x_offset
  or pixel_planar1_mask_nxt
  ) begin
    pixel_planar1_x_offset = (reg2dp_pixel_x_offset & pixel_planar1_mask_nxt);
end

always @(
  reg2dp_pad_left
  or pixel_planar0_mask_nxt
  ) begin
    pixel_planar0_lp_filled = reg2dp_pad_left & pixel_planar0_mask_nxt;
end

always @(
  reg2dp_pad_left
  or pixel_planar1_mask_nxt
  ) begin
    pixel_planar1_lp_filled = reg2dp_pad_left & pixel_planar1_mask_nxt;
end

always @(
  pixel_planar0_x_offset
  or pixel_planar0_lp_filled
  or reg2dp_pad_left
  or pixel_planar0_sft_nxt
  ) begin
    {mon_pixel_planar0_lp_burst_w[1:0],
     pixel_planar0_lp_burst_w} = (pixel_planar0_x_offset >= pixel_planar0_lp_filled) ? (reg2dp_pad_left >> pixel_planar0_sft_nxt) :
                                 (reg2dp_pad_left >> pixel_planar0_sft_nxt) + 1'b1;
end

always @(
  pixel_planar1_x_offset
  or pixel_planar1_lp_filled
  or reg2dp_pad_left
  or pixel_planar1_sft_nxt
  ) begin
    {mon_pixel_planar1_lp_burst_w[2:0],
     pixel_planar1_lp_burst_w} = (pixel_planar1_x_offset >= pixel_planar1_lp_filled) ? (reg2dp_pad_left >> pixel_planar1_sft_nxt) :
                                 (reg2dp_pad_left >> pixel_planar1_sft_nxt) + 1'b1;
end

always @(
  reg2dp_datain_width
  or pixel_planar0_x_offset
  or pixel_planar1_x_offset
  ) begin
    pixel_planar0_fetch_width = reg2dp_datain_width + pixel_planar0_x_offset;
    pixel_planar1_fetch_width = reg2dp_datain_width + pixel_planar1_x_offset;
end

always @(
  pixel_planar0_fetch_width
  or pixel_planar0_sft_nxt
  ) begin
    {mon_pixel_planar0_width_burst_w[2:0],
     pixel_planar0_width_burst_w} = (pixel_planar0_fetch_width >> pixel_planar0_sft_nxt) + 1'b1;
end

always @(
  pixel_planar1_fetch_width
  or pixel_planar1_sft_nxt
  ) begin
    {mon_pixel_planar1_width_burst_w[3:0],
     pixel_planar1_width_burst_w} = (pixel_planar1_fetch_width >> pixel_planar1_sft_nxt) + 1'b1;
end

always @(
  reg2dp_pad_left
  or reg2dp_datain_width
  or reg2dp_pad_right
  ) begin
    pixel_store_width = reg2dp_pad_left + reg2dp_datain_width + reg2dp_pad_right;
end

always @(
  pixel_store_width
  or pixel_planar0_sft_nxt
  ) begin
    {mon_pixel_planar0_burst_need_w[2:0],
     pixel_planar0_burst_need_w} = (pixel_store_width >> pixel_planar0_sft_nxt) + 2'h2;
end

always @(
  pixel_store_width
  or pixel_planar1_sft_nxt
  ) begin
    {mon_pixel_planar1_burst_need_w[3:0],
     pixel_planar1_burst_need_w} = (pixel_store_width >> pixel_planar1_sft_nxt) + 2'h2;
end

always @(
  pixel_planar0_burst_need_w
  or pixel_planar0_lp_burst_w
  or pixel_planar0_width_burst_w
  ) begin
    {mon_pixel_planar0_rp_burst_w[8:0],
     pixel_planar0_rp_burst_w} = pixel_planar0_burst_need_w - pixel_planar0_lp_burst_w - pixel_planar0_width_burst_w;
end

always @(
  pixel_planar1_burst_need_w
  or pixel_planar1_lp_burst_w
  or pixel_planar1_width_burst_w
  ) begin
    {mon_pixel_planar1_rp_burst_w[9:0],
     pixel_planar1_rp_burst_w} = pixel_planar1_burst_need_w - pixel_planar1_lp_burst_w - pixel_planar1_width_burst_w;
end

always @(
  reg2dp_pad_left
  or reg2dp_datain_width
  or reg2dp_pad_right
  ) begin
    {mon_pixel_planar1_total_width_w,
     pixel_planar1_total_width_w} = reg2dp_pad_left + reg2dp_datain_width[5:0] + reg2dp_pad_right + 1;
end

always @(
  pixel_precision_nxt
  ) begin
    byte_per_pixel = ~(|pixel_precision_nxt) ? 3'h3 : 3'h6;
end

always @(
  pixel_planar1_total_width_w
  or byte_per_pixel
  ) begin
    {pixel_planar1_tail_width_w,
     mon_pixel_planar1_tail_width_w} = pixel_planar1_total_width_w * byte_per_pixel + 6'h3f;
end

//&Always;
//    pixel_tail_0_w = (pixel_planar1_tail_width_w == 3'h0) | (pixel_planar1_tail_width_w == 3'h3) | (pixel_planar1_tail_width_w == 3'h6);
//&End;
always @(
  pixel_planar1_lp_burst_w
  or pixel_planar1_rp_burst_w
  or pixel_planar1_width_burst_w
  ) begin
    {mon_pixel_planar1_total_burst_w[1:0],
     pixel_planar1_total_burst_w[1:0]} = pixel_planar1_lp_burst_w[1:0] + pixel_planar1_rp_burst_w[1:0] + pixel_planar1_width_burst_w[1:0];
end

always @(
  pixel_planar1_tail_width_w
  ) begin
    pixel_tail_1_w = (pixel_planar1_tail_width_w == 3'h1) | (pixel_planar1_tail_width_w == 3'h4);
end

always @(
  pixel_planar1_tail_width_w
  ) begin
    pixel_tail_2_w = (pixel_planar1_tail_width_w == 3'h2) | (pixel_planar1_tail_width_w == 3'h5);
end

always @(
  pixel_planar_nxt
  or pixel_tail_1_w
  or pixel_tail_2_w
  or pixel_planar1_total_burst_w
  ) begin
    pixel_early_end_w = pixel_planar_nxt & (pixel_tail_1_w | (pixel_tail_2_w & ~pixel_planar1_total_burst_w[1]));
end

always @(
  reg2dp_pixel_x_offset
  or reg2dp_pad_left
  ) begin
    {mon_pixel_element_sft_w,
     pixel_element_sft_w} = (reg2dp_pixel_x_offset - reg2dp_pad_left);
end

always @(
  pixel_element_sft_w
  or pixel_planar0_sft_nxt
  ) begin
    {mon_pixel_planar0_byte_sft_w[4:0],
     pixel_planar0_byte_sft_w} = {pixel_element_sft_w, 5'b0} >> pixel_planar0_sft_nxt;
end

always @(
  pixel_element_sft_w
  or pixel_planar1_sft_nxt
  ) begin
    {mon_pixel_planar1_byte_sft_w[4:0],
     pixel_planar1_byte_sft_w} = {pixel_element_sft_w, 5'b0} >> pixel_planar1_sft_nxt;
end

assign pixel_planar0_bundle_limit_w = 4'h8;
assign pixel_planar0_bundle_limit_1st_w = 4'h9;
assign pixel_planar1_bundle_limit_w = 5'h10;
assign pixel_planar1_bundle_limit_1st_w = 5'h11;

assign planar1_vld_w = pixel_planar_nxt;
assign pixel_planar0_lp_vld_w = (|pixel_planar0_lp_burst_w);
assign pixel_planar1_lp_vld_w = (|pixel_planar1_lp_burst_w);
assign pixel_planar0_rp_vld_w = (|pixel_planar0_rp_burst_w);
assign pixel_planar1_rp_vld_w = (|pixel_planar1_rp_burst_w);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_planar <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar <= pixel_planar_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_precision <= {2{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_precision <= pixel_precision_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_precision <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_order <= {11{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_order <= pixel_order_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_order <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_packed_10b <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_packed_10b <= pixel_packed_10b_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_packed_10b <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_data_expand <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_data_expand <= pixel_data_expand_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_data_expand <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_data_shrink <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_data_shrink <= pixel_data_shrink_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_data_shrink <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_uint <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_uint <= pixel_uint_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_uint <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_sft <= {3{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_sft <= pixel_planar0_sft_nxt;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_sft <= {3{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_sft <= pixel_planar1_sft_nxt;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_lp_burst <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_lp_burst <= pixel_planar0_lp_burst_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_lp_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_lp_burst <= {3{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_lp_burst <= pixel_planar1_lp_burst_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_lp_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_lp_vld <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_lp_vld <= pixel_planar0_lp_vld_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_lp_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_lp_vld <= 1'b0;
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_lp_vld <= pixel_planar1_lp_vld_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_lp_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_width_burst <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_width_burst <= pixel_planar0_width_burst_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_width_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_width_burst <= {11{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_width_burst <= pixel_planar1_width_burst_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_width_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_rp_burst <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_rp_burst <= pixel_planar0_rp_burst_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_rp_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_rp_burst <= {3{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_rp_burst <= pixel_planar1_rp_burst_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_rp_burst <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_rp_vld <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_rp_vld <= pixel_planar0_rp_vld_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_rp_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_rp_vld <= 1'b0;
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_rp_vld <= pixel_planar1_rp_vld_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_rp_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_early_end <= 1'b0;
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_early_end <= pixel_early_end_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_early_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_byte_sft <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_byte_sft <= pixel_planar0_byte_sft_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_byte_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_byte_sft <= {5{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_byte_sft <= pixel_planar1_byte_sft_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_byte_sft <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_bank <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_bank <= reg2dp_data_bank + 1'b1;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_bundle_limit <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_bundle_limit <= pixel_planar0_bundle_limit_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_bundle_limit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_bundle_limit <= {5{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_bundle_limit <= pixel_planar1_bundle_limit_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_bundle_limit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar0_bundle_limit_1st <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_planar0_bundle_limit_1st <= pixel_planar0_bundle_limit_1st_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_planar0_bundle_limit_1st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pixel_planar1_bundle_limit_1st <= {5{1'b0}};
  end else begin
  if ((layer_st & planar1_vld_w) == 1'b1) begin
    pixel_planar1_bundle_limit_1st <= pixel_planar1_bundle_limit_1st_w;
  // VCS coverage off
  end else if ((layer_st & planar1_vld_w) == 1'b0) begin
  end else begin
    pixel_planar1_bundle_limit_1st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error Config! Pixel X offset is out of range!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|(reg2dp_pixel_x_offset & ~pixel_planar0_mask_nxt)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error Config! Unmatch input int8 precision")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (img_en & ((pixel_precision_nxt == 2'h0) ^ (reg2dp_in_precision == 2'h0 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error Config! Unmatch input int16 precision")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (img_en & (((pixel_precision_nxt == 2'h1) | (pixel_precision_nxt == 2'h2)) ^ (reg2dp_in_precision == 2'h1 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error Config! Unmatch input fp16 precision")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (img_en & ((pixel_precision_nxt == 2'h3) ^ (reg2dp_in_precision == 2'h2 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar0_lp_burst_w is overflow!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_lp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_lp_burst_w is overflow!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_lp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar0_burst_need_w is overflow!")      zzz_assert_never_42x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_burst_need_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_burst_need_w is overflow!")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_burst_need_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar0_rp_burst_w is overflow!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_rp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_rp_burst_w is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_rp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar0_lp_burst_w is out of range!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar0_lp_burst_w > 4'h8))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_lp_burst_w is out of range!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar1_lp_burst_w > 3'h4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar0_rp_burst_w is out of range!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar0_rp_burst_w > 4'h9))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_rp_burst_w is out of range!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar1_rp_burst_w > 3'h5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pixel_planar1_tail_width_w is out of range!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar1_tail_width_w == 3'h7))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// assign obs_bus_cdma_img_cur_state = cur_state;
// assign obs_bus_cdma_img_nxt_state = nxt_state;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////

//                           img2status_state
//                           {pixel_early_end,pixel_planar}
//                           pixel_planar0_byte_sft[1:0]
//                           {pixel_planar0_lp_vld,pixel_planar1_lp_vld};

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

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

    property cdma_img_ctrl__img_reuse__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cur_state == IMG_STATE_IDLE) & (nxt_state == IMG_STATE_DONE));
    endproperty
    // Cover 0 : "((cur_state == IMG_STATE_IDLE) & (nxt_state == IMG_STATE_DONE))"
    FUNCPOINT_cdma_img_ctrl__img_reuse__0_COV : cover property (cdma_img_ctrl__img_reuse__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_img_ctrl__img_yuv_tail_0__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (layer_st & pixel_planar_nxt & ~pixel_tail_1_w & ~pixel_tail_2_w);
    endproperty
    // Cover 1 : "(layer_st & pixel_planar_nxt & ~pixel_tail_1_w & ~pixel_tail_2_w)"
    FUNCPOINT_cdma_img_ctrl__img_yuv_tail_0__1_COV : cover property (cdma_img_ctrl__img_yuv_tail_0__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_img_ctrl__img_yuv_tail_1__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (layer_st & pixel_planar_nxt & pixel_tail_1_w);
    endproperty
    // Cover 2 : "(layer_st & pixel_planar_nxt & pixel_tail_1_w)"
    FUNCPOINT_cdma_img_ctrl__img_yuv_tail_1__2_COV : cover property (cdma_img_ctrl__img_yuv_tail_1__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property cdma_img_ctrl__img_yuv_tail_2__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (layer_st & pixel_planar_nxt & pixel_tail_2_w);
    endproperty
    // Cover 3 : "(layer_st & pixel_planar_nxt & pixel_tail_2_w)"
    FUNCPOINT_cdma_img_ctrl__img_yuv_tail_2__3_COV : cover property (cdma_img_ctrl__img_yuv_tail_2__3_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDMA_IMG_ctrl


