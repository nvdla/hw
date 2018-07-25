// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_bufferin_tp1.v

#include "NV_NVDLA_CDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_DP_bufferin_tp1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cdp_rdma2dp_pd
  ,cdp_rdma2dp_valid
  ,normalz_buf_data_prdy
  ,cdp_rdma2dp_ready
  ,normalz_buf_data
  ,normalz_buf_data_pvld
  );
//////////////////////////////////////////////
parameter buf2sq_data_bw = NVDLA_CDP_ICVTO_BWPE*(NVDLA_CDP_THROUGHPUT+8);
parameter buf2sq_dp_bw = buf2sq_data_bw + 17;
//////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+17-1:0] cdp_rdma2dp_pd;
input          cdp_rdma2dp_valid;
input          normalz_buf_data_prdy;
output         cdp_rdma2dp_ready;
output [buf2sq_dp_bw-1:0] normalz_buf_data;
output         normalz_buf_data_pvld;
//////////////////////////////////////////////
reg            NormalC2CubeEnd;
reg            b_sync_align;
reg            b_sync_dly1;
reg            buf_dat_vld;
reg            buffer_b_sync;
reg    [buf2sq_data_bw-1:0] buffer_data;
reg            buffer_data_vld;
reg            buffer_last_c;
reg            buffer_last_h;
reg            buffer_last_w;
reg      [4:0] buffer_pos_c;
reg      [3:0] buffer_pos_w;
reg      [3:0] buffer_width;
wire           cdp_rdma2dp_ready;
reg      [3:0] cube_end_width_cnt;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//: foreach my $m  (0..7) {
//:     foreach my $k  (0..$reg_num -1) {
//:     print qq(
//:         reg     [${tp}*${bpe}-1:0] data_shift_${k}${m};
//:     );
//:     }
//: }
//: foreach my $m  (0..7) {
//:     foreach my $k  (0..$reg_1stc_num -1) {
//:     print qq(
//:         reg     [${tp}*${bpe}-1:0] data_1stC_${k}${m};
//:     );
//:     }
//: }
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
reg      [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+17-1:0] nvdla_cdp_rdma2dp_pd;
reg            nvdla_cdp_rdma2dp_valid;
reg      [4:0] pos_c_align;
reg      [4:0] pos_c_dly1;
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
wire    [buf2sq_dp_bw-1:0] buffer_pd;
wire           buffer_valid;
wire           cube_done;
wire           data_shift_load;
wire           data_shift_load_all;
wire           data_shift_ready;
wire           dp_b_sync;
wire     [NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] dp_data;
wire           dp_last_c;
wire           dp_last_h;
wire           dp_last_w;
wire     [4:0] dp_pos_c;
wire     [3:0] dp_pos_w;
wire     [3:0] dp_width;
wire           is_b_sync;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire     [4:0] is_pos_c;
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
reg      [1:0] hold_4ele_cnt;
wire           is_hold_4ele_done;

/////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////
// pipe
assign cdp_rdma2dp_ready = nvdla_cdp_rdma2dp_ready || (~nvdla_cdp_rdma2dp_valid);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn)
    nvdla_cdp_rdma2dp_valid <= 1'b0;
  else if(cdp_rdma2dp_valid)
    nvdla_cdp_rdma2dp_valid <= 1'b1;
  else if(nvdla_cdp_rdma2dp_ready)
    nvdla_cdp_rdma2dp_valid <= 1'b0;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn)
    nvdla_cdp_rdma2dp_pd <= {NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+17{1'b0}};
  else if(cdp_rdma2dp_valid & cdp_rdma2dp_ready)
    nvdla_cdp_rdma2dp_pd <= cdp_rdma2dp_pd;
end

/////////////////////////////////////////////////////////////
//==============
// INPUT UNPACK: from RDMA
//==============
assign  dp_data[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0] =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE-1:0];
assign  dp_pos_w[3:0] = nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+3:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE];
assign  dp_width[3:0] = nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+7:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+4];
assign  dp_pos_c[4:0] = nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+12:NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+8];
assign  dp_b_sync  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+13];
assign  dp_last_w  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+14];
assign  dp_last_h  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+15];
assign  dp_last_c  =    nvdla_cdp_rdma2dp_pd[NVDLA_CDP_THROUGHPUT*NVDLA_CDP_ICVTO_BWPE+16];

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
wire        is_4ele_here;
wire        is_posc_end;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $m  = int(4/$tp+0.99) -1;
//: if($tp < 4){
//:     print "assign is_4ele_here = (is_pos_c == ${m});  \n";
//: } else {
//:     print "assign is_4ele_here = (is_pos_c == 0);  \n";
//: }
//: my $k  = int($atmm/$tp) -1;
//: print "assign is_posc_end = (is_pos_c == ${k});  \n";

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
        if (is_b_sync & is_4ele_here & load_din) begin
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: if($atmm == 4) {
//:     print qq(
//:           if(is_posc_end & is_last_c & is_last_h & is_last_w) begin
//:               NormalC2CubeEnd = 1;
//:               stat_nex = CUBE_END;
//:           end else if(is_posc_end & is_last_c) begin
//:               stat_nex = FIRST_C; 
//:           end else begin
//:               stat_nex = NORMAL_C;
//:           end
//:     );
//: } elsif($atmm > 4) {
//:     print qq(
//:               stat_nex = NORMAL_C;
//:     );
//: }
        end
      end
      NORMAL_C: begin
        if (is_b_sync & is_posc_end & is_last_c & is_last_h & is_last_w & load_din) begin
          NormalC2CubeEnd = 1;
          stat_nex = CUBE_END; 
        end else if (is_b_sync & is_posc_end & is_last_c & load_din) begin
          stat_nex = FIRST_C; 
        end
      end
      FIRST_C: begin
        if ((is_4ele_here & (is_pos_w == is_width) & (~more2less) & load_din)
                || (more2less & (width_pre_cnt == width_pre) & is_hold_4ele_done & hold_here & rdma2dp_ready_normal)) begin
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: if($atmm == 4) {
//:     print qq(
//:            if(is_posc_end & is_last_c & is_last_h & is_last_w)
//:                stat_nex = CUBE_END;
//:            else if(is_posc_end & is_last_c)
//:                stat_nex = FIRST_C;
//:            else
//:                stat_nex = SECOND_C; 
//:     );
//: } elsif($atmm > 4) {
//:     print qq(
//:               stat_nex = SECOND_C;
//:     );
//: }
        end
      end
      SECOND_C: begin
        if (is_b_sync & load_din)
          stat_nex = NORMAL_C; 
      end
      CUBE_END: begin
        if (cube_done) 
          stat_nex = WAIT; 
      end
      default: begin
        stat_nex = WAIT; 
      end
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
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//:     foreach my $m  (0..7) {
//:         foreach my $k  (0..$reg_num -1) {
//:         print qq(
//:                 data_shift_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:         );
//:         }
//:     }
//:     foreach my $m  (0..7) {
//:         foreach my $k  (0..$reg_1stc_num -1) {
//:         print qq(
//:                data_1stC_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:         );
//:         }
//:     }
  end else begin
  case(stat_cur)
      WAIT: begin
          if(load_din) begin
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//:             foreach my $m  (0..7) {
//:                 print qq(
//:                     if(is_pos_w==4'd${m}) begin    
//:                     data_shift_0${m} <= dp_data[${tp}*${bpe}-1:0];
//:                 );
//:                 my $p = 4/$tp-2;
//:                 foreach my $s  (0..$p) {
//:                     my $q = $s +1;
//:                     print qq(
//:                         data_shift_${q}${m} <= data_shift_${s}${m};
//:                     );
//:                 }
//:                 print qq(
//:                     end
//:                 );
//:             }
//: print " // reset all of un-used register in WAIT status  \n";
//: my $reg_1stc_num = int(4/$tp);
//:     foreach my $m  (0..7) {
//:         foreach my $k  (0..$reg_1stc_num -1) {
//:         print qq(
//:                data_1stC_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:         );
//:         }
//:     }
//: my $rest = $reg_num - $reg_1stc_num;
//:     foreach my $m  (0..7) {
//:         foreach my $k  (0..$rest -1) {
//:         my $re = $k + $reg_1stc_num;
//:         print qq(
//:                 data_shift_${re}${m} <= {${tp}*${bpe}{1'd0}};
//:         );
//:         }
//:     }
      end end
      NORMAL_C: begin
          if(load_din) begin
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//:             foreach my $m  (0..7) {
//:                 print qq(
//:                         if(is_pos_w==4'd${m}) begin
//:                            data_shift_0${m} <= dp_data[${tp}*${bpe}-1:0];
//:                 );
//:                 foreach my $s  (0..$reg_num -2) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                            data_shift_${k}${m} <= data_shift_${s}${m};
//:                     );
//:                 }
//:                 print qq(
//:                        end
//:                 );
//:             }
      end end
      FIRST_C: begin
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//:             foreach my $m  (0..7) {
//:                 print qq(
//:                          if(hold_here & rdma2dp_ready_normal) begin                
//:                              if(width_pre_cnt==4'd${m}) begin                      
//:                                  data_shift_0${m} <= {${tp}*${bpe}{1'd0}};      
//:                 );
//:                 foreach my $s  (0..$reg_num -2) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                                  data_shift_${k}${m} <= data_shift_${s}${m};             
//:                     );
//:                 }
//:                 print qq(
//:                              end                                                   
//:                          end else begin                                            
//:                              if((is_pos_w==4'd${m}) & load_din) begin              
//:                                  data_1stC_0${m}  <= dp_data[${tp}*${bpe}-1:0]; 
//:                                  data_shift_0${m} <= {${tp}*${bpe}{1'd0}};      
//:                 );
//:                 foreach my $s  (0..$reg_num -2) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                                  data_shift_${k}${m} <= data_shift_${s}${m};             
//:                     );
//:                 }
//:                 foreach my $s  (0..$reg_1stc_num -2) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                                  data_1stC_${k}${m} <= data_1stC_${s}${m};             
//:                     );
//:                 }
//:                 print qq(
//:                              end                                                   
//:                          end                                                       
//:                 );
//:             }
      end
      SECOND_C: begin
          if(load_din) begin
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//:             foreach my $m  (0..7) {
//:                 print qq(
//:                        if(is_pos_w==4'd${m}) begin
//:                            data_shift_0${m} <= dp_data[${tp}*${bpe}-1:0];
//:                 );
//:                 foreach my $s  (0..$reg_1stc_num -1) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                            data_shift_${k}${m} <= data_1stC_${s}${m};
//:                     );
//:                 }
//:                 foreach my $s  (0..$reg_1stc_num -1) {
//:                 my $k = $s + $reg_1stc_num + 1;
//:                     print qq(
//:                            data_shift_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:                     );
//:                 }
//:                 print qq(
//:                        end
//:                 );
//:             }
      end end
      CUBE_END: begin
          if(rdma2dp_ready_normal) begin
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//:             foreach my $m  (0..7) {
//:                 print qq(
//:                         if(cube_end_width_cnt==4'd${m}) begin                
//:                                  data_shift_0${m} <= {${tp}*${bpe}{1'd0}};
//:                 );
//:                 foreach my $s  (0..$reg_num -2) {
//:                 my $k = $s + 1;
//:                     print qq(
//:                                  data_shift_${k}${m} <= data_shift_${s}${m};       
//:                     );
//:                 }
//:                 print qq(
//:                        end                                                   
//:                 );
//:             }
      end end
      default: begin 
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $bpe = NVDLA_CDP_ICVTO_BWPE;
//: my $reg_num = int(8/$tp + 1);
//: my $reg_1stc_num = int(4/$tp);
//:             foreach my $m  (0..7) {
//:                 foreach my $k  (0..$reg_num -1) {
//:                 print qq(
//:                         data_shift_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:                 );
//:                 }
//:             }
//:             foreach my $m  (0..7) {
//:                 foreach my $k  (0..$reg_1stc_num -1) {
//:                 print qq(
//:                        data_1stC_${k}${m} <= {${tp}*${bpe}{1'd0}};
//:                 );
//:                 }
//:             }
      end
 endcase
   end
 end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre <= {4{1'b0}};
  end else begin
    if((stat_cur==NORMAL_C) & is_last_c & is_b_sync & is_posc_end & load_din)
        width_pre <= is_width;
  end
end
always @(*) begin
    if((stat_cur==FIRST_C) & (is_pos_w == 0) & (is_pos_c == 0))
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
    end else if(NormalC2CubeEnd)
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn)
begin
  if (!nvdla_core_rstn)
    hold_4ele_cnt <= {2{1'b0}};
  else if((stat_cur==FIRST_C) & more2less & hold_here & (width_pre_cnt == width_pre) & rdma2dp_ready_normal) begin
    if(is_hold_4ele_done)
        hold_4ele_cnt <= {2{1'b0}};
    else
        hold_4ele_cnt <= hold_4ele_cnt + 1'b1;
  end
end
//: my $atomm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $m  = int(4/$tp+0.99) -1;
//:     print "assign is_hold_4ele_done = (hold_4ele_cnt == ${m});  ";


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

reg [2:0]   cube_end_c_cnt;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cube_end_c_cnt <= {3{1'b0}};
  end else begin
    if(stat_cur==CUBE_END) begin
        if(rdma2dp_ready_normal) begin
            if(cube_end_width_cnt == last_width)
                //cube_end_c_cnt <= cube_end_c_cnt + NVDLA_CDP_THROUGHPUT;
                cube_end_c_cnt <= cube_end_c_cnt + 1'b1;
        end
    end else
        cube_end_c_cnt <= 3'd0;
  end
end
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: if( $tp >= 4 ) {
//:     print " assign cube_done = (stat_cur==CUBE_END) & (cube_end_width_cnt == last_width) & rdma2dp_ready_normal;    \n";
//: } elsif( $tp == 2 ) {
//:     print " assign cube_done = (stat_cur==CUBE_END) & (cube_end_width_cnt == last_width) & (cube_end_c_cnt == 3'd1) & rdma2dp_ready_normal; \n";
//: } elsif( $tp == 1 ) {
//:     print " assign cube_done = (stat_cur==CUBE_END) & (cube_end_width_cnt == last_width) & (cube_end_c_cnt == 3'd3) & rdma2dp_ready_normal; \n";
//: }


//assign cube_done = (stat_cur==CUBE_END) & (cube_end_width_cnt == last_width) & rdma2dp_ready_normal;

//1pipe delay for buffer data generation

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly <= {3{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    stat_cur_dly <= stat_cur;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    more2less_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    more2less_dly <= more2less;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    less2more_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    less2more_dly <= less2more;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    hold_here_dly <= 1'b0;
  end else begin
  if ((load_din_full) == 1'b1) begin
    hold_here_dly <= hold_here;
  end
  end
end
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
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_dly <= {4{1'b0}};
  end else begin
  if ((load_din_full) == 1'b1) begin
    width_pre_dly <= width_pre;
  end
  end
end

/////////////////////////////
//buffer data generation for output data

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_data <= {buf2sq_data_bw{1'b0}};
  end else begin
  if(((stat_cur_dly==NORMAL_C) || (stat_cur_dly==SECOND_C) || (stat_cur_dly==CUBE_END)) & data_shift_load) begin
//: if(NVDLA_CDP_THROUGHPUT == 1) {
//:     foreach my $m  (0..7) {
//:         print qq(
//:             if(is_pos_w_dly == 4'd${m})
//:                 buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},
//:                                 data_shift_4${m},data_shift_5${m},data_shift_6${m},data_shift_7${m},data_shift_8${m}};
//:         );
//:     }
//: } elsif(NVDLA_CDP_THROUGHPUT == 2) {
//:     foreach my $m  (0..7) {
//:         print qq(
//:             if(is_pos_w_dly == 4'd${m})
//:                 buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},data_shift_4${m}};
//:         );
//:     }
//: }
  end else if(stat_cur_dly==FIRST_C) begin
      if(more2less_dly) begin
          if(data_shift_load) begin
//: if(NVDLA_CDP_THROUGHPUT == 1) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(is_pos_w_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},
//:                                     data_shift_4${m},data_shift_5${m},data_shift_6${m},data_shift_7${m},data_shift_8${m}};
//:             );
//:         }
//: } elsif(NVDLA_CDP_THROUGHPUT == 2) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(is_pos_w_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},data_shift_4${m}};
//:             );
//:         }
//: }
          end else if(hold_here_dly & data_shift_ready) begin
//: if(NVDLA_CDP_THROUGHPUT == 1) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(width_pre_cnt_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},
//:                                     data_shift_4${m},data_shift_5${m},data_shift_6${m},data_shift_7${m},data_shift_8${m}};
//:             );
//:         }
//: } elsif(NVDLA_CDP_THROUGHPUT == 2) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(width_pre_cnt_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},data_shift_4${m}};
//:             );
//:         }
//: }
          end
      end else begin
          if((is_pos_w_dly<=width_pre_dly) & data_shift_load) begin
//: if(NVDLA_CDP_THROUGHPUT == 1) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(is_pos_w_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},
//:                                     data_shift_4${m},data_shift_5${m},data_shift_6${m},data_shift_7${m},data_shift_8${m}};
//:             );
//:         }
//: } elsif(NVDLA_CDP_THROUGHPUT == 2) {
//:         foreach my $m  (0..7) {
//:             print qq(
//:                 if(is_pos_w_dly == 4'd${m})
//:                     buffer_data <= {data_shift_0${m},data_shift_1${m},data_shift_2${m},data_shift_3${m},data_shift_4${m}};
//:             );
//:         }
//: }
          end else if(data_shift_load) begin
              buffer_data <= {buf2sq_data_bw{1'b0}};
          end
      end
  end else if(data_shift_ready) begin
      buffer_data <= {buf2sq_data_bw{1'b0}};
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
//assign buf_dat_rdy = buffer_ready;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stat_cur_dly2 <= {3{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    stat_cur_dly2 <= stat_cur_dly;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    less2more_dly2 <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    less2more_dly2 <= less2more_dly;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_pos_w_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    is_pos_w_dly2 <= is_pos_w_dly;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_pre_dly2 <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    width_pre_dly2 <= width_pre_dly;
  end
  end
end

always @(*) begin
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
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_w_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_w_align <= is_last_w;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_h_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_h_align <= is_last_h;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_c_align <= 1'b0;
  end else begin
  if (((is_b_sync & load_din & (~FIRST_C_bf_end)) | FIRST_C_end) == 1'b1) begin
    last_c_align <= is_last_c;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pos_c_align <= {5{1'b0}};
  end else begin
    if(FIRST_C_end)
        pos_c_align <= 5'd0;
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
    pos_c_dly1 <= {5{1'b0}};
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
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_width <= {4{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_width <= width_dly1;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_pos_c <= {5{1'b0}};
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_pos_c <= pos_c_dly1;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_b_sync <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_b_sync <= b_sync_dly1;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_last_w <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_w <= last_w_dly1;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_last_h <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_h <= last_h_dly1;
  end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    buffer_last_c <= 1'b0;
  end else begin
  if ((data_shift_load_all) == 1'b1) begin
    buffer_last_c <= last_c_dly1;
  end
  end
end

/////////////////////////////////////////

//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $k = (${tp}+8)*${icvto};
//: print qq(
//:     assign buffer_pd[${k}-1:0] = buffer_data;
//:     assign buffer_pd[${k}+3:${k}] =  buffer_pos_w[3:0];
//:     assign buffer_pd[${k}+7:${k}+4] =  buffer_width[3:0];
//:     assign buffer_pd[${k}+12:${k}+8] = buffer_pos_c[4:0];
//:     assign buffer_pd[${k}+13] =    buffer_b_sync ;
//:     assign buffer_pd[${k}+14] =    buffer_last_w ;
//:     assign buffer_pd[${k}+15] =    buffer_last_h ;
//:     assign buffer_pd[${k}+16] =    buffer_last_c ;
//: );
/////////////////////////////////////////
assign buffer_valid = buffer_data_vld;

/////////////////////////////////////////
//: my $icvto = NVDLA_CDP_ICVTO_BWPE;
//: my $tp = NVDLA_CDP_THROUGHPUT;
//: my $k = (${tp}+8)*${icvto}+17;
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


