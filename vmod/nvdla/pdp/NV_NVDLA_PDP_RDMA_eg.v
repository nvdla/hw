// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_RDMA_eg.v

#include "NV_NVDLA_PDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_RDMA_eg (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,cq2eg_pd                     //|< i
  ,cq2eg_pvld                   //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2pdp_rd_rsp_pd           //|< i
  ,cvif2pdp_rd_rsp_valid        //|< i
  ,cvif2pdp_rd_rsp_ready        //|> o
  ,pdp2cvif_rd_cdt_lat_fifo_pop //|> o
#endif
  ,mcif2pdp_rd_rsp_pd           //|< i
  ,mcif2pdp_rd_rsp_valid        //|< i
  ,pdp_rdma2dp_ready            //|< i
  ,pwrbus_ram_pd                //|< i
  ,reg2dp_src_ram_type          //|< i
  ,cq2eg_prdy                   //|> o
  ,dp2reg_done                  //|> o
  ,eg2ig_done                   //|> o
  ,mcif2pdp_rd_rsp_ready        //|> o
  ,pdp2mcif_rd_cdt_lat_fifo_pop //|> o
  ,pdp_rdma2dp_pd               //|> o
  ,pdp_rdma2dp_valid            //|> o
  ,rdma2wdma_done               //|> o
  );
///////////////////////////////////////////////////////////////////////////////////////////
input          reg2dp_src_ram_type;
output         dp2reg_done;
output         eg2ig_done;
output         rdma2wdma_done;
//
input  nvdla_core_clk;   
input  nvdla_core_rstn;  

input          mcif2pdp_rd_rsp_valid;
output         mcif2pdp_rd_rsp_ready;
input [NVDLA_PDP_MEM_RD_RSP-1:0] mcif2pdp_rd_rsp_pd;

output  pdp2mcif_rd_cdt_lat_fifo_pop;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input          cvif2pdp_rd_rsp_valid;
output         cvif2pdp_rd_rsp_ready;
input [NVDLA_PDP_MEM_RD_RSP-1:0] cvif2pdp_rd_rsp_pd;
output  pdp2cvif_rd_cdt_lat_fifo_pop;
#else
#endif

output        pdp_rdma2dp_valid;
input         pdp_rdma2dp_ready;
output [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11:0] pdp_rdma2dp_pd;

input         cq2eg_pvld;
output        cq2eg_prdy;
input  [17:0] cq2eg_pd;

input [31:0] pwrbus_ram_pd;
///////////////////////////////////////////////////////////////////////////////////////////

reg     [13:0] beat_cnt;
wire           dma_rd_rsp_rdy;
reg            dp2reg_done_flag;
reg     [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT-1:0] dp_data;
wire           dp_rdy;
reg            dp_vld;
reg            eg2ig_done_flag;
reg      [5:0] fifo_sel_cnt;
reg            is_cube_end;
reg            is_line_end;
reg            is_split_end;
reg            is_surf_end;
reg            pdp2cvif_rd_cdt_lat_fifo_pop;
reg            pdp2mcif_rd_cdt_lat_fifo_pop;
reg     [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11:0] pdp_rdma2dp_pd;
reg            rdma2wdma_done_flag;
reg      [3:0] tran_cnt;
reg     [13:0] width_cnt;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] cv_dma_rd_rsp_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] cv_int_rd_rsp_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] cvif2pdp_rd_rsp_pd_d0;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] cvif2pdp_rd_rsp_pd_d1;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] dma_rd_rsp_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] lat_rd_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] mc_dma_rd_rsp_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] mc_int_rd_rsp_pd;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] mcif2pdp_rd_rsp_pd_d0;
wire [NVDLA_PDP_MEM_RD_RSP-1:0] mcif2pdp_rd_rsp_pd_d1;
wire           cv_dma_rd_rsp_vld;
wire           cv_int_rd_rsp_ready;
wire           cv_int_rd_rsp_valid;
wire           cvif2pdp_rd_rsp_ready_d0;
wire           cvif2pdp_rd_rsp_ready_d1;
wire           cvif2pdp_rd_rsp_valid_d0;
wire           cvif2pdp_rd_rsp_valid_d1;
wire           dma_rd_cdt_lat_fifo_pop;
wire           dma_rd_rsp_ram_type;
wire           dma_rd_rsp_vld;
wire           dp2reg_done_f;
wire           dp_b_sync;
wire           dp_cube_end;
wire           dp_line_end;
wire    [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11:0] dp_pd;
wire     [2:0] dp_pos_c;
wire     [3:0] dp_pos_w;
wire           dp_split_end;
wire           dp_surf_end;
wire           eccg_dma_rd_rsp_rdy;
wire           eg2ig_done_f;
wire     [7:0] fifo_rd_pvld;
wire     [5:0] fifo_sel;
wire           ig2eg_align;
wire           ig2eg_cube_end;
wire           ig2eg_line_end;
wire    [12:0] ig2eg_size;
wire           ig2eg_split_end;
wire           ig2eg_surf_end;
wire           is_b_sync;
wire           is_last_beat;
wire           is_last_tran;
wire   [NVDLA_PDP_DMAIF_BW-1:0] lat_rd_data;
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE; ##atomic_m BW
//: my $M = NVDLA_PDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: print "wire     [${M}-1:0] lat_rd_mask; \n";
wire           lat_rd_prdy;
wire           lat_rd_pvld;
wire           mc_dma_rd_rsp_vld;
wire           mc_int_rd_rsp_ready;
wire           mc_int_rd_rsp_valid;
wire           mcif2pdp_rd_rsp_ready_d0;
wire           mcif2pdp_rd_rsp_ready_d1;
wire           mcif2pdp_rd_rsp_valid_d0;
wire           mcif2pdp_rd_rsp_valid_d1;
wire    [10:0] mon_dp_pos_w;
wire           rdma2wdma_done_f;
//: my $kx = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;     ##throughput BW
//: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE; ##atomic_m BW
//: my $k = NVDLA_PDP_DMAIF_BW/$kx;  ##total fifo num
//: my $M = NVDLA_PDP_DMAIF_BW/$jx;  ##atomic_m number per dma transaction
//: my $F = $k/$M;                   ##how many fifo contribute to one atomic_m
//: foreach my $m (0..$k-1) {
//:    print qq(
//:         wire    [${kx}-1:0] ro${m}_rd_pd;
//:         wire                ro${m}_rd_prdy;
//:         wire                ro${m}_rd_pvld;
//:         wire    [${kx}-1:0] ro${m}_wr_pd;
//:    );
//: }
//: foreach my $m (0..$M-1) {
//:    print qq(
//:         wire                ro${m}_wr_pvld;
//:         wire                ro${m}_wr_rdy;
//:    );
//: }
//: foreach my $i (0..$M-1) {
//:     print qq(
//:         wire     [${F}-1:0] ro${i}_wr_rdys;
//:     );
//: }
wire           tran_accept;
wire           tran_cnt_idle;
wire    [13:0] tran_num;
wire           tran_rdy;
wire           tran_vld;
///////////////////////////////////////////////////////////////////////////////////
    
NV_NVDLA_DMAIF_rdrsp NV_NVDLA_PDP_RDMA_rdrsp(
   .nvdla_core_clk     (nvdla_core_clk   ) 
  ,.nvdla_core_rstn    (nvdla_core_rstn  ) 
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_rd_rsp_pd       (cvif2pdp_rd_rsp_pd     )    
  ,.cvif_rd_rsp_valid    (cvif2pdp_rd_rsp_valid  )
  ,.cvif_rd_rsp_ready    (cvif2pdp_rd_rsp_ready  )
  #endif
  ,.mcif_rd_rsp_pd       (mcif2pdp_rd_rsp_pd     ) 
  ,.mcif_rd_rsp_valid    (mcif2pdp_rd_rsp_valid  )
  ,.mcif_rd_rsp_ready    (mcif2pdp_rd_rsp_ready  )

  ,.dmaif_rd_rsp_pd      (dma_rd_rsp_pd    )    
  ,.dmaif_rd_rsp_pvld    (dma_rd_rsp_vld  )
  ,.dmaif_rd_rsp_prdy    (dma_rd_rsp_rdy  )
);

////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2mcif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  pdp2mcif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b1);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2cvif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  pdp2cvif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b0);
  end
end

assign dma_rd_rsp_ram_type   = reg2dp_src_ram_type;

//pipe for timing closure
//: my $s = NVDLA_PDP_MEM_RD_RSP;
//: &eperl::pipe("-is -wid $s -do eccg_dma_rd_rsp_pd -vo eccg_dma_rd_rsp_vld -ri eccg_dma_rd_rsp_rdy -di dma_rd_rsp_pd -vi dma_rd_rsp_vld -ro dma_rd_rsp_rdy_f ");
assign dma_rd_rsp_rdy = dma_rd_rsp_rdy_f;

//==============
// Latency FIFO to buffer return DATA
//==============
NV_NVDLA_PDP_RDMA_lat_fifo u_lat_fifo (
   .nvdla_core_clk           (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn          (nvdla_core_rstn)              //|< i
  ,.lat_wr_prdy              (eccg_dma_rd_rsp_rdy)          //|> w
  ,.lat_wr_pvld              (eccg_dma_rd_rsp_vld)          //|< r
  ,.lat_wr_pd                (eccg_dma_rd_rsp_pd)    //|< r
  ,.lat_rd_prdy              (lat_rd_prdy)                  //|< w
  ,.lat_rd_pvld              (lat_rd_pvld)                  //|> w
  ,.lat_rd_pd                (lat_rd_pd)             //|> w
  ,.pwrbus_ram_pd            (pwrbus_ram_pd[31:0])          //|< i
  );


assign lat_rd_data[NVDLA_PDP_DMAIF_BW-1:0] = lat_rd_pd[NVDLA_PDP_DMAIF_BW-1:0];
assign lat_rd_mask[NVDLA_DMA_MASK_BIT-1:0] = lat_rd_pd[NVDLA_DMA_RD_RSP-1: NVDLA_PDP_DMAIF_BW];
////: my $k = NVDLA_PDP_DMAIF_BW;
////: my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE; ##atomic_m BW
////: my $M = $k/$jx;  ##atomic_m number per dma transaction
////: if($M > 1) {
////: print "assign       lat_rd_mask[${M}-1:0] =    lat_rd_pd[${k}+${M}-1:${k}];  \n"; 
////: }
assign dma_rd_cdt_lat_fifo_pop = lat_rd_pvld & lat_rd_prdy;

// only care the rdy of ro-fifo which mask bit indidates
assign lat_rd_prdy = lat_rd_pvld 
//: my $msk = NVDLA_DMA_MASK_BIT;
//: foreach my $k (0..$msk-1) {
//:     print " & (~lat_rd_mask[$k] | (lat_rd_mask[$k] & ro${k}_wr_rdy))  \n";
//: }
//: print " ; \n";
//:
//:
//: my $tp = NVDLA_CDP_THROUGHPUT*NVDLA_BPE;     ##throughput BW
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE; ##atomic_m BW
//: my $k = NVDLA_PRIMARY_MEMIF_WIDTH/$tp;  ##total fifo num
//: my $M = NVDLA_PRIMARY_MEMIF_WIDTH/$atmm;  ##atomic_m number per dma transaction
//: my $F = $atmm/$tp;                       ##how many fifo contribute to one atomic_m
//:
//:
//: print " // when also need send to other group of ro-fif, need clamp the vld if others are not ready  \n";
//: foreach my $i (0..$M-1){
//:    print "    assign ro${i}_wr_pvld = lat_rd_pvld & (lat_rd_mask[${i}] & ro${i}_wr_rdy)  \n";
//:         foreach my $s (0..$msk-1) {
//:             if($s != $i) {
//:                   print "        & ( ~lat_rd_mask[${s}] | (lat_rd_mask[${s}] & ro${s}_wr_rdy))  \n";
//:             }
//:         }
//:    print " ;  \n";
//: }
//:
//:
//:    foreach my $m  (0..$M-1) {
//:        print "   assign ro${m}_wr_rdy = &ro${m}_wr_rdys;  \n";
//:        foreach my $f (0..$F-1) {
//:            my $r = $F * $m  + $f;
//:            print " assign ro${r}_wr_pd  = lat_rd_data[${tp}*${r}+${tp}-1:${tp}*${r}];  \n";
//:            print " NV_NVDLA_PDP_RDMA_ro_fifo u_ro${r}_fifo(     \n";
//:            print "  .nvdla_core_clk      (nvdla_core_clk)       \n";
//:            print " ,.nvdla_core_rstn     (nvdla_core_rstn)      \n";
//:            print " ,.ro_wr_prdy          (ro${m}_wr_rdys[$f])   \n";
//:            print " ,.ro_wr_pvld          (ro${m}_wr_pvld)       \n";
//:            print " ,.ro_wr_pd            (ro${r}_wr_pd)         \n";
//:            print " ,.ro_rd_prdy          (ro${r}_rd_prdy)       \n";
//:            print " ,.ro_rd_pvld          (ro${r}_rd_pvld)       \n";
//:            print " ,.ro_rd_pd            (ro${r}_rd_pd)         \n";
//:            print " ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])  \n";
//:            print " ); \n";
//:        }
//:    }
//:
//:
//:    print " // DATA MUX out \n";
//:    print " assign fifo_sel = fifo_sel_cnt; \n";
//:    print " always @(*) begin \n";
//:    print " case(fifo_sel) \n";
//:    foreach my $m  (0..$M-1) {
//:        foreach my $f (0..$F-1) {
//:            my $r = $F * $m  + $f;
//:            print "   6'd$r: begin \n";
//:            print "       dp_vld = ro${r}_rd_pvld & (~tran_cnt_idle); \n";
//:            print "       dp_data = ro${r}_rd_pd; \n";
//:            print "   end \n";
//:        }
//:    }
//:    print "default: begin \n";
//:    print "       dp_vld = 1'b0; \n";
//:    print "       dp_data = ${tp}'d0; \n";
//:    print "end \n";
//:    print "endcase \n";
//:    print "end \n";
//:
//:
//:    foreach my $m  (0..$M-1) {
//:        foreach my $f (0..$F-1) {
//:            my $r = $F * $m  + $f;
//:            print " assign ro${r}_rd_prdy = dp_rdy & (fifo_sel==$r) & (~tran_cnt_idle);  \n";
//:        }
//:    }
//:


//==============
// Context Queue: read
//==============

//==============
// Return Data Counting
//==============
// unpack from rd_pd, which should be the same order as wr_pd
assign cq2eg_prdy = tran_rdy;
assign tran_vld = cq2eg_pvld;

// PKT_UNPACK_WIRE( pdp_rdma_ig2eg ,  ig2eg_ ,  cq2eg_pd )
assign        ig2eg_size[12:0] =     cq2eg_pd[12:0];
assign         ig2eg_align  =     cq2eg_pd[13];
assign         ig2eg_line_end  =     cq2eg_pd[14];
assign         ig2eg_surf_end  =     cq2eg_pd[15];
assign         ig2eg_split_end  =     cq2eg_pd[16];
assign         ig2eg_cube_end  =     cq2eg_pd[17];

assign tran_num[13:0] = cq2eg_pvld ? (ig2eg_size + 1) : 14'b0;
assign tran_cnt_idle = (tran_cnt==0);
assign is_last_tran  = (tran_cnt==1);
assign is_last_beat  = (beat_cnt==1);
//:  my $kx = NVDLA_CDP_THROUGHPUT*NVDLA_PDP_BWPE;     ##throughput BW
//:  my $jx = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE; ##atomic_m BW
//:  my $k = NVDLA_PRIMARY_MEMIF_WIDTH/$kx;       ##total fifo num
//:  my $M = NVDLA_PRIMARY_MEMIF_WIDTH/$jx;       ##atomic_m number per dma trans
//:  my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//:    foreach my $r (0..$k-1) {
//:       print " assign fifo_rd_pvld[$r] = (fifo_sel==${r}) & ro${r}_rd_pvld;  \n";
//:    }

assign tran_rdy = (tran_cnt_idle & (|fifo_rd_pvld)) || (is_last_tran & is_last_beat & dp_rdy);

assign tran_accept = tran_vld & tran_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fifo_sel_cnt <= {6{1'b0}};
  end else begin
    if(is_cube_end & is_b_sync) begin
            fifo_sel_cnt <= 6'd0;
    end else if (tran_rdy) begin
            fifo_sel_cnt <= 6'd0;
    end else if (dp_rdy & |fifo_rd_pvld)
//:  my $kx = NVDLA_PDP_THROUGHPUT*NVDLA_PDP_BWPE;     ##throughput BW
//:  my $k = NVDLA_PRIMARY_MEMIF_WIDTH/$kx;       ##total fifo num
//:     print "   fifo_sel_cnt <= (fifo_sel_cnt==(6'd${k}-1))? 6'd0 : fifo_sel_cnt + 1; \n";
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    tran_cnt <= {4{1'b0}};
    beat_cnt <= {14{1'b0}};
  end else begin
    if(is_cube_end & is_b_sync) begin
            tran_cnt    <= 4'd0;
            beat_cnt    <= 4'd0;
    end if (tran_rdy) begin
        if (tran_vld) begin
//:  my $txnum = NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_THROUGHPUT;
//:  print " tran_cnt    <= 4'd${txnum}; \n";
            beat_cnt    <= tran_num;
        end else begin
            tran_cnt    <= 0;
            beat_cnt    <= 0;
        end
    end else if (dp_rdy & |fifo_rd_pvld) begin
        beat_cnt <= (beat_cnt==1)? width_cnt : beat_cnt - 1;
        if (is_last_beat) begin
            tran_cnt <= tran_cnt - 1;
        end
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    width_cnt <= {14{1'b0}};
  end else begin
  if ((tran_accept) == 1'b1) begin
    width_cnt <= tran_num;
  // VCS coverage off
  end else if ((tran_accept) == 1'b0) begin
  end else begin
    width_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(tran_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_line_end <= 1'b0;
  end else begin
  if ((tran_accept) == 1'b1) begin
    is_line_end <= ig2eg_line_end;
  // VCS coverage off
  end else if ((tran_accept) == 1'b0) begin
  end else begin
    is_line_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(tran_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_surf_end <= 1'b0;
  end else begin
  if ((tran_accept) == 1'b1) begin
    is_surf_end <= ig2eg_surf_end;
  // VCS coverage off
  end else if ((tran_accept) == 1'b0) begin
  end else begin
    is_surf_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(tran_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_split_end <= 1'b0;
  end else begin
  if ((tran_accept) == 1'b1) begin
    is_split_end <= ig2eg_split_end;
  // VCS coverage off
  end else if ((tran_accept) == 1'b0) begin
  end else begin
    is_split_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(tran_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    is_cube_end <= 1'b0;
  end else begin
  if ((tran_accept) == 1'b1) begin
    is_cube_end <= ig2eg_cube_end;
  // VCS coverage off
  end else if ((tran_accept) == 1'b0) begin
  end else begin
    is_cube_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(tran_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign is_b_sync = is_last_beat & is_last_tran & dp_rdy;

assign {mon_dp_pos_w[10:0],dp_pos_w[3:0]}   = width_cnt - beat_cnt;
//:  my $pdpbw = NVDLA_CDP_THROUGHPUT*NVDLA_PDP_BWPE;     ##throughput BW
//:  my $atmbw = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_PDP_BWPE; ##atomic_m BW
//:  my $k = NVDLA_PRIMARY_MEMIF_WIDTH/$pdpbw;       ##total fifo num
//:  my $M = NVDLA_PRIMARY_MEMIF_WIDTH/$atmbw;       ##atomic_m number per dma trans
//:  my $F = $k/$M;                       ##how many fifo contribute to one atomic_m
//:  my $cmax = int( log($F)/log(2));
//:     print " assign dp_pos_c[2:0] = fifo_sel[${cmax}-1:0];//need update to 5bits when configurable  \n";
assign dp_b_sync  = is_b_sync;
assign dp_line_end = is_line_end;
assign dp_surf_end = is_surf_end;
assign dp_split_end = is_split_end;
assign dp_cube_end = is_cube_end;

assign dp2reg_done_f    = is_cube_end & is_b_sync;
assign eg2ig_done_f     = is_cube_end & is_b_sync;
assign rdma2wdma_done_f = is_cube_end & is_b_sync;

//==============
// OUTPUT PACK and PIPE: To Data Processor
//==============
// PD Pack

// PKT_PACK_WIRE( pdp_rdma2dp , dp_ , dp_pd )
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT-1:0] =    dp_data[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT-1:0];
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+3:NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT] =    dp_pos_w[3:0];
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+6:NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+4] =    dp_pos_c[2:0];
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+7] =    dp_b_sync ;
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+8] =    dp_line_end ;
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+9] =    dp_surf_end ;
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+10] =    dp_split_end ;
assign      dp_pd[NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11] =    dp_cube_end ;

wire    [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+14:0]  eg_out_pipe0_di;
assign eg_out_pipe0_di = {dp_pd,rdma2wdma_done_f,eg2ig_done_f,dp2reg_done_f};
//: my $k = NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+15;
//: &eperl::pipe("-is -wid $k -do eg_out_pipe0_do -vo pdp_rdma2dp_valid_f -ri pdp_rdma2dp_ready -di eg_out_pipe0_di -vi dp_vld -ro dp_rdy_ff ");
assign dp_rdy = dp_rdy_ff;
assign  {pdp_rdma2dp_pd,rdma2wdma_done_flag,eg2ig_done_flag,dp2reg_done_flag} = eg_out_pipe0_do;

assign pdp_rdma2dp_valid = pdp_rdma2dp_valid_f;

assign rdma2wdma_done = (pdp_rdma2dp_valid_f & pdp_rdma2dp_ready & rdma2wdma_done_flag) ? 1'b1 : 1'b0;
assign eg2ig_done     = (pdp_rdma2dp_valid_f & pdp_rdma2dp_ready & eg2ig_done_flag)     ? 1'b1 : 1'b0;
assign dp2reg_done    = (pdp_rdma2dp_valid_f & pdp_rdma2dp_ready & dp2reg_done_flag)    ? 1'b1 : 1'b0;
////==============
////OBS signals
////==============
//assign obs_bus_pdp_rdma_wr_0x_vld = ro0_wr_pvld; 
//assign obs_bus_pdp_rdma_wr_1x_vld = ro1_wr_pvld;
//assign obs_bus_pdp_rdma_rd_00_rdy = ro0_rd_prdy;
//assign obs_bus_pdp_rdma_rd_10_rdy = ro4_rd_prdy;
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

    property PDP_RDMA_eg__bsync_end_stall__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_last_beat & is_last_tran & (~dp_rdy);
    endproperty
    // Cover 0 : "is_last_beat & is_last_tran & (~dp_rdy)"
    FUNCPOINT_PDP_RDMA_eg__bsync_end_stall__0_COV : cover property (PDP_RDMA_eg__bsync_end_stall__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_eg__line_end_stall__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_line_end & (~dp_rdy);
    endproperty
    // Cover 1 : "is_line_end & (~dp_rdy)"
    FUNCPOINT_PDP_RDMA_eg__line_end_stall__1_COV : cover property (PDP_RDMA_eg__line_end_stall__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_eg__surf_end_stall__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_surf_end & (~dp_rdy);
    endproperty
    // Cover 2 : "is_surf_end & (~dp_rdy)"
    FUNCPOINT_PDP_RDMA_eg__surf_end_stall__2_COV : cover property (PDP_RDMA_eg__surf_end_stall__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_eg__split_end_stall__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_split_end & (~dp_rdy);
    endproperty
    // Cover 3 : "is_split_end & (~dp_rdy)"
    FUNCPOINT_PDP_RDMA_eg__split_end_stall__3_COV : cover property (PDP_RDMA_eg__split_end_stall__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_eg__cube_end_stall__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        is_cube_end & (~dp_rdy);
    endproperty
    // Cover 4 : "is_cube_end & (~dp_rdy)"
    FUNCPOINT_PDP_RDMA_eg__cube_end_stall__4_COV : cover property (PDP_RDMA_eg__cube_end_stall__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_RDMA_eg_backpressure_cq__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        tran_rdy & (~tran_vld) & (~is_cube_end);
    endproperty
    // Cover 5 : "tran_rdy & (~tran_vld) & (~is_cube_end)"
    FUNCPOINT_PDP_RDMA_eg_backpressure_cq__5_COV : cover property (PDP_RDMA_eg_backpressure_cq__5_cov);

  `endif
`endif
//VCS coverage on



endmodule // NV_NVDLA_PDP_RDMA_eg



//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_RDMA_lat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus lat_wr -rd_pipebus lat_rd -rd_reg -d 61 -w 514 -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"

#ifdef LARGE_FIFO_RAM

module NV_NVDLA_PDP_RDMA_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [513:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [513:0] lat_rd_pd;
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
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [5:0] lat_wr_count;			// write-side count

wire [5:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [5:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [5:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_61 = ( wr_count_next_no_wr_popping == 6'd61 );
wire wr_count_next_is_61 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_61;
wire [5:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [5:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_61 || // busy next cycle?
                          (wr_limit_reg != 6'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_61 || // busy next cycle?
                          (wr_limit_reg != 6'd0 &&      // check lat_wr_limit if != 0
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
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  6'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [5:0] lat_wr_adr;			// current write address
wire [5:0] lat_rd_adr_p;		// read address to use for ram
wire [513:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_61x514 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [5:0] wr_adr_next = (lat_wr_adr == 6'd60) ? 6'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  6'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [5:0] lat_rd_adr;		// current read address
// next    read address
wire [5:0] rd_adr_next = (lat_rd_adr == 6'd60) ? 6'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  6'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [5:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [5:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [5:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [5:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  6'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {6{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
assign ore = rd_popping;

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit : 6'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 6'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 6'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 6'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [5:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 6'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( lat_wr_pvld && !(!lat_wr_prdy)
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
    , .max      ( {26'd0, (wr_limit_reg == 6'd0) ? 6'd61 : wr_limit_reg} )
    , .curr	( {26'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_RDMA_lat_fifo") true
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


endmodule // NV_NVDLA_PDP_RDMA_lat_fifo

#endif

#ifdef SMALL_FIFO_RAM

module NV_NVDLA_PDP_RDMA_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_wr_prdy
    , lat_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_wr_pause
`endif
    , lat_wr_pd
    , lat_rd_prdy
    , lat_rd_pvld
    , lat_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_wr_prdy;
input         lat_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_wr_pause;
`endif
input  [64:0] lat_wr_pd;
input         lat_rd_prdy;
output        lat_rd_pvld;
output [64:0] lat_rd_pd;
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
reg        lat_wr_busy_int;		        	// copy for internal use
assign     lat_wr_prdy = !lat_wr_busy_int;
assign       wr_reserving = lat_wr_pvld && !lat_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [5:0] lat_wr_count;			// write-side count

wire [5:0] wr_count_next_wr_popping = wr_reserving ? lat_wr_count : (lat_wr_count - 1'd1); // spyglass disable W164a W484
wire [5:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_wr_count + 1'd1) : lat_wr_count; // spyglass disable W164a W484
wire [5:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_61 = ( wr_count_next_no_wr_popping == 6'd61 );
wire wr_count_next_is_61 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_61;
wire [5:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [5:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_61 || // busy next cycle?
                          (wr_limit_reg != 6'd0 &&      // check lat_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_wr_busy_next = wr_count_next_is_61 || // busy next cycle?
                          (wr_limit_reg != 6'd0 &&      // check lat_wr_limit if != 0
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
        lat_wr_busy_int <=  1'b0;
        lat_wr_count <=  6'd0;
    end else begin
	lat_wr_busy_int <=  lat_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_wr_count <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_wr_pvld

//
// RAM
//

reg  [5:0] lat_wr_adr;			// current write address
wire [5:0] lat_rd_adr_p;		// read address to use for ram
wire [64:0] lat_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_61x65 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_wr_pd )
    , .ra        ( lat_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_wr_adr if wr_pushing=1
wire [5:0] wr_adr_next = (lat_wr_adr == 6'd60) ? 6'd0 : (lat_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_wr_adr <=  6'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_wr_adr   <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [5:0] lat_rd_adr;		// current read address
// next    read address
wire [5:0] rd_adr_next = (lat_rd_adr == 6'd60) ? 6'd0 : (lat_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_rd_adr_p = rd_popping ? rd_adr_next : lat_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_adr <=  6'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_rd_adr <=  {6{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_rd_pvld_p; 		// data out of fifo is valid

reg        lat_rd_pvld_int;			// internal copy of lat_rd_pvld
assign     lat_rd_pvld = lat_rd_pvld_int;
assign     rd_popping = lat_rd_pvld_p && !(lat_rd_pvld_int && !lat_rd_prdy);

reg  [5:0] lat_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [5:0] rd_count_p_next_rd_popping = rd_pushing ? lat_rd_count_p : 
                                                                (lat_rd_count_p - 1'd1);
wire [5:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_rd_count_p + 1'd1) : 
                                                                    lat_rd_count_p;
// spyglass enable_block W164a W484
wire [5:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_count_p <=  6'd0;
        lat_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_count_p <=  {6{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_rd_pvld_p || (lat_rd_pvld_int && !lat_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_rd_pvld_int <=  1'b0;
    end else begin
        lat_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_rd_pd = lat_rd_pd_p;
assign ore = rd_popping;

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_wr_pvld && !lat_wr_busy_int) || (lat_wr_busy_int != lat_wr_busy_next)) || (rd_pushing || rd_popping || (lat_rd_pvld_int && lat_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit : 6'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 6'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 6'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 6'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [5:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 6'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_PDP_RDMA_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( lat_wr_pvld && !(!lat_wr_prdy)
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
    , .max      ( {26'd0, (wr_limit_reg == 6'd0) ? 6'd61 : wr_limit_reg} )
    , .curr	( {26'd0, lat_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_RDMA_lat_fifo") true
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


endmodule // NV_NVDLA_PDP_RDMA_lat_fifo




#endif



// Re-Order Data
// if we have rd_reg, then depth = required - 1 ,so depth=4-1=3
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_RDMA_ro_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus ro_wr -rd_pipebus ro_rd -rd_reg -rand_none -ram_bypass -d 3 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"

#ifdef LARGE_FIFO_RAM

module NV_NVDLA_PDP_RDMA_ro_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [63:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [63:0] ro_rd_pd;
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
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] ro_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  2'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  (ro_wr_adr == 2'd2) ? 2'd0 : (ro_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 2'd3 : ro_rd_adr )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (ro_rd_adr == 2'd2) ? 2'd0 : (ro_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    ro_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
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

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [1:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [63:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {64{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
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


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit : 2'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

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
    , .curr	( {30'd0, ro_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_RDMA_ro_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_RDMA_ro_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64 (
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

vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64 emu_ram (
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

endmodule // NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64 (
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64] }
endmodule // vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64

//vmw: Memory vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64
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

//qt: CELL vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_3x64
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


module NV_NVDLA_PDP_RDMA_ro_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , ro_wr_prdy
    , ro_wr_pvld
    , ro_wr_pd
    , ro_rd_prdy
    , ro_rd_pvld
    , ro_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        ro_wr_prdy;
input         ro_wr_pvld;
input  [7:0] ro_wr_pd;
input         ro_rd_prdy;
output        ro_rd_pvld;
output [7:0] ro_rd_pd;
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
wire wr_reserving;
reg        ro_wr_busy_int;		        	// copy for internal use
assign     ro_wr_prdy = !ro_wr_busy_int;
assign       wr_reserving = ro_wr_pvld && !ro_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] ro_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? ro_wr_count : (ro_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (ro_wr_count + 1'd1) : ro_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       ro_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check ro_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_busy_int <=  1'b0;
        ro_wr_count <=  3'd0;
    end else begin
	ro_wr_busy_int <=  ro_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    ro_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            ro_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as ro_wr_pvld

//
// RAM
//

reg  [1:0] ro_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    ro_wr_adr <=  ro_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] ro_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (ro_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [7:0] ro_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( ro_wr_pd )
    , .we        ( ram_we )
    , .wa        ( ro_wr_adr )
    , .ra        ( (ro_wr_count == 0) ? 3'd4 : {1'b0,ro_rd_adr} )
    , .dout        ( ro_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = ro_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    ro_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            ro_rd_adr <=  {2{`x_or_0}};
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

wire       ro_rd_pvld_p; 		// data out of fifo is valid

reg        ro_rd_pvld_int;	// internal copy of ro_rd_pvld
assign     ro_rd_pvld = ro_rd_pvld_int;
assign     rd_popping = ro_rd_pvld_p && !(ro_rd_pvld_int && !ro_rd_prdy);

reg  [2:0] ro_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? ro_rd_count_p : 
                                                                (ro_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (ro_rd_count_p + 1'd1) : 
                                                                    ro_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     ro_rd_pvld_p = ro_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    ro_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            ro_rd_count_p <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [7:0]  ro_rd_pd;         // output data register
wire        rd_req_next = (ro_rd_pvld_p || (ro_rd_pvld_int && !ro_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        ro_rd_pvld_int <=  1'b0;
    end else begin
        ro_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        ro_rd_pd <=  ro_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        ro_rd_pd <=  {8{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (ro_wr_pvld && !ro_wr_busy_int) || (ro_wr_busy_int != ro_wr_busy_next)) || (rd_pushing || rd_popping || (ro_rd_pvld_int && ro_rd_prdy)) || (wr_pushing))
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


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_RDMA_ro_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, ro_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_RDMA_ro_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_RDMA_ro_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8 (
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
input  [1:0] wa;
input  [2:0] ra;
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
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [7:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [7:0] ram_ff0;
reg [7:0] ram_ff1;
reg [7:0] ram_ff2;
reg [7:0] ram_ff3;

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
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [7:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {8{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [7:0] Di0;
input  [1:0] Ra0;
output [7:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 8'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [7:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [7:0] Q0 = mem[0];
wire [7:0] Q1 = mem[1];
wire [7:0] Q2 = mem[2];
wire [7:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8] }
endmodule // vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8

//vmw: Memory vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8
//vmw: Address-size 2
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

//qt: CELL vmw_NV_NVDLA_PDP_RDMA_ro_fifo_flopram_rwsa_4x8
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU




#endif

