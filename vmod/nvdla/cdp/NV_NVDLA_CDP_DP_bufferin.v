// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_bufferin.v

#include "NV_NVDLA_CDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_DP_bufferin (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cdp_rdma2dp_pd
  ,cdp_rdma2dp_valid
  ,normalz_buf_data_prdy
  ,cdp_rdma2dp_ready
  ,normalz_buf_data
  ,normalz_buf_data_pvld
  );
/////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+14:0] cdp_rdma2dp_pd;
input          cdp_rdma2dp_valid;
input          normalz_buf_data_prdy;
output         cdp_rdma2dp_ready;
//output [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE*3+14:0] normalz_buf_data;
output [(NVDLA_CDP_THROUGHPUT+8)*NVDLA_CDP_ICVTO_BWPE+14:0] normalz_buf_data;
output         normalz_buf_data_pvld;
/////////////////////////////////////////////////////////////
reg            NormalC2CubeEnd;
reg            b_sync_align;
reg            b_sync_dly1;
reg            buf_dat_vld;
reg            buffer_b_sync;
reg    [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE*3:0] buffer_data;
reg            buffer_data_vld;
reg            buffer_last_c;
reg            buffer_last_h;
reg            buffer_last_w;
reg      [2:0] buffer_pos_c;
reg      [3:0] buffer_pos_w;
//reg            buffer_ready;
reg      [3:0] buffer_width;
//reg            cdp_rdma2dp_ready;
reg      [3:0] cube_end_width_cnt;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_0;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_1;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_2;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_3;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_4;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_5;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_6;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_1stC_7;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_00;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_01;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_02;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_10;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_11;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_12;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_20;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_21;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_22;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_30;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_31;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_32;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_40;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_41;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_42;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_50;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_51;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_52;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_60;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_61;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_62;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_70;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_71;
reg     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] data_shift_72;
reg            data_shift_valid;
reg            hold_here;
reg            hold_here_dly;
reg      [3:0] is_pos_w_dly;
reg      [3:0] is_pos_w_dly2;
reg            last_c_align;
reg            last_c_dly1;
reg            last_h_align;
reg            last_h_dly1;
reg            last_w_align;
reg            last_w_dly1;
reg      [3:0] last_width;
reg            less2more_dly;
reg            less2more_dly2;
reg            more2less_dly;
reg      [2:0] pos_c_align;
reg      [2:0] pos_c_dly1;
reg      [3:0] pos_w_align;
reg      [3:0] pos_w_dly1;
reg      [2:0] stat_cur;
reg      [2:0] stat_cur_dly;
reg      [2:0] stat_cur_dly2;
reg      [2:0] stat_nex;
reg      [3:0] width_align;
reg      [3:0] width_cur_1;
reg      [3:0] width_cur_2;
reg      [3:0] width_dly1;
reg      [3:0] width_pre;
reg      [3:0] width_pre_cnt;
reg      [3:0] width_pre_cnt_dly;
reg      [3:0] width_pre_dly;
reg      [3:0] width_pre_dly2;
wire           FIRST_C_bf_end;
wire           FIRST_C_end;
wire           buf_dat_rdy;
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $k = (${tp}+8)*${icvto}+15;
//: print "wire    [${k}-1:0] buffer_pd;   \n";

wire           buffer_valid;
wire           cube_done;
wire           data_shift_load;
wire           data_shift_load_all;
wire           data_shift_ready;
wire           dp_b_sync;
wire     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE:0] dp_data;
wire           dp_last_c;
wire           dp_last_h;
wire           dp_last_w;
wire     [2:0] dp_pos_c;
wire     [3:0] dp_pos_w;
wire     [3:0] dp_width;
wire           is_b_sync;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire     [2:0] is_pos_c;
wire     [3:0] is_pos_w;
wire     [3:0] is_width;
wire     [3:0] is_width_f;
wire           l2m_1stC_vld;
wire           less2more;
wire           load_din;
wire           load_din_full;
wire           more2less;
wire           nvdla_cdp_rdma2dp_ready;
wire           rdma2dp_ready_normal;
wire           rdma2dp_valid_rebuild;
wire           vld;
wire     [3:0] width_cur;
/////////////////////////////////////////////////////////////
//
parameter cvt2buf_data_bw = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE;
parameter cvt2buf_info_bw = 15;
parameter cvt2buf_dp_bw = cvt2buf_data_bw + cvt2buf_info_bw;

/////////////////////////////////////////////////////////////
//: my $k = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+15;
//: &eperl::pipe(" -is -wid $k -do nvdla_cdp_rdma2dp_pd -vo nvdla_cdp_rdma2dp_valid -ri nvdla_cdp_rdma2dp_ready -di cdp_rdma2dp_pd -vi cdp_rdma2dp_valid -ro cdp_rdma2dp_ready ");

//==============
// INPUT UNPACK: from RDMA
//==============
assign       dp_data[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0];
assign       dp_pos_w[3:0] =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+3:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE];
assign       dp_width[3:0] =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+7:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+4];
assign       dp_pos_c[2:0] =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+10:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+8];
assign        dp_b_sync  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+11];
assign        dp_last_w  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+12];
assign        dp_last_h  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+13];
assign        dp_last_c  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+14];

assign is_pos_w       = dp_pos_w;
assign is_width_f     = dp_width[3:0];
assign is_width[3:0]  = is_width_f - 1'b1;
assign is_pos_c  = dp_pos_c;
assign is_b_sync = dp_b_sync ;
assign is_last_w = dp_last_w ;
assign is_last_h = dp_last_h ;
assign is_last_c = dp_last_c ;

///////////////////////////////////////////////////
assign nvdla_cdp_rdma2dp_ready = rdma2dp_ready_normal & (~hold_here);
assign rdma2dp_valid_rebuild = nvdla_cdp_rdma2dp_valid | hold_here;

assign vld = rdma2dp_valid_rebuild;
assign load_din = vld & nvdla_cdp_rdma2dp_ready;
assign load_din_full = rdma2dp_valid_rebuild & rdma2dp_ready_normal;
///////////////////////////////////////////////////
localparam WAIT = 3'b000;
localparam NORMAL_C = 3'b001;
localparam FIRST_C = 3'b010;
localparam SECOND_C = 3'b011;
localparam CUBE_END = 3'b100;

  always @(*) begin
    stat_nex = stat_cur;
    NormalC2CubeEnd = 0;
    begin
      casez (stat_cur)
        WAIT: begin
          if ((is_b_sync & (is_pos_c==3'd0) & load_din)) begin
            stat_nex = NORMAL_C; 
          end
        end
        NORMAL_C: begin
          if ((is_b_sync & (is_pos_c==3'd3) & is_last_c & is_last_h & is_last_w & load_din)) begin
            NormalC2CubeEnd = 1;
            stat_nex = CUBE_END; 
          end
          else if ((is_b_sync & (is_pos_c==3'd3) & is_last_c) & (~(is_last_h & is_last_w) & load_din)) begin
            stat_nex = FIRST_C; 
          end
        end
        FIRST_C: begin
          if (((is_pos_w == is_width) & (~more2less) & load_din)
                  ||(more2less & (width_pre_cnt == width_pre) & hold_here & rdma2dp_ready_normal)) begin
            stat_nex = SECOND_C; 
          end
        end
        SECOND_C: begin
          if (is_b_sync & load_din) begin
            stat_nex = NORMAL_C; 
          end
        end
        CUBE_END: begin
          if (cube_done) begin
            stat_nex = WAIT; 
          end
        end
        // VCS coverage off
        default: begin
          stat_nex = WAIT; 
          `ifndef SYNTHESIS
          stat_nex = {3{1'bx}};
          `endif
        end
        // VCS coverage on
      endcase
    end
  end

  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
      stat_cur <= WAIT;
    end else begin
    stat_cur <= stat_nex;
    end
  end
/////////////////////////////////////////
assign rdma2dp_ready_normal = (~data_shift_valid) | data_shift_ready; 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_shift_valid <= 1'b0;
  end else begin
        if(vld)
            data_shift_valid <= 1'b1;
        else if(data_shift_ready)
            data_shift_valid <= 1'b0;
  end
end
assign data_shift_ready =(~buf_dat_vld | buf_dat_rdy);

assign data_shift_load_all = data_shift_ready & data_shift_valid;
assign data_shift_load = data_shift_load_all & ((~hold_here_dly)  | (stat_cur_dly == CUBE_END));
/////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_shift_00 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_10 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_20 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_30 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_40 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_50 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_60 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_70 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_01 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_02 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_11 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_12 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_21 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_22 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_31 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_32 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_41 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_42 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_51 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_52 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_61 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_62 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_71 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_shift_72 <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_0   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_1   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_2   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_3   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_4   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_5   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_6   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
    data_1stC_7   <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE{1'b0}};
  end else begin
  case(stat_cur)
      WAIT: begin
          if(load_din) begin
              if(is_pos_w==4'd0) begin
                  data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd1) begin
                  data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd2) begin
                  data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd3) begin
                  data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd4) begin
                  data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd5) begin
                  data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd6) begin
                  data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
              end
              if(is_pos_w==4'd7) begin
                  data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
              end
                  data_shift_01 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_02 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_11 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_12 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_21 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_22 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_31 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_32 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_41 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_42 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_51 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_52 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_61 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_62 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_71 <= {cvt2buf_data_bw{1'd0}};
                  data_shift_72 <= {cvt2buf_data_bw{1'd0}};
      end end
      NORMAL_C: begin
          if(load_din) begin
                      if(is_pos_w==4'd0) begin
                      data_shift_02 <= data_shift_01;
                      data_shift_01 <= data_shift_00;
                      data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd1) begin
                      data_shift_12 <= data_shift_11;
                      data_shift_11 <= data_shift_10;
                      data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd2) begin
                      data_shift_22 <= data_shift_21;
                      data_shift_21 <= data_shift_20;
                      data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd3) begin
                      data_shift_32 <= data_shift_31;
                      data_shift_31 <= data_shift_30;
                      data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd4) begin
                      data_shift_42 <= data_shift_41;
                      data_shift_41 <= data_shift_40;
                      data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd5) begin
                      data_shift_52 <= data_shift_51;
                      data_shift_51 <= data_shift_50;
                      data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd6) begin
                      data_shift_62 <= data_shift_61;
                      data_shift_61 <= data_shift_60;
                      data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd7) begin
                      data_shift_72 <= data_shift_71;
                      data_shift_71 <= data_shift_70;
                      data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
                      end
      end end
      FIRST_C: begin
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd0) begin
                                  data_shift_02 <= data_shift_01;
                                  data_shift_01 <= data_shift_00;
                                  data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd0) & load_din) begin
                                  data_1stC_0   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_02 <= data_shift_01;
                                  data_shift_01 <= data_shift_00;
                                  data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd1) begin
                                  data_shift_12 <= data_shift_11;
                                  data_shift_11 <= data_shift_10;
                                  data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd1) & load_din) begin
                                  data_1stC_1   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_12 <= data_shift_11;
                                  data_shift_11 <= data_shift_10;
                                  data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd2) begin
                                  data_shift_22 <= data_shift_21;
                                  data_shift_21 <= data_shift_20;
                                  data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd2) & load_din) begin
                                  data_1stC_2   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_22 <= data_shift_21;
                                  data_shift_21 <= data_shift_20;
                                  data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd3) begin
                                  data_shift_32 <= data_shift_31;
                                  data_shift_31 <= data_shift_30;
                                  data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd3) & load_din) begin
                                  data_1stC_3   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_32 <= data_shift_31;
                                  data_shift_31 <= data_shift_30;
                                  data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd4) begin
                                  data_shift_42 <= data_shift_41;
                                  data_shift_41 <= data_shift_40;
                                  data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd4) & load_din) begin
                                  data_1stC_4   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_42 <= data_shift_41;
                                  data_shift_41 <= data_shift_40;
                                  data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd5) begin
                                  data_shift_52 <= data_shift_51;
                                  data_shift_51 <= data_shift_50;
                                  data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd5) & load_din) begin
                                  data_1stC_5   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_52 <= data_shift_51;
                                  data_shift_51 <= data_shift_50;
                                  data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd6) begin
                                  data_shift_62 <= data_shift_61;
                                  data_shift_61 <= data_shift_60;
                                  data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd6) & load_din) begin
                                  data_1stC_6   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_62 <= data_shift_61;
                                  data_shift_61 <= data_shift_60;
                                  data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
                          if(hold_here & rdma2dp_ready_normal) begin
                              if(width_pre_cnt==4'd7) begin
                                  data_shift_72 <= data_shift_71;
                                  data_shift_71 <= data_shift_70;
                                  data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end else begin
                              if((is_pos_w==4'd7) & load_din) begin
                                  data_1stC_7   <= dp_data[cvt2buf_data_bw-1:0];
                                  data_shift_72 <= data_shift_71;
                                  data_shift_71 <= data_shift_70;
                                  data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                              end
                          end
      end// end
      SECOND_C: begin
          if(load_din) begin
                      if(is_pos_w==4'd0) begin
                      data_shift_02 <= 0;
                      data_shift_01 <= data_1stC_0;
                      data_shift_00 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd1) begin
                      data_shift_12 <= 0;
                      data_shift_11 <= data_1stC_1;
                      data_shift_10 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd2) begin
                      data_shift_22 <= 0;
                      data_shift_21 <= data_1stC_2;
                      data_shift_20 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd3) begin
                      data_shift_32 <= 0;
                      data_shift_31 <= data_1stC_3;
                      data_shift_30 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd4) begin
                      data_shift_42 <= 0;
                      data_shift_41 <= data_1stC_4;
                      data_shift_40 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd5) begin
                      data_shift_52 <= 0;
                      data_shift_51 <= data_1stC_5;
                      data_shift_50 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd6) begin
                      data_shift_62 <= 0;
                      data_shift_61 <= data_1stC_6;
                      data_shift_60 <= dp_data[cvt2buf_data_bw-1:0];
                      end
                      if(is_pos_w==4'd7) begin
                      data_shift_72 <= 0;
                      data_shift_71 <= data_1stC_7;
                      data_shift_70 <= dp_data[cvt2buf_data_bw-1:0];
                      end
      end end
      CUBE_END: begin
          if(rdma2dp_ready_normal) begin
                      if(cube_end_width_cnt==4'd0) begin
                      data_shift_02 <= data_shift_01;
                      data_shift_01 <= data_shift_00;
                      data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd1) begin
                      data_shift_12 <= data_shift_11;
                      data_shift_11 <= data_shift_10;
                      data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd2) begin
                      data_shift_22 <= data_shift_21;
                      data_shift_21 <= data_shift_20;
                      data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd3) begin
                      data_shift_32 <= data_shift_31;
                      data_shift_31 <= data_shift_30;
                      data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd4) begin
                      data_shift_42 <= data_shift_41;
                      data_shift_41 <= data_shift_40;
                      data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd5) begin
                      data_shift_52 <= data_shift_51;
                      data_shift_51 <= data_shift_50;
                      data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd6) begin
                      data_shift_62 <= data_shift_61;
                      data_shift_61 <= data_shift_60;
                      data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                      end
                      if(cube_end_width_cnt==4'd7) begin
                      data_shift_72 <= data_shift_71;
                      data_shift_71 <= data_shift_70;
                      data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                      end
      end end
      default: begin 
                      data_shift_02 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_01 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_00 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_0 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_12 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_11 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_10 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_1 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_22 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_21 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_20 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_2 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_32 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_31 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_30 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_3 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_42 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_41 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_40 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_4 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_52 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_51 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_50 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_5 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_62 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_61 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_60 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_6 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_72 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_71 <= {cvt2buf_data_bw{1'd0}};
                      data_shift_70 <= {cvt2buf_data_bw{1'd0}};
                      data_1stC_7 <= {cvt2buf_data_bw{1'd0}};
      end
 endcase
   end
 end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre <= {4{1'b0}};
  end else begin
    if((stat_cur==NORMAL_C) & is_last_c & is_b_sync & (is_pos_c==3'd3) & load_din)
        width_pre <= is_width;
  end
end
always @(
  stat_cur
  or is_pos_w
  or is_width
  ) begin
    //if((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)
    if((stat_cur==FIRST_C) & (is_pos_w == 0))
        width_cur_1 = is_width;
    else
        width_cur_1 = 0;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_cur_2 <= {4{1'b0}};
  end else begin
    if((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)
        width_cur_2 <= is_width;
  end
end
//assign width_cur = ((stat_cur==FIRST_C) & (is_pos_w == 0) & load_din)? width_cur_1 : width_cur_2;
assign width_cur = ((stat_cur==FIRST_C) & (is_pos_w == 0))? width_cur_1 : width_cur_2;

assign more2less = (stat_cur==FIRST_C) & (width_cur<width_pre);
assign less2more = (stat_cur==FIRST_C) & (width_cur>width_pre);
assign l2m_1stC_vld = (stat_cur==FIRST_C) & less2more & (is_pos_w <= width_pre);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    hold_here <= 1'b0;
  end else begin
    if((stat_cur==FIRST_C) & more2less) begin
            if((is_pos_w==is_width) & load_din)
                hold_here <= 1;
            else if((width_pre_cnt == width_pre) & rdma2dp_ready_normal)
                hold_here <= 0;
    end else if(NormalC2CubeEnd)//stat_cur==CUBE_END)
            hold_here <= 1;
    else if(cube_done)
            hold_here <= 0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_cnt[3:0] <= {4{1'b0}};
  end else begin
    if((stat_cur==FIRST_C) & more2less) begin
        if((is_pos_w==is_width) & load_din)
            width_pre_cnt[3:0] <= is_width+4'd1;
        else if(hold_here & rdma2dp_ready_normal)
            width_pre_cnt[3:0] <= width_pre_cnt+4'd1;
    end else
        width_pre_cnt[3:0] <= 4'd0;
  end
end

//the last block data need to be output in cube end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_width <= {4{1'b0}};
  end else begin
    if(NormalC2CubeEnd & load_din)
        last_width <= is_width;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cube_end_width_cnt <= {4{1'b0}};
  end else begin
    if(stat_cur==CUBE_END) begin
        if(rdma2dp_ready_normal) begin
            if(cube_end_width_cnt == last_width)
                cube_end_width_cnt <= 4'd0;
            else
                cube_end_width_cnt <= cube_end_width_cnt + 1;
        end
    end else
        cube_end_width_cnt <= 4'd0;
  end
end

assign cube_done = (stat_cur==CUBE_END) && (cube_end_width_cnt == last_width) & rdma2dp_ready_normal;

//1pipe delay for buffer data generation

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly <= {3{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    stat_cur_dly <= stat_cur;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    stat_cur_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    more2less_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    more2less_dly <= more2less;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    more2less_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    less2more_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    less2more_dly <= less2more;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    less2more_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    hold_here_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    hold_here_dly <= hold_here;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    hold_here_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_pos_w_dly <= {4{1'b0}};
  end else begin
    if((stat_cur == CUBE_END) & rdma2dp_ready_normal)
        is_pos_w_dly <= cube_end_width_cnt;
    else if(load_din)
        is_pos_w_dly <= is_pos_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_cnt_dly <= {4{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    width_pre_cnt_dly <= width_pre_cnt;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    width_pre_cnt_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    width_pre_dly <= {4{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    width_pre_dly <= width_pre;
  // VCS coverage off
  end else if ((load_din_full) == 1'b0) begin
  end else begin
    width_pre_dly <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(load_din_full))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////
//buffer data generation for output data

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_data <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE*3{1'b0}};
  end else begin
  if(((stat_cur_dly==NORMAL_C) || (stat_cur_dly==SECOND_C) || (stat_cur_dly==CUBE_END)) & data_shift_load) begin
      if(is_pos_w_dly==4'd0)
          buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
      if(is_pos_w_dly==4'd1)
          buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
      if(is_pos_w_dly==4'd2)
          buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
      if(is_pos_w_dly==4'd3)
          buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
      if(is_pos_w_dly==4'd4)
          buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
      if(is_pos_w_dly==4'd5)
          buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
      if(is_pos_w_dly==4'd6)
          buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
      if(is_pos_w_dly==4'd7)
          buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
  end else if(stat_cur_dly==FIRST_C) begin
      if(more2less_dly) begin
//           if((~hold_here_dly) & data_shift_load) begin
          if(data_shift_load) begin
              if(is_pos_w_dly==4'd0)
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(is_pos_w_dly==4'd1)
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(is_pos_w_dly==4'd2)
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(is_pos_w_dly==4'd3)
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(is_pos_w_dly==4'd4)
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(is_pos_w_dly==4'd5)
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(is_pos_w_dly==4'd6)
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(is_pos_w_dly==4'd7)
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end else if(hold_here_dly & data_shift_ready) begin
              if(width_pre_cnt_dly==4'd0)
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(width_pre_cnt_dly==4'd1)
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(width_pre_cnt_dly==4'd2)
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(width_pre_cnt_dly==4'd3)
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(width_pre_cnt_dly==4'd4)
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(width_pre_cnt_dly==4'd5)
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(width_pre_cnt_dly==4'd6)
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(width_pre_cnt_dly==4'd7)
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end
      end else begin
          if((is_pos_w_dly<=width_pre_dly) & data_shift_load) begin
              if(is_pos_w_dly==4'd0 )
                  buffer_data <= {data_shift_00,data_shift_01,data_shift_02};
              if(is_pos_w_dly==4'd1 )
                  buffer_data <= {data_shift_10,data_shift_11,data_shift_12};
              if(is_pos_w_dly==4'd2 )
                  buffer_data <= {data_shift_20,data_shift_21,data_shift_22};
              if(is_pos_w_dly==4'd3 )
                  buffer_data <= {data_shift_30,data_shift_31,data_shift_32};
              if(is_pos_w_dly==4'd4 )
                  buffer_data <= {data_shift_40,data_shift_41,data_shift_42};
              if(is_pos_w_dly==4'd5 )
                  buffer_data <= {data_shift_50,data_shift_51,data_shift_52};
              if(is_pos_w_dly==4'd6 )
                  buffer_data <= {data_shift_60,data_shift_61,data_shift_62};
              if(is_pos_w_dly==4'd7 )
                  buffer_data <= {data_shift_70,data_shift_71,data_shift_72};
          end else if(data_shift_load) begin
              buffer_data <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE*3{1'd0}};
          end
      end
  end else if(data_shift_ready) begin
      buffer_data <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE*3{1'd0}};
  end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buf_dat_vld <= 1'b0;
  end else begin
    if(data_shift_valid)
        buf_dat_vld <=  1'b1 ;
    else if(buf_dat_rdy)
        buf_dat_vld <=  1'b0 ;
  end
end
//  assign buf_dat_rdy = buffer_ready;

//assign buf_dat_load_all = buf_dat_vld & buf_dat_rdy;
//assign buf_dat_load     = buf_dat_load_all & (~hold_here_dly2);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly2 <= {3{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    stat_cur_dly2 <= stat_cur_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    stat_cur_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    less2more_dly2 <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    less2more_dly2 <= less2more_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    less2more_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_pos_w_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    is_pos_w_dly2 <= is_pos_w_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    is_pos_w_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    width_pre_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    width_pre_dly2 <= width_pre_dly;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    width_pre_dly2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  stat_cur_dly2
  or less2more_dly2
  or is_pos_w_dly2
  or width_pre_dly2
  or buf_dat_vld
  ) begin
   if(((stat_cur_dly2==FIRST_C) & less2more_dly2 & (is_pos_w_dly2 > width_pre_dly2)) || (stat_cur_dly2==WAIT)) 
       buffer_data_vld = 1'b0;
   else
       buffer_data_vld = buf_dat_vld;
end

///////////////////////////////////////////////////////////////////////////////////////////
//output data_info generation
///////////////////////////////////////////////////////////////////////////////////////////
assign FIRST_C_end = ((stat_cur==FIRST_C) & (width_pre_cnt == width_pre) & more2less & rdma2dp_ready_normal);
assign FIRST_C_bf_end = ((stat_cur==FIRST_C) & (width_pre_cnt < width_pre) & more2less);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_align <= {4{1'b0}};
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    width_align <= is_width;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    width_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_w_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_w_align <= is_last_w;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_w_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_h_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_h_align <= is_last_h;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_h_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_c_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_c_align <= is_last_c;
  // VCS coverage off
  end else if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b0) begin
  end else begin
    last_c_align <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    pos_c_align <= {3{1'b0}};
  end else begin
    if(FIRST_C_end)
        pos_c_align <= 3'd0;
    else if(is_b_sync & load_din & (~FIRST_C_bf_end))
        pos_c_align <= is_pos_c;
  end
end
always @(*) begin
    if(stat_cur==CUBE_END)
        pos_w_align = cube_end_width_cnt;
    else if(stat_cur==WAIT)
        pos_w_align = 4'd0;
    else if(stat_cur==FIRST_C) begin
        if(more2less) begin
            if(hold_here)
                pos_w_align = width_pre_cnt;
            else
                pos_w_align = is_pos_w;
        end else if(less2more) begin
            if((is_pos_w <= width_pre))
                pos_w_align = is_pos_w;
            else
                pos_w_align = 4'd0;
        end else
                pos_w_align = is_pos_w;
    end else
        pos_w_align = is_pos_w;
end
always @(*) begin
    if(stat_cur==CUBE_END)
        b_sync_align = cube_done;
    else if(stat_cur==WAIT)
        b_sync_align = 1'b0;
    else if(stat_cur==FIRST_C) begin
        if(more2less)
            b_sync_align = (width_pre_cnt == width_pre);
        else if(less2more)
            b_sync_align = (is_pos_w == width_pre) & load_din;
        else
            b_sync_align = (is_b_sync & load_din);
    end
    else
        b_sync_align = (is_b_sync & load_din);
end

///////////////////
//Two cycle delay
///////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pos_w_dly1 <= {4{1'b0}};
    width_dly1 <= {4{1'b0}};
    pos_c_dly1 <= {3{1'b0}};
    b_sync_dly1 <= 1'b0;
    last_w_dly1 <= 1'b0;
    last_h_dly1 <= 1'b0;
    last_c_dly1 <= 1'b0;
  end else begin
    if((((stat_cur==NORMAL_C)||(stat_cur==SECOND_C)) & load_din)
      || ((stat_cur==CUBE_END) & rdma2dp_ready_normal))begin
        pos_w_dly1  <=  pos_w_align;
        width_dly1  <=  width_align;
        pos_c_dly1  <=  pos_c_align;
        b_sync_dly1 <=  b_sync_align;
        last_w_dly1 <=  last_w_align;
        last_h_dly1 <=  last_h_align;
        last_c_dly1 <=  last_c_align;
    end else if(stat_cur==FIRST_C) begin
        if(more2less & rdma2dp_ready_normal) begin
            if(hold_here) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end else if(load_din) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end
        end else if(less2more) begin
            if(l2m_1stC_vld & load_din) begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
            end
        end else if(load_din)begin
                pos_w_dly1  <=  pos_w_align;
                width_dly1  <=  width_align;
                pos_c_dly1  <=  pos_c_align;
                b_sync_dly1 <=  b_sync_align;
                last_w_dly1 <=  last_w_align;
                last_h_dly1 <=  last_h_align;
                last_c_dly1 <=  last_c_align;
        end
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_pos_w <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_pos_w <= pos_w_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_pos_w <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_width <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_width <= width_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_pos_c <= {3{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_pos_c <= pos_c_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_pos_c <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_b_sync <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_b_sync <= b_sync_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_b_sync <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_w <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_w <= last_w_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_w <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_h <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_h <= last_h_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    buffer_last_c <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_c <= last_c_dly1;
  // VCS coverage off
  end else if ((data_shift_load_all) == 1'b0) begin
  end else begin
    buffer_last_c <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(data_shift_load_all))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////////////

//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $k = (${tp}+8)*${icvto};
//: print qq(
//:     assign buffer_pd[${k}-1:0] = buffer_data[${k}-1+4*${icvto}:4*${icvto}];
//:     assign buffer_pd[${k}+3:${k}] =    buffer_pos_w[3:0];
//:     assign buffer_pd[${k}+7:${k}+4] =    buffer_width[3:0];
//:     assign buffer_pd[${k}+10:${k}+8] =    buffer_pos_c[2:0];
//:     assign buffer_pd[${k}+11] =    buffer_b_sync ;
//:     assign buffer_pd[${k}+12] =    buffer_last_w ;
//:     assign buffer_pd[${k}+13] =    buffer_last_h ;
//:     assign buffer_pd[${k}+14] =    buffer_last_c ;
//: );

/////////////////////////////////////////
assign buffer_valid = buffer_data_vld;

/////////////////////////////////////////
//output data pipe for register out

//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $k = (${tp}+8)*${icvto}+15;
//: &eperl::pipe(" -is -wid $k -do normalz_buf_data -vo normalz_buf_data_pvld -ri normalz_buf_data_prdy -di buffer_pd -vi buffer_valid -ro buffer_ready ");

assign buf_dat_rdy = buffer_ready;

/////////////////////////////////////////

//==============
//function points
//==============

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

    property CDP_bufin_widthchange__more2less__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        load_din_full & more2less;
    endproperty
    // Cover 0 : "load_din_full & more2less"
    FUNCPOINT_CDP_bufin_widthchange__more2less__0_COV : cover property (CDP_bufin_widthchange__more2less__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_bufin_widthchange__less2more__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        load_din_full & less2more;
    endproperty
    // Cover 1 : "load_din_full & less2more"
    FUNCPOINT_CDP_bufin_widthchange__less2more__1_COV : cover property (CDP_bufin_widthchange__less2more__1_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CDP_DP_bufferin


