// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_DMAIF_rdrsp.v

`include "simulate_x_tick.vh"
module NV_NVDLA_DMAIF_rdrsp (
   nvdla_core_clk      
  ,nvdla_core_rstn     
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif_rd_rsp_pd   
  ,cvif_rd_rsp_valid
  ,cvif_rd_rsp_ready
  #endif
  ,mcif_rd_rsp_pd    
  ,mcif_rd_rsp_valid 
  ,mcif_rd_rsp_ready 

  ,dmaif_rd_rsp_pd
  ,dmaif_rd_rsp_pvld
  ,dmaif_rd_rsp_prdy
);
//////////////////////////////////////////////
input      nvdla_core_clk;     
input      nvdla_core_rstn;    
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: print qq( input   [${dmabw}-1:0]   cvif_rd_rsp_pd; \n); 
input                           cvif_rd_rsp_valid;
output                          cvif_rd_rsp_ready;
#endif
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: print qq( input   [${dmabw}-1:0]   mcif_rd_rsp_pd; \n); 
//: print qq( output  [${dmabw}-1:0]   dmaif_rd_rsp_pd; \n);
input                           mcif_rd_rsp_valid;
output                          mcif_rd_rsp_ready;

output                 dmaif_rd_rsp_pvld;
input                  dmaif_rd_rsp_prdy;
//////////////////////////////////////////////
wire                    dma_rd_rsp_rdy;
wire                    dma_rd_rsp_vld;
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: print qq( wire  [${dmabw}-1:0] dma_rd_rsp_pd;  \n);
//////////////////////////////////////////////


///////////////////////////////////////
// pipe before mux
///////////////////////////////////////
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: &eperl::pipe(" -wid $dmabw -is -do mcif_rd_rsp_pd_d0 -vo mcif_rd_rsp_valid_d0 -ri dma_rd_rsp_rdy -di mcif_rd_rsp_pd -vi mcif_rd_rsp_valid -ro mcif_rd_rsp_ready  ");
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire    cv_dma_rd_rsp_rdy;
assign cv_dma_rd_rsp_rdy = dma_rd_rsp_rdy;
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: &eperl::pipe(" -wid $dmabw -is -do cvif_rd_rsp_pd_d0 -vo cvif_rd_rsp_valid_d0 -ri cv_dma_rd_rsp_rdy -di cvif_rd_rsp_pd -vi cvif_rd_rsp_valid -ro cvif_rd_rsp_ready  ");
#endif
///////////////////////////////////////
//mux
///////////////////////////////////////

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign dma_rd_rsp_vld = mcif_rd_rsp_valid_d0 | cvif_rd_rsp_valid_d0;
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: print qq(
//:     assign dma_rd_rsp_pd = ({${dmabw}{mcif_rd_rsp_valid_d0}} & mcif_rd_rsp_pd_d0) 
//:                          | ({${dmabw}{cvif_rd_rsp_valid_d0}} & cvif_rd_rsp_pd_d0);
//: );
#else
assign dma_rd_rsp_vld = mcif_rd_rsp_valid_d0; 
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: print qq(
//:     assign dma_rd_rsp_pd = ({${dmabw}{mcif_rd_rsp_valid_d0}} & mcif_rd_rsp_pd_d0);
//: );
#endif

// //: &eperl::assert(" -type never -desc 'DMAIF: mcif and cvif should never return data both' -expr 'mcif_rd_rsp_valid_d0 & cvif_rd_rsp_valid_d0' ");
///////////////////////////////////////
// pipe after mux
///////////////////////////////////////
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $maskbw;
//:        $maskbw = $mask; 
//: my $dmabw = ( $dmaif + $maskbw );
//: &eperl::pipe(" -wid $dmabw -is -do dmaif_rd_rsp_pd -vo dmaif_rd_rsp_pvld -ri dmaif_rd_rsp_prdy -di dma_rd_rsp_pd -vi dma_rd_rsp_vld -ro dma_rd_rsp_rdy_f  ");
assign dma_rd_rsp_rdy = dma_rd_rsp_rdy_f;


endmodule
