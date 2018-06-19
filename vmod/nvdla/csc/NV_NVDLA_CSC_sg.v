// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_sg.v

#include "NV_NVDLA_CSC.h"

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

input  nvdla_core_clk;   /* done_dp2reg, dat_up_cdma2sc, wt_up_cdma2sc, sg2dl_pkg, sg2wl_pkg, accu2sc_credit, sc_state, sc2cdma_dat_pending, sc2cdma_wt_pending, cdma2sc_dat_pending, cdma2sc_wt_pending, sg2dl_reuse, sg2wl_reuse */
input  nvdla_core_rstn;  /* done_dp2reg, dat_up_cdma2sc, wt_up_cdma2sc, sg2dl_pkg, sg2wl_pkg, accu2sc_credit, sc_state, sc2cdma_dat_pending, sc2cdma_wt_pending, cdma2sc_dat_pending, cdma2sc_wt_pending, sg2dl_reuse, sg2wl_reuse */

input [31:0] pwrbus_ram_pd;
output  dp2reg_done;

input        cdma2sc_dat_updt;     /* data valid */
input [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_dat_entries;
input [13:0] cdma2sc_dat_slices;

input        cdma2sc_wt_updt;      /* data valid */
input [13:0] cdma2sc_wt_kernels;
input [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_wt_entries;
input  [8:0] cdma2sc_wmb_entries;

output        sg2dl_pvld;  /* data valid */
output [30:0] sg2dl_pd;
output        sg2wl_pvld;  /* data valid */
output [17:0] sg2wl_pd;
input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;
output [1:0] sc_state;
output  sc2cdma_dat_pending_req;   //send sg pending to cdma
output  sc2cdma_wt_pending_req;
input  cdma2sc_dat_pending_ack;   //cdma tould sg to clr pending
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
input [4:0]                       reg2dp_data_bank;
input [4:0]                     reg2dp_weight_bank;
input [20:0]                      reg2dp_atomics;
input [11:0]                   reg2dp_rls_slices;

reg     [6:0] batch_delta;
reg    [13:0] channel_up_cnt;
reg     [8:0] credit_cnt;
reg     [2:0] credit_size;
reg           credit_vld;
reg     [1:0] cur_state;
reg           dat_pending_ack;
reg           dat_pending_clr;
reg           dat_pending_req;
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
wire    [30:0] dat_pop_pd;
reg     [6:0] dat_stripe_length;
reg     [6:0] dat_stripe_size;
reg     [5:0] data_batch;
reg    [13:0] data_in_height;
reg    [21:0] data_out_atomic;
reg    [12:0] dataout_h_up_cnt;
reg     [1:0] dbg_pre_prec;
reg           dp2reg_done;
reg     [7:0] flush_cycles;
reg     [9:0] group_up_cnt;
reg           is_img_d1;
#ifdef NVDLA_WINOGRAD_ENABLE
reg           is_winograd_d1;
#endif
reg    [14:0] kernels_avl;
reg     [4:0] last_data_bank;
reg    [13:0] last_kernels;
reg     [2:0] last_mode;
reg           last_skip_weight_rls;
reg    [13:0] last_slices;
reg     [4:0] last_weight_bank;
reg           layer_done;
reg     [6:0] lower_limit;
reg     [1:0] nxt_state;
reg     [1:0] pkg_idx;
reg           pkg_vld;
reg     [5:0] pop_cnt;
reg    [13:0] required_kernels;
reg    [13:0] rls_slices;
reg    [30:0] sg2dl_pd;
reg           sg2dl_pvld;
reg           sg2dl_reuse_rls;
reg    [17:0] sg2wl_pd;
reg           sg2wl_pvld;
reg           sg2wl_reuse_rls;
reg     [7:0] sg_dn_cnt;
reg    [13:0] slice_left;
reg    [13:0] slices_avl;
reg    [21:0] stripe_up_cnt;
reg     [6:0] upper_limit;
reg    [13:0] weight_channel;
reg     [9:0] weight_groups;
reg     [4:0] weight_height_cmp;
reg     [2:0] weight_r_add;
reg     [2:0] weight_r_last;
reg     [4:0] weight_r_up_cnt;
reg     [4:0] weight_s_up_cnt;
reg     [4:0] weight_width_cmp;
reg           wt_pending_ack;
reg           wt_pending_clr;
reg           wt_pending_req;
reg     [2:0] wt_pkg_cur_sub_h;
reg     [6:0] wt_pkg_kernel_size;
reg     [6:0] wt_pkg_weight_size;
reg           wt_pkg_wt_release;
wire    [17:0] wt_pop_pd;
reg           wt_pop_ready_d1;
wire    [7:0] c_fetch_size;
wire          cbuf_ready;
wire   [13:0] channel_up_cnt_inc;
wire   [13:0] channel_up_cnt_w;
wire    [3:0] credit_cnt_add;
wire    [8:0] credit_cnt_dec;
wire    [8:0] credit_cnt_w;
wire          credit_ready;
wire    [8:0] credit_req_size;
wire    [6:0] cur_channel;
wire    [6:0] cur_kernel;
wire    [2:0] cur_mode;
wire    [2:0] cur_r;
wire    [6:0] cur_stripe;
wire    [6:0] cur_stripe_inc;
wire          dat_bank_change;
wire          dat_cbuf_ready;
wire    [8:0] dat_impact_cnt;
wire    [6:0] dat_max_cycles;
wire          dat_pending_clr_w;
wire          dat_pending_req_w;
wire   [30:0] dat_pkg_pd;
wire   [32:0] dat_pop_data;
wire    [1:0] dat_pop_idx;
wire          dat_pop_ready;
wire          dat_pop_req;
wire   [32:0] dat_push_data;
wire          dat_push_empty;
wire          dat_push_ready;
wire          dat_push_req;
wire          dat_release;
wire          dat_reuse_release;
wire    [6:0] dat_stripe_batch_size_w;
wire    [6:0] dat_stripe_img_length_w;
wire    [6:0] dat_stripe_img_size_w;
wire    [6:0] dat_stripe_length_w;
wire    [6:0] dat_stripe_size_w;
wire    [5:0] data_batch_w;
wire   [13:0] data_in_height_w;
wire   [21:0] data_out_atomic_w;
wire   [12:0] dataout_h_up_cnt_w;
wire    [1:0] dbg_cur_prec;
wire          fifo_is_clear;
wire          fifo_push_ready;
wire    [7:0] flush_cycles_w;
wire    [9:0] group_up_cnt_inc;
wire    [9:0] group_up_cnt_w;
wire          is_conv;
wire          is_dc;
wire          is_done;
wire          is_idle;
wire          is_img;
wire          is_last_block;
wire          is_last_channel;
wire          is_last_do_h;
wire          is_last_group;
wire          is_last_r;
wire          is_last_s;
wire          is_last_stripe;
wire          is_mode_change;
wire          is_nxt_done;
wire          is_nxt_pending;
wire          is_pending;
wire          is_pixel;
wire          is_running;
wire          is_stripe_be_2x;
wire          is_stripe_le_1x;
#ifdef NVDLA_WINOGRAD_ENABLE
wire          is_winograd;
#endif
wire   [13:0] kernels_avl_add;
wire   [13:0] kernels_avl_sub;
wire   [14:0] kernels_avl_w;
wire          layer_done_w;
wire          layer_st;
wire    [6:0] lower_limit_w;
wire    [5:0] max_cycles;
wire          mon_channel_up_cnt_inc;
wire          mon_credit_cnt_w;
wire   [15:0] mon_cur_stripe_inc;
wire    [5:0] mon_dat_stripe_batch_size_w;
wire          mon_dat_stripe_img_length_w;
wire          mon_dataout_h_up_cnt_w;
wire          mon_group_up_cnt_inc;
wire    [0:0] mon_kernels_avl_w;
wire    [1:0] mon_max_cycles;
wire          mon_pkg_idx_w;
wire          mon_pop_cnt_dec;
wire          mon_required_kernels_inc;
wire          mon_rls_slices_w;
wire          mon_sg2wt_kernel_size_inc;
wire          mon_sg_dn_cnt_w;
wire    [1:0] mon_slice_left_w;
wire    [1:0] mon_slices_avl_w;
wire          mon_stripe_up_cnt_2x_inc;
wire          mon_stripe_up_cnt_1x_inc;
wire          mon_stripe_up_cnt_w;
wire    [2:0] mon_weight_r_add_w;
wire          mon_weight_s_up_cnt_inc;
wire          need_pending;
wire          op_channel_en;
wire          op_do_h_en;
wire          op_group_en;
wire          op_layer_en;
wire          op_r_en;
wire          op_s_en;
wire          op_stripe_en;
wire          pending_done;
wire          pkg_adv;
wire          pkg_block_end_w;
wire          pkg_channel_end_w;
wire          pkg_group_end_w;
wire    [1:0] pkg_idx_w;
wire          pkg_layer_end_w;
wire          pkg_vld_w;
wire    [6:0] pkg_weight_size_w;
wire    [5:0] pop_cnt_dec;
wire    [5:0] pop_cnt_w;
wire   [13:0] required_kernels_inc;
wire   [13:0] required_kernels_w;
wire   [13:0] rls_slices_w;
wire    [1:0] sc_state;
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
wire    [5:0] sg2wt_kernel_size_inc;
wire    [6:0] sg2wt_weight_size;
wire          sg2wt_wt_release;
wire    [7:0] sg_dn_cnt_w;
wire   [13:0] slice_left_w;
wire   [13:0] slices_avl_add;
wire   [13:0] slices_avl_sub;
wire   [13:0] slices_avl_w;
wire    [6:0] stripe_length_w;
wire   [21:0] stripe_up_cnt_2x_inc;
wire   [21:0] stripe_up_cnt_1x_inc;
wire   [21:0] stripe_up_cnt_w;
wire    [6:0] upper_limit_w;
wire   [13:0] weight_channel_w;
wire    [9:0] weight_groups_w;
wire    [4:0] weight_height_cmp_w;
wire    [2:0] weight_r_add_w;
wire    [2:0] weight_r_last_w;
wire    [5:0] weight_r_up_cnt_inc;
wire    [4:0] weight_r_up_cnt_w;
wire    [4:0] weight_s_up_cnt_inc;
wire    [4:0] weight_s_up_cnt_w;
wire    [4:0] weight_width_cmp_w;
wire          wt_bank_change;
wire          wt_cbuf_ready;
wire    [5:0] wt_cycles;
wire    [5:0] wt_max_cycles;
wire          wt_pending_clr_w;
wire          wt_pending_req_w;
wire          wt_pkg_channel_end;
wire          wt_pkg_group_end;
wire   [17:0] wt_pkg_pd;
wire   [19:0] wt_pop_data;
wire    [1:0] wt_pop_idx;
wire          wt_pop_ready;
wire          wt_pop_req;
wire   [19:0] wt_push_data;
wire          wt_push_empty;
wire          wt_push_ready;
wire          wt_push_req;
wire          wt_release;
wire          wt_reuse_release;

////////////////////////////////////////////////////////////////////////
// CSC control FSM                                                    //
////////////////////////////////////////////////////////////////////////
localparam SG_STATE_IDLE = 2'b00;
localparam SG_STATE_PEND = 2'b01;
localparam SG_STATE_BUSY = 2'b10;
localparam SG_STATE_DONE = 2'b11;

//## fsm (1) com block

always @ (*) begin
    nxt_state = cur_state;
    begin
        casez (cur_state)
        SG_STATE_IDLE: begin
            if ((reg2dp_op_en & need_pending)) begin
                nxt_state = SG_STATE_PEND; 
            end
            else if (reg2dp_op_en) begin
                nxt_state = SG_STATE_BUSY; 
            end
        end
        SG_STATE_PEND: begin
            if (pending_done) begin
                nxt_state = SG_STATE_BUSY; 
            end
        end
        SG_STATE_BUSY: begin
            if (layer_done & fifo_is_clear & ~pkg_vld) begin
                nxt_state = SG_STATE_DONE; 
            end
        end
        SG_STATE_DONE: begin
            if (dp2reg_done) begin
                nxt_state = SG_STATE_IDLE; 
            end
        end
        endcase
    end
end

//: &eperl::flop("-nodeclare   -rval \"SG_STATE_IDLE\"   -d \"nxt_state\" -q cur_state");


////////////////////////////////////////////////////////////////////////
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////
assign fifo_is_clear    = ~dat_pop_req & ~wt_pop_req & dat_push_empty & wt_push_empty;
assign dat_bank_change  = (last_data_bank != reg2dp_data_bank);
assign wt_bank_change   = (last_weight_bank != reg2dp_weight_bank);
assign need_pending     = (dat_bank_change | wt_bank_change);
assign pending_done     = is_pending & (dat_pending_clr ~^ dat_pending_req) & (wt_pending_clr ~^ wt_pending_req);
assign flush_cycles_w   = dat_stripe_size + CSC_SG_DONE_FLUSH ;
assign {mon_sg_dn_cnt_w, sg_dn_cnt_w} = (~is_done & is_nxt_done) ? {1'b0, flush_cycles} : sg_dn_cnt - 1'b1;

//: &eperl::flop("-nodeclare   -rval \"{8{1'b0}}\"  -en \"is_nxt_done\" -d \"sg_dn_cnt_w\" -q sg_dn_cnt");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"cdma2sc_dat_pending_ack\" -q dat_pending_ack");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"cdma2sc_wt_pending_ack\" -q wt_pending_ack");
//: &eperl::flop("-nodeclare   -rval \"{8{1'b0}}\"  -en \"dat_pop_req & dat_pop_ready & sg2dat_layer_end\" -d \"flush_cycles_w\" -q flush_cycles");

////////////////////////////////////////////////////////////////////////
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////
assign layer_st         = reg2dp_op_en && (cur_state == SG_STATE_IDLE);
assign is_idle          = (cur_state == SG_STATE_IDLE);
assign is_pending       = (cur_state == SG_STATE_PEND);
assign is_running       = (cur_state == SG_STATE_BUSY);
assign is_done          = (cur_state == SG_STATE_DONE);
assign is_nxt_done      = (nxt_state == SG_STATE_DONE);
assign is_nxt_pending   = (nxt_state == SG_STATE_PEND);
assign sc_state         = is_idle ? 0  : is_pending ? 1  : is_running ? 2  : 3 ;
assign dat_pending_req_w= (is_nxt_pending & dat_bank_change) ? 1'b1 : (~is_nxt_pending) ? 1'b0 : dat_pending_req;
assign wt_pending_req_w = (is_nxt_pending) ? 1'b1 : (~is_nxt_pending) ? 1'b0 : wt_pending_req;
assign is_mode_change   = (last_mode != cur_mode);
assign dat_pending_clr_w= (is_pending & dat_pending_ack) ? 1'b1 : ~is_nxt_pending ? 1'b0 : dat_pending_clr;
assign wt_pending_clr_w = (is_pending & wt_pending_ack) ? 1'b1 : ~is_nxt_pending ? 1'b0 : wt_pending_clr;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_done && (sg_dn_cnt == 6'b1)\" -q dp2reg_done");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_pending_req_w\" -q dat_pending_req");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_pending_req_w\" -q wt_pending_req");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_pending_clr_w\" -q dat_pending_clr");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_pending_clr_w\" -q wt_pending_clr");
// sg send pending status to cdma
assign sc2cdma_dat_pending_req = dat_pending_req;
assign sc2cdma_wt_pending_req = wt_pending_req;

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
//: &eperl::flop("-nodeclare   -rval \"{5{1'b1}}\"  -en \"dp2reg_done\" -d \"reg2dp_data_bank\" -q last_data_bank");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b1}}\"  -en \"dp2reg_done\" -d \"reg2dp_weight_bank\" -q last_weight_bank");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"dp2reg_done\" -d \"slice_left\" -q last_slices");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"dp2reg_done\" -d \"reg2dp_weight_kernel + 1'b1\" -q last_kernels");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"dp2reg_done\" -d \"reg2dp_skip_weight_rls\" -q last_skip_weight_rls");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"dp2reg_done\" -d \"cur_mode\" -q last_mode");

////////////////////////////////////////////////////////////////////////
//  registers to calculate local values                               //
////////////////////////////////////////////////////////////////////////
//assign is_int8  = (reg2dp_proc_precision == 2'h0 );
assign is_pixel = (reg2dp_datain_format == 1'h1 );
assign is_conv  = (reg2dp_conv_mode == 1'h0 );
assign is_dc    = is_conv & ~is_pixel;
#ifdef NVDLA_WINOGRAD_ENABLE
assign is_winograd  = (reg2dp_conv_mode == 1'h1 );
assign cur_mode     = {is_img, is_winograd, is_dc};
assign data_out_atomic_w= is_img ? reg2dp_dataout_width + 1'b1 :
                           is_winograd ? ({2'b0, reg2dp_atomics[20:2]} + 1'b1) :
                           reg2dp_atomics + 1'b1;
assign weight_width_cmp_w   = (is_winograd | is_img) ? 5'b0 : reg2dp_weight_width_ext;
assign weight_height_cmp_w  = is_winograd ? 5'b0 : reg2dp_weight_height_ext;
#else
assign cur_mode             = {is_img, 1'b0, is_dc};
assign data_out_atomic_w    = is_img ? reg2dp_dataout_width + 1'b1 : reg2dp_atomics + 1'b1;
assign weight_width_cmp_w   = (is_img) ? 5'b0 : reg2dp_weight_width_ext;
assign weight_height_cmp_w  = reg2dp_weight_height_ext;
#endif
assign is_img               = is_conv & is_pixel;
assign data_in_height_w     = reg2dp_datain_height_ext + 1'b1;
assign weight_channel_w     = reg2dp_weight_channel_ext + 1'b1;
assign weight_groups_w      = reg2dp_weight_kernel[12:LOG2_ATOMK] + 1'b1;
assign {weight_r_add_w, mon_weight_r_add_w} = (6'h9 << reg2dp_y_extension);
assign weight_r_last_w = weight_r_add_w[0] ? 2'b0 :
                         weight_r_add_w[1] ? {1'b0, reg2dp_weight_height_ext[0]} :
                         reg2dp_weight_height_ext[1:0];
assign {mon_rls_slices_w, rls_slices_w} = reg2dp_rls_slices + 1'b1;
assign {mon_slice_left_w, slice_left_w} = reg2dp_skip_data_rls ? (reg2dp_datain_height_ext + 1'b1) : reg2dp_datain_height_ext - reg2dp_rls_slices;

//In opensource, DC batching only support fully connected layer. In this case stripe operation length is always 1
//upper_limit = 2*lower_limit or upper_limit = lower_limit
assign lower_limit_w = is_img ? CSC_IMG_STRIPE :
#ifdef NVDLA_WINOGRAD_ENABLE
                       is_winograd ? CSC_ATOMK_HEX :
#endif
#ifdef NVDLA_BATCH_ENABLE
                       (reg2dp_batches != 5'd0) ? CSC_BATCH_STRIPE :
#endif
                       CSC_ATOMK_HEX;

assign upper_limit_w = is_img ? CSC_IMG_STRIPE :
#ifdef NVDLA_WINOGRAD_ENABLE
                       is_winograd ? CSC_ATOMK_MUL2_HEX :
#endif
#ifdef NVDLA_BATCH_ENABLE
                       (reg2dp_batches != 5'd0) ? CSC_BATCH_STRIPE :
#endif
                       CSC_ATOMK_MUL2_HEX;

#ifdef NVDLA_WINOGRAD_ENABLE
assign c_fetch_size = is_winograd ? 8'h4 : CSC_ENTRY_HEX;
#else
assign c_fetch_size = CSC_ENTRY_HEX;
#endif
#ifdef NVDLA_BATCH_ENABLE
assign data_batch_w = reg2dp_batches + 1'b1;
#else
assign data_batch_w = 6'b0;
#endif

//: my $kk=CSC_ATOMK_HEX_STR;
//: my $jj=CSC_ATOMK_MUL2_HEX_STR;
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"data_in_height_w\" -q data_in_height");
//: &eperl::flop("-nodeclare   -rval \"{22{1'b0}}\"  -en \"layer_st\" -d \"data_out_atomic_w\" -q data_out_atomic");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"layer_st\" -d \"data_batch_w\" -q data_batch");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st\" -d \"weight_width_cmp_w\" -q weight_width_cmp");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st\" -d \"weight_height_cmp_w\" -q weight_height_cmp");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"weight_channel_w\" -q weight_channel");
//: &eperl::flop("-nodeclare   -rval \"{10{1'b0}}\"  -en \"layer_st\" -d \"weight_groups_w\" -q weight_groups");
//: &eperl::flop("-nodeclare   -rval \"3'h1\"  -en \"layer_st\" -d \"weight_r_add_w\" -q weight_r_add");
//: &eperl::flop("-nodeclare   -rval \"3'h1\"  -en \"layer_st\" -d \"weight_r_last_w\" -q weight_r_last");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"rls_slices_w\" -q rls_slices");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"slice_left_w\" -q slice_left");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"is_img\" -q is_img_d1");
//: &eperl::flop("-nodeclare   -rval ${kk}  -en \"layer_st\" -d \"lower_limit_w\" -q lower_limit");
//: &eperl::flop("-nodeclare   -rval ${jj}  -en \"layer_st\" -d \"upper_limit_w\" -q upper_limit");
#ifdef NVDLA_WINOGRAD_ENABLE
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"is_winograd\" -q is_winograd_d1");
#endif


////////////////////////////////////////////////////////////////////////
//  sequence generator for direct convolution                         //
////////////////////////////////////////////////////////////////////////
//---------------------------layer count -----------------------------//
assign layer_done_w = layer_st ? 1'b0 : is_last_group ? 1'b1 : layer_done;
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st | op_layer_en\" -d \"layer_done_w\" -q layer_done");

//---------------------------kernel group count -----------------------------//
assign {mon_group_up_cnt_inc, group_up_cnt_inc} = group_up_cnt + 1'b1;
assign is_last_group = (group_up_cnt_inc == weight_groups);
assign group_up_cnt_w = layer_st ? 10'b0 : group_up_cnt_inc;
assign cur_kernel = ~is_last_group ? CSC_ATOMK_HEX : (reg2dp_weight_kernel[LOG2_ATOMK-1:0] + 1'b1) ;
//: &eperl::flop("-nodeclare   -rval \"{10{1'b0}}\"  -en \"layer_st | op_group_en\" -d \"group_up_cnt_w\" -q group_up_cnt");


//--------------------------- output height count, for image case only -----------------------------//
assign is_last_do_h = ~is_img_d1 | (dataout_h_up_cnt == reg2dp_dataout_height);
assign {mon_dataout_h_up_cnt_w, dataout_h_up_cnt_w} = layer_st ? 14'b0 :
                                                        is_last_do_h ? 14'b0 :
                                                        (dataout_h_up_cnt + 1'b1);
//: &eperl::flop("-nodeclare   -rval \"{13{1'b0}}\"  -en \"layer_st | op_do_h_en\" -d \"dataout_h_up_cnt_w\" -q dataout_h_up_cnt");


//--------------------------- output stripe count -----------------------------//
assign {mon_stripe_up_cnt_2x_inc, stripe_up_cnt_2x_inc} = stripe_up_cnt + {upper_limit, 1'b0};
assign {mon_stripe_up_cnt_1x_inc, stripe_up_cnt_1x_inc} = stripe_up_cnt + upper_limit;
assign is_stripe_be_2x = (stripe_up_cnt_2x_inc <= data_out_atomic);
assign is_stripe_le_1x = (stripe_up_cnt_1x_inc >= data_out_atomic);
assign is_last_stripe = is_stripe_le_1x;
assign {mon_stripe_up_cnt_w, stripe_up_cnt_w} = layer_st ? 23'b0 :
                                                is_last_stripe ? 23'b0 :
                                                is_stripe_be_2x ? (stripe_up_cnt + upper_limit) :
                                                (stripe_up_cnt + lower_limit);
assign {mon_cur_stripe_inc[15:0], cur_stripe_inc[6:0]} = data_out_atomic - stripe_up_cnt;
assign cur_stripe = is_stripe_be_2x ? upper_limit : is_stripe_le_1x ? cur_stripe_inc : lower_limit;
//: &eperl::flop("-nodeclare   -rval \"{22{1'b0}}\"  -en \"layer_st | op_stripe_en\" -d \"stripe_up_cnt_w\" -q stripe_up_cnt");


//--------------------------- channel count -----------------------------//
assign {mon_channel_up_cnt_inc, channel_up_cnt_inc} = channel_up_cnt + c_fetch_size[6:0];
assign is_last_channel = (channel_up_cnt_inc >= weight_channel);
assign channel_up_cnt_w = layer_st ? 14'b0 : is_last_channel ? 14'b0 : channel_up_cnt_inc;
#ifdef NVDLA_WINOGRAD_ENABLE
assign cur_channel = (is_winograd_d1 | ~is_last_channel) ? c_fetch_size[6:0] : (reg2dp_weight_channel_ext[LOG2_ATOMC-1:0] + 1'b1);
#else
assign cur_channel = (~is_last_channel) ? c_fetch_size[6:0] : (reg2dp_weight_channel_ext[LOG2_ATOMC-1:0] + 1'b1);
#endif
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st | op_channel_en\" -d \"channel_up_cnt_w\" -q channel_up_cnt");


//--------------------------- weight block count -----------------------------//
assign {mon_weight_s_up_cnt_inc, weight_s_up_cnt_inc} = weight_s_up_cnt + 1'b1;
assign weight_r_up_cnt_inc = weight_r_up_cnt + weight_r_add;
assign is_last_s = (weight_s_up_cnt == weight_width_cmp);
assign is_last_r = (weight_r_up_cnt_inc > {1'b0, weight_height_cmp});
assign cur_r = is_last_r ? weight_r_last :
               weight_r_add[2] ? 2'h3 :
               weight_r_add[1] ? 2'h1 :
               2'h0;
assign is_last_block = is_last_s & is_last_r;
assign weight_s_up_cnt_w = layer_st ? 5'b0 : (is_last_s) ? 5'b0 : weight_s_up_cnt_inc;
assign weight_r_up_cnt_w = layer_st ? 5'b0 : (is_last_r) ? 5'b0 : weight_r_up_cnt_inc[4:0];
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st | op_s_en\" -d \"weight_s_up_cnt_w\" -q weight_s_up_cnt");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st | op_r_en\" -d \"weight_r_up_cnt_w\" -q weight_r_up_cnt");


//--------------------------- cbuf check logic -----------------------------//
assign dat_cbuf_ready = (slices_avl >= data_in_height[13:0]);
assign {mon_required_kernels_inc, required_kernels_inc} = required_kernels + cur_kernel;
assign required_kernels_w = (layer_st | is_last_group | ~reg2dp_skip_weight_rls) ? 14'b0 : required_kernels_inc;
assign wt_cbuf_ready = ({1'b0, required_kernels_inc} <= kernels_avl);
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st | op_group_en\" -d \"required_kernels_w\" -q required_kernels");


//--------------------------- register enable signal -----------------------------//
assign fifo_push_ready = dat_push_ready & wt_push_ready;
assign cbuf_ready = dat_cbuf_ready & wt_cbuf_ready;
assign pkg_adv = is_running & cbuf_ready & ~layer_done & (~pkg_vld | fifo_push_ready);
assign op_s_en = pkg_adv;
assign op_r_en = pkg_adv & is_last_s;
assign op_channel_en = pkg_adv & is_last_block;
assign op_stripe_en = pkg_adv & is_last_block & is_last_channel;
assign op_do_h_en = is_img_d1 & pkg_adv & is_last_block & is_last_channel & is_last_stripe;
assign op_group_en = pkg_adv & is_last_block & is_last_channel & is_last_stripe & is_last_do_h;
assign op_layer_en = pkg_adv & is_last_block & is_last_channel & is_last_stripe & is_last_do_h & is_last_group;
assign pkg_vld_w = ~is_running  ? 1'b0 :
                   (cbuf_ready & ~layer_done) ? 1'b1 :
                   fifo_push_ready ? 1'b0 :
                   pkg_vld;

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"pkg_vld_w\" -q pkg_vld");

//--------------------------- package registers -----------------------------//
assign {mon_pkg_idx_w, pkg_idx_w} = layer_st ? 2'h3 : (pkg_idx + 2'b1);
#ifdef NVDLA_WINOGRAD_ENABLE
assign pkg_weight_size_w = (is_winograd_d1) ? CSC_ENTRY_HEX : cur_channel;
#else
assign pkg_weight_size_w = cur_channel;
#endif
assign stripe_length_w = cur_stripe;
assign pkg_block_end_w = is_last_block;
assign pkg_channel_end_w = is_last_block & is_last_channel;
assign pkg_group_end_w = is_last_block & is_last_channel & is_last_stripe & is_last_do_h;
assign pkg_layer_end_w = is_last_block & is_last_channel & is_last_stripe & is_last_do_h & is_last_group;

//: &eperl::flop("-nodeclare   -rval \"{2{1'b1}}\"  -en \"layer_st | pkg_adv\" -d \"pkg_idx_w\" -q pkg_idx");

//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"pkg_adv\" -d \"weight_s_up_cnt\" -q dat_pkg_w_offset");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"pkg_adv\" -d \"weight_r_up_cnt\" -q dat_pkg_h_offset");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"pkg_adv\" -d \"cur_channel\" -q dat_pkg_channel_size");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"pkg_adv\" -d \"stripe_length_w\" -q dat_pkg_stripe_length");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"pkg_adv\" -d \"cur_r\" -q dat_pkg_cur_sub_h");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"pkg_block_end_w\" -q dat_pkg_block_end");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"pkg_channel_end_w\" -q dat_pkg_channel_end");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"pkg_group_end_w\" -q dat_pkg_group_end");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"pkg_layer_end_w\" -q dat_pkg_layer_end");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"~reg2dp_skip_data_rls & pkg_layer_end_w\" -q dat_pkg_dat_release");

// PKT_PACK_WIRE( csc_dat_pkg ,  dat_pkg_ ,  dat_pkg_pd )
assign dat_pkg_pd[4:0] =    dat_pkg_w_offset[4:0];
assign dat_pkg_pd[9:5] =    dat_pkg_h_offset[4:0];
assign dat_pkg_pd[16:10] =  dat_pkg_channel_size[6:0];
assign dat_pkg_pd[23:17] =  dat_pkg_stripe_length[6:0];
assign dat_pkg_pd[25:24] =  dat_pkg_cur_sub_h[1:0];
assign dat_pkg_pd[26] =     dat_pkg_block_end ;
assign dat_pkg_pd[27] =     dat_pkg_channel_end ;
assign dat_pkg_pd[28] =     dat_pkg_group_end ;
assign dat_pkg_pd[29] =     dat_pkg_layer_end ;
assign dat_pkg_pd[30] =     dat_pkg_dat_release ;

assign dat_push_data = {pkg_idx, dat_pkg_pd};

//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"pkg_adv\" -d \"cur_kernel\" -q wt_pkg_kernel_size");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"pkg_adv\" -d \"pkg_weight_size_w\" -q wt_pkg_weight_size");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"pkg_adv\" -d \"cur_r\" -q wt_pkg_cur_sub_h");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"pkg_adv\" -d \"~reg2dp_skip_weight_rls & pkg_group_end_w\" -q wt_pkg_wt_release");

assign wt_pkg_channel_end = dat_pkg_channel_end;
assign wt_pkg_group_end = dat_pkg_group_end;

// PKT_PACK_WIRE( csc_wt_pkg ,  wt_pkg_ ,  wt_pkg_pd )
assign wt_pkg_pd[6:0] =    wt_pkg_weight_size[6:0];
assign wt_pkg_pd[12:7] =   wt_pkg_kernel_size[5:0];
assign wt_pkg_pd[14:13] =  wt_pkg_cur_sub_h[1:0];
assign wt_pkg_pd[15] =     wt_pkg_channel_end ;
assign wt_pkg_pd[16] =     wt_pkg_group_end ;
assign wt_pkg_pd[17] =     wt_pkg_wt_release ;

assign wt_push_data = {pkg_idx, wt_pkg_pd};

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

assign dat_push_req = pkg_vld & wt_push_ready;
assign wt_push_req = pkg_vld & dat_push_ready;

////////////////////////////////////////////////////////////////////////
//  issue control logic                                               //
////////////////////////////////////////////////////////////////////////
assign {dat_pop_idx, dat_pop_pd} = dat_pop_data;
assign {wt_pop_idx, wt_pop_pd} = wt_pop_data;

// PKT_UNPACK_WIRE( csc_dat_pkg ,  sg2dat_ ,  dat_pop_pd )
assign sg2dat_w_offset[4:0]      = dat_pop_pd[4:0];
assign sg2dat_h_offset[4:0]      = dat_pop_pd[9:5];
assign sg2dat_channel_size[6:0]  = dat_pop_pd[16:10];
assign sg2dat_stripe_length[6:0] = dat_pop_pd[23:17];
assign sg2dat_cur_sub_h[1:0]     = dat_pop_pd[25:24];
assign sg2dat_block_end          = dat_pop_pd[26];
assign sg2dat_channel_end        = dat_pop_pd[27];
assign sg2dat_group_end          = dat_pop_pd[28];
assign sg2dat_layer_end          = dat_pop_pd[29];
assign sg2dat_dat_release        = dat_pop_pd[30];

// PKT_UNPACK_WIRE( csc_wt_pkg ,  sg2wt_ ,  wt_pop_pd )
assign sg2wt_weight_size[6:0] = wt_pop_pd[6:0];
assign sg2wt_kernel_size[5:0] = wt_pop_pd[12:7];
assign sg2wt_cur_sub_h[1:0]   = wt_pop_pd[14:13];
assign sg2wt_channel_end      = wt_pop_pd[15];
assign sg2wt_group_end        = wt_pop_pd[16];
assign sg2wt_wt_release       = wt_pop_pd[17];

assign {mon_sg2wt_kernel_size_inc, sg2wt_kernel_size_inc} = sg2wt_kernel_size + 1'b1;
#ifdef NVDLA_BATCH_ENABLE
assign {mon_dat_stripe_batch_size_w, dat_stripe_batch_size_w} = sg2dat_stripe_length * data_batch;
#else
assign dat_stripe_batch_size_w = sg2dat_stripe_length;
#endif
assign dat_stripe_img_size_w = sg2dat_stripe_length;
assign dat_stripe_size_w = is_img_d1 ? dat_stripe_img_size_w :  dat_stripe_batch_size_w;
assign {mon_dat_stripe_img_length_w,
        dat_stripe_img_length_w} = ~is_img_d1 ? 8'b0 :
                                  (reg2dp_y_extension == 2'h2) ? ((sg2dat_stripe_length + 2'h3) & 8'hfc) :
                                  (reg2dp_y_extension == 2'h1) ? ((sg2dat_stripe_length + 2'h1) & 8'hfe) :
                                  {1'b0, sg2dat_stripe_length};

assign dat_stripe_length_w = is_img_d1 ? dat_stripe_img_length_w : dat_stripe_batch_size_w;

//delay for one cycle
assign dat_max_cycles = ~dat_pop_ready ? 7'b0 :
                        (dat_stripe_length < CSC_MIN_STRIPE ) ? CSC_MIN_STRIPE  :
                        dat_stripe_length;
assign wt_cycles = sg2wt_kernel_size[5:0];
assign wt_max_cycles = ~wt_pop_ready ? 6'b0 :
                       ((wt_cycles <= 6'b1) & (pop_cnt <= 6'b1)) ? 6'h2 :
                       (wt_cycles > pop_cnt) ?  wt_cycles :
                       pop_cnt;

assign {mon_max_cycles, max_cycles} = (dat_max_cycles >= {1'b0, wt_max_cycles}) ? (dat_max_cycles - 1'b1) : ({1'b0, wt_max_cycles} - 1'b1);
assign {mon_pop_cnt_dec, pop_cnt_dec} = pop_cnt - 1'b1;
assign pop_cnt_w = (dat_pop_ready | wt_pop_ready) ? max_cycles : (pop_cnt == 6'h0) ? 6'h0 : pop_cnt_dec;
assign wt_pop_ready = wt_pop_req & (((pop_cnt == 6'b0) & credit_ready) | (dat_pop_idx == wt_pop_idx));
assign dat_pop_ready = dat_pop_req & (pop_cnt == 6'b0) & credit_ready & ((dat_pop_idx != wt_pop_idx) | ~wt_pop_req);

//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_pop_ready\" -q wt_pop_ready_d1");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"wt_pop_ready_d1\" -d \"dat_stripe_size_w\" -q dat_stripe_size");
//: &eperl::flop("-nodeclare   -rval \"{7{1'b0}}\"  -en \"wt_pop_ready_d1\" -d \"dat_stripe_length_w\" -q dat_stripe_length");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"   -d \"pop_cnt_w\" -q pop_cnt");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dat_pop_ready\" -q sg2dl_pvld");
//: &eperl::flop("-nodeclare   -rval \"{31{1'b0}}\"  -en \"dat_pop_ready\" -d \"dat_pop_pd\" -q sg2dl_pd");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"wt_pop_ready\" -q sg2wl_pvld");
//: &eperl::flop("-nodeclare   -rval \"{18{1'b0}}\"  -en \"wt_pop_ready\" -d \"wt_pop_pd\" -q sg2wl_pd");


////////////////////////////////////////////////////////////////////////
//  credit controll logic                                             //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//
//flop credit signal because it cross partition boundary
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"accu2sc_credit_vld\" -q credit_vld");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk -norst -en \"accu2sc_credit_vld\" -d \"accu2sc_credit_size\" -q credit_size");

#ifdef NVDLA_WINOGRAD_ENABLE
assign dat_impact_cnt = is_winograd_d1 ? {dat_stripe_size[5:0], 3'b0} :
                        is_winograd_d1 ? {1'b0, dat_stripe_size[5:0], 2'b0} :
                        ~is_winograd_d1 ? {1'b0, dat_stripe_size, 1'b0} :
                        {2'b0, dat_stripe_size};
#else
assign dat_impact_cnt = {2'b0, dat_stripe_size};
#endif
assign credit_req_size = dat_impact_cnt;
assign credit_cnt_add = credit_vld ? credit_size : 4'b0;
assign credit_cnt_dec = (dat_pop_ready & sg2dat_channel_end) ? dat_impact_cnt : 9'b0;
assign {mon_credit_cnt_w, credit_cnt_w} = credit_cnt + credit_cnt_add - credit_cnt_dec;
assign credit_ready = ~sg2dat_channel_end | (credit_cnt >= credit_req_size);

//: my $credit_size = NVDLA_CC_CREDIT_SIZE;
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval $credit_size  -en \"dat_pop_ready | credit_vld\" -d \"credit_cnt_w\" -q credit_cnt");

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  convolution buffer local status                                   //
////////////////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//
assign dat_release = pkg_adv & pkg_layer_end_w & ~reg2dp_skip_data_rls;
assign dat_reuse_release = is_idle & reg2dp_op_en & (~reg2dp_data_reuse | is_mode_change) & (|last_slices);
assign slices_avl_add = cdma2sc_dat_updt ? cdma2sc_dat_slices : 14'b0;
assign slices_avl_sub = dat_release ? rls_slices : dat_reuse_release ? last_slices[13:0] : 14'b0;
assign {mon_slices_avl_w, slices_avl_w} = (dat_pending_req) ? 14'b0 : (slices_avl + slices_avl_add - slices_avl_sub);
assign wt_release = pkg_adv & ~reg2dp_skip_weight_rls & pkg_group_end_w;
assign wt_reuse_release = is_idle & reg2dp_op_en & ~reg2dp_weight_reuse & last_skip_weight_rls;
assign kernels_avl_add = cdma2sc_wt_updt ? cdma2sc_wt_kernels : 14'b0;
assign kernels_avl_sub = wt_release ? {{7{1'b0}}, cur_kernel} : wt_reuse_release ? last_kernels[13:0] : 14'b0;
assign {mon_kernels_avl_w, kernels_avl_w} = (wt_pending_req) ? 15'b0 : kernels_avl + kernels_avl_add - kernels_avl_sub;

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{14{1'b0}}\"  -en \"dat_pending_req | dat_release | dat_reuse_release | cdma2sc_dat_updt\" -d \"slices_avl_w\" -q slices_avl");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{15{1'b0}}\"  -en \"wt_pending_req | wt_release | wt_reuse_release | cdma2sc_wt_updt\" -d \"kernels_avl_w\" -q kernels_avl");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"dat_reuse_release\" -q sg2dl_reuse_rls");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"wt_reuse_release\" -q sg2wl_reuse_rls");

//================  Non-SLCG clock domain end ================//

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////
assign dbg_cur_prec = reg2dp_proc_precision;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        dbg_pre_prec <= {2{1'b1}};
    end else begin
        dbg_pre_prec <= reg2dp_proc_precision;
    end
end

endmodule // NV_NVDLA_CSC_sg
