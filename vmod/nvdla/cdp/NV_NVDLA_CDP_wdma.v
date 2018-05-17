// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_wdma.v

#include "NV_NVDLA_CDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_wdma (
   nvdla_core_clk       
  ,nvdla_core_clk_orig  
  ,nvdla_core_rstn      
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdp2cvif_wr_req_ready
  ,cdp2cvif_wr_req_pd   
  ,cdp2cvif_wr_req_valid
  ,cvif2cdp_wr_rsp_complete
  #endif
  ,cdp2mcif_wr_req_ready
  ,cdp_dp2wdma_pd       
  ,cdp_dp2wdma_valid    
  ,mcif2cdp_wr_rsp_complete
  ,pwrbus_ram_pd           
  ,reg2dp_dma_en           
  ,reg2dp_dst_base_addr_high
  ,reg2dp_dst_base_addr_low 
  ,reg2dp_dst_line_stride   
  ,reg2dp_dst_ram_type      
  ,reg2dp_dst_surface_stride
  ,reg2dp_interrupt_ptr     
  ,reg2dp_op_en             
  ,cdp2glb_done_intr_pd     
  ,cdp2mcif_wr_req_pd       
  ,cdp2mcif_wr_req_valid    
  ,cdp_dp2wdma_ready        
  ,dp2reg_d0_perf_write_stall
  ,dp2reg_d1_perf_write_stall
  ,dp2reg_done               
  );

////////////////////////////////////////////////////////////////////////////
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output         cdp2mcif_wr_req_valid;
input          cdp2mcif_wr_req_ready;
output [NVDLA_DMA_WR_REQ-1:0] cdp2mcif_wr_req_pd;
input  mcif2cdp_wr_rsp_complete;

  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output         cdp2cvif_wr_req_valid;
input          cdp2cvif_wr_req_ready;
output [NVDLA_DMA_WR_REQ-1:0] cdp2cvif_wr_req_pd;
input  cvif2cdp_wr_rsp_complete;
#endif

input         cdp_dp2wdma_valid;
output        cdp_dp2wdma_ready;
input  [NVDLA_CDP_THROUGHPUT*NVDLA_BPE+14:0] cdp_dp2wdma_pd;

output [1:0] cdp2glb_done_intr_pd;

input   nvdla_core_clk_orig;
input   [31:0] pwrbus_ram_pd;
input          reg2dp_dma_en;
input   [31:0] reg2dp_dst_base_addr_high;
input   [31:0] reg2dp_dst_base_addr_low;
input   [31:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [31:0] reg2dp_dst_surface_stride;
input          reg2dp_interrupt_ptr;
input          reg2dp_op_en;
output  [31:0] dp2reg_d0_perf_write_stall;
output  [31:0] dp2reg_d1_perf_write_stall;
output         dp2reg_done;
////////////////////////////////////////////////////////////////////////////
reg            ack_bot_id;
reg            ack_bot_vld;
reg            ack_top_id;
reg            ack_top_vld;
reg     [63:0] base_addr_c;
reg     [63:0] base_addr_w;
reg      [2:0] beat_cnt;
reg      [1:0] cdp2glb_done_intr_pd;
reg     [31:0] cdp_wr_stall_count;
reg            cmd_en;
reg      [2:0] cmd_fifo_rd_pos_w_reg;
reg            cv_dma_wr_rsp_complete;
reg            cv_pending;
reg            dat_en;
reg     [63:0] dma_req_addr;
reg            dma_wr_rsp_complete;
reg     [31:0] dp2reg_d0_perf_write_stall;
reg     [31:0] dp2reg_d1_perf_write_stall;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: if($M == 1)  { print "reg            is_beat_num_odd; \n";
//:                print "wire     [0:0] dma_wr_dat_mask; \n";}
//: if($M == 2)  { print "reg            is_beat_num_odd; \n";
//:                print "wire     [1:0] dma_wr_dat_mask; \n";}
//: if($M == 4)  { print "reg  [1:0]     is_beat_num_odd; \n";
//:                print "wire     [3:0] dma_wr_dat_mask; \n";}
//: if($M == 8)  { print "reg  [2:0]     is_beat_num_odd; \n";
//:                print "wire     [7:0] dma_wr_dat_mask; \n";}
//: if($M == 16) { print "reg  [3:0]     is_beat_num_odd; \n";
//:                print "wire    [15:0] dma_wr_dat_mask; \n";}
//reg            is_beat_num_odd;
reg            layer_flag;
reg            mc_dma_wr_rsp_complete;
reg            mc_pending;
reg            mon_base_addr_c_c;
reg            mon_base_addr_w_c;
reg            mon_dma_req_addr_c;
reg            mon_nan_in_count;
reg            op_prcess;
reg            reg_cube_last;
reg      [2:0] req_chn_size;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
wire           ack_bot_rdy;
wire           ack_raw_id;
wire           ack_raw_rdy;
wire           ack_raw_vld;
wire           ack_top_rdy;
wire           cdp_wr_stall_count_dec;
wire           cmd_accept;
wire           cmd_fifo_rd_b_sync;
wire           cmd_fifo_rd_b_sync_NC;
wire           cmd_fifo_rd_last_c;
wire           cmd_fifo_rd_last_h;
wire           cmd_fifo_rd_last_w;
wire    [14:0] cmd_fifo_rd_pd;
wire     [2:0] cmd_fifo_rd_pos_c;
wire     [3:0] cmd_fifo_rd_pos_w;
wire           cmd_fifo_rd_prdy;
wire           cmd_fifo_rd_pvld;
wire     [3:0] cmd_fifo_rd_width;
wire    [14:0] cmd_fifo_wr_pd;
wire           cmd_fifo_wr_prdy;
wire           cmd_fifo_wr_pvld;
wire           cmd_rdy;
wire           cmd_vld;
wire           cnt_cen;
wire           cnt_clr;
wire           cnt_inc;
wire           dat_accept;
wire   [NVDLA_CDP_DMAIF_BW-1:0] dat_data;
wire           dat_fifo_wr_rdy;
wire           dat_rdy;
wire           dat_vld;
wire    [63:0] dma_wr_cmd_addr;
wire    [NVDLA_MEM_ADDRESS_WIDTH+13:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_require_ack;
wire    [12:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [NVDLA_CDP_DMAIF_BW-1:0] dma_wr_dat_data;
wire   [NVDLA_DMA_WR_REQ-2:0] dma_wr_dat_pd;
reg    [NVDLA_DMA_WR_REQ-1:0] dma_wr_req_pd; 
wire           dma_wr_dat_vld;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
wire           dp2wdma_b_sync;
wire    [14:0] dp2wdma_cmd_pd;
wire    [NVDLA_CDP_THROUGHPUT*NVDLA_BPE-1:0] dp2wdma_data;
wire           dp2wdma_last_c;
wire           dp2wdma_last_h;
wire           dp2wdma_last_w;
wire     [2:0] dp2wdma_pos_c;
wire     [3:0] dp2wdma_pos_w;
wire           dp2wdma_pos_w_bit0;
wire           dp2wdma_rdy;
wire     [3:0] dp2wdma_width;
wire           intr_fifo_rd_pd;
wire           intr_fifo_rd_prdy;
wire           intr_fifo_rd_pvld;
wire           intr_fifo_wr_pd;
wire           intr_fifo_wr_pvld;
wire           is_cube_last;
wire           is_last_beat;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire           op_done;
wire           op_load;
wire    [63:0] reg2dp_base_addr;
wire    [31:0] reg2dp_line_stride;
wire    [31:0] reg2dp_surf_stride;
wire           releasing;
wire           require_ack;
wire     [3:0] width_size;
wire     [3:0] width_size_use;
wire           wr_req_rdyi;
////////////////////////////////////////////////////////////////////////////
//==============
// Work Processing
//==============
assign op_load = reg2dp_op_en & !op_prcess;
assign op_done = reg_cube_last & is_last_beat & dat_accept;
assign dp2reg_done = op_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_prcess <= 1'b0;
  end else begin
    if (op_load) begin
        op_prcess <= 1'b1;
    end else if (op_done) begin
        op_prcess <= 1'b0;
    end
  end
end

//==============
// Data INPUT pipe and Unpack
//==============
//: my $k=NVDLA_CDP_THROUGHPUT*NVDLA_BPE+15;
//: &eperl::pipe(" -wid $k -is -do dp2wdma_pd -vo dp2wdma_vld -ri dp2wdma_rdy -di cdp_dp2wdma_pd -vi cdp_dp2wdma_valid -ro cdp_dp2wdma_ready ");

assign dp2wdma_data[NVDLA_CDP_THROUGHPUT*NVDLA_BPE-1:0] =    dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE-1:0];
assign dp2wdma_pos_w[3:0] =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+3:NVDLA_CDP_THROUGHPUT*NVDLA_BPE];
assign dp2wdma_width[3:0] =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+7:NVDLA_CDP_THROUGHPUT*NVDLA_BPE+4];
assign dp2wdma_pos_c[2:0] =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+10:NVDLA_CDP_THROUGHPUT*NVDLA_BPE+8];
assign dp2wdma_b_sync     =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+11];
assign dp2wdma_last_w     =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+12];
assign dp2wdma_last_h     =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+13];
assign dp2wdma_last_c     =  dp2wdma_pd[NVDLA_CDP_THROUGHPUT*NVDLA_BPE+14];

assign      dp2wdma_cmd_pd[3:0]  =  dp2wdma_pos_w[3:0];
assign      dp2wdma_cmd_pd[7:4]  =  dp2wdma_width[3:0];
assign      dp2wdma_cmd_pd[10:8] =  dp2wdma_pos_c[2:0];
assign      dp2wdma_cmd_pd[11] =    dp2wdma_b_sync ;
assign      dp2wdma_cmd_pd[12] =    dp2wdma_last_w ;
assign      dp2wdma_cmd_pd[13] =    dp2wdma_last_h ;
assign      dp2wdma_cmd_pd[14] =    dp2wdma_last_c ;
///////////////////////////////////////////////////////
// when b_sync, both cmd.fifo and dat.fifo need be ready, when !b_sync, only dat.fifo need be ready
assign dp2wdma_rdy = dp2wdma_vld & (dp2wdma_b_sync ? (dat_fifo_wr_rdy & cmd_fifo_wr_prdy) : dat_fifo_wr_rdy);

//==============
// Input FIFO : DATA and its swizzle
//==============

//: my $tp = NVDLA_CDP_THROUGHPUT*NVDLA_BPE;   
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $k = NVDLA_CDP_DMAIF_BW/$tp;
//: my $M = NVDLA_CDP_DMAIF_BW/$atmm;
//: my $F = $atmm/$tp;                
//:   if($M == 1) {
//:     print qq(   assign dp2wdma_pos_w_bit0 = 1'b0;  );
//:   } elsif($M == 2) {
//:     print qq(   assign dp2wdma_pos_w_bit0 = dp2wdma_pos_w[0];  );
//:   } elsif($M == 4) {
//:     print qq(   assign dp2wdma_pos_w_bit0 = dp2wdma_pos_w[1:0];   );
//:   } elsif($M == 8) {
//:     print qq(   assign dp2wdma_pos_w_bit0 = dp2wdma_pos_w[2:0];   );
//:   } elsif($M == 16) {
//:     print qq(   assign dp2wdma_pos_w_bit0 = dp2wdma_pos_w[3:0];   );
//:   }
//: foreach my $i (0..$M-1) {
//:     print "wire dat${i}_rdy; \n";
//: }
//:    my @dat_wr_rdys;
//:    foreach my $m (0..$k-1) {
//:     my $chn = $m % $F;
//:     my $pos = int($m / $F);
//:     print qq(
//:        wire                 dat${pos}_fifo${chn}_wr_pvld;
//:        wire                 dat${pos}_fifo${chn}_wr_prdy;
//:        wire    [$tp-1:0]    dat${pos}_fifo${chn}_wr_pd;
//:        wire    [$tp-1:0]    dat${pos}_fifo${chn}_rd_pd;
//:        wire                 dat${pos}_fifo${chn}_rd_prdy;
//:        wire                 dat${pos}_fifo${chn}_rd_pvld;
//:        assign dat${pos}_fifo${chn}_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==$chn) & (dp2wdma_pos_w_bit0==$pos);
//:        assign dat${pos}_fifo${chn}_wr_pd   = dp2wdma_data;
//:        NV_NVDLA_CDP_WDMA_dat_fifo u_dat${pos}_fifo${chn} (
//:           .nvdla_core_clk      (nvdla_core_clk                 ) 
//:          ,.nvdla_core_rstn     (nvdla_core_rstn                )
//:          ,.dat_fifo_wr_prdy    (dat${pos}_fifo${chn}_wr_prdy   )
//:          ,.dat_fifo_wr_pvld    (dat${pos}_fifo${chn}_wr_pvld   )
//:          ,.dat_fifo_wr_pd      (dat${pos}_fifo${chn}_wr_pd     )
//:          ,.dat_fifo_rd_prdy    (dat${pos}_fifo${chn}_rd_prdy   )
//:          ,.dat_fifo_rd_pvld    (dat${pos}_fifo${chn}_rd_pvld   )
//:          ,.dat_fifo_rd_pd      (dat${pos}_fifo${chn}_rd_pd     )
//:          ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0]            )  
//:          );
//:
//:        assign dat${pos}_fifo${chn}_rd_prdy = dat${pos}_rdy & (${chn} <= req_chn_size);
//:     );
//:     push @dat_wr_rdys, "(dat${pos}_fifo${chn}_wr_prdy & (dp2wdma_pos_c==$chn) & (dp2wdma_pos_w_bit0==$pos))";
//:    }
//:    my $dat_wr_rdys_str = join(" \n| ",@dat_wr_rdys);
//:    print "assign dat_fifo_wr_rdy = $dat_wr_rdys_str; ";



//: my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_BWPE;     ##throughput BW in int8
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDP_BWPE; ##atomic_m BW in int8
//: my $k = NVDLA_CDP_DMAIF_BW/$kx;  ##total fifo num
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//: foreach my $m (0..$M-1) {
//:   print "wire           dat${m}_fifo_rd_pvld; \n";
//:   my @dat_vlds_s;
//:     foreach my $f (0..$F-1) {
//:         push @dat_vlds_s, "dat${m}_fifo${f}_rd_pvld";
//:     }
//:   my $dat_vlds_str = join(" \n& ",@dat_vlds_s);
//:   print "assign dat${m}_fifo_rd_pvld = $dat_vlds_str; \n";
//: }

//
// //: my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_BWPE;        ##throughput BW in int8
// //: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDP_BWPE;    ##atomic_m BW in int8
// //: my $k = NVDLA_CDP_DMAIF_BW/$kx;  ##total fifo num
// //: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
// //: my $F = $k/$M;                          ##how many fifo contribute to one atomic_m
// //: foreach my $m (0..$M-1) {
// //:   print "&eperl::assert -type never -desc 'CDP-WDMA: dat$m rdys should be all 1 or all 0' -expr ( ";
// //    if($F > 1) {
// //:     foreach my $f (0..$F-2) {
// //:       my $k = $F - $f -1;
// //:       print "dat${m}_fifo${k}_rd_prdy & ";
// //:     }
// //:   }
// //:   print "dat${m}_fifo0_rd_prdy)!=(";
// //    if($F > 1) {
// //:     foreach my $f (0..$F-2) {
// //:       my $k = $F - $f -1;
// //:       print "dat${m}_fifo${k}_rd_prdy | ";
// //:     }
// //:   }
// //:     print "dat${m}_fifo0_rd_prdy) -clk nvdla_core_clk -rst nvdla_core_rstn; \n";
// //: }
//DorisLei
//&eperl::assert -type never -desc 'CDP-WDMA: dat0 rdys should be all 1 or all 0' -expr (dat0_fifo0_rd_prdy & dat0_fifo1_rd_prdy & dat0_fifo2_rd_prdy & dat0_fifo3_rd_prdy)!=(dat0_fifo0_rd_prdy | dat0_fifo1_rd_prdy | dat0_fifo2_rd_prdy | dat0_fifo3_rd_prdy) -clk nvdla_core_clk -rst nvdla_core_rstn;
//&eperl::assert -type never -desc 'CDP-WDMA: dat1 rdys should be all 1 or all 0' -expr (dat1_fifo0_rd_prdy & dat1_fifo1_rd_prdy & dat1_fifo2_rd_prdy & dat1_fifo3_rd_prdy)!=(dat1_fifo0_rd_prdy | dat1_fifo1_rd_prdy | dat1_fifo2_rd_prdy | dat1_fifo3_rd_prdy) -clk nvdla_core_clk -rst nvdla_core_rstn;

//: my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_BWPE;     ##throughput BW in int8
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDP_BWPE; ##atomic_m BW in int8
//: my $k = NVDLA_CDP_DMAIF_BW/$kx;  ##total fifo num
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//: foreach my $m (0..$M-1) {
//:     print "wire  [$jx-1:0]  dat${m}_data; \n";
//:     print "assign dat${m}_data= { \n";
//:     if($F > 1) {
//:       foreach my $k (0..$F-2) {
//:         my $j = $F - $k -1;
//:         print "dat${m}_fifo${j}_rd_pd,";
//:       }
//:     }
//:     print "dat${m}_fifo0_rd_pd}; \n";
//: }


assign dat_data = {
//: my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_CDP_BWPE;     ##throughput BW in int8
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDP_BWPE; ##atomic_m BW in int8
//: my $k = NVDLA_CDP_DMAIF_BW/$kx;  ##total fifo num
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//:     if($M > 1) {
//:       foreach my $k (0..$M-2) {
//:         my $j = $M - $k -1;
//:         print "dat${j}_data,";
//:       }
//:     }
dat0_data};

//==============
// Input FIFO: CMD
//==============
// cmd-fifo control
// if b_sync, need push into both dat_fifo and cmd_fifo

// FIFO:Write side
//assign cmd_fifo_wr_pvld = dp2wdma_vld & (dp2wdma_b_sync & (dp2wdma_pos_c==3'd3)) & dat_fifo_wr_rdy;
assign cmd_fifo_wr_pvld = dp2wdma_vld & (dp2wdma_b_sync & (dp2wdma_pos_c==(NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_CDP_THROUGHPUT-1))) & dat_fifo_wr_rdy;
assign cmd_fifo_wr_pd   = dp2wdma_cmd_pd;
// CMD FIFO:Instance
NV_NVDLA_CDP_WDMA_cmd_fifo u_cmd_fifo (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cmd_fifo_wr_prdy    (cmd_fifo_wr_prdy)        //|> w
  ,.cmd_fifo_wr_pvld    (cmd_fifo_wr_pvld)        //|< w
  ,.cmd_fifo_wr_pd      (cmd_fifo_wr_pd[14:0])    //|< w
  ,.cmd_fifo_rd_prdy    (cmd_fifo_rd_prdy)        //|< w
  ,.cmd_fifo_rd_pvld    (cmd_fifo_rd_pvld)        //|> w
  ,.cmd_fifo_rd_pd      (cmd_fifo_rd_pd[14:0])    //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );
// CMD FIFO:Read side
assign cmd_fifo_rd_prdy = cmd_en & cmd_rdy;

// Unpack cmd & data together

assign       cmd_fifo_rd_pos_w[3:0] =    cmd_fifo_rd_pd[3:0];
assign       cmd_fifo_rd_width[3:0] =    cmd_fifo_rd_pd[7:4];
assign       cmd_fifo_rd_pos_c[2:0] =    cmd_fifo_rd_pd[10:8];
assign        cmd_fifo_rd_b_sync  =    cmd_fifo_rd_pd[11];
assign        cmd_fifo_rd_last_w  =    cmd_fifo_rd_pd[12];
assign        cmd_fifo_rd_last_h  =    cmd_fifo_rd_pd[13];
assign        cmd_fifo_rd_last_c  =    cmd_fifo_rd_pd[14];

assign cmd_fifo_rd_b_sync_NC = cmd_fifo_rd_b_sync;
assign is_last_w = cmd_fifo_rd_last_w;
assign is_last_h = cmd_fifo_rd_last_h;
assign is_last_c = cmd_fifo_rd_last_c;
assign is_cube_last = is_last_w & is_last_h & is_last_c;

//==============
// BLOCK Operation
//==============
assign cmd_vld = cmd_en & cmd_fifo_rd_pvld;
assign cmd_rdy = dma_wr_req_rdy;
assign cmd_accept = cmd_vld & cmd_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: if($M == 1)  { print "is_beat_num_odd <= 1'b0; \n";}
//: if($M == 2)  { print "is_beat_num_odd <= 1'b0; \n";}
//: if($M == 4)  { print "is_beat_num_odd <= 2'd0; \n";}
//: if($M == 8)  { print "is_beat_num_odd <= 3'd0; \n";}
//: if($M == 16) { print "is_beat_num_odd <= 4'd0; \n";}
  end else if ((cmd_accept) == 1'b1) begin
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: if($M == 1)  { print "is_beat_num_odd <= 1'b0; \n";}
//: if($M == 2)  { print "is_beat_num_odd <= (cmd_fifo_rd_pos_w[0]); \n";}
//: if($M == 4)  { print "is_beat_num_odd <= (cmd_fifo_rd_pos_w[1:0]); \n";}
//: if($M == 8)  { print "is_beat_num_odd <= (cmd_fifo_rd_pos_w[2:0]); \n";}
//: if($M == 16) { print "is_beat_num_odd <= (cmd_fifo_rd_pos_w[3:0]); \n";}
   // is_beat_num_odd <= (cmd_fifo_rd_pos_w[0]==0);
  end
end

//: my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_BPE;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $k = NVDLA_CDP_DMAIF_BW/$kx;  ##total fifo num
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//: foreach my $m (0..$M-1) {
//: print "wire           dat${m}_vld; \n";
//: print "//wire           dat${m}_rdy; \n";
//: print "assign dat${m}_vld  = dat_en & dat${m}_fifo_rd_pvld & !(is_last_beat & (is_beat_num_odd < $m)); \n";
//: print "assign dat${m}_rdy  = dat_en & dat_rdy & !(is_last_beat & (is_beat_num_odd < $m)); \n";
//: }

assign dat_vld   = dat_en & (//dat0_vld | dat1_vld;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = NVDLA_CDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: if($M > 1) {
//:     foreach my $m (0..$M-2) {
//:       my $k = $M - $m -1;
//:       print "dat${k}_vld | ";
//:     }
//: }
dat0_vld);

assign dat_rdy   = dat_en & dma_wr_req_rdy;
assign dat_accept = dat_vld & dat_rdy;

// Req.cmd
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (is_last_beat & dat_accept) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end else if (cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_cube_last <= 1'b0;
  end else if ((cmd_accept) == 1'b1) begin
    reg_cube_last <= is_cube_last;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_chn_size <= {3{1'b0}};
  end else if ((cmd_accept) == 1'b1) begin
    req_chn_size <= cmd_fifo_rd_pos_c;
  end
end
assign width_size = cmd_fifo_rd_pos_w;

// Beat CNT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_cnt <= {3{1'b0}};
  end else begin
    if (cmd_accept) begin
        beat_cnt <= 0;
    end else if (dat_accept) begin
        beat_cnt <= beat_cnt + 1;
    end
  end
end

reg mon_cmd_fifo_rd_pos_w_reg;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_fifo_rd_pos_w_reg <= {3{1'b0}};
  end else if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b1) begin
//: my $dmaif = NVDLA_CDP_DMAIF_BW/NVDLA_BPE;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $Mnum = int( log( $dmaif/$atmm )/log(2));
//: print "  {mon_cmd_fifo_rd_pos_w_reg,cmd_fifo_rd_pos_w_reg} <= cmd_fifo_rd_pos_w[3:${Mnum}]; \n";
  end
end

assign is_last_beat  = (beat_cnt==cmd_fifo_rd_pos_w_reg);
//==============
// DMA REQ: DATA
//==============
//------------------------------------
// mode:  64      ||  mode: 32
// clk : 0 0 1 1  ||  clk : 0 0 1 1
// - - - - - - - -||  - - - - - - - 
// fifo: 0 4 0 4  ||  fifo: 0 4 0 4
// fifo: 1 5 1 5  ||  fifo: 1 5 1 5
// fifo: 2 6 2 6  ||  fifo: 2 6 2 6
// fifo: 3 7 3 7  ||  fifo: 3 7 3 7
// - - - - - - - -||  - - - - - - - 
// bus : L-H L-H  ||  bus : L H-L H
//------------------------------------

//==============
// DMA REQ: ADDR
//==============
// rename for reuse between rdma and wdma
assign reg2dp_base_addr   = {reg2dp_dst_base_addr_high,reg2dp_dst_base_addr_low};
assign reg2dp_line_stride = reg2dp_dst_line_stride;
assign reg2dp_surf_stride = reg2dp_dst_surface_stride;
//==============
// DMA Req : ADDR : Prepration
// DMA Req: go through the CUBE: W8->C->H
//==============
// Width: need be updated when move to next line 
// Trigger Condition: (is_last_c & is_last_w)
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_w <= {64{1'b0}};
    {mon_base_addr_w_c,base_addr_w} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_w <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c && is_last_w) begin
            {mon_base_addr_w_c,base_addr_w} <= base_addr_w + reg2dp_line_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_w_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// base_Chn: need be updated when move to next w.group 
// Trigger Condition: (is_last_c)
//  1, jump to next line when is_last_w
//  2, jump to next w.group when !is_last_w
assign width_size_use[3:0] = width_size + 1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_c <= {64{1'b0}};
    {mon_base_addr_c_c,base_addr_c} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_c <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_base_addr_c_c,base_addr_c} <= base_addr_w + reg2dp_line_stride;
            end else begin
                //{mon_base_addr_c_c,base_addr_c} <= base_addr_c + {width_size_use,5'd0};
//: my $atmm_bw = int( log(NVDLA_MEMORY_ATOMIC_SIZE)/log(2)) ;
//: print qq(
//:     {mon_base_addr_c_c,base_addr_c} <= base_addr_c + {width_size_use,${atmm_bw}'d0};
//: );
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_c_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// DMA Req : ADDR : Generation
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_req_addr <= {64{1'b0}};
    {mon_dma_req_addr_c,dma_req_addr} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        dma_req_addr <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_w + reg2dp_line_stride;
            end else begin
//: my $atmm_bw = int( log(NVDLA_MEMORY_ATOMIC_SIZE)/log(2)) ;
//: print qq(
//:     {mon_dma_req_addr_c,dma_req_addr} <= base_addr_c + {width_size_use,${atmm_bw}'d0};
//: );
//                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_c + {width_size_use,5'd0};
            end
        end else begin
            {mon_dma_req_addr_c,dma_req_addr} <= dma_req_addr + reg2dp_surf_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, mon_dma_req_addr_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
////==============
//==============
// DMA REQ: Size
//==============
// packet: cmd
assign dma_wr_cmd_vld  = cmd_vld;
assign dma_wr_cmd_addr = dma_req_addr;
assign dma_wr_cmd_size = {{9{1'b0}}, cmd_fifo_rd_pos_w};
assign dma_wr_cmd_require_ack   = is_cube_last;

// PKT_PACK_WIRE( dma_write_cmd ,  dma_wr_cmd_ ,  dma_wr_cmd_pd )
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH-1:0]  = dma_wr_cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0];
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+12:NVDLA_MEM_ADDRESS_WIDTH] = dma_wr_cmd_size[12:0];
assign       dma_wr_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+13]    = dma_wr_cmd_require_ack ;
// packet: data
assign dma_wr_dat_vld  = dat_vld;
assign dma_wr_dat_data = dat_data;

//: my $k = NVDLA_CDP_DMAIF_BW;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = $k/$jx;  ##atomic_m number per dma transaction
//: if($M == 1)  { print "assign dma_wr_dat_mask = 1'b1; \n"; }
//: if($M == 2)  { print "assign dma_wr_dat_mask = ((is_beat_num_odd == 1'b0) && is_last_beat) ? 2'b01 : 2'b11; \n"; }
//: if($M == 4)  { print "assign dma_wr_dat_mask = ((is_beat_num_odd == 2'd0) && is_last_beat) ? 4'b0001 : (((is_beat_num_odd == 2'd1) && is_last_beat) ? 4'b0011 : (((is_beat_num_odd == 2'd2) && is_last_beat) ? 4'b0111 : 4'b1111)); \n"; }
//: if($M == 8)  { 
//:     print qq( 
//:         assign dma_wr_dat_mask = ((is_beat_num_odd == 3'd0) && is_last_beat) ? 8'b00000001 : 
//:                                  ((is_beat_num_odd == 3'd1) && is_last_beat) ? 8'b00000011 :
//:                                  ((is_beat_num_odd == 3'd2) && is_last_beat) ? 8'b00000111 :
//:                                  ((is_beat_num_odd == 3'd3) && is_last_beat) ? 8'b00001111 :
//:                                  ((is_beat_num_odd == 3'd4) && is_last_beat) ? 8'b00011111 :
//:                                  ((is_beat_num_odd == 3'd5) && is_last_beat) ? 8'b00111111 :
//:                                  ((is_beat_num_odd == 3'd6) && is_last_beat) ? 8'b01111111 : 8'b11111111;
//:     );
//: }
//: if($M == 16)  { 
//:     print qq( 
//:         assign dma_wr_dat_mask = ((is_beat_num_odd == 4'h0) && is_last_beat) ? 16'b0000_0000_0000_0001 : 
//:                                  ((is_beat_num_odd == 4'h1) && is_last_beat) ? 16'b0000_0000_0000_0011 :
//:                                  ((is_beat_num_odd == 4'h2) && is_last_beat) ? 16'b0000_0000_0000_0111 :
//:                                  ((is_beat_num_odd == 4'h3) && is_last_beat) ? 16'b0000_0000_0000_1111 :
//:                                  ((is_beat_num_odd == 4'h4) && is_last_beat) ? 16'b0000_0000_0001_1111 :
//:                                  ((is_beat_num_odd == 4'h5) && is_last_beat) ? 16'b0000_0000_0011_1111 :
//:                                  ((is_beat_num_odd == 4'h6) && is_last_beat) ? 16'b0000_0000_0111_1111 :
//:                                  ((is_beat_num_odd == 4'h7) && is_last_beat) ? 16'b0000_0000_1111_1111 :
//:                                  ((is_beat_num_odd == 4'h8) && is_last_beat) ? 16'b0000_0001_1111_1111 :
//:                                  ((is_beat_num_odd == 4'h9) && is_last_beat) ? 16'b0000_0011_1111_1111 :
//:                                  ((is_beat_num_odd == 4'ha) && is_last_beat) ? 16'b0000_0111_1111_1111 :
//:                                  ((is_beat_num_odd == 4'hb) && is_last_beat) ? 16'b0000_1111_1111_1111 :
//:                                  ((is_beat_num_odd == 4'hc) && is_last_beat) ? 16'b0001_1111_1111_1111 :
//:                                  ((is_beat_num_odd == 4'hd) && is_last_beat) ? 16'b0011_1111_1111_1111 :
//:                                  ((is_beat_num_odd == 4'he) && is_last_beat) ? 16'b0111_1111_1111_1111 : 8'b11111111_11111111;
//:     );
//: }
//: print "assign       dma_wr_dat_pd[${k}-1:0] =     dma_wr_dat_data[${k}-1:0]; \n";
//: print "assign       dma_wr_dat_pd[${k}+$M-1:${k}] =     dma_wr_dat_mask[${M}-1:0]; \n";

//============================

// pack cmd & dat
assign dma_wr_req_vld = dma_wr_cmd_vld | dma_wr_dat_vld;
//: my $k = NVDLA_CDP_DMAIF_BW;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = $k/$jx;  ##atomic_m number per dma transaction
always @(*) begin
    // init to 0
    dma_wr_req_pd = 0;
    // cmd or dat
    if (cmd_en) begin
        dma_wr_req_pd = {{(NVDLA_DMA_WR_REQ-NVDLA_MEM_ADDRESS_WIDTH-14){1'b0}},dma_wr_cmd_pd};
    end else begin
        dma_wr_req_pd = {1'b0,dma_wr_dat_pd};
    end
//: my $k = NVDLA_CDP_DMAIF_BW;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $M = $k/$jx;  ##atomic_m number per dma transaction
//: print"    dma_wr_req_pd[${k}+${M}] = cmd_en ? 1'd0   : 1'd1  ; \n";
end

//==============
// writting stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = op_done;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_wr_req_vld & (~dma_wr_req_rdy));



    assign cdp_wr_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or cdp_wr_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ cdp_wr_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or cdp_wr_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !cdp_wr_stall_count_dec)? stl_cnt_inc : (!cnt_inc && cdp_wr_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (cnt_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (cnt_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      cdp_wr_stall_count[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flag <= 1'b0;
  end else begin
  if ((cnt_clr) == 1'b1) begin
    layer_flag <= ~layer_flag;
  end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr & (~layer_flag)) == 1'b1) begin
    dp2reg_d0_perf_write_stall <= cdp_wr_stall_count[31:0];
  end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr &   layer_flag ) == 1'b1) begin
    dp2reg_d1_perf_write_stall <= cdp_wr_stall_count[31:0];
  end
  end
end

//==============
// DMA Interface
//==============

NV_NVDLA_DMAIF_wr NV_NVDLA_CDP_WDMA_wr(
   .nvdla_core_clk          (nvdla_core_clk_orig  )  
  ,.nvdla_core_rstn         (nvdla_core_rstn      ) 
  ,.reg2dp_dst_ram_type     (reg2dp_dst_ram_type  )
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_wr_req_pd          (cdp2cvif_wr_req_pd      )    
  ,.cvif_wr_req_valid       (cdp2cvif_wr_req_valid   )
  ,.cvif_wr_req_ready       (cdp2cvif_wr_req_ready   )
  ,.cvif_wr_rsp_complete    (cvif2cdp_wr_rsp_complete)
  #endif
  ,.mcif_wr_req_pd          (cdp2mcif_wr_req_pd      ) 
  ,.mcif_wr_req_valid       (cdp2mcif_wr_req_valid   ) 
  ,.mcif_wr_req_ready       (cdp2mcif_wr_req_ready   ) 
  ,.mcif_wr_rsp_complete    (mcif2cdp_wr_rsp_complete)

  ,.dmaif_wr_req_pd         (dma_wr_req_pd       )   
  ,.dmaif_wr_req_pvld       (dma_wr_req_vld      )
  ,.dmaif_wr_req_prdy       (dma_wr_req_rdy      )
  ,.dmaif_wr_rsp_complete   (dma_wr_rsp_complete )
);


////////////////////////////////////////////////////////

NV_NVDLA_CDP_WDMA_intr_fifo u_intr_fifo (
   .nvdla_core_clk      (nvdla_core_clk_orig)     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.intr_fifo_wr_pvld   (intr_fifo_wr_pvld)       //|< w
  ,.intr_fifo_wr_pd     (intr_fifo_wr_pd)         //|< w
  ,.intr_fifo_rd_prdy   (intr_fifo_rd_prdy)       //|< w
  ,.intr_fifo_rd_pvld   (intr_fifo_rd_pvld)       //|> w
  ,.intr_fifo_rd_pd     (intr_fifo_rd_pd)         //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );
assign intr_fifo_wr_pd    = reg2dp_interrupt_ptr;
assign intr_fifo_wr_pvld  = op_done;
assign intr_fifo_rd_prdy  = dma_wr_rsp_complete;
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  cdp2glb_done_intr_pd[0] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==0);
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  cdp2glb_done_intr_pd[1] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==1);
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
  // VCS coverage off 
  nv_assert_never #(0,0,"when write complete, intr_ptr should be already in the head of intr_fifo read side")      zzz_assert_never_25x (nvdla_core_clk_orig, `ASSERT_RESET, !intr_fifo_rd_pvld & dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////==============

//==============
//function polint
//==============
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_WDMA__dma_writing_stall__7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_req_vld & (~dma_wr_req_rdy);
    endproperty
    // Cover 7 : "dma_wr_req_vld & (~dma_wr_req_rdy)"
    FUNCPOINT_CDP_WDMA__dma_writing_stall__7_COV : cover property (CDP_WDMA__dma_writing_stall__7_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_WDMA__dp2wdma_stall__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        cdp_dp2wdma_valid & (~cdp_dp2wdma_ready);
    endproperty
    // Cover 8 : "cdp_dp2wdma_valid & (~cdp_dp2wdma_ready)"
    FUNCPOINT_CDP_WDMA__dp2wdma_stall__8_COV : cover property (CDP_WDMA__dp2wdma_stall__8_cov);

  `endif
`endif
//VCS coverage on



endmodule // NV_NVDLA_CDP_wdma



// -w 64, 8byte each fifo
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_dat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dat_fifo_wr -rd_pipebus dat_fifo_rd -rd_reg -ram_bypass -d 3 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


#ifdef LARGE_FIFO_RAM

module NV_NVDLA_CDP_WDMA_dat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_prdy
    , dat_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , dat_fifo_wr_pause
`endif
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dat_fifo_wr_prdy;
input         dat_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         dat_fifo_wr_pause;
`endif
input  [63:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [63:0] dat_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        dat_fifo_wr_busy_int;		        	// copy for internal use
assign     dat_fifo_wr_prdy = !dat_fifo_wr_busy_int;
assign       wr_reserving = dat_fifo_wr_pvld && !dat_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] dat_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || dat_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_busy_int <=  1'b0;
        dat_fifo_wr_count <=  2'd0;
    end else begin
	dat_fifo_wr_busy_int <=  dat_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg  [1:0] dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  (dat_fifo_wr_adr == 2'd2) ? 2'd0 : (dat_fifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 2'd3 : dat_fifo_rd_adr )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (dat_fifo_rd_adr == 2'd2) ? 2'd0 : (dat_fifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [1:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [63:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {64{`x_or_0}};
    end
    //synopsys translate_on

end

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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dat_fifo_wr_pvld && !dat_fifo_wr_busy_int) || (dat_fifo_wr_busy_int != dat_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( dat_fifo_wr_pvld && !(!dat_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst2(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst3(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, dat_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_dat_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_WDMA_dat_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [63:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [63:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif


`ifdef EMU


wire [63:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [63:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [63:0] ram_ff0;
reg [63:0] ram_ff1;
reg [63:0] ram_ff2;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [63:0] Di0;
input  [1:0] Ra0;
output [63:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 64'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [63:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [63:0] Q0 = mem[0];
wire [63:0] Q1 = mem[1];
wire [63:0] Q2 = mem[2];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64] }
endmodule // vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64

//vmw: Memory vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64
//vmw: Address-size 2
//vmw: Data-size 64
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[63:0] data0[63:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[63:0] data1[63:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU
               

#endif

#ifdef SMALL_FIFO_RAM

module NV_NVDLA_CDP_WDMA_dat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_prdy
    , dat_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , dat_fifo_wr_pause
`endif
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dat_fifo_wr_prdy;
input         dat_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         dat_fifo_wr_pause;
`endif
input  [7:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [7:0] dat_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        dat_fifo_wr_busy_int;		        	// copy for internal use
assign     dat_fifo_wr_prdy = !dat_fifo_wr_busy_int;
assign       wr_reserving = dat_fifo_wr_pvld && !dat_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [3:0] dat_fifo_wr_count;			// write-side count

wire [3:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [3:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [3:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_8 = ( wr_count_next_no_wr_popping == 4'd8 );
wire wr_count_next_is_8 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_8;
wire [3:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [3:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_8 || // busy next cycle?
                          (wr_limit_reg != 4'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || dat_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_8 || // busy next cycle?
                          (wr_limit_reg != 4'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_busy_int <=  1'b0;
        dat_fifo_wr_count <=  4'd0;
    end else begin
	dat_fifo_wr_busy_int <=  dat_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {4{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg  [2:0] dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  3'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  dat_fifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [2:0] dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 4'd0 || !rd_popping);   // note: write occurs next cycle
wire [7:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 4'd8 : {1'b0,dat_fifo_rd_adr} )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [2:0] rd_adr_next_popping = dat_fifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  3'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [3:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [3:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [3:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [3:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  4'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {4{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [7:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {8{`x_or_0}};
    end
    //synopsys translate_on

end

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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dat_fifo_wr_pvld && !dat_fifo_wr_busy_int) || (dat_fifo_wr_busy_int != dat_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit : 4'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 4'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 4'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 4'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [3:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 4'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( dat_fifo_wr_pvld && !(!dat_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
    , .max      ( {28'd0, (wr_limit_reg == 4'd0) ? 4'd8 : wr_limit_reg} )
    , .curr	( {28'd0, dat_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_dat_fifo") true
// synopsys dc_script_end


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


endmodule // NV_NVDLA_CDP_WDMA_dat_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [7:0] di;
input  we;
input  [2:0] wa;
input  [3:0] ra;
output [7:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif


`ifdef EMU


wire [7:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [2:0] Wa0_vmw;
reg we0_vmw;
reg [7:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[2:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 8) ? di : dout_p;

`else

reg [7:0] ram_ff0;
reg [7:0] ram_ff1;
reg [7:0] ram_ff2;
reg [7:0] ram_ff3;
reg [7:0] ram_ff4;
reg [7:0] ram_ff5;
reg [7:0] ram_ff6;
reg [7:0] ram_ff7;

always @( posedge clk ) begin
    if ( we && wa == 3'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 3'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 3'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 3'd3 ) begin
	ram_ff3 <=  di;
    end
    if ( we && wa == 3'd4 ) begin
	ram_ff4 <=  di;
    end
    if ( we && wa == 3'd5 ) begin
	ram_ff5 <=  di;
    end
    if ( we && wa == 3'd6 ) begin
	ram_ff6 <=  di;
    end
    if ( we && wa == 3'd7 ) begin
	ram_ff7 <=  di;
    end
end

reg [7:0] dout;

always @(*) begin
    case( ra ) 
    4'd0:       dout = ram_ff0;
    4'd1:       dout = ram_ff1;
    4'd2:       dout = ram_ff2;
    4'd3:       dout = ram_ff3;
    4'd4:       dout = ram_ff4;
    4'd5:       dout = ram_ff5;
    4'd6:       dout = ram_ff6;
    4'd7:       dout = ram_ff7;
    4'd8:       dout = di;
    //VCS coverage off
    default:    dout = {8{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [2:0] Wa0;
input            we0;
input  [7:0] Di0;
input  [2:0] Ra0;
output [7:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 8'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [7:0] mem[7:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [7:0] Q0 = mem[0];
wire [7:0] Q1 = mem[1];
wire [7:0] Q2 = mem[2];
wire [7:0] Q3 = mem[3];
wire [7:0] Q4 = mem[4];
wire [7:0] Q5 = mem[5];
wire [7:0] Q6 = mem[6];
wire [7:0] Q7 = mem[7];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8] }
endmodule // vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8

//vmw: Memory vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8
//vmw: Address-size 3
//vmw: Data-size 8
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[7:0] data0[7:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[7:0] data1[7:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_8x8
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


#endif





// swizzle: 0: start from fifo_0; start from fifo_4
// width: 0~7, 32x1 in each 32x8
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_cmd_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus cmd_fifo_wr -rd_pipebus cmd_fifo_rd -rd_reg -ram_bypass -d 3 -w 15 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_WDMA_cmd_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , cmd_fifo_wr_prdy
    , cmd_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , cmd_fifo_wr_pause
`endif
    , cmd_fifo_wr_pd
    , cmd_fifo_rd_prdy
    , cmd_fifo_rd_pvld
    , cmd_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cmd_fifo_wr_prdy;
input         cmd_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         cmd_fifo_wr_pause;
`endif
input  [14:0] cmd_fifo_wr_pd;
input         cmd_fifo_rd_prdy;
output        cmd_fifo_rd_pvld;
output [14:0] cmd_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        cmd_fifo_wr_busy_int;		        	// copy for internal use
assign     cmd_fifo_wr_prdy = !cmd_fifo_wr_busy_int;
assign       wr_reserving = cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] cmd_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? cmd_fifo_wr_count : (cmd_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (cmd_fifo_wr_count + 1'd1) : cmd_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || cmd_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_busy_int <=  1'b0;
        cmd_fifo_wr_count <=  2'd0;
    end else begin
	cmd_fifo_wr_busy_int <=  cmd_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    cmd_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            cmd_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as cmd_fifo_wr_pvld

//
// RAM
//

reg  [1:0] cmd_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    cmd_fifo_wr_adr <=  (cmd_fifo_wr_adr == 2'd2) ? 2'd0 : (cmd_fifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (cmd_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [14:0] cmd_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( cmd_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( cmd_fifo_wr_adr )
    , .ra        ( (cmd_fifo_wr_count == 0) ? 2'd3 : cmd_fifo_rd_adr )
    , .dout        ( cmd_fifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (cmd_fifo_rd_adr == 2'd2) ? 2'd0 : (cmd_fifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd_fifo_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       cmd_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        cmd_fifo_rd_pvld_int;	// internal copy of cmd_fifo_rd_pvld
assign     cmd_fifo_rd_pvld = cmd_fifo_rd_pvld_int;
assign     rd_popping = cmd_fifo_rd_pvld_p && !(cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy);

reg  [1:0] cmd_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? cmd_fifo_rd_count_p : 
                                                                (cmd_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (cmd_fifo_rd_count_p + 1'd1) : 
                                                                    cmd_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     cmd_fifo_rd_pvld_p = cmd_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [14:0]  cmd_fifo_rd_pd;         // output data register
wire        rd_req_next = (cmd_fifo_rd_pvld_p || (cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_pvld_int <=  1'b0;
    end else begin
        cmd_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        cmd_fifo_rd_pd <=  cmd_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        cmd_fifo_rd_pd <=  {15{`x_or_0}};
    end
    //synopsys translate_on

end

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

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int) || (cmd_fifo_wr_busy_int != cmd_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (cmd_fifo_rd_pvld_int && cmd_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( cmd_fifo_wr_pvld && !(!cmd_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst4(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst5(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


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
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, cmd_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_cmd_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed4;
reg prand_initialized4;
reg prand_no_rollpli4;
`endif
`endif
`endif

function [31:0] prand_inst4;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst4 = min;
`else
`ifdef SYNTHESIS
        prand_inst4 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized4 !== 1'b1) begin
            prand_no_rollpli4 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli4)
                prand_local_seed4 = {$prand_get_seed(4), 16'b0};
            prand_initialized4 = 1'b1;
        end
        if (prand_no_rollpli4) begin
            prand_inst4 = min;
        end else begin
            diff = max - min + 1;
            prand_inst4 = min + prand_local_seed4[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed4 = prand_local_seed4 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst4 = min;
`else
        prand_inst4 = $RollPLI(min, max, "auto");
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
reg [47:0] prand_local_seed5;
reg prand_initialized5;
reg prand_no_rollpli5;
`endif
`endif
`endif

function [31:0] prand_inst5;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst5 = min;
`else
`ifdef SYNTHESIS
        prand_inst5 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized5 !== 1'b1) begin
            prand_no_rollpli5 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli5)
                prand_local_seed5 = {$prand_get_seed(5), 16'b0};
            prand_initialized5 = 1'b1;
        end
        if (prand_no_rollpli5) begin
            prand_inst5 = min;
        end else begin
            diff = max - min + 1;
            prand_inst5 = min + prand_local_seed5[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed5 = prand_local_seed5 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst5 = min;
`else
        prand_inst5 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_WDMA_cmd_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [14:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [14:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif


`ifdef EMU


wire [14:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [14:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [14:0] ram_ff0;
reg [14:0] ram_ff1;
reg [14:0] ram_ff2;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
end

reg [14:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {15{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [14:0] Di0;
input  [1:0] Ra0;
output [14:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 15'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [14:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [14:0] Q0 = mem[0];
wire [14:0] Q1 = mem[1];
wire [14:0] Q2 = mem[2];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15] }
endmodule // vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15

//vmw: Memory vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15
//vmw: Address-size 2
//vmw: Data-size 15
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[14:0] data0[14:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[14:0] data1[14:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//interrupt fifo
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_intr_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus intr_fifo_wr -rd_pipebus intr_fifo_rd -ram_bypass -d 0 -rd_reg -rd_busy_reg -no_wr_busy -w 1 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_WDMA_intr_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intr_fifo_wr_pvld
    , intr_fifo_wr_pd
    , intr_fifo_rd_prdy
    , intr_fifo_rd_pvld
    , intr_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         intr_fifo_wr_pvld;
input         intr_fifo_wr_pd;
input         intr_fifo_rd_prdy;
output        intr_fifo_rd_pvld;
output        intr_fifo_rd_pd;
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
        
//          
// NOTE: 0-depth fifo has no write side
//          


//
// RAM
//

//
// NOTE: 0-depth fifo has no ram.
//
wire [0:0] intr_fifo_rd_pd_p = intr_fifo_wr_pd;

//
// SYNCHRONOUS BOUNDARY
//

//
// NOTE: 0-depth fifo has no real boundary between write and read sides
//


//
// READ SIDE
//

reg        intr_fifo_rd_prdy_d;				// intr_fifo_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_prdy_d <=  1'b1;
    end else begin
        intr_fifo_rd_prdy_d <=  intr_fifo_rd_prdy;
    end
end

wire       intr_fifo_rd_prdy_d_o;			// combinatorial rd_busy

reg        intr_fifo_rd_pvld_int;			// internal copy of intr_fifo_rd_pvld

assign     intr_fifo_rd_pvld = intr_fifo_rd_pvld_int;
wire       intr_fifo_rd_pvld_p = intr_fifo_wr_pvld ; 		// no real fifo, take from write-side input
reg        intr_fifo_rd_pvld_int_o;	// internal copy of intr_fifo_rd_pvld_o
wire       intr_fifo_rd_pvld_o = intr_fifo_rd_pvld_int_o;
wire       rd_popping = intr_fifo_rd_pvld_p && !(intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o);


// 
// SKID for -rd_busy_reg
//
reg  intr_fifo_rd_pd_o;         // output data register
wire        rd_req_next_o = (intr_fifo_rd_pvld_p || (intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int_o <=  1'b0;
    end else begin
        intr_fifo_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        intr_fifo_rd_pd_o <=  intr_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        intr_fifo_rd_pd_o <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg  intr_fifo_rd_pd;				// output data register
reg        intr_fifo_rd_pvld_int_d;			// so we can bubble-collapse intr_fifo_rd_prdy_d
assign     intr_fifo_rd_prdy_d_o = !((intr_fifo_rd_pvld_o && intr_fifo_rd_pvld_int_d && !intr_fifo_rd_prdy_d ) );
wire       rd_req_next = (!intr_fifo_rd_prdy_d_o ? intr_fifo_rd_pvld_o : intr_fifo_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int <=  1'b0;
        intr_fifo_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) begin
	    intr_fifo_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy) ) begin
        end else begin
            intr_fifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        intr_fifo_rd_pvld_int_d <=  intr_fifo_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) ) begin
        case (!intr_fifo_rd_prdy_d_o) 
            1'b0:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_p;
            1'b1:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_o;
            //VCS coverage off
            default: intr_fifo_rd_pd <=  {1{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy)) ) begin
    end else begin
        intr_fifo_rd_pd <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end


// Tie-offs for pwrbus_ram_pd

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

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
assign nvdla_core_clk_mgated_enable = ((1'b0) || (intr_fifo_wr_pvld || (intr_fifo_rd_pvld_int && intr_fifo_rd_prdy_d) || (intr_fifo_rd_pvld_int_o && intr_fifo_rd_prdy_d_o)))
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_intr_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_CDP_WDMA_intr_fifo

