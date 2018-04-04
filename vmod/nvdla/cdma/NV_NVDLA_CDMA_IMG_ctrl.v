// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_IMG_ctrl.v

#include "NV_NVDLA_CDMA_define.h"

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
////////////////////////////////////////////////////////
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
output  [5:0] pixel_bank;//
output        pixel_data_expand;
output        pixel_data_shrink;
output        pixel_early_end;
output [10:0] pixel_order;
output        pixel_packed_10b;
output        pixel_planar;
output  [3:0] pixel_planar0_bundle_limit;
output  [3:0] pixel_planar0_bundle_limit_1st;
//: my $atmmbw = int( log(NVDLA_MEMORY_ATOMIC_SIZE) / log(2) );
//: print qq(
//:     output  [${atmmbw}-1:0] pixel_planar0_byte_sft;
//:     output  [${atmmbw}-1:0] pixel_planar1_byte_sft;
//: );
output  [3:0] pixel_planar0_lp_burst;
output        pixel_planar0_lp_vld;
output  [3:0] pixel_planar0_rp_burst;
output        pixel_planar0_rp_vld;
output  [2:0] pixel_planar0_sft;
output [13:0] pixel_planar0_width_burst;
output  [4:0] pixel_planar1_bundle_limit;
output  [4:0] pixel_planar1_bundle_limit_1st;
output  [2:0] pixel_planar1_lp_burst;
output        pixel_planar1_lp_vld;
output  [2:0] pixel_planar1_rp_burst;
output        pixel_planar1_rp_vld;
output  [2:0] pixel_planar1_sft;
output [13:0] pixel_planar1_width_burst;
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
input [4:0]                      reg2dp_data_bank;
input [4:0]         reg2dp_pixel_x_offset;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;
////////////////////////////////////////////////////////

reg     [1:0] cur_state;
reg     [4:0] delay_cnt;
reg     [1:0] img2status_state;
reg           is_running_d1;
reg     [4:0] last_data_bank;
reg           last_img;
reg           last_skip_data_rls;
reg     [1:0] nxt_state;
reg           pending_req;
reg           pending_req_d1;
reg     [5:0] pixel_bank;
reg           pixel_data_expand;
reg           pixel_data_shrink;
reg           pixel_early_end;
reg    [10:0] pixel_order;
reg    [10:0] pixel_order_nxt;
reg           pixel_packed_10b;
reg           pixel_packed_10b_nxt;
reg           pixel_planar;
reg     [3:0] pixel_planar0_bundle_limit;
reg     [3:0] pixel_planar0_bundle_limit_1st;
reg     [3:0] pixel_planar0_lp_burst;
reg           pixel_planar0_lp_vld;
reg     [4:0] pixel_planar0_mask_nxt;
reg     [3:0] pixel_planar0_rp_burst;
reg           pixel_planar0_rp_vld;
reg     [2:0] pixel_planar0_sft;
reg     [2:0] pixel_planar0_sft_nxt;
reg    [13:0] pixel_planar0_width_burst;
reg     [4:0] pixel_planar1_bundle_limit;
reg     [4:0] pixel_planar1_bundle_limit_1st;
reg     [2:0] pixel_planar1_lp_burst;
reg           pixel_planar1_lp_vld;
reg     [4:0] pixel_planar1_mask_nxt;
reg     [2:0] pixel_planar1_rp_burst;
reg           pixel_planar1_rp_vld;
reg     [2:0] pixel_planar1_sft;
reg     [2:0] pixel_planar1_sft_nxt;
reg    [13:0] pixel_planar1_width_burst;
reg           pixel_planar_nxt;
reg     [1:0] pixel_precision;
reg     [1:0] pixel_precision_nxt;
reg           pixel_uint;
reg     [1:0] slcg_img_gate_d1;
reg     [1:0] slcg_img_gate_d2;
reg     [1:0] slcg_img_gate_d3;
wire    [2:0] byte_per_pixel;
wire    [4:0] delay_cnt_end;
wire    [4:0] delay_cnt_w;
wire    [1:0] img2status_state_w;
wire          img_done;
wire          img_en;
wire          img_end;
wire          is_dc;
wire          is_done;
wire          is_first_running;
wire          is_idle;
wire          is_input_int8;
wire          is_int8;
wire          is_pending;
wire          is_pixel;
wire          is_running;
wire          layer_st;
wire          mode_match;
wire          mon_delay_cnt_w;
wire    [2:0] mon_pixel_element_sft_w;
wire          mon_pixel_planar0_burst_need_w;
wire    [2:0] mon_pixel_planar0_byte_sft_w;
wire    [1:0] mon_pixel_planar0_lp_burst_w;
wire    [10:0] mon_pixel_planar0_rp_burst_w;
wire          mon_pixel_planar0_width_burst_w;
wire    [3:0] mon_pixel_planar1_burst_need_w;
wire    [2:0] mon_pixel_planar1_byte_sft_w;
wire    [2:0] mon_pixel_planar1_lp_burst_w;
wire    [11:0] mon_pixel_planar1_rp_burst_w;
wire    [1:0] mon_pixel_planar1_total_burst_w;
wire    [2:0] mon_pixel_planar1_total_width_w;
wire    [3:0] mon_pixel_planar1_width_burst_w;
wire          need_pending;
wire          pending_req_end;
wire          pixel_data_expand_nxt;
wire          pixel_data_shrink_nxt;
wire          pixel_early_end_w;
//: my $atmmbw = int( log(NVDLA_MEMORY_ATOMIC_SIZE) / log(2) );
//: print qq(
//:     wire    [${atmmbw}-1:0] pixel_element_sft_w ;
//:     wire    [${atmmbw}-1:0] pixel_planar0_byte_sft_w;
//:     wire    [${atmmbw}-1:0] pixel_planar1_byte_sft_w;
//:     reg     [${atmmbw}-1:0] pixel_planar0_byte_sft;
//:     reg     [${atmmbw}-1:0] pixel_planar1_byte_sft;
//: );
wire    [3:0] pixel_planar0_bundle_limit_1st_w;
wire    [3:0] pixel_planar0_bundle_limit_w;
wire   [13:0] pixel_planar0_burst_need_w;
wire   [13:0] pixel_planar0_fetch_width;
wire    [3:0] pixel_planar0_lp_burst_w;
wire    [4:0] pixel_planar0_lp_filled;
wire          pixel_planar0_lp_vld_w;
wire    [3:0] pixel_planar0_rp_burst_w;
wire          pixel_planar0_rp_vld_w;
wire   [13:0] pixel_planar0_width_burst_w;
wire    [4:0] pixel_planar1_bundle_limit_1st_w;
wire    [4:0] pixel_planar1_bundle_limit_w;
wire   [13:0] pixel_planar1_burst_need_w;
wire   [13:0] pixel_planar1_fetch_width;
wire    [2:0] pixel_planar1_lp_burst_w;
wire    [4:0] pixel_planar1_lp_filled;
wire          pixel_planar1_lp_vld_w;
wire    [2:0] pixel_planar1_rp_burst_w;
wire          pixel_planar1_rp_vld_w;
wire    [2:0] pixel_planar1_tail_width_w;
wire    [1:0] pixel_planar1_total_burst_w;

//: my $dmaif_bw = int( log(int(NVDLA_CDMA_DMAIF_BW/8)) / log(2) );
//: print qq(
//:     wire    [${dmaif_bw}-1:0] pixel_planar1_total_width_w;
//:     wire    [${dmaif_bw}-1:0] mon_pixel_planar1_tail_width_w; 
//: );
wire   [13:0] pixel_planar1_width_burst_w;
wire    [4:0] pixel_planar1_x_offset;
wire   [13:0] pixel_store_width;
wire          pixel_tail_1_w;
wire          pixel_tail_2_w;
wire          pixel_uint_nxt;
wire          planar1_vld_w;
wire          slcg_img_en_w;
wire    [1:0] slcg_img_gate_w;
    
////////////////////////////////////////////////////////////////////////
// CDMA image input data fetching logic FSM                           //
////////////////////////////////////////////////////////////////////////
localparam IMG_STATE_IDLE = 2'b00;
localparam IMG_STATE_PEND = 2'b01;
localparam IMG_STATE_BUSY = 2'b10;
localparam IMG_STATE_DONE = 2'b11;

always @(*) begin
    nxt_state = cur_state;
    begin
        casez (cur_state)
        IMG_STATE_IDLE: begin
            if ((img_en & need_pending)) begin
                nxt_state = IMG_STATE_PEND; 
            end
            else if ((img_en & reg2dp_data_reuse & last_skip_data_rls & mode_match)) begin
                nxt_state = IMG_STATE_DONE; 
            end
            else if (img_en) begin
                nxt_state = IMG_STATE_BUSY; 
            end
        end
        IMG_STATE_PEND: begin
            if ((pending_req_end)) begin
                nxt_state = IMG_STATE_BUSY; 
            end
        end
        IMG_STATE_BUSY: begin
            if (img_done) begin
                nxt_state = IMG_STATE_DONE; 
            end
        end
        IMG_STATE_DONE: begin
            if (status2dma_fsm_switch) begin
                nxt_state = IMG_STATE_IDLE; 
            end
        end
        endcase
    end
end
//: &eperl::flop("-nodeclare   -rval \"IMG_STATE_IDLE\"   -d \"nxt_state\" -q cur_state");

////////////////////////////////////////////////////////////////////////
//  FSM output signals                                                //
////////////////////////////////////////////////////////////////////////
assign layer_st = img_en & is_idle;
assign is_idle = (cur_state == IMG_STATE_IDLE);
assign is_pending = (cur_state == IMG_STATE_PEND);
assign is_running = (cur_state == IMG_STATE_BUSY);
assign is_done = (cur_state == IMG_STATE_DONE);
assign img2status_state_w = (nxt_state == IMG_STATE_PEND) ? 1  : 
                            (nxt_state == IMG_STATE_BUSY) ? 2  : 
                            (nxt_state == IMG_STATE_DONE) ? 3  :
                            0 ;
assign is_first_running = is_running & ~is_running_d1;

//: &eperl::flop("-nodeclare   -rval \"0\"   -d \"img2status_state_w\" -q img2status_state");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"is_running\" -q is_running_d1");

////////////////////////////////////////////////////////////////////////
//  registers to keep last layer status                               //
////////////////////////////////////////////////////////////////////////
assign pending_req_end = pending_req_d1 & ~pending_req;

//================  Non-SLCG clock domain ================//
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"  -en \"reg2dp_op_en & is_idle\" -d \"img_en\" -q last_img");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{5{1'b1}}\"  -en \"reg2dp_op_en & is_idle\" -d \"reg2dp_data_bank\" -q last_data_bank");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"  -en \"reg2dp_op_en & is_idle\" -d \"img_en & reg2dp_skip_data_rls\" -q last_skip_data_rls");

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"sc2cdma_dat_pending_req\" -q pending_req");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"1'b0\"   -d \"pending_req\" -q pending_req_d1");

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_img_en_w = img_en & (is_running | is_pending | is_done);
assign slcg_img_gate_w = {2{~slcg_img_en_w}};

//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{2{1'b1}}\"   -d \"slcg_img_gate_w\" -q slcg_img_gate_d1");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{2{1'b1}}\"   -d \"slcg_img_gate_d1\" -q slcg_img_gate_d2");
//: &eperl::flop("-nodeclare -clk nvdla_core_ng_clk  -rval \"{2{1'b1}}\"   -d \"slcg_img_gate_d2\" -q slcg_img_gate_d3");

assign slcg_img_gate_dc = slcg_img_gate_d3[0];
assign slcg_img_gate_wg = slcg_img_gate_d3[1];

//================  Non-SLCG clock domain end ================//

////////////////////////////////////////////////////////////////////////
//  FSM input signals                                                 //
////////////////////////////////////////////////////////////////////////

assign img_end = is_running & ~is_first_running & sg_is_done & pack_is_done;
assign img_done = img_end & (delay_cnt == delay_cnt_end);
assign delay_cnt_end = (3   + 3   + 3 ) ;
assign {mon_delay_cnt_w,
        delay_cnt_w} = ~is_running ? 6'b0 :
                      img_end ? delay_cnt + 1'b1 : {1'b0, delay_cnt};
assign need_pending = (last_data_bank != reg2dp_data_bank);
assign mode_match = img_en & last_img;
assign is_dc = (reg2dp_conv_mode == 1'h0 );
assign is_pixel = (reg2dp_datain_format == 1'h1 );
assign img_en = reg2dp_op_en & is_dc & is_pixel;

//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"img_end | is_done\" -d \"delay_cnt_w\" -q delay_cnt");

////////////////////////////////////////////////////////////////////////
//  pixel format parser                                               //
////////////////////////////////////////////////////////////////////////
//

always @(*) begin
    pixel_planar_nxt = 1'h0;
    pixel_precision_nxt = 2'h0;
    pixel_order_nxt = 11'h1;
    pixel_packed_10b_nxt = 1'b0;
    //pixel_planar0_sft_nxt = 3'h3;//log2(atmm/BytePerPixel(4 in a8r8g8b8))
    //pixel_planar1_sft_nxt = 3'h5;//log2(?)
    //pixel_planar0_mask_nxt = 5'h7;//atomm/(BytePerPixel) -1
    //pixel_planar1_mask_nxt = 5'h1f;//?
    pixel_planar0_sft_nxt = 3'h1;
    pixel_planar1_sft_nxt = 3'h3;
    pixel_planar0_mask_nxt = 5'h1;
    pixel_planar1_mask_nxt = 5'h7;
    case(reg2dp_pixel_format)
    6'h0 :
//               0    T_R8, 
    begin
        //pixel_planar0_sft_nxt = 3'h5;
        //pixel_planar0_mask_nxt = 5'h1f;
        pixel_planar0_sft_nxt = 3'h3;
        pixel_planar0_mask_nxt = 5'h7;
    end
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
    6'h1, 6'h2, 6'h3 :
//               1    T_R10,
//               2    T_R12,
//               3    T_R16,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_planar0_sft_nxt = 3'h4;
        pixel_planar0_mask_nxt = 5'hf;
    end
    6'h4 :
//               4    T_R16_I, 
    begin
        pixel_precision_nxt = 2'h2;
        pixel_planar0_sft_nxt = 3'h4;
        pixel_planar0_mask_nxt = 5'hf;
    end
    6'h5 :
//               5    T_R16_F,
    begin
        pixel_precision_nxt = 2'h3;
        pixel_planar0_sft_nxt = 3'h4;
        pixel_planar0_mask_nxt = 5'hf;
    end
    6'h6, 6'h7 :
//               6    T_A16B16G16R16,
//               7    T_X16B16G16R16,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_planar0_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h3;
    end
    6'h8 :
//               8    T_A16B16G16R16_F,
    begin
        pixel_precision_nxt = 2'h3;
        pixel_planar0_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h3;
    end
    6'h9 :
//               9    T_A16Y16U16V16,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h4;
        pixel_planar0_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h3;
    end
    6'ha :
//               a    T_V16U16Y16A16,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h10;
        pixel_planar0_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h3;
    end
    6'hb :
//               b    T_A16Y16U16V16_F
    begin
        pixel_precision_nxt = 2'h3;
        pixel_order_nxt = 11'h4;
        pixel_planar0_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h3;
    end
#endif
    6'hc, 6'h10 :
//               c    T_A8B8G8R8,
//              10    T_X8B8G8R8,
    begin
        pixel_order_nxt = 11'h1;
    end
    6'hd, 6'h11, 6'h1a :
//               d    T_A8R8G8B8,
//              11    T_X8R8G8B8,
//              1a    T_A8Y8U8V8,
    begin
        pixel_order_nxt = 11'h2;
    end
    6'he, 6'h12, 6'h1b :
//               e    T_B8G8R8A8,
//              12    T_B8G8R8X8,
//              1b    T_V8U8Y8A8,
    begin
        pixel_order_nxt = 11'h8;
    end
    6'hf, 6'h13 :
//               f    T_R8G8B8A8,
//              13    T_R8G8B8X8,
    begin
        pixel_order_nxt = 11'h20;
    end
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
    6'h14 :
//              14    T_A2B10G10R10,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_packed_10b_nxt = 1'b1;
    end
    6'h15, 6'h18 :
//              15    T_A2R10G10B10,
//              18    T_A2Y10U10V10,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h40;
        pixel_packed_10b_nxt = 1'b1;
    end
    6'h16, 6'h19 :
//              16    T_B10G10R10A2,
//              19    T_V10U10Y10A2,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h80;
        pixel_packed_10b_nxt = 1'b1;
    end
    6'h17 :
//              17    T_R10G10B10A2,
    begin
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h100;
        pixel_packed_10b_nxt = 1'b1;
    end
#endif
    6'h1c :
//              1c    T_Y8___U8V8_N444,
    begin
        pixel_planar_nxt = 1'h1;
        pixel_order_nxt = 11'h200;
        //pixel_planar0_sft_nxt = 3'h5;
        //pixel_planar1_sft_nxt = 3'h4;
        //pixel_planar0_mask_nxt = 5'h1f;
        //pixel_planar1_mask_nxt = 5'hf;
        pixel_planar0_sft_nxt = 3'h3;
        pixel_planar1_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h7;
        pixel_planar1_mask_nxt = 5'h3;
    end
    6'h1d :
//              1d    T_Y8___V8U8_N444,
    begin
        pixel_planar_nxt = 1'h1;
        //pixel_planar0_sft_nxt = 3'h5;
        //pixel_planar1_sft_nxt = 3'h4;
        //pixel_planar0_mask_nxt = 5'h1f;
        //pixel_planar1_mask_nxt = 5'hf;
        pixel_planar0_sft_nxt = 3'h3;
        pixel_planar1_sft_nxt = 3'h2;
        pixel_planar0_mask_nxt = 5'h7;
        pixel_planar1_mask_nxt = 5'h3;
    end
#ifndef NVDLA_FEATURE_DATA_TYPE_INT8
    6'h1e, 6'h20, 6'h22 :
//              1e    T_Y10___U10V10_N444,
//              20    T_Y12___U12V12_N444,
//              22    T_Y16___U16V16_N444,
    begin
        pixel_planar_nxt = 1'h1;
        pixel_precision_nxt = 2'h1;
        pixel_order_nxt = 11'h400;
        pixel_planar0_sft_nxt = 3'h4;
        pixel_planar1_sft_nxt = 3'h3;
        pixel_planar0_mask_nxt = 5'hf;
        pixel_planar1_mask_nxt = 5'h7;
    end
    6'h1f, 6'h21, 6'h23 :
//              1f    T_Y10___V10U10_N444
//              21    T_Y12___V12U12_N444
//              23    T_Y16___V16U16_N444
    begin
        pixel_planar_nxt = 1'h1;
        pixel_precision_nxt = 2'h1;
        pixel_planar0_sft_nxt = 3'h4;
        pixel_planar1_sft_nxt = 3'h3;
        pixel_planar0_mask_nxt = 5'hf;
        pixel_planar1_mask_nxt = 5'h7;
    end
#endif
    endcase
end

#ifdef NVDLA_FEATURE_DATA_TYPE_INT8
assign is_int8 = 1'b1;
assign is_input_int8 = 1'b1;
assign pixel_data_expand_nxt = 1'b0;
assign pixel_data_shrink_nxt = 1'b0;
#else
assign is_int8 = (reg2dp_proc_precision == 2'h0 );
assign is_input_int8 = (reg2dp_in_precision == 2'h0 );
assign pixel_data_expand_nxt = ~is_int8 & is_input_int8;
assign pixel_data_shrink_nxt = is_int8 & ~is_input_int8;
#endif

//////// pixel_lp_burst, pixel_width_burst, pixel_rp_burst ////////
assign pixel_uint_nxt = (reg2dp_pixel_sign_override == 1'h0 );
assign pixel_planar1_x_offset = (reg2dp_pixel_x_offset & pixel_planar1_mask_nxt);
assign pixel_planar0_lp_filled = reg2dp_pad_left & pixel_planar0_mask_nxt;
assign pixel_planar1_lp_filled = reg2dp_pad_left & pixel_planar1_mask_nxt;
assign {mon_pixel_planar0_lp_burst_w[1:0],
        pixel_planar0_lp_burst_w} = (reg2dp_pixel_x_offset >= pixel_planar0_lp_filled) ? (reg2dp_pad_left >> pixel_planar0_sft_nxt) :
                                   (reg2dp_pad_left >> pixel_planar0_sft_nxt) + 1'b1;
assign {mon_pixel_planar1_lp_burst_w[2:0],
        pixel_planar1_lp_burst_w} = (pixel_planar1_x_offset >= pixel_planar1_lp_filled) ? (reg2dp_pad_left >> pixel_planar1_sft_nxt) :
                                   (reg2dp_pad_left >> pixel_planar1_sft_nxt) + 1'b1;
assign pixel_planar0_fetch_width = reg2dp_datain_width + reg2dp_pixel_x_offset;
assign pixel_planar1_fetch_width = reg2dp_datain_width + pixel_planar1_x_offset;
assign pixel_planar0_width_burst_w = (pixel_planar0_fetch_width >> pixel_planar0_sft_nxt) + 14'b1;
assign pixel_planar1_width_burst_w = (pixel_planar1_fetch_width >> pixel_planar1_sft_nxt) + 14'b1;
//assign {mon_pixel_planar0_width_burst_w[0],
//        pixel_planar0_width_burst_w} = (pixel_planar0_fetch_width >> pixel_planar0_sft_nxt) + 14'b1;
//assign {mon_pixel_planar1_width_burst_w[3:0],
//        pixel_planar1_width_burst_w} = (pixel_planar1_fetch_width >> pixel_planar1_sft_nxt) + 14'b1;
assign pixel_store_width = reg2dp_pad_left + reg2dp_datain_width + reg2dp_pad_right;
assign pixel_planar0_burst_need_w = (pixel_store_width >> pixel_planar0_sft_nxt) + 14'h2;
assign pixel_planar1_burst_need_w = (pixel_store_width >> pixel_planar1_sft_nxt) + 14'h2;
//assign {mon_pixel_planar0_burst_need_w[0],
//        pixel_planar0_burst_need_w} = (pixel_store_width >> pixel_planar0_sft_nxt) + 14'h2;
//assign {mon_pixel_planar1_burst_need_w[0],
//        pixel_planar1_burst_need_w} = (pixel_store_width >> pixel_planar1_sft_nxt) + 14'h2;
assign {mon_pixel_planar0_rp_burst_w[10:0],
        pixel_planar0_rp_burst_w} = (pixel_planar0_burst_need_w - {10'd0,pixel_planar0_lp_burst_w}) - pixel_planar0_width_burst_w;
assign {mon_pixel_planar1_rp_burst_w[11:0],
        pixel_planar1_rp_burst_w} = (pixel_planar1_burst_need_w - {11'd0,pixel_planar1_lp_burst_w}) - pixel_planar1_width_burst_w;
assign byte_per_pixel = ~(|pixel_precision_nxt) ? 3'h3 : 3'h6;

////////////////////////////////////////////////
// early end control
////////////////////////////////////////////////
//: my $dmaif_bw = int( log(int(NVDLA_CDMA_DMAIF_BW/8)) / log(2) );
//: print qq(
//:     assign {mon_pixel_planar1_total_width_w,
//:             pixel_planar1_total_width_w} = reg2dp_pad_left + reg2dp_datain_width[${dmaif_bw}-1:0] + reg2dp_pad_right + 1;
//:     assign {pixel_planar1_tail_width_w,
//:             mon_pixel_planar1_tail_width_w} = pixel_planar1_total_width_w * byte_per_pixel + {${dmaif_bw}{1'b1}};
//: );

/////////////////////////////
//: my $dmaif = NVDLA_CDMA_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: if($dmaif/$atmm == 1 ) {
//:     print qq(
//:         assign pixel_early_end_w = pixel_planar_nxt & ((pixel_planar1_tail_width_w==3'd1) | (pixel_planar1_tail_width_w==3'd4) | ((pixel_planar1_tail_width_w==3'd2) & {pixel_planar1_total_width_w,1'b0} > $dmaif) );
//:     );
//: } elsif($dmaif/$atmm == 2 ) {
//:     print qq(
//:         assign {mon_pixel_planar1_total_burst_w[1:0], pixel_planar1_total_burst_w[1:0]} 
//:                                     = pixel_planar1_lp_burst_w[1:0] + pixel_planar1_rp_burst_w[1:0] + pixel_planar1_width_burst_w[1:0];
//:         assign pixel_tail_1_w = (pixel_planar1_tail_width_w == 3'h1) | (pixel_planar1_tail_width_w == 3'h4);
//:         assign pixel_tail_2_w = (pixel_planar1_tail_width_w == 3'h2) | (pixel_planar1_tail_width_w == 3'h5);
//:         assign pixel_early_end_w = pixel_planar_nxt & (pixel_tail_1_w | (pixel_tail_2_w & ~pixel_planar1_total_burst_w[1]));
//:     );
//: } elsif($dmaif/$atmm == 4 ) {
//: }


////////////////////////////////////////////////
////////////////////////////////////////////////

// assign {mon_pixel_element_sft_w,
//         pixel_element_sft_w} = (reg2dp_pixel_x_offset - reg2dp_pad_left);

// 5bits means atmm bit-width
// assign {mon_pixel_planar0_byte_sft_w[4:0],
//         pixel_planar0_byte_sft_w} = {pixel_element_sft_w, 5'b0} >> pixel_planar0_sft_nxt;
// assign {mon_pixel_planar1_byte_sft_w[4:0],
//         pixel_planar1_byte_sft_w} = {pixel_element_sft_w, 5'b0} >> pixel_planar1_sft_nxt;

//: my $atmmbw = int( log(NVDLA_MEMORY_ATOMIC_SIZE) / log(2) );
//: print qq(
//:     assign {mon_pixel_element_sft_w,
//:             pixel_element_sft_w} = (reg2dp_pixel_x_offset - {2'd0,reg2dp_pad_left[${atmmbw}-1:0]});
//:     assign {mon_pixel_planar0_byte_sft_w[2:0],
//:             pixel_planar0_byte_sft_w} = {pixel_element_sft_w, ${atmmbw}'b0} >> pixel_planar0_sft_nxt;
//:     assign {mon_pixel_planar1_byte_sft_w[2:0],
//:             pixel_planar1_byte_sft_w} = {pixel_element_sft_w, ${atmmbw}'b0} >> pixel_planar1_sft_nxt;
//: );
assign pixel_planar0_bundle_limit_w = 4'h8;
assign pixel_planar0_bundle_limit_1st_w = 4'h9;
assign pixel_planar1_bundle_limit_w = 5'h10;
assign pixel_planar1_bundle_limit_1st_w = 5'h11;

assign planar1_vld_w = pixel_planar_nxt;
assign pixel_planar0_lp_vld_w = (|pixel_planar0_lp_burst_w);
assign pixel_planar1_lp_vld_w = (|pixel_planar1_lp_burst_w);
assign pixel_planar0_rp_vld_w = (|pixel_planar0_rp_burst_w);
assign pixel_planar1_rp_vld_w = (|pixel_planar1_rp_burst_w);

//: my $atmmbw = int( log(NVDLA_MEMORY_ATOMIC_SIZE) / log(2) );
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_planar_nxt\" -q pixel_planar");
//: &eperl::flop("-nodeclare   -rval \"{2{1'b0}}\"  -en \"layer_st\" -d \"pixel_precision_nxt\" -q pixel_precision");
//: &eperl::flop("-nodeclare   -rval \"{11{1'b0}}\"  -en \"layer_st\" -d \"pixel_order_nxt\" -q pixel_order");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_packed_10b_nxt\" -q pixel_packed_10b");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_data_expand_nxt\" -q pixel_data_expand");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_data_shrink_nxt\" -q pixel_data_shrink");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_uint_nxt\" -q pixel_uint");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_sft_nxt\" -q pixel_planar0_sft");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_sft_nxt\" -q pixel_planar1_sft");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_lp_burst_w\" -q pixel_planar0_lp_burst");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_lp_burst_w\" -q pixel_planar1_lp_burst");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_planar0_lp_vld_w\" -q pixel_planar0_lp_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_lp_vld_w\" -q pixel_planar1_lp_vld");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_width_burst_w\" -q pixel_planar0_width_burst");
//: &eperl::flop("-nodeclare   -rval \"{14{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_width_burst_w\" -q pixel_planar1_width_burst");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_rp_burst_w\" -q pixel_planar0_rp_burst");
//: &eperl::flop("-nodeclare   -rval \"{3{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_rp_burst_w\" -q pixel_planar1_rp_burst");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st\" -d \"pixel_planar0_rp_vld_w\" -q pixel_planar0_rp_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_rp_vld_w\" -q pixel_planar1_rp_vld");
//: &eperl::flop("-nodeclare   -rval \"1'b0\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_early_end_w\" -q pixel_early_end");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_byte_sft_w\" -q pixel_planar0_byte_sft");
//: &eperl::flop("-nodeclare   -rval \"{${atmmbw}{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_byte_sft_w\" -q pixel_planar1_byte_sft");
//: &eperl::flop("-nodeclare   -rval \"{6{1'b0}}\"  -en \"layer_st\" -d \"reg2dp_data_bank + 1'b1\" -q pixel_bank");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_bundle_limit_w\" -q pixel_planar0_bundle_limit");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_bundle_limit_w\" -q pixel_planar1_bundle_limit");
//: &eperl::flop("-nodeclare   -rval \"{4{1'b0}}\"  -en \"layer_st\" -d \"pixel_planar0_bundle_limit_1st_w\" -q pixel_planar0_bundle_limit_1st");
//: &eperl::flop("-nodeclare   -rval \"{5{1'b0}}\"  -en \"layer_st & planar1_vld_w\" -d \"pixel_planar1_bundle_limit_1st_w\" -q pixel_planar1_bundle_limit_1st");


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


////////////////////////////////////////////////////////////////////////
//  Assertion                                                         //
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

  nv_assert_no_x #(0,2,0,"No Xs allowed on cur_state")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1, cur_state); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(reg2dp_op_en & is_idle))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(img_end | is_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st & planar1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 

  nv_assert_never #(0,0,"Error config! PIXEL for non-DC")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~is_dc & is_pixel)); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error config! Invalid image type")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & img_en & (reg2dp_pixel_format > 6'h23 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error Config! Pixel format is not pitch linear!")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (reg2dp_pixel_mapping != 1'h0 ))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error Config! Pixel X offset is out of range!")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|(reg2dp_pixel_x_offset & ~pixel_planar0_mask_nxt)))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error Config! Unmatch input int8 precision")      zzz_assert_never_37x (nvdla_core_clk, `ASSERT_RESET, (img_en & ((pixel_precision_nxt == 2'h0) ^ (reg2dp_in_precision == 2'h0 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error Config! Unmatch input int16 precision")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (img_en & (((pixel_precision_nxt == 2'h1) | (pixel_precision_nxt == 2'h2)) ^ (reg2dp_in_precision == 2'h1 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error Config! Unmatch input fp16 precision")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (img_en & ((pixel_precision_nxt == 2'h3) ^ (reg2dp_in_precision == 2'h2 )))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar0_lp_burst_w is overflow!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_lp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar1_lp_burst_w is overflow!")      zzz_assert_never_41x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_lp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar0_burst_need_w is overflow!")      zzz_assert_never_42x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_burst_need_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar1_burst_need_w is overflow!")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_burst_need_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar0_rp_burst_w is overflow!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar0_rp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar1_rp_burst_w is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_planar1_rp_burst_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar0_lp_burst_w is out of range!")      zzz_assert_never_46x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar0_lp_burst_w > 4'h8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar1_lp_burst_w is out of range!")      zzz_assert_never_47x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar1_lp_burst_w > 3'h4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar0_rp_burst_w is out of range!")      zzz_assert_never_48x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar0_rp_burst_w > 4'h9))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"Error! pixel_planar1_rp_burst_w is out of range!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (pixel_planar1_rp_burst_w > 3'h5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

endmodule // NV_NVDLA_CDMA_IMG_ctrl
