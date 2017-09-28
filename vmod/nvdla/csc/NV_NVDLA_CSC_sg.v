// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_sg.v

module NV_NVDLA_CSC_sg (
   nvdla_core_clk            //|< i
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_core_rstn           //|< i
  ,accu2sc_credit_size       //|< i
  ,accu2sc_credit_vld        //|< i
  ,cdma2sc_dat_entries       //|< i *
  ,cdma2sc_dat_pending_ack   //|< i
  ,cdma2sc_dat_slices        //|< i
  ,cdma2sc_dat_updt          //|< i
  ,cdma2sc_wmb_entries       //|< i *
  ,cdma2sc_wt_entries        //|< i *
  ,cdma2sc_wt_kernels        //|< i
  ,cdma2sc_wt_pending_ack    //|< i
  ,cdma2sc_wt_updt           //|< i
  ,pwrbus_ram_pd             //|< i
  ,reg2dp_atomics            //|< i
  ,reg2dp_batches            //|< i
  ,reg2dp_conv_mode          //|< i
  ,reg2dp_data_bank          //|< i
  ,reg2dp_data_reuse         //|< i
  ,reg2dp_datain_format      //|< i
  ,reg2dp_datain_height_ext  //|< i
  ,reg2dp_dataout_height     //|< i
  ,reg2dp_dataout_width      //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_rls_slices         //|< i
  ,reg2dp_skip_data_rls      //|< i
  ,reg2dp_skip_weight_rls    //|< i
  ,reg2dp_weight_bank        //|< i
  ,reg2dp_weight_channel_ext //|< i
  ,reg2dp_weight_height_ext  //|< i
  ,reg2dp_weight_kernel      //|< i
  ,reg2dp_weight_reuse       //|< i
  ,reg2dp_weight_width_ext   //|< i
  ,reg2dp_y_extension        //|< i
  ,dp2reg_done               //|> o
  ,sc2cdma_dat_pending_req   //|> o
  ,sc2cdma_wt_pending_req    //|> o
  ,sc_state                  //|> o
  ,sg2dl_pd                  //|> o
  ,sg2dl_pvld                //|> o
  ,sg2dl_reuse_rls           //|> o
  ,sg2wl_pd                  //|> o
  ,sg2wl_pvld                //|> o
  ,sg2wl_reuse_rls           //|> o
  );


//
// NV_NVDLA_CSC_sg_ports.v
//
input  nvdla_core_clk;   /* done_dp2reg, dat_up_cdma2sc, wt_up_cdma2sc, sg2dl_pkg, sg2wl_pkg, accu2sc_credit, sc_state, sc2cdma_dat_pending, sc2cdma_wt_pending, cdma2sc_dat_pending, cdma2sc_wt_pending, sg2dl_reuse, sg2wl_reuse */
input  nvdla_core_rstn;  /* done_dp2reg, dat_up_cdma2sc, wt_up_cdma2sc, sg2dl_pkg, sg2wl_pkg, accu2sc_credit, sc_state, sc2cdma_dat_pending, sc2cdma_wt_pending, cdma2sc_dat_pending, cdma2sc_wt_pending, sg2dl_reuse, sg2wl_reuse */

input [31:0] pwrbus_ram_pd;

output  dp2reg_done;

input        cdma2sc_dat_updt;     /* data valid */
input [11:0] cdma2sc_dat_entries;
input [11:0] cdma2sc_dat_slices;

input        cdma2sc_wt_updt;      /* data valid */
input [13:0] cdma2sc_wt_kernels;
input [11:0] cdma2sc_wt_entries;
input  [8:0] cdma2sc_wmb_entries;

output        sg2dl_pvld;  /* data valid */
output [30:0] sg2dl_pd;

output        sg2wl_pvld;  /* data valid */
output [17:0] sg2wl_pd;

input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;

output [1:0] sc_state;

output  sc2cdma_dat_pending_req;

output  sc2cdma_wt_pending_req;

input  cdma2sc_dat_pending_ack;

input  cdma2sc_wt_pending_ack;

output  sg2dl_reuse_rls;

output  sg2wl_reuse_rls;

input nvdla_core_ng_clk;

input [0:0]                      reg2dp_op_en;
input [0:0]                   reg2dp_conv_mode;
input [1:0]              reg2dp_proc_precision;
input [0:0]                  reg2dp_data_reuse;
input [0:0]               reg2dp_skip_data_rls;
input [0:0]                reg2dp_weight_reuse;
input [0:0]             reg2dp_skip_weight_rls;
input [4:0]                 reg2dp_batches;
input [0:0]          reg2dp_datain_format;
input [12:0]  reg2dp_datain_height_ext;
input [1:0]         reg2dp_y_extension;
input [4:0]   reg2dp_weight_width_ext;
input [4:0]  reg2dp_weight_height_ext;
input [12:0] reg2dp_weight_channel_ext;
input [12:0]      reg2dp_weight_kernel;
input [12:0]         reg2dp_dataout_width;
input [12:0]        reg2dp_dataout_height;
input [3:0]                       reg2dp_data_bank;
input [3:0]                     reg2dp_weight_bank;
input [20:0]                      reg2dp_atomics;
input [11:0]                   reg2dp_rls_slices;

wire   [30:0] dat_pkg_pd;
wire   [32:0] dat_pop_data;
wire          dat_pop_req;
wire          dat_push_empty;
wire          dat_push_ready;
wire    [1:0] dbg_cur_prec;
wire          sg2dat_block_end;
wire          sg2dat_channel_end;
wire    [6:0] sg2dat_channel_size;
wire    [1:0] sg2dat_cur_sub_h;
wire          sg2dat_dat_release;
wire          sg2dat_group_end;
wire    [4:0] sg2dat_h_offset;
wire          sg2dat_layer_end;
wire    [6:0] sg2dat_stripe_length;
wire    [4:0] sg2dat_w_offset;
wire          sg2wt_channel_end;
wire    [1:0] sg2wt_cur_sub_h;
wire          sg2wt_group_end;
wire    [5:0] sg2wt_kernel_size;
wire    [6:0] sg2wt_weight_size;
wire          sg2wt_wt_release;
wire    [6:0] stripe_length_w;
wire          wt_pkg_channel_end;
wire          wt_pkg_group_end;
wire   [17:0] wt_pkg_pd;
wire   [19:0] wt_pop_data;
wire          wt_pop_req;
wire          wt_push_empty;
wire          wt_push_ready;
reg     [6:0] batch_delta;
reg     [6:0] batch_delta_w;
reg     [6:0] c_fetch_size;
reg           cbuf_ready;
reg    [13:0] channel_up_cnt;
reg    [13:0] channel_up_cnt_inc;
reg    [13:0] channel_up_cnt_w;
reg     [8:0] credit_cnt;
reg     [3:0] credit_cnt_add;
reg     [8:0] credit_cnt_dec;
reg     [8:0] credit_cnt_w;
reg           credit_ready;
reg     [8:0] credit_req_size;
reg     [2:0] credit_size;
reg           credit_vld;
reg     [6:0] cur_channel;
reg     [5:0] cur_kernel;
reg     [2:0] cur_mode;
reg     [2:0] cur_r;
reg     [1:0] cur_state;
reg     [6:0] cur_stripe;
reg     [6:0] cur_stripe_inc;
reg           dat_bank_change;
reg           dat_cbuf_ready;
reg     [8:0] dat_impact_cnt;
reg     [6:0] dat_max_cycles;
reg           dat_pending_ack;
reg           dat_pending_clr;
reg           dat_pending_clr_w;
reg           dat_pending_req;
reg           dat_pending_req_w;
reg           dat_pkg_block_end;
reg           dat_pkg_channel_end;
reg     [6:0] dat_pkg_channel_size;
reg     [2:0] dat_pkg_cur_sub_h;
reg           dat_pkg_dat_release;
reg           dat_pkg_group_end;
reg     [4:0] dat_pkg_h_offset;
reg           dat_pkg_layer_end;
reg     [6:0] dat_pkg_stripe_length;
reg     [4:0] dat_pkg_w_offset;
reg     [1:0] dat_pop_idx;
reg    [30:0] dat_pop_pd;
reg           dat_pop_ready;
reg    [32:0] dat_push_data;
reg           dat_push_req;
reg           dat_release;
reg           dat_reuse_release;
reg     [5:0] dat_stripe_batch_size_w;
reg     [6:0] dat_stripe_img_length_w;
reg     [6:0] dat_stripe_img_size_w;
reg     [6:0] dat_stripe_length;
reg     [6:0] dat_stripe_length_w;
reg     [6:0] dat_stripe_size;
reg     [6:0] dat_stripe_size_w;
reg     [5:0] data_batch;
reg     [5:0] data_batch_w;
reg    [13:0] data_in_height;
reg    [13:0] data_in_height_w;
reg    [21:0] data_out_atomic;
reg    [21:0] data_out_atomic_w;
reg    [12:0] dataout_h_up_cnt;
reg    [12:0] dataout_h_up_cnt_w;
reg     [1:0] dbg_pre_prec;
reg           dp2reg_done;
reg           fifo_is_clear;
reg           fifo_push_ready;
reg     [7:0] flush_cycles;
reg     [7:0] flush_cycles_w;
reg     [9:0] group_up_cnt;
reg     [9:0] group_up_cnt_inc;
reg     [9:0] group_up_cnt_w;
reg           is_conv;
reg           is_dc;
reg           is_done;
reg           is_idle;
reg           is_img;
reg           is_img_d1;
reg           is_int8;
reg           is_int8_d1;
reg           is_last_block;
reg           is_last_channel;
reg           is_last_do_h;
reg           is_last_group;
reg           is_last_r;
reg           is_last_s;
reg           is_last_stripe;
reg           is_mode_change;
reg           is_nxt_done;
reg           is_nxt_pending;
reg           is_pending;
reg           is_pixel;
reg           is_running;
reg           is_winograd;
reg           is_winograd_d1;
reg    [14:0] kernels_avl;
reg    [13:0] kernels_avl_add;
reg    [13:0] kernels_avl_sub;
reg    [14:0] kernels_avl_w;
reg     [3:0] last_data_bank;
reg    [13:0] last_kernels;
reg     [2:0] last_mode;
reg           last_skip_weight_rls;
reg    [13:0] last_slices;
reg     [3:0] last_weight_bank;
reg           layer_done;
reg           layer_done_w;
reg           layer_st;
reg     [6:0] lower_limit;
reg     [6:0] lower_limit_w;
reg     [5:0] max_cycles;
reg           mon_channel_up_cnt_inc;
reg           mon_credit_cnt_w;
reg           mon_credit_req_size;
reg           mon_cur_stripe_inc;
reg     [5:0] mon_dat_stripe_batch_size_w;
reg           mon_dat_stripe_img_length_w;
reg           mon_dataout_h_up_cnt_w;
reg           mon_group_up_cnt_inc;
reg     [0:0] mon_kernels_avl_w;
reg     [1:0] mon_max_cycles;
reg           mon_pkg_idx_w;
reg           mon_pop_cnt_dec;
reg           mon_required_kernels_inc;
reg           mon_rls_slices_w;
reg           mon_sg2wt_kernel_size_inc;
reg           mon_sg_dn_cnt_w;
reg     [1:0] mon_slice_left_w;
reg     [1:0] mon_slices_avl_w;
reg           mon_stripe_up_cnt_inc;
reg           mon_stripe_up_cnt_w;
reg     [2:0] mon_weight_r_add_w;
reg           mon_weight_s_up_cnt_inc;
reg           need_pending;
reg     [1:0] nxt_state;
reg           op_channel_en;
reg           op_do_h_en;
reg           op_group_en;
reg           op_layer_en;
reg           op_r_en;
reg           op_s_en;
reg           op_stripe_en;
reg           pending_done;
reg           pkg_adv;
reg           pkg_block_end_w;
reg           pkg_channel_end_w;
reg           pkg_group_end_w;
reg     [1:0] pkg_idx;
reg     [1:0] pkg_idx_w;
reg           pkg_layer_end_w;
reg           pkg_vld;
reg           pkg_vld_w;
reg     [6:0] pkg_weight_size_w;
reg     [5:0] pop_cnt;
reg     [5:0] pop_cnt_dec;
reg     [5:0] pop_cnt_w;
reg    [13:0] required_kernels;
reg    [13:0] required_kernels_inc;
reg    [13:0] required_kernels_w;
reg    [11:0] rls_slices;
reg    [11:0] rls_slices_w;
reg     [1:0] sc_state;
reg    [30:0] sg2dl_pd;
reg           sg2dl_pvld;
reg           sg2dl_reuse_rls;
reg    [17:0] sg2wl_pd;
reg           sg2wl_pvld;
reg           sg2wl_reuse_rls;
reg     [5:0] sg2wt_kernel_size_inc;
reg     [7:0] sg_dn_cnt;
reg     [7:0] sg_dn_cnt_w;
reg    [13:0] slice_left;
reg    [13:0] slice_left_w;
reg    [11:0] slices_avl;
reg    [11:0] slices_avl_add;
reg    [11:0] slices_avl_sub;
reg    [11:0] slices_avl_w;
reg    [21:0] stripe_up_cnt;
reg    [21:0] stripe_up_cnt_inc;
reg    [21:0] stripe_up_cnt_w;
reg     [6:0] upper_limit;
reg     [6:0] upper_limit_w;
reg    [13:0] weight_channel;
reg    [13:0] weight_channel_w;
reg     [9:0] weight_groups;
reg     [9:0] weight_groups_w;
reg     [4:0] weight_height_cmp;
reg     [4:0] weight_height_cmp_w;
reg     [2:0] weight_r_add;
reg     [2:0] weight_r_add_w;
reg     [2:0] weight_r_last;
reg     [2:0] weight_r_last_w;
reg     [4:0] weight_r_up_cnt;
reg     [5:0] weight_r_up_cnt_inc;
reg     [4:0] weight_r_up_cnt_w;
reg     [4:0] weight_s_up_cnt;
reg     [4:0] weight_s_up_cnt_inc;
reg     [4:0] weight_s_up_cnt_w;
reg     [4:0] weight_width_cmp;
reg     [4:0] weight_width_cmp_w;
reg           wt_bank_change;
reg           wt_cbuf_ready;
reg     [4:0] wt_cycles;
reg     [5:0] wt_max_cycles;
reg           wt_pending_ack;
reg           wt_pending_clr;
reg           wt_pending_clr_w;
reg           wt_pending_req;
reg           wt_pending_req_w;
reg     [2:0] wt_pkg_cur_sub_h;
reg     [5:0] wt_pkg_kernel_size;
reg     [6:0] wt_pkg_weight_size;
reg           wt_pkg_wt_release;
reg     [1:0] wt_pop_idx;
reg    [17:0] wt_pop_pd;
reg           wt_pop_ready;
reg           wt_pop_ready_d1;
reg    [19:0] wt_push_data;
reg           wt_push_req;
reg           wt_release;
reg           wt_reuse_release;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
////////////////////////////////////////////////////////////////////////
// CSC control FSM                                                    //
////////////////////////////////////////////////////////////////////////


//## fsm (1) output

//|)

//## fsm (1) defines

localparam SG_STATE_IDLE = 2'b00;
localparam SG_STATE_PEND = 2'b01;
localparam SG_STATE_BUSY = 2'b10;
localparam SG_STATE_DONE = 2'b11;

//## fsm (1) com block

always @(
  cur_state
  or reg2dp_op_en
  or need_pending
  or pending_done
  or layer_done
  or fifo_is_clear
  or pkg_vld
  or dp2reg_done
  ) begin
  nxt_state = cur_state;
  begin
    casez (cur_state)
      SG_STATE_IDLE: begin
        if ((reg2dp_op_en & need_pending)) begin
          nxt_state = SG_STATE_PEND; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if (((reg2dp_op_en & need_pending)) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
        else if (reg2dp_op_en) begin
          nxt_state = SG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((reg2dp_op_en) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      SG_STATE_PEND: begin
        if (pending_done) begin
          nxt_state = SG_STATE_BUSY; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((pending_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      SG_STATE_BUSY: begin
        if (layer_done & fifo_is_clear & ~pkg_vld) begin
          nxt_state = SG_STATE_DONE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((layer_done & fifo_is_clear & ~pkg_vld) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      SG_STATE_DONE: begin
        if (dp2reg_done) begin
          nxt_state = SG_STATE_IDLE; 
        end
        `ifndef SYNTHESIS
        // VCS coverage off
        else if ((dp2reg_done) === 1'bx) begin
          nxt_state = 'bx;
        end
        // VCS coverage on
        `endif
      end
      // VCS coverage off
      default: begin
        nxt_state = SG_STATE_IDLE; 
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
    cur_state <= SG_STATE_IDLE;
  end else begin
  cur_state <= nxt_state;
  end
end

//## fsm (1) reachable testpoints


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_SG_STATE_IDLE
    `define COVER_OR_TP__state_reachable_SG_STATE_IDLE_OR_COVER
  `endif // TP__state_reachable_SG_STATE_IDLE

`ifdef COVER_OR_TP__state_reachable_SG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_SG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_IDLE ::: cur_state==SG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_IDLE ::: testpoint_0_goal_0
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
            if ((cur_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_IDLE ::: testpoint_0_goal_0");
 `endif
            if ((cur_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
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
    wire testpoint_0_goal_0_active = ((cur_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_SG_STATE_IDLE_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_SG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_SG_STATE_PEND
    `define COVER_OR_TP__state_reachable_SG_STATE_PEND_OR_COVER
  `endif // TP__state_reachable_SG_STATE_PEND

`ifdef COVER_OR_TP__state_reachable_SG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_SG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_PEND ::: cur_state==SG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_PEND ::: testpoint_1_goal_0
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
            if ((cur_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_PEND ::: testpoint_1_goal_0");
 `endif
            if ((cur_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
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
    wire testpoint_1_goal_0_active = ((cur_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_SG_STATE_PEND_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_SG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_SG_STATE_BUSY
    `define COVER_OR_TP__state_reachable_SG_STATE_BUSY_OR_COVER
  `endif // TP__state_reachable_SG_STATE_BUSY

`ifdef COVER_OR_TP__state_reachable_SG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_SG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_BUSY ::: cur_state==SG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_BUSY ::: testpoint_2_goal_0
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
            if ((cur_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_BUSY ::: testpoint_2_goal_0");
 `endif
            if ((cur_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
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
    wire testpoint_2_goal_0_active = ((cur_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_SG_STATE_BUSY_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_SG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__state_reachable_SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__state_reachable_SG_STATE_DONE
    `define COVER_OR_TP__state_reachable_SG_STATE_DONE_OR_COVER
  `endif // TP__state_reachable_SG_STATE_DONE

`ifdef COVER_OR_TP__state_reachable_SG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="state_reachable_SG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_DONE ::: cur_state==SG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_DONE ::: testpoint_3_goal_0
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
            if ((cur_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: state_reachable_SG_STATE_DONE ::: testpoint_3_goal_0");
 `endif
            if ((cur_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
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
    wire testpoint_3_goal_0_active = ((cur_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_state_reachable_SG_STATE_DONE_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__state_reachable_SG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

//## fsm (1) transition testpoints

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND_OR_COVER
  `endif // TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND

`ifdef COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_SG_STATE_IDLE__to__SG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_PEND ::: (cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_PEND)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_PEND ::: testpoint_4_goal_0
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
            if (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_PEND ::: testpoint_4_goal_0");
 `endif
            if (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
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
    wire testpoint_4_goal_0_active = (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_PEND)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_SG_STATE_IDLE__to__SG_STATE_PEND_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY
    `define COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY_OR_COVER
  `endif // TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY

`ifdef COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_SG_STATE_IDLE__to__SG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_BUSY ::: (cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_BUSY ::: testpoint_5_goal_0
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
            if (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_IDLE__to__SG_STATE_BUSY ::: testpoint_5_goal_0");
 `endif
            if (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
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
    wire testpoint_5_goal_0_active = (((cur_state==SG_STATE_IDLE) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_SG_STATE_IDLE__to__SG_STATE_BUSY_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_SG_STATE_IDLE__to__SG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE
    `define COVER_OR_TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_OR_COVER
  `endif // TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE

`ifdef COVER_OR_TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE ::: cur_state==SG_STATE_IDLE && nxt_state==SG_STATE_IDLE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE ::: testpoint_6_goal_0
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
            if ((cur_state==SG_STATE_IDLE && nxt_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE ::: testpoint_6_goal_0");
 `endif
            if ((cur_state==SG_STATE_IDLE && nxt_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk)
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
    wire testpoint_6_goal_0_active = ((cur_state==SG_STATE_IDLE && nxt_state==SG_STATE_IDLE) && testpoint_got_reset_testpoint_6_internal_nvdla_core_rstn_with_clock_testpoint_6_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_0 (.clk (testpoint_6_internal_nvdla_core_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_SG_STATE_IDLE__to__SG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY
    `define COVER_OR_TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY_OR_COVER
  `endif // TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY

`ifdef COVER_OR_TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_SG_STATE_PEND__to__SG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_PEND__to__SG_STATE_BUSY ::: (cur_state==SG_STATE_PEND) && (nxt_state == SG_STATE_BUSY)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: transition_SG_STATE_PEND__to__SG_STATE_BUSY ::: testpoint_7_goal_0
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
            if (((cur_state==SG_STATE_PEND) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_PEND__to__SG_STATE_BUSY ::: testpoint_7_goal_0");
 `endif
            if (((cur_state==SG_STATE_PEND) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk)
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
    wire testpoint_7_goal_0_active = (((cur_state==SG_STATE_PEND) && (nxt_state == SG_STATE_BUSY)) && testpoint_got_reset_testpoint_7_internal_nvdla_core_rstn_with_clock_testpoint_7_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_SG_STATE_PEND__to__SG_STATE_BUSY_0 (.clk (testpoint_7_internal_nvdla_core_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_SG_STATE_PEND__to__SG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND
    `define COVER_OR_TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND_OR_COVER
  `endif // TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND

`ifdef COVER_OR_TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_SG_STATE_PEND__to__SG_STATE_PEND"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_PEND__to__SG_STATE_PEND ::: cur_state==SG_STATE_PEND && nxt_state==SG_STATE_PEND");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_PEND__to__SG_STATE_PEND ::: testpoint_8_goal_0
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
            if ((cur_state==SG_STATE_PEND && nxt_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_PEND__to__SG_STATE_PEND ::: testpoint_8_goal_0");
 `endif
            if ((cur_state==SG_STATE_PEND && nxt_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk)
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
    wire testpoint_8_goal_0_active = ((cur_state==SG_STATE_PEND && nxt_state==SG_STATE_PEND) && testpoint_got_reset_testpoint_8_internal_nvdla_core_rstn_with_clock_testpoint_8_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_SG_STATE_PEND__to__SG_STATE_PEND_0 (.clk (testpoint_8_internal_nvdla_core_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_SG_STATE_PEND__to__SG_STATE_PEND_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE
    `define COVER_OR_TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE_OR_COVER
  `endif // TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE

`ifdef COVER_OR_TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_SG_STATE_BUSY__to__SG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_BUSY__to__SG_STATE_DONE ::: (cur_state==SG_STATE_BUSY) && (nxt_state == SG_STATE_DONE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: transition_SG_STATE_BUSY__to__SG_STATE_DONE ::: testpoint_9_goal_0
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
            if (((cur_state==SG_STATE_BUSY) && (nxt_state == SG_STATE_DONE)) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_BUSY__to__SG_STATE_DONE ::: testpoint_9_goal_0");
 `endif
            if (((cur_state==SG_STATE_BUSY) && (nxt_state == SG_STATE_DONE)) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk)
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
    wire testpoint_9_goal_0_active = (((cur_state==SG_STATE_BUSY) && (nxt_state == SG_STATE_DONE)) && testpoint_got_reset_testpoint_9_internal_nvdla_core_rstn_with_clock_testpoint_9_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_SG_STATE_BUSY__to__SG_STATE_DONE_0 (.clk (testpoint_9_internal_nvdla_core_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_SG_STATE_BUSY__to__SG_STATE_DONE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY
    `define COVER_OR_TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_OR_COVER
  `endif // TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY

`ifdef COVER_OR_TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY ::: cur_state==SG_STATE_BUSY && nxt_state==SG_STATE_BUSY");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY ::: testpoint_10_goal_0
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
            if ((cur_state==SG_STATE_BUSY && nxt_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY ::: testpoint_10_goal_0");
 `endif
            if ((cur_state==SG_STATE_BUSY && nxt_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk)
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
    wire testpoint_10_goal_0_active = ((cur_state==SG_STATE_BUSY && nxt_state==SG_STATE_BUSY) && testpoint_got_reset_testpoint_10_internal_nvdla_core_rstn_with_clock_testpoint_10_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_0 (.clk (testpoint_10_internal_nvdla_core_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_SG_STATE_BUSY__to__SG_STATE_BUSY_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE_OR_COVER
  `endif // COVER

  `ifdef TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE
    `define COVER_OR_TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE_OR_COVER
  `endif // TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE

`ifdef COVER_OR_TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="transition_SG_STATE_DONE__to__SG_STATE_IDLE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_DONE__to__SG_STATE_IDLE ::: (cur_state==SG_STATE_DONE) && (nxt_state == SG_STATE_IDLE)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: transition_SG_STATE_DONE__to__SG_STATE_IDLE ::: testpoint_11_goal_0
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
            if (((cur_state==SG_STATE_DONE) && (nxt_state == SG_STATE_IDLE)) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: transition_SG_STATE_DONE__to__SG_STATE_IDLE ::: testpoint_11_goal_0");
 `endif
            if (((cur_state==SG_STATE_DONE) && (nxt_state == SG_STATE_IDLE)) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk)
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
    wire testpoint_11_goal_0_active = (((cur_state==SG_STATE_DONE) && (nxt_state == SG_STATE_IDLE)) && testpoint_got_reset_testpoint_11_internal_nvdla_core_rstn_with_clock_testpoint_11_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_transition_SG_STATE_DONE__to__SG_STATE_IDLE_0 (.clk (testpoint_11_internal_nvdla_core_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__transition_SG_STATE_DONE__to__SG_STATE_IDLE_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE_OR_COVER
  `endif // COVER

  `ifdef TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE
    `define COVER_OR_TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE_OR_COVER
  `endif // TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE

`ifdef COVER_OR_TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="self_transition_SG_STATE_DONE__to__SG_STATE_DONE"
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
                $display("TESTPOINT_HIT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_DONE__to__SG_STATE_DONE ::: cur_state==SG_STATE_DONE && nxt_state==SG_STATE_DONE");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_DONE__to__SG_STATE_DONE ::: testpoint_12_goal_0
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
            if ((cur_state==SG_STATE_DONE && nxt_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CSC_sg ::: self_transition_SG_STATE_DONE__to__SG_STATE_DONE ::: testpoint_12_goal_0");
 `endif
            if ((cur_state==SG_STATE_DONE && nxt_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk)
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
    wire testpoint_12_goal_0_active = ((cur_state==SG_STATE_DONE && nxt_state==SG_STATE_DONE) && testpoint_got_reset_testpoint_12_internal_nvdla_core_rstn_with_clock_testpoint_12_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_self_transition_SG_STATE_DONE__to__SG_STATE_DONE_0 (.clk (testpoint_12_internal_nvdla_core_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__self_transition_SG_STATE_DONE__to__SG_STATE_DONE_OR_COVER
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
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////

always @(
  dat_pop_req
  or wt_pop_req
  or dat_push_empty
  or wt_push_empty
  ) begin
    fifo_is_clear = ~dat_pop_req & ~wt_pop_req & dat_push_empty & wt_push_empty;
end

always @(
  last_data_bank
  or reg2dp_data_bank
  ) begin
    dat_bank_change = (last_data_bank != reg2dp_data_bank);
end

always @(
  last_weight_bank
  or reg2dp_weight_bank
  ) begin
    wt_bank_change = (last_weight_bank != reg2dp_weight_bank);
end

always @(
  dat_bank_change
  or wt_bank_change
  ) begin
    need_pending = (dat_bank_change | wt_bank_change);
end

always @(
  is_pending
  or dat_pending_clr
  or dat_pending_req
  or wt_pending_clr
  or wt_pending_req
  ) begin
    pending_done = is_pending & (dat_pending_clr ~^ dat_pending_req) & (wt_pending_clr ~^ wt_pending_req);
end

always @(
  dat_stripe_size
  ) begin
    flush_cycles_w = dat_stripe_size + 6'h30 ;
end

always @(
  is_done
  or is_nxt_done
  or flush_cycles
  or sg_dn_cnt
  ) begin
    {mon_sg_dn_cnt_w,
     sg_dn_cnt_w} = (~is_done & is_nxt_done) ? {1'b0, flush_cycles} :
                    sg_dn_cnt - 1'b1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg_dn_cnt <= {8{1'b0}};
  end else begin
  if ((is_nxt_done) == 1'b1) begin
    sg_dn_cnt <= sg_dn_cnt_w;
  // VCS coverage off
  end else if ((is_nxt_done) == 1'b0) begin
  end else begin
    sg_dn_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_nxt_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pending_ack <= 1'b0;
  end else begin
  dat_pending_ack <= cdma2sc_dat_pending_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_pending_ack <= 1'b0;
  end else begin
  wt_pending_ack <= cdma2sc_wt_pending_ack;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    flush_cycles <= {8{1'b0}};
  end else begin
  if ((dat_pop_req & dat_pop_ready & sg2dat_layer_end) == 1'b1) begin
    flush_cycles <= flush_cycles_w;
  // VCS coverage off
  end else if ((dat_pop_req & dat_pop_ready & sg2dat_layer_end) == 1'b0) begin
  end else begin
    flush_cycles <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_pop_req & dat_pop_ready & sg2dat_layer_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! sg_dn_cnt unusual count")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (~is_done & (|sg_dn_cnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! pending status error!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (is_pending & ~dat_pending_req & ~wt_pending_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  reg2dp_op_en
  or cur_state
  ) begin
    layer_st = reg2dp_op_en && (cur_state == SG_STATE_IDLE);
end
//
//&Always;
//    layer_end = (cur_state == SG_STATE_DONE);
//&End;

always @(
  cur_state
  ) begin
    is_idle = (cur_state == SG_STATE_IDLE);
end

always @(
  cur_state
  ) begin
    is_pending = (cur_state == SG_STATE_PEND);
end

always @(
  cur_state
  ) begin
    is_running = (cur_state == SG_STATE_BUSY);
end

always @(
  cur_state
  ) begin
    is_done = (cur_state == SG_STATE_DONE);
end

always @(
  nxt_state
  ) begin
    is_nxt_done = (nxt_state == SG_STATE_DONE);
end

always @(
  nxt_state
  ) begin
    is_nxt_pending = (nxt_state == SG_STATE_PEND);
end

always @(
  is_idle
  or is_pending
  or is_running
  ) begin
    sc_state = is_idle ? 0  :
               is_pending ? 1  :
               is_running ? 2  :
               3 ;
end

always @(
  is_nxt_pending
  or dat_bank_change
  or dat_pending_req
  ) begin
    dat_pending_req_w = (is_nxt_pending & dat_bank_change) ? 1'b1 :
                        (~is_nxt_pending) ? 1'b0 :
                        dat_pending_req;
end

always @(
  is_nxt_pending
  or wt_pending_req
  ) begin
    wt_pending_req_w = (is_nxt_pending) ? 1'b1 :
                       (~is_nxt_pending) ? 1'b0 :
                       wt_pending_req;
end

always @(
  last_mode
  or cur_mode
  ) begin
    is_mode_change = (last_mode != cur_mode);
end

always @(
  is_pending
  or dat_pending_ack
  or is_nxt_pending
  or dat_pending_clr
  ) begin
    dat_pending_clr_w = (is_pending & dat_pending_ack) ? 1'b1 :
                        ~is_nxt_pending ? 1'b0 :
                        dat_pending_clr;
end

always @(
  is_pending
  or wt_pending_ack
  or is_nxt_pending
  or wt_pending_clr
  ) begin
    wt_pending_clr_w = (is_pending & wt_pending_ack) ? 1'b1 :
                       ~is_nxt_pending ? 1'b0 :
                       wt_pending_clr;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_done <= 1'b0;
  end else begin
  dp2reg_done <= is_done && (sg_dn_cnt == 6'b1);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_pending_req <= 1'b0;
  end else begin
  dat_pending_req <= dat_pending_req_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_pending_req <= 1'b0;
  end else begin
  wt_pending_req <= wt_pending_req_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_pending_clr <= 1'b0;
  end else begin
  dat_pending_clr <= dat_pending_clr_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_pending_clr <= 1'b0;
  end else begin
  wt_pending_clr <= wt_pending_clr_w;
  end
end

assign sc2cdma_dat_pending_req = dat_pending_req;
assign sc2cdma_wt_pending_req = wt_pending_req;

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_data_bank <= {4{1'b1}};
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_data_bank <= reg2dp_data_bank;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_weight_bank <= {4{1'b1}};
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_weight_bank <= reg2dp_weight_bank;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    last_weight_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_slices <= {14{1'b0}};
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_slices <= slice_left;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    last_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_kernels <= {14{1'b0}};
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_kernels <= reg2dp_weight_kernel + 1'b1;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    last_kernels <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_skip_weight_rls <= 1'b0;
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_skip_weight_rls <= reg2dp_skip_weight_rls;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    last_skip_weight_rls <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_mode <= {3{1'b0}};
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    last_mode <= cur_mode;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    last_mode <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////


always @(
  reg2dp_proc_precision
  ) begin
    is_int8 = (reg2dp_proc_precision == 2'h0 );
end

always @(
  reg2dp_datain_format
  ) begin
    is_pixel = (reg2dp_datain_format == 1'h1 );
end

always @(
  reg2dp_conv_mode
  ) begin
    is_conv = (reg2dp_conv_mode == 1'h0 );
end

always @(
  is_conv
  or is_pixel
  ) begin
    is_dc = is_conv & ~is_pixel;
end

always @(
  reg2dp_conv_mode
  ) begin
    is_winograd = (reg2dp_conv_mode == 1'h1 );
end

always @(
  is_conv
  or is_pixel
  ) begin
    is_img = is_conv & is_pixel;
end

always @(
  is_img
  or is_winograd
  or is_dc
  ) begin
    cur_mode = {is_img, is_winograd, is_dc};
end

always @(
  reg2dp_datain_height_ext
  ) begin
    data_in_height_w = reg2dp_datain_height_ext + 1'b1;
end

always @(
  is_img
  or reg2dp_dataout_width
  or is_winograd
  or reg2dp_atomics
  ) begin
    data_out_atomic_w = is_img ? reg2dp_dataout_width + 1'b1 :
                        is_winograd ? ({2'b0, reg2dp_atomics[20:2]} + 1'b1) :
                        reg2dp_atomics + 1'b1;
end

always @(
  is_winograd
  or is_img
  or reg2dp_weight_width_ext
  ) begin
    weight_width_cmp_w = (is_winograd | is_img) ? 5'b0 : reg2dp_weight_width_ext;
end

always @(
  is_winograd
  or reg2dp_weight_height_ext
  ) begin
    weight_height_cmp_w = is_winograd ? 5'b0 : reg2dp_weight_height_ext;
end

always @(
  reg2dp_weight_channel_ext
  ) begin
    weight_channel_w = reg2dp_weight_channel_ext + 1'b1;
end

always @(
  is_int8
  or reg2dp_weight_kernel
  ) begin
    weight_groups_w = is_int8 ? (reg2dp_weight_kernel[12:5] + 1'b1) :
                      (reg2dp_weight_kernel[12:4] + 1'b1);
end

always @(
  reg2dp_y_extension
  ) begin
    {weight_r_add_w,
     mon_weight_r_add_w} = (6'h9 << reg2dp_y_extension);
end

always @(
  weight_r_add_w
  or reg2dp_weight_height_ext
  ) begin
    weight_r_last_w = weight_r_add_w[0] ? 2'b0 :
                      weight_r_add_w[1] ? {1'b0, reg2dp_weight_height_ext[0]} :
                      reg2dp_weight_height_ext[1:0];
end

always @(
  reg2dp_rls_slices
  ) begin
    {mon_rls_slices_w,
     rls_slices_w} = reg2dp_rls_slices + 1'b1;
end

always @(
  reg2dp_skip_data_rls
  or reg2dp_datain_height_ext
  or reg2dp_rls_slices
  ) begin
    {mon_slice_left_w,
     slice_left_w} = reg2dp_skip_data_rls ? (reg2dp_datain_height_ext + 1'b1) :
                     reg2dp_datain_height_ext - reg2dp_rls_slices;
end

always @(
  is_img
  or is_winograd
  or reg2dp_batches
  ) begin
    lower_limit_w = is_img ? 7'h40 :
                    is_winograd ? 7'h10 :
                    (reg2dp_batches == 5'd0) ? 7'h10 :
                    (reg2dp_batches <= 5'd2) ? 7'h8 :
                    (reg2dp_batches <= 5'd6) ? 7'h4 :
                    (reg2dp_batches <= 5'd14) ? 7'h2 :
                    7'h1;
end

always @(
  is_img
  or is_winograd
  or reg2dp_batches
  ) begin
    upper_limit_w = is_img ? 7'h40 :
                    is_winograd ? 7'h20 :
                    (reg2dp_batches == 5'd0) ? 7'h20 :
                    (reg2dp_batches <= 5'd2) ? 7'h10 :
                    (reg2dp_batches <= 5'd6) ? 7'h8 :
                    (reg2dp_batches <= 5'd14) ? 7'h4 :
                    7'h1;
end

always @(
  is_winograd
  ) begin
    c_fetch_size = is_winograd ? 7'h4 : 7'h40;
end

always @(
  reg2dp_batches
  ) begin
    data_batch_w = reg2dp_batches + 1'b1;
end

always @(
  is_dc
  or reg2dp_batches
  or is_int8
  or data_batch_w
  ) begin
    batch_delta_w = (~is_dc | ~(|reg2dp_batches)) ? 7'b0 :
                    is_int8 ? {data_batch_w, 1'b0} :
                    {1'b0, data_batch_w};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_in_height <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_in_height <= data_in_height_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_in_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    data_out_atomic <= {22{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_out_atomic <= data_out_atomic_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_out_atomic <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    data_batch <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_batch <= data_batch_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_batch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    batch_delta <= {7{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    batch_delta <= batch_delta_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    batch_delta <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    weight_width_cmp <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_width_cmp <= weight_width_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_width_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    weight_height_cmp <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_height_cmp <= weight_height_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_height_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    weight_channel <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_channel <= weight_channel_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_channel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    weight_groups <= {10{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_groups <= weight_groups_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_groups <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    weight_r_add <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_r_add <= weight_r_add_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_r_add <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    weight_r_last <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_r_last <= weight_r_last_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_r_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    rls_slices <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    rls_slices <= rls_slices_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    rls_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    slice_left <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    slice_left <= slice_left_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    slice_left <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_img_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_img_d1 <= is_img;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_img_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    is_winograd_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_winograd_d1 <= is_winograd;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_winograd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_int8_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_int8_d1 <= is_int8;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_int8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    lower_limit <= 7'h10;
  end else begin
  if ((layer_st) == 1'b1) begin
    lower_limit <= lower_limit_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    lower_limit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    upper_limit <= 7'h20;
  end else begin
  if ((layer_st) == 1'b1) begin
    upper_limit <= upper_limit_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    upper_limit <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config Error! Input data height is out of range!")      zzz_assert_never_29x (nvdla_core_clk, `ASSERT_RESET, (is_running && (data_in_height > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Atomics is overflow")      zzz_assert_never_30x (nvdla_core_clk, `ASSERT_RESET, (~is_idle && (data_out_atomic > (3840 * 128)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! rls_slices_w is overflow")      zzz_assert_never_31x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_rls_slices_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! Winograd uses pixel input!")      zzz_assert_never_32x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & is_pixel)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! No mode is activated!")      zzz_assert_never_33x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~(is_conv | is_winograd))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! weight_channel_ext exceed 128 when image input!")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_img & (weight_channel_w > 14'h80))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! weight width is invalid when winograd!")      zzz_assert_never_35x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_weight_width_ext != 5'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! weight height is invalid when winograd!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_weight_height_ext != 5'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! data output width is invalid when winograd!")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_dataout_width[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! data output height is invalid when winograd!")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_dataout_height[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! reg2dp_y_extension is out of range!")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (reg2dp_y_extension == 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! reg2dp_y_extension is too big for channel!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|reg2dp_y_extension)  & (weight_channel_w * weight_r_add_w > 64))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config error! reg2dp_y_extension is conflict with batch size!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|reg2dp_y_extension)  & (|reg2dp_batches))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  sequence generator for direct convolution                         //
////////////////////////////////////////////////////////////////////////

//---------------------------layer count -----------------------------//
always @(
  layer_st
  or is_last_group
  or layer_done
  ) begin
    layer_done_w = layer_st ? 1'b0 :
                   is_last_group ? 1'b1 :
                   layer_done;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_done <= 1'b0;
  end else begin
  if ((layer_st | op_layer_en) == 1'b1) begin
    layer_done <= layer_done_w;
  // VCS coverage off
  end else if ((layer_st | op_layer_en) == 1'b0) begin
  end else begin
    layer_done <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_layer_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//---------------------------kernel group count -----------------------------//

always @(
  group_up_cnt
  ) begin
   {mon_group_up_cnt_inc,
    group_up_cnt_inc} = group_up_cnt + 1'b1;
end

always @(
  group_up_cnt_inc
  or weight_groups
  ) begin
    is_last_group = (group_up_cnt_inc == weight_groups);
end

always @(
  layer_st
  or group_up_cnt_inc
  ) begin
    group_up_cnt_w = layer_st ? 10'b0 :
                     group_up_cnt_inc;
end

always @(
  is_last_group
  or is_int8_d1
  or reg2dp_weight_kernel
  ) begin
    cur_kernel = ~is_last_group ? (is_int8_d1 ? 6'h20 : 6'h10) :
                 is_int8_d1 ? (reg2dp_weight_kernel[4:0] + 1'b1) :
                 (reg2dp_weight_kernel[3:0] + 1'b1);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    group_up_cnt <= {10{1'b0}};
  end else begin
  if ((layer_st | op_group_en) == 1'b1) begin
    group_up_cnt <= group_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_group_en) == 1'b0) begin
  end else begin
    group_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_group_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Group up count overflow")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (~is_idle & mon_group_up_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cru_kernel is out of range")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (~is_idle & cur_kernel > 6'h20)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cru_kernel is underflow")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (~is_idle && ((|cur_kernel) ==  1'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- output height count, for image case only -----------------------------//

always @(
  is_img_d1
  or dataout_h_up_cnt
  or reg2dp_dataout_height
  ) begin
    is_last_do_h = ~is_img_d1 | (dataout_h_up_cnt == reg2dp_dataout_height);
end

always @(
  layer_st
  or is_last_do_h
  or dataout_h_up_cnt
  ) begin
    {mon_dataout_h_up_cnt_w,
     dataout_h_up_cnt_w} = layer_st ? 14'b0 :
                           is_last_do_h ? 14'b0 :
                           (dataout_h_up_cnt + 1'b1);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dataout_h_up_cnt <= {13{1'b0}};
  end else begin
  if ((layer_st | op_do_h_en) == 1'b1) begin
    dataout_h_up_cnt <= dataout_h_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_do_h_en) == 1'b0) begin
  end else begin
    dataout_h_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_do_h_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Stripe up count is overflow!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (is_running & mon_dataout_h_up_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- output stripe count -----------------------------//

always @(
  stripe_up_cnt
  or upper_limit
  ) begin
    {mon_stripe_up_cnt_inc,
     stripe_up_cnt_inc} = stripe_up_cnt + upper_limit;
end

always @(
  stripe_up_cnt_inc
  or data_out_atomic
  ) begin
    is_last_stripe = (stripe_up_cnt_inc >= data_out_atomic);
end

always @(
  layer_st
  or is_last_stripe
  or stripe_up_cnt
  or lower_limit
  ) begin
    {mon_stripe_up_cnt_w,
     stripe_up_cnt_w} = layer_st ? 23'b0 :
                        is_last_stripe? 23'b0 :
                        (stripe_up_cnt + lower_limit);
end

always @(
  data_out_atomic
  or stripe_up_cnt
  ) begin
    {mon_cur_stripe_inc, 
     cur_stripe_inc} = data_out_atomic[6:0] - stripe_up_cnt[6:0];
end

always @(
  is_last_stripe
  or cur_stripe_inc
  or lower_limit
  ) begin
    cur_stripe = is_last_stripe ? cur_stripe_inc :
                 lower_limit;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stripe_up_cnt <= {22{1'b0}};
  end else begin
  if ((layer_st | op_stripe_en) == 1'b1) begin
    stripe_up_cnt <= stripe_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_stripe_en) == 1'b0) begin
  end else begin
    stripe_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_stripe_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Stripe up count inc is overflow!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (is_running & mon_stripe_up_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Stripe up count is overflow!")      zzz_assert_never_51x (nvdla_core_clk, `ASSERT_RESET, (is_running & mon_stripe_up_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cur_stripe is underflow!")      zzz_assert_never_52x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~layer_done & ~(|cur_stripe))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- channel count -----------------------------//

always @(
  channel_up_cnt
  or c_fetch_size
  ) begin
    {mon_channel_up_cnt_inc,
     channel_up_cnt_inc} = channel_up_cnt + c_fetch_size;
end

always @(
  channel_up_cnt_inc
  or weight_channel
  ) begin
    is_last_channel = (channel_up_cnt_inc >= weight_channel);
end

always @(
  layer_st
  or is_last_channel
  or channel_up_cnt_inc
  ) begin
    channel_up_cnt_w = layer_st ? 14'b0 :
                       is_last_channel ? 14'b0 :
                       channel_up_cnt_inc;
end

always @(
  is_winograd_d1
  or is_last_channel
  or c_fetch_size
  or reg2dp_weight_channel_ext
  ) begin
    cur_channel = (is_winograd_d1 | ~is_last_channel) ? c_fetch_size :
                  (reg2dp_weight_channel_ext[5:0] + 1'b1);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    channel_up_cnt <= {14{1'b0}};
  end else begin
  if ((layer_st | op_channel_en) == 1'b1) begin
    channel_up_cnt <= channel_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_channel_en) == 1'b0) begin
  end else begin
    channel_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_channel_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Channel up count inc underflow!")      zzz_assert_never_54x (nvdla_core_clk, `ASSERT_RESET, (~is_idle & mon_channel_up_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cur_channel is out of range!")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (~is_idle && (cur_channel > 7'h40))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! cur_channel is underflow!")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (~is_idle && ((|cur_channel) == 1'b0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- weight block count -----------------------------//

always @(
  weight_s_up_cnt
  ) begin
    {mon_weight_s_up_cnt_inc,
     weight_s_up_cnt_inc} = weight_s_up_cnt + 1'b1;
end

always @(
  weight_r_up_cnt
  or weight_r_add
  ) begin
    weight_r_up_cnt_inc = weight_r_up_cnt + weight_r_add;
end

always @(
  weight_s_up_cnt
  or weight_width_cmp
  ) begin
    is_last_s = (weight_s_up_cnt == weight_width_cmp);
end

always @(
  weight_r_up_cnt_inc
  or weight_height_cmp
  ) begin
    is_last_r = (weight_r_up_cnt_inc > {1'b0, weight_height_cmp});
end

always @(
  is_last_r
  or weight_r_last
  or weight_r_add
  ) begin
    cur_r = is_last_r ? weight_r_last :
            weight_r_add[2] ? 2'h3 :
            weight_r_add[1] ? 2'h1 :
            2'h0;
end

always @(
  is_last_s
  or is_last_r
  ) begin
    is_last_block = is_last_s & is_last_r;
end

always @(
  layer_st
  or is_last_s
  or weight_s_up_cnt_inc
  ) begin
    weight_s_up_cnt_w = layer_st ? 5'b0 :
                        (is_last_s) ? 5'b0 :
                        weight_s_up_cnt_inc;
end

always @(
  layer_st
  or is_last_r
  or weight_r_up_cnt_inc
  ) begin
    weight_r_up_cnt_w = layer_st ? 5'b0 :
                        (is_last_r) ? 5'b0 :
                        weight_r_up_cnt_inc[4:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    weight_s_up_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | op_s_en) == 1'b1) begin
    weight_s_up_cnt <= weight_s_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_s_en) == 1'b0) begin
  end else begin
    weight_s_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_s_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    weight_r_up_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | op_r_en) == 1'b1) begin
    weight_r_up_cnt <= weight_r_up_cnt_w;
  // VCS coverage off
  end else if ((layer_st | op_r_en) == 1'b0) begin
  end else begin
    weight_r_up_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_r_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Weight S up count is out of range!")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~(is_winograd_d1) & (weight_s_up_cnt > reg2dp_weight_width_ext))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Weight R up count is out of range!")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, (is_running & ~(is_winograd_d1 | is_img_d1) & (weight_r_up_cnt > reg2dp_weight_height_ext))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- cbuf check logic -----------------------------//

always @(
  slices_avl
  or data_in_height
  ) begin
    dat_cbuf_ready = (slices_avl >= data_in_height[12 -1:0]);
end

always @(
  required_kernels
  or cur_kernel
  ) begin
    {mon_required_kernels_inc,
     required_kernels_inc} = required_kernels + cur_kernel;
end

always @(
  layer_st
  or is_last_group
  or reg2dp_skip_weight_rls
  or required_kernels_inc
  ) begin
    required_kernels_w = (layer_st | is_last_group | ~reg2dp_skip_weight_rls) ? 14'b0 :
                         required_kernels_inc;
end

always @(
  required_kernels_inc
  or kernels_avl
  ) begin
    wt_cbuf_ready = ({1'b0, required_kernels_inc} <= kernels_avl);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    required_kernels <= {14{1'b0}};
  end else begin
  if ((layer_st | op_group_en) == 1'b1) begin
    required_kernels <= required_kernels_w;
  // VCS coverage off
  end else if ((layer_st | op_group_en) == 1'b0) begin
  end else begin
    required_kernels <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | op_group_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! required_kernels_inc overflow")      zzz_assert_never_62x (nvdla_core_clk, `ASSERT_RESET, (~is_idle & mon_required_kernels_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//--------------------------- register enable signal -----------------------------//
always @(
  dat_push_ready
  or wt_push_ready
  ) begin
    fifo_push_ready = dat_push_ready & wt_push_ready;
end

always @(
  dat_cbuf_ready
  or wt_cbuf_ready
  ) begin
    cbuf_ready = dat_cbuf_ready & wt_cbuf_ready;
end

always @(
  is_running
  or cbuf_ready
  or layer_done
  or pkg_vld
  or fifo_push_ready
  ) begin
    pkg_adv = is_running & cbuf_ready & ~layer_done & (~pkg_vld | fifo_push_ready);
end

always @(
  pkg_adv
  ) begin
    op_s_en = pkg_adv;
end

always @(
  pkg_adv
  or is_last_s
  ) begin
    op_r_en = pkg_adv & is_last_s;
end

always @(
  pkg_adv
  or is_last_block
  ) begin
    op_channel_en = pkg_adv & is_last_block;
end

always @(
  pkg_adv
  or is_last_block
  or is_last_channel
  ) begin
    op_stripe_en = pkg_adv & is_last_block & is_last_channel;
end

always @(
  is_img_d1
  or pkg_adv
  or is_last_block
  or is_last_channel
  or is_last_stripe
  ) begin
    op_do_h_en = is_img_d1 & pkg_adv & is_last_block & is_last_channel & is_last_stripe;
end

always @(
  pkg_adv
  or is_last_block
  or is_last_channel
  or is_last_stripe
  or is_last_do_h
  ) begin
    op_group_en = pkg_adv & is_last_block & is_last_channel & is_last_stripe & is_last_do_h;
end

always @(
  pkg_adv
  or is_last_block
  or is_last_channel
  or is_last_stripe
  or is_last_do_h
  or is_last_group
  ) begin
    op_layer_en = pkg_adv & is_last_block & is_last_channel & is_last_stripe & is_last_do_h & is_last_group;
end

always @(
  is_running
  or cbuf_ready
  or layer_done
  or fifo_push_ready
  or pkg_vld
  ) begin
    pkg_vld_w = ~is_running  ? 1'b0 :
                (cbuf_ready & ~layer_done) ? 1'b1 :
                fifo_push_ready ? 1'b0 :
                pkg_vld;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pkg_vld <= 1'b0;
  end else begin
  pkg_vld <= pkg_vld_w;
  end
end

//--------------------------- package registers -----------------------------//

always @(
  layer_st
  or pkg_idx
  ) begin
    {mon_pkg_idx_w,
     pkg_idx_w} = layer_st ? 2'h3 : (pkg_idx + 2'b1);
end

always @(
  is_winograd_d1
  or cur_channel
  ) begin
    pkg_weight_size_w = (is_winograd_d1) ? 7'h40 :
                        cur_channel;
end

assign stripe_length_w = cur_stripe;

always @(
  is_last_block
  ) begin
    pkg_block_end_w = is_last_block;
end

always @(
  is_last_block
  or is_last_channel
  ) begin
    pkg_channel_end_w = is_last_block & is_last_channel;
end

always @(
  is_last_block
  or is_last_channel
  or is_last_stripe
  or is_last_do_h
  ) begin
    pkg_group_end_w = is_last_block & is_last_channel & is_last_stripe & is_last_do_h;
end

always @(
  is_last_block
  or is_last_channel
  or is_last_stripe
  or is_last_do_h
  or is_last_group
  ) begin
    pkg_layer_end_w = is_last_block & is_last_channel & is_last_stripe & is_last_do_h & is_last_group;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pkg_idx <= {2{1'b1}};
  end else begin
  if ((layer_st | pkg_adv) == 1'b1) begin
    pkg_idx <= pkg_idx_w;
  // VCS coverage off
  end else if ((layer_st | pkg_adv) == 1'b0) begin
  end else begin
    pkg_idx <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_w_offset <= {5{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_w_offset <= weight_s_up_cnt;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_w_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_h_offset <= {5{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_h_offset <= weight_r_up_cnt;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_h_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_channel_size <= {7{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_channel_size <= cur_channel;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_channel_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_stripe_length <= {7{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_stripe_length <= stripe_length_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_stripe_length <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_cur_sub_h <= {3{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_cur_sub_h <= cur_r;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_cur_sub_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_block_end <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_block_end <= pkg_block_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_block_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_channel_end <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_channel_end <= pkg_channel_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_channel_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_group_end <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_group_end <= pkg_group_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_group_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_layer_end <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_layer_end <= pkg_layer_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_layer_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_pkg_dat_release <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    dat_pkg_dat_release <= ~reg2dp_skip_data_rls & pkg_layer_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    dat_pkg_dat_release <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// PKT_PACK_WIRE( csc_dat_pkg ,  dat_pkg_ ,  dat_pkg_pd )
assign       dat_pkg_pd[4:0] =     dat_pkg_w_offset[4:0];
assign       dat_pkg_pd[9:5] =     dat_pkg_h_offset[4:0];
assign       dat_pkg_pd[16:10] =     dat_pkg_channel_size[6:0];
assign       dat_pkg_pd[23:17] =     dat_pkg_stripe_length[6:0];
assign       dat_pkg_pd[25:24] =     dat_pkg_cur_sub_h[1:0];
assign       dat_pkg_pd[26] =     dat_pkg_block_end ;
assign       dat_pkg_pd[27] =     dat_pkg_channel_end ;
assign       dat_pkg_pd[28] =     dat_pkg_group_end ;
assign       dat_pkg_pd[29] =     dat_pkg_layer_end ;
assign       dat_pkg_pd[30] =     dat_pkg_dat_release ;

always @(
  pkg_idx
  or dat_pkg_pd
  ) begin
    dat_push_data = {pkg_idx, dat_pkg_pd};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_pkg_kernel_size <= {6{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    wt_pkg_kernel_size <= cur_kernel;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    wt_pkg_kernel_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_pkg_weight_size <= {7{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    wt_pkg_weight_size <= pkg_weight_size_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    wt_pkg_weight_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_pkg_cur_sub_h <= {3{1'b0}};
  end else begin
  if ((pkg_adv) == 1'b1) begin
    wt_pkg_cur_sub_h <= cur_r;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    wt_pkg_cur_sub_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_pkg_wt_release <= 1'b0;
  end else begin
  if ((pkg_adv) == 1'b1) begin
    wt_pkg_wt_release <= ~reg2dp_skip_weight_rls & pkg_group_end_w;
  // VCS coverage off
  end else if ((pkg_adv) == 1'b0) begin
  end else begin
    wt_pkg_wt_release <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pkg_adv))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign wt_pkg_channel_end = dat_pkg_channel_end;
assign wt_pkg_group_end = dat_pkg_group_end;

// PKT_PACK_WIRE( csc_wt_pkg ,  wt_pkg_ ,  wt_pkg_pd )
assign       wt_pkg_pd[6:0] =     wt_pkg_weight_size[6:0];
assign       wt_pkg_pd[12:7] =     wt_pkg_kernel_size[5:0];
assign       wt_pkg_pd[14:13] =     wt_pkg_cur_sub_h[1:0];
assign       wt_pkg_pd[15] =     wt_pkg_channel_end ;
assign       wt_pkg_pd[16] =     wt_pkg_group_end ;
assign       wt_pkg_pd[17] =     wt_pkg_wt_release ;

always @(
  pkg_idx
  or wt_pkg_pd
  ) begin
    wt_push_data = {pkg_idx, wt_pkg_pd};
end

////////////////////////////////////////////////////////////////////////
//  package fifos                                                     //
////////////////////////////////////////////////////////////////////////

NV_NVDLA_CSC_SG_dat_fifo u_dat_fifo (
   .clk           (nvdla_core_clk)      //|< i
  ,.reset_        (nvdla_core_rstn)     //|< i
  ,.wr_ready      (dat_push_ready)      //|> w
  ,.wr_empty      (dat_push_empty)      //|> w
  ,.wr_req        (dat_push_req)        //|< r
  ,.wr_data       (dat_push_data[32:0]) //|< r
  ,.rd_ready      (dat_pop_ready)       //|< r
  ,.rd_req        (dat_pop_req)         //|> w
  ,.rd_data       (dat_pop_data[32:0])  //|> w
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );

NV_NVDLA_CSC_SG_wt_fifo u_wt_fifo (
   .clk           (nvdla_core_clk)      //|< i
  ,.reset_        (nvdla_core_rstn)     //|< i
  ,.wr_ready      (wt_push_ready)       //|> w
  ,.wr_empty      (wt_push_empty)       //|> w
  ,.wr_req        (wt_push_req)         //|< r
  ,.wr_data       (wt_push_data[19:0])  //|< r
  ,.rd_ready      (wt_pop_ready)        //|< r
  ,.rd_req        (wt_pop_req)          //|> w
  ,.rd_data       (wt_pop_data[19:0])   //|> w
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0]) //|< i
  );

always @(
  pkg_vld
  or wt_push_ready
  ) begin
    dat_push_req = pkg_vld & wt_push_ready;
end

always @(
  pkg_vld
  or dat_push_ready
  ) begin
    wt_push_req = pkg_vld & dat_push_ready;
end

////////////////////////////////////////////////////////////////////////
//  issue control logic                                               //
////////////////////////////////////////////////////////////////////////



always @(
  dat_pop_data
  ) begin
    {dat_pop_idx, dat_pop_pd} = dat_pop_data;
end

always @(
  wt_pop_data
  ) begin
    {wt_pop_idx, wt_pop_pd} = wt_pop_data;
end


// PKT_UNPACK_WIRE( csc_dat_pkg ,  sg2dat_ ,  dat_pop_pd )
assign        sg2dat_w_offset[4:0] =     dat_pop_pd[4:0];
assign        sg2dat_h_offset[4:0] =     dat_pop_pd[9:5];
assign        sg2dat_channel_size[6:0] =     dat_pop_pd[16:10];
assign        sg2dat_stripe_length[6:0] =     dat_pop_pd[23:17];
assign        sg2dat_cur_sub_h[1:0] =     dat_pop_pd[25:24];
assign         sg2dat_block_end  =     dat_pop_pd[26];
assign         sg2dat_channel_end  =     dat_pop_pd[27];
assign         sg2dat_group_end  =     dat_pop_pd[28];
assign         sg2dat_layer_end  =     dat_pop_pd[29];
assign         sg2dat_dat_release  =     dat_pop_pd[30];

// PKT_UNPACK_WIRE( csc_wt_pkg ,  sg2wt_ ,  wt_pop_pd )
assign        sg2wt_weight_size[6:0] =     wt_pop_pd[6:0];
assign        sg2wt_kernel_size[5:0] =     wt_pop_pd[12:7];
assign        sg2wt_cur_sub_h[1:0] =     wt_pop_pd[14:13];
assign         sg2wt_channel_end  =     wt_pop_pd[15];
assign         sg2wt_group_end  =     wt_pop_pd[16];
assign         sg2wt_wt_release  =     wt_pop_pd[17];

always @(
  sg2wt_kernel_size
  ) begin
    {mon_sg2wt_kernel_size_inc,
     sg2wt_kernel_size_inc} = sg2wt_kernel_size + 1'b1;
end

always @(
  sg2dat_stripe_length
  or data_batch
  ) begin
    {mon_dat_stripe_batch_size_w,
     dat_stripe_batch_size_w} = sg2dat_stripe_length * data_batch;
end

always @(
  sg2dat_stripe_length
  ) begin
    dat_stripe_img_size_w = sg2dat_stripe_length;
end

always @(
  is_img_d1
  or dat_stripe_img_size_w
  or dat_stripe_batch_size_w
  ) begin
    dat_stripe_size_w = is_img_d1 ? dat_stripe_img_size_w : {1'b0, dat_stripe_batch_size_w};
end

always @(
  is_img_d1
  or reg2dp_y_extension
  or sg2dat_stripe_length
  ) begin
    {mon_dat_stripe_img_length_w,
     dat_stripe_img_length_w} = ~is_img_d1 ? 8'b0 :
                                (reg2dp_y_extension == 2'h2) ? ((sg2dat_stripe_length + 2'h3) & 8'hfc) :
                                (reg2dp_y_extension == 2'h1) ? ((sg2dat_stripe_length + 2'h1) & 8'hfe) :
                                {1'b0, sg2dat_stripe_length};
end

always @(
  is_img_d1
  or dat_stripe_img_length_w
  or dat_stripe_batch_size_w
  ) begin
    dat_stripe_length_w = is_img_d1 ? dat_stripe_img_length_w : {1'b0, dat_stripe_batch_size_w};
end

//delay for one cycle
always @(
  dat_pop_ready
  or dat_stripe_length
  ) begin
    dat_max_cycles = ~dat_pop_ready ? 7'b0 :
                     (dat_stripe_length < 7'd10 ) ? 7'd10  :
                     dat_stripe_length;
end

always @(
  is_int8_d1
  or sg2wt_kernel_size_inc
  or sg2wt_kernel_size
  ) begin
    wt_cycles = is_int8_d1 ? sg2wt_kernel_size_inc[5:1] :
                sg2wt_kernel_size[4:0];
end

always @(
  wt_pop_ready
  or wt_cycles
  or pop_cnt
  ) begin
    wt_max_cycles = ~wt_pop_ready ? 6'b0 :
                    ((wt_cycles <= 5'b1) & (pop_cnt <= 6'b1)) ? 6'h2 :
                    ({1'b0, wt_cycles} > pop_cnt) ? {1'b0, wt_cycles} :
                    pop_cnt;
end

always @(
  dat_max_cycles
  or wt_max_cycles
  ) begin
    {mon_max_cycles,
     max_cycles} = (dat_max_cycles >= {1'b0, wt_max_cycles}) ? (dat_max_cycles - 1'b1) :
                   ({1'b0, wt_max_cycles} - 1'b1);
end

always @(
  pop_cnt
  ) begin
    {mon_pop_cnt_dec,
     pop_cnt_dec} = pop_cnt - 1'b1;
end

always @(
  dat_pop_ready
  or wt_pop_ready
  or max_cycles
  or pop_cnt
  or pop_cnt_dec
  ) begin
     pop_cnt_w = (dat_pop_ready | wt_pop_ready) ? max_cycles :
                 (pop_cnt == 6'h0) ? 6'h0 :
                 pop_cnt_dec;
end

always @(
  wt_pop_req
  or pop_cnt
  or credit_ready
  or dat_pop_idx
  or wt_pop_idx
  ) begin
    wt_pop_ready = wt_pop_req & (((pop_cnt == 6'b0) & credit_ready) | (dat_pop_idx == wt_pop_idx));
end

always @(
  dat_pop_req
  or pop_cnt
  or credit_ready
  or dat_pop_idx
  or wt_pop_idx
  or wt_pop_req
  ) begin
    dat_pop_ready = dat_pop_req & (pop_cnt == 6'b0) & credit_ready & ((dat_pop_idx != wt_pop_idx) | ~wt_pop_req);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_pop_ready_d1 <= 1'b0;
  end else begin
  wt_pop_ready_d1 <= wt_pop_ready;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_stripe_size <= {7{1'b0}};
  end else begin
  if ((wt_pop_ready_d1) == 1'b1) begin
    dat_stripe_size <= dat_stripe_size_w;
  // VCS coverage off
  end else if ((wt_pop_ready_d1) == 1'b0) begin
  end else begin
    dat_stripe_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_pop_ready_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dat_stripe_length <= {7{1'b0}};
  end else begin
  if ((wt_pop_ready_d1) == 1'b1) begin
    dat_stripe_length <= dat_stripe_length_w;
  // VCS coverage off
  end else if ((wt_pop_ready_d1) == 1'b0) begin
  end else begin
    dat_stripe_length <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_pop_ready_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pop_cnt <= {6{1'b0}};
  end else begin
  pop_cnt <= pop_cnt_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg2dl_pvld <= 1'b0;
  end else begin
  sg2dl_pvld <= dat_pop_ready;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg2dl_pd <= {31{1'b0}};
  end else begin
  if ((dat_pop_ready) == 1'b1) begin
    sg2dl_pd <= dat_pop_pd;
  // VCS coverage off
  end else if ((dat_pop_ready) == 1'b0) begin
  end else begin
    sg2dl_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_pop_ready))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sg2wl_pvld <= 1'b0;
  end else begin
  sg2wl_pvld <= wt_pop_ready;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg2wl_pd <= {18{1'b0}};
  end else begin
  if ((wt_pop_ready) == 1'b1) begin
    sg2wl_pd <= wt_pop_pd;
  // VCS coverage off
  end else if ((wt_pop_ready) == 1'b0) begin
  end else begin
    sg2wl_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_pop_ready))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! sg2wt_kernel_size_inc overflow!")      zzz_assert_never_82x (nvdla_core_clk, `ASSERT_RESET, (~is_idle & mon_sg2wt_kernel_size_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dat_stripe_batch_size_w is overflow!")      zzz_assert_never_83x (nvdla_core_clk, `ASSERT_RESET, (wt_pop_ready_d1 & (|mon_dat_stripe_batch_size_w) & ~is_img_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dat_stripe_size_w is out of range!")      zzz_assert_never_84x (nvdla_core_clk, `ASSERT_RESET, (wt_pop_ready_d1 & (dat_stripe_size_w > 7'h40))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dat_stripe_size_w is out of range when winograd!")      zzz_assert_never_85x (nvdla_core_clk, `ASSERT_RESET, (wt_pop_ready_d1 & is_winograd_d1 & (dat_stripe_size_w > 7'h20))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dat_stripe_img_length_w is overflow!")      zzz_assert_never_86x (nvdla_core_clk, `ASSERT_RESET, (wt_pop_ready_d1 & (|mon_dat_stripe_img_length_w) & is_img_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! dat_stripe_length_w is out of range!")      zzz_assert_never_87x (nvdla_core_clk, `ASSERT_RESET, (wt_pop_ready_d1 & (dat_stripe_length_w > 7'h40))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! max_cycles is overflow!")      zzz_assert_never_88x (nvdla_core_clk, `ASSERT_RESET, ((wt_pop_ready | dat_pop_ready) & (|mon_max_cycles))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_pop_req valid when data_pop_req not!")      zzz_assert_never_89x (nvdla_core_clk, `ASSERT_RESET, (~dat_pop_req & wt_pop_req)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_pop_req not valid when group_end not set!")      zzz_assert_never_90x (nvdla_core_clk, `ASSERT_RESET, (~wt_pop_req & dat_pop_req & ~sg2dat_group_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//  credit controll logic                                             //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//


//flop credit signal because it cross partition boundary
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    credit_vld <= 1'b0;
  end else begin
  credit_vld <= accu2sc_credit_vld;
  end
end
always @(posedge nvdla_core_ng_clk) begin
  if ((accu2sc_credit_vld) == 1'b1) begin
    credit_size <= accu2sc_credit_size;
  // VCS coverage off
  end else if ((accu2sc_credit_vld) == 1'b0) begin
  end else begin
    credit_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(
  is_winograd_d1
  or is_int8_d1
  or dat_stripe_size
  ) begin
    dat_impact_cnt = (is_winograd_d1 & is_int8_d1) ? {dat_stripe_size[5:0], 3'b0} :
                     (is_winograd_d1 & ~is_int8_d1) ? {1'b0, dat_stripe_size[5:0], 2'b0} :
                     (~is_winograd_d1 & is_int8_d1) ? {1'b0, dat_stripe_size, 1'b0} :
                     {2'b0, dat_stripe_size};
end

always @(
  dat_impact_cnt
  or batch_delta
  ) begin
    {mon_credit_req_size,
     credit_req_size} = dat_impact_cnt + batch_delta;
end

always @(
  credit_vld
  or credit_size
  ) begin
    credit_cnt_add = credit_vld ? credit_size : 4'b0;
end

always @(
  dat_pop_ready
  or sg2dat_channel_end
  or dat_impact_cnt
  ) begin
    credit_cnt_dec = (dat_pop_ready & sg2dat_channel_end) ? dat_impact_cnt : 9'b0;
end

always @(
  credit_cnt
  or credit_cnt_add
  or credit_cnt_dec
  ) begin
    {mon_credit_cnt_w,
     credit_cnt_w} = credit_cnt + credit_cnt_add - credit_cnt_dec;
end

always @(
  sg2dat_channel_end
  or credit_cnt
  or credit_req_size
  ) begin
    credit_ready = ~sg2dat_channel_end | (credit_cnt >= credit_req_size);
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    credit_cnt <= 9'h100;
  end else begin
  if ((dat_pop_ready | credit_vld) == 1'b1) begin
    credit_cnt <= credit_cnt_w;
  // VCS coverage off
  end else if ((dat_pop_ready | credit_vld) == 1'b0) begin
  end else begin
    credit_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(dat_pop_ready | credit_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! credit count overflow!")      zzz_assert_never_92x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_idle & mon_credit_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! credit count out of range!")      zzz_assert_never_93x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_idle && (credit_cnt > 9'h100 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! credit_req_size is overflow!")      zzz_assert_never_94x (nvdla_core_ng_clk, `ASSERT_RESET, (is_running & mon_credit_req_size)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  convolution buffer local status                                   //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//



always @(
  pkg_adv
  or pkg_layer_end_w
  or reg2dp_skip_data_rls
  ) begin
    dat_release = pkg_adv & pkg_layer_end_w & ~reg2dp_skip_data_rls;
end

always @(
  is_idle
  or reg2dp_op_en
  or reg2dp_data_reuse
  or is_mode_change
  or last_slices
  ) begin
    dat_reuse_release = is_idle & reg2dp_op_en & (~reg2dp_data_reuse | is_mode_change) & (|last_slices);
end

always @(
  cdma2sc_dat_updt
  or cdma2sc_dat_slices
  ) begin
    slices_avl_add = cdma2sc_dat_updt ? cdma2sc_dat_slices : 12'b0;
end

always @(
  dat_release
  or rls_slices
  or dat_reuse_release
  or last_slices
  ) begin
    slices_avl_sub = dat_release ? rls_slices :
                     dat_reuse_release ? last_slices[12 -1:0] :
                     12'b0;
end

always @(
  dat_pending_req
  or slices_avl
  or slices_avl_add
  or slices_avl_sub
  ) begin
    {mon_slices_avl_w,
     slices_avl_w} = (dat_pending_req) ? 14'b0 :
                     (slices_avl + slices_avl_add - slices_avl_sub);
end

always @(
  pkg_adv
  or reg2dp_skip_weight_rls
  or pkg_group_end_w
  ) begin
    wt_release = pkg_adv & ~reg2dp_skip_weight_rls & pkg_group_end_w;
end

always @(
  is_idle
  or reg2dp_op_en
  or reg2dp_weight_reuse
  or last_skip_weight_rls
  ) begin
    wt_reuse_release = is_idle & reg2dp_op_en & ~reg2dp_weight_reuse & last_skip_weight_rls;
end

always @(
  cdma2sc_wt_updt
  or cdma2sc_wt_kernels
  ) begin
    kernels_avl_add = cdma2sc_wt_updt ? cdma2sc_wt_kernels : 14'b0;
end

always @(
  wt_release
  or cur_kernel
  or wt_reuse_release
  or last_kernels
  ) begin
    kernels_avl_sub = wt_release ? {{8{1'b0}}, cur_kernel} :
                      wt_reuse_release ? last_kernels[13:0] :
                      14'b0;
end

always @(
  wt_pending_req
  or kernels_avl
  or kernels_avl_add
  or kernels_avl_sub
  ) begin
    {mon_kernels_avl_w,
     kernels_avl_w} = (wt_pending_req) ? 15'b0 :
                      kernels_avl + kernels_avl_add - kernels_avl_sub;
end

always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slices_avl <= {12{1'b0}};
  end else begin
  if ((dat_pending_req | dat_release | dat_reuse_release | cdma2sc_dat_updt) == 1'b1) begin
    slices_avl <= slices_avl_w;
  // VCS coverage off
  end else if ((dat_pending_req | dat_release | dat_reuse_release | cdma2sc_dat_updt) == 1'b0) begin
  end else begin
    slices_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(dat_pending_req | dat_release | dat_reuse_release | cdma2sc_dat_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    kernels_avl <= {15{1'b0}};
  end else begin
  if ((wt_pending_req | wt_release | wt_reuse_release | cdma2sc_wt_updt) == 1'b1) begin
    kernels_avl <= kernels_avl_w;
  // VCS coverage off
  end else if ((wt_pending_req | wt_release | wt_reuse_release | cdma2sc_wt_updt) == 1'b0) begin
  end else begin
    kernels_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(wt_pending_req | wt_release | wt_reuse_release | cdma2sc_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sg2dl_reuse_rls <= 1'b0;
  end else begin
  sg2dl_reuse_rls <= dat_reuse_release;
  end
end
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sg2wl_reuse_rls <= 1'b0;
  end else begin
  sg2wl_reuse_rls <= wt_reuse_release;
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
  nv_assert_never #(0,0,"Error! Available slices overflow")      zzz_assert_never_97x (nvdla_core_ng_clk, `ASSERT_RESET, (~is_idle & (|mon_slices_avl_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Available kernels overflow")      zzz_assert_never_98x (nvdla_core_ng_clk, `ASSERT_RESET, ((wt_pending_req | wt_release | wt_reuse_release | cdma2sc_wt_updt) & mon_kernels_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//================  Non-SLCG clock domain end ================//

// ////////////////////////////////////////////////////////////////////////
// //  OBS connection                                                    //
// ////////////////////////////////////////////////////////////////////////
// assign obs_bus_csc_sg2dl_pvld         = sg2dl_pvld;
// assign obs_bus_csc_sg2dl_pd           = sg2dl_pd[28:0];
// assign obs_bus_csc_sg2dl_reuse_rls    = sg2dl_reuse_rls;
// assign obs_bus_csc_sg2wl_reuse_rls    = sg2wl_reuse_rls;
// assign obs_bus_csc_sg2wl_pvld         = sg2wl_pvld;
// assign obs_bus_csc_sg2wl_pd           = sg2wl_pd;
// assign obs_bus_csc_accu2sc_credit_vld = accu2sc_credit_vld;
// assign obs_bus_csc_dat_push_req       = dat_push_req;
// assign obs_bus_csc_dat_push_ready     = dat_push_ready;
// assign obs_bus_csc_dat_push_empty     = dat_push_empty;
// assign obs_bus_csc_dat_pop_req        = dat_pop_req;
// assign obs_bus_csc_dat_pop_ready      = dat_pop_ready;
// assign obs_bus_csc_wt_push_req        = wt_push_req;
// assign obs_bus_csc_wt_push_ready      = wt_push_ready;
// assign obs_bus_csc_wt_push_empty      = wt_push_empty;
// assign obs_bus_csc_wt_pop_req         = wt_pop_req;
// assign obs_bus_csc_wt_pop_ready       = wt_pop_ready;
// assign obs_bus_csc_cur_state          = cur_state;
// assign obs_bus_csc_nxt_state          = nxt_state;
// assign obs_bus_csc_dat_cbuf_ready     = dat_cbuf_ready;
// assign obs_bus_csc_wt_cbuf_ready      = wt_cbuf_ready;

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           pkg_idx
//                           {layer_done,pkg_vld}
//                           {dat_pkg_block_end,dat_pkg_channel_end}
//                           {dat_pkg_group_end,dat_pkg_layer_end} 
//                           {dat_pkg_layer_end,wt_pkg_wt_release}
//                           pop_cnt[1:0]
//                           {wt_pop_ready_d1,credit_vld}
//                           {sg2dl_pvld,sg2wl_pvld}
//                           {sg2dl_reuse_rls,sg2wl_reuse_rls};

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////
assign dbg_cur_prec = reg2dp_proc_precision;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_pre_prec <= {2{1'b1}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  dbg_pre_prec <= reg2dp_proc_precision;
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

    property csc_sg__dat_push_not_ready__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (pkg_vld & ~dat_push_ready & wt_push_ready);
    endproperty
    // Cover 0 : "(pkg_vld & ~dat_push_ready & wt_push_ready)"
    FUNCPOINT_csc_sg__dat_push_not_ready__0_COV : cover property (csc_sg__dat_push_not_ready__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__data_update_release_same_time__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (cdma2sc_dat_updt & dat_release);
    endproperty
    // Cover 1 : "(cdma2sc_dat_updt & dat_release)"
    FUNCPOINT_csc_sg__data_update_release_same_time__1_COV : cover property (csc_sg__data_update_release_same_time__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__weight_update_release_same_time__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (cdma2sc_wt_updt & wt_release);
    endproperty
    // Cover 2 : "(cdma2sc_wt_updt & wt_release)"
    FUNCPOINT_csc_sg__weight_update_release_same_time__2_COV : cover property (csc_sg__weight_update_release_same_time__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__dat_pop_credit_invalid__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dat_pop_req & (pop_cnt == 6'b0) & ~credit_ready & ((dat_pop_idx != wt_pop_idx) | ~wt_pop_req));
    endproperty
    // Cover 3 : "(dat_pop_req & (pop_cnt == 6'b0) & ~credit_ready & ((dat_pop_idx != wt_pop_idx) | ~wt_pop_req))"
    FUNCPOINT_csc_sg__dat_pop_credit_invalid__3_COV : cover property (csc_sg__dat_pop_credit_invalid__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__wt_pop_credit_invalid__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (wt_pop_req & ((pop_cnt == 6'b0) & ~credit_ready) & (dat_pop_idx != wt_pop_idx));
    endproperty
    // Cover 4 : "(wt_pop_req & ((pop_cnt == 6'b0) & ~credit_ready) & (dat_pop_idx != wt_pop_idx))"
    FUNCPOINT_csc_sg__wt_pop_credit_invalid__4_COV : cover property (csc_sg__wt_pop_credit_invalid__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__wt_pop_forward__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (wt_pop_ready & (pop_cnt != 6'b0));
    endproperty
    // Cover 5 : "(wt_pop_ready & (pop_cnt != 6'b0))"
    FUNCPOINT_csc_sg__wt_pop_forward__5_COV : cover property (csc_sg__wt_pop_forward__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_sg__layer_mode_precision_switch_EQ_0__6_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_0 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_0__6_0_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_0__6_0_cov);

    property csc_sg__layer_mode_precision_switch_EQ_1__6_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_1 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_1__6_1_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_1__6_1_cov);

    property csc_sg__layer_mode_precision_switch_EQ_2__6_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_2 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_2__6_2_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_2__6_2_cov);

    property csc_sg__layer_mode_precision_switch_EQ_3__6_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_3 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_3__6_3_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_3__6_3_cov);

    property csc_sg__layer_mode_precision_switch_EQ_4__6_4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_4 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_4__6_4_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_4__6_4_cov);

    property csc_sg__layer_mode_precision_switch_EQ_5__6_5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_5 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_5__6_5_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_5__6_5_cov);

    property csc_sg__layer_mode_precision_switch_EQ_6__6_6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_6 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_6__6_6_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_6__6_6_cov);

    property csc_sg__layer_mode_precision_switch_EQ_7__6_7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_7 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_7__6_7_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_7__6_7_cov);

    property csc_sg__layer_mode_precision_switch_EQ_8__6_8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_8 : "(last_mode == 3'h1) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_8__6_8_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_8__6_8_cov);

    property csc_sg__layer_mode_precision_switch_EQ_9__6_9_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_9 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_9__6_9_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_9__6_9_cov);

    property csc_sg__layer_mode_precision_switch_EQ_10__6_10_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_10 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_10__6_10_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_10__6_10_cov);

    property csc_sg__layer_mode_precision_switch_EQ_11__6_11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_11 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_11__6_11_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_11__6_11_cov);

    property csc_sg__layer_mode_precision_switch_EQ_12__6_12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_12 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_12__6_12_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_12__6_12_cov);

    property csc_sg__layer_mode_precision_switch_EQ_13__6_13_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_13 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_13__6_13_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_13__6_13_cov);

    property csc_sg__layer_mode_precision_switch_EQ_14__6_14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_14 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_14__6_14_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_14__6_14_cov);

    property csc_sg__layer_mode_precision_switch_EQ_15__6_15_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_15 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_15__6_15_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_15__6_15_cov);

    property csc_sg__layer_mode_precision_switch_EQ_16__6_16_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_16 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_16__6_16_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_16__6_16_cov);

    property csc_sg__layer_mode_precision_switch_EQ_17__6_17_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_17 : "(last_mode == 3'h1) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_17__6_17_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_17__6_17_cov);

    property csc_sg__layer_mode_precision_switch_EQ_18__6_18_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_18 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_18__6_18_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_18__6_18_cov);

    property csc_sg__layer_mode_precision_switch_EQ_19__6_19_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_19 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_19__6_19_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_19__6_19_cov);

    property csc_sg__layer_mode_precision_switch_EQ_20__6_20_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_20 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_20__6_20_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_20__6_20_cov);

    property csc_sg__layer_mode_precision_switch_EQ_21__6_21_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_21 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_21__6_21_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_21__6_21_cov);

    property csc_sg__layer_mode_precision_switch_EQ_22__6_22_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_22 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_22__6_22_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_22__6_22_cov);

    property csc_sg__layer_mode_precision_switch_EQ_23__6_23_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_23 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_23__6_23_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_23__6_23_cov);

    property csc_sg__layer_mode_precision_switch_EQ_24__6_24_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_24 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_24__6_24_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_24__6_24_cov);

    property csc_sg__layer_mode_precision_switch_EQ_25__6_25_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_25 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_25__6_25_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_25__6_25_cov);

    property csc_sg__layer_mode_precision_switch_EQ_26__6_26_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_26 : "(last_mode == 3'h1) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_26__6_26_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_26__6_26_cov);

    property csc_sg__layer_mode_precision_switch_EQ_27__6_27_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_27 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_27__6_27_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_27__6_27_cov);

    property csc_sg__layer_mode_precision_switch_EQ_28__6_28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_28 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_28__6_28_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_28__6_28_cov);

    property csc_sg__layer_mode_precision_switch_EQ_29__6_29_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_29 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_29__6_29_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_29__6_29_cov);

    property csc_sg__layer_mode_precision_switch_EQ_30__6_30_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_30 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_30__6_30_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_30__6_30_cov);

    property csc_sg__layer_mode_precision_switch_EQ_31__6_31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_31 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_31__6_31_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_31__6_31_cov);

    property csc_sg__layer_mode_precision_switch_EQ_32__6_32_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_32 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_32__6_32_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_32__6_32_cov);

    property csc_sg__layer_mode_precision_switch_EQ_33__6_33_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_33 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_33__6_33_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_33__6_33_cov);

    property csc_sg__layer_mode_precision_switch_EQ_34__6_34_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_34 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_34__6_34_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_34__6_34_cov);

    property csc_sg__layer_mode_precision_switch_EQ_35__6_35_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_35 : "(last_mode == 3'h2) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_35__6_35_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_35__6_35_cov);

    property csc_sg__layer_mode_precision_switch_EQ_36__6_36_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_36 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_36__6_36_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_36__6_36_cov);

    property csc_sg__layer_mode_precision_switch_EQ_37__6_37_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_37 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_37__6_37_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_37__6_37_cov);

    property csc_sg__layer_mode_precision_switch_EQ_38__6_38_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_38 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_38__6_38_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_38__6_38_cov);

    property csc_sg__layer_mode_precision_switch_EQ_39__6_39_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_39 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_39__6_39_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_39__6_39_cov);

    property csc_sg__layer_mode_precision_switch_EQ_40__6_40_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_40 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_40__6_40_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_40__6_40_cov);

    property csc_sg__layer_mode_precision_switch_EQ_41__6_41_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_41 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_41__6_41_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_41__6_41_cov);

    property csc_sg__layer_mode_precision_switch_EQ_42__6_42_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_42 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_42__6_42_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_42__6_42_cov);

    property csc_sg__layer_mode_precision_switch_EQ_43__6_43_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_43 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_43__6_43_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_43__6_43_cov);

    property csc_sg__layer_mode_precision_switch_EQ_44__6_44_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_44 : "(last_mode == 3'h2) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_44__6_44_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_44__6_44_cov);

    property csc_sg__layer_mode_precision_switch_EQ_45__6_45_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_45 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_45__6_45_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_45__6_45_cov);

    property csc_sg__layer_mode_precision_switch_EQ_46__6_46_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_46 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_46__6_46_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_46__6_46_cov);

    property csc_sg__layer_mode_precision_switch_EQ_47__6_47_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_47 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_47__6_47_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_47__6_47_cov);

    property csc_sg__layer_mode_precision_switch_EQ_48__6_48_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_48 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_48__6_48_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_48__6_48_cov);

    property csc_sg__layer_mode_precision_switch_EQ_49__6_49_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_49 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_49__6_49_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_49__6_49_cov);

    property csc_sg__layer_mode_precision_switch_EQ_50__6_50_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_50 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_50__6_50_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_50__6_50_cov);

    property csc_sg__layer_mode_precision_switch_EQ_51__6_51_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_51 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_51__6_51_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_51__6_51_cov);

    property csc_sg__layer_mode_precision_switch_EQ_52__6_52_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_52 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_52__6_52_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_52__6_52_cov);

    property csc_sg__layer_mode_precision_switch_EQ_53__6_53_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_53 : "(last_mode == 3'h2) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_53__6_53_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_53__6_53_cov);

    property csc_sg__layer_mode_precision_switch_EQ_54__6_54_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_54 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_54__6_54_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_54__6_54_cov);

    property csc_sg__layer_mode_precision_switch_EQ_55__6_55_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_55 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_55__6_55_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_55__6_55_cov);

    property csc_sg__layer_mode_precision_switch_EQ_56__6_56_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_56 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_56__6_56_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_56__6_56_cov);

    property csc_sg__layer_mode_precision_switch_EQ_57__6_57_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_57 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_57__6_57_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_57__6_57_cov);

    property csc_sg__layer_mode_precision_switch_EQ_58__6_58_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_58 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_58__6_58_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_58__6_58_cov);

    property csc_sg__layer_mode_precision_switch_EQ_59__6_59_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_59 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_59__6_59_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_59__6_59_cov);

    property csc_sg__layer_mode_precision_switch_EQ_60__6_60_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_60 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_60__6_60_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_60__6_60_cov);

    property csc_sg__layer_mode_precision_switch_EQ_61__6_61_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_61 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_61__6_61_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_61__6_61_cov);

    property csc_sg__layer_mode_precision_switch_EQ_62__6_62_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_62 : "(last_mode == 3'h4) && (cur_mode == 3'h1) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_62__6_62_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_62__6_62_cov);

    property csc_sg__layer_mode_precision_switch_EQ_63__6_63_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_63 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_63__6_63_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_63__6_63_cov);

    property csc_sg__layer_mode_precision_switch_EQ_64__6_64_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_64 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_64__6_64_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_64__6_64_cov);

    property csc_sg__layer_mode_precision_switch_EQ_65__6_65_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_65 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_65__6_65_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_65__6_65_cov);

    property csc_sg__layer_mode_precision_switch_EQ_66__6_66_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_66 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_66__6_66_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_66__6_66_cov);

    property csc_sg__layer_mode_precision_switch_EQ_67__6_67_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_67 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_67__6_67_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_67__6_67_cov);

    property csc_sg__layer_mode_precision_switch_EQ_68__6_68_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_68 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_68__6_68_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_68__6_68_cov);

    property csc_sg__layer_mode_precision_switch_EQ_69__6_69_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_69 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_69__6_69_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_69__6_69_cov);

    property csc_sg__layer_mode_precision_switch_EQ_70__6_70_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_70 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_70__6_70_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_70__6_70_cov);

    property csc_sg__layer_mode_precision_switch_EQ_71__6_71_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_71 : "(last_mode == 3'h4) && (cur_mode == 3'h2) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_71__6_71_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_71__6_71_cov);

    property csc_sg__layer_mode_precision_switch_EQ_72__6_72_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_72 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_72__6_72_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_72__6_72_cov);

    property csc_sg__layer_mode_precision_switch_EQ_73__6_73_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_73 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_73__6_73_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_73__6_73_cov);

    property csc_sg__layer_mode_precision_switch_EQ_74__6_74_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_74 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h0) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_74__6_74_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_74__6_74_cov);

    property csc_sg__layer_mode_precision_switch_EQ_75__6_75_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_75 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_75__6_75_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_75__6_75_cov);

    property csc_sg__layer_mode_precision_switch_EQ_76__6_76_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_76 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_76__6_76_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_76__6_76_cov);

    property csc_sg__layer_mode_precision_switch_EQ_77__6_77_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_77 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h1) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_77__6_77_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_77__6_77_cov);

    property csc_sg__layer_mode_precision_switch_EQ_78__6_78_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0));
    endproperty
    // Cover 6_78 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h0)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_78__6_78_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_78__6_78_cov);

    property csc_sg__layer_mode_precision_switch_EQ_79__6_79_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1));
    endproperty
    // Cover 6_79 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h1)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_79__6_79_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_79__6_79_cov);

    property csc_sg__layer_mode_precision_switch_EQ_80__6_80_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((layer_st) && nvdla_core_rstn) |-> ((last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2));
    endproperty
    // Cover 6_80 : "(last_mode == 3'h4) && (cur_mode == 3'h4) && (dbg_pre_prec == 2'h2) && (dbg_cur_prec == 2'h2)"
    FUNCPOINT_csc_sg__layer_mode_precision_switch_EQ_80__6_80_COV : cover property (csc_sg__layer_mode_precision_switch_EQ_80__6_80_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CSC_sg


