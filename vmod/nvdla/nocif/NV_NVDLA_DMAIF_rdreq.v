// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_DMAIF_rdreq.v

`include "simulate_x_tick.vh"
module NV_NVDLA_DMAIF_rdreq (
   nvdla_core_clk      
  ,nvdla_core_rstn   
  ,reg2dp_src_ram_type
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif_rd_req_pd   
  ,cvif_rd_req_valid
  ,cvif_rd_req_ready
  #endif
  ,mcif_rd_req_pd    
  ,mcif_rd_req_valid 
  ,mcif_rd_req_ready 

  ,dmaif_rd_req_pd
  ,dmaif_rd_req_vld
  ,dmaif_rd_req_rdy
);
//////////////////////////////////////////////
input       nvdla_core_clk;     
input       nvdla_core_rstn;   
input       reg2dp_src_ram_type;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output  [NVDLA_MEM_ADDRESS_WIDTH+14:0]   cvif_rd_req_pd;
output                          cvif_rd_req_valid;
input                           cvif_rd_req_ready;
#endif
output   [NVDLA_MEM_ADDRESS_WIDTH+14:0]   mcif_rd_req_pd;
output                           mcif_rd_req_valid;
input                            mcif_rd_req_ready;

input   [NVDLA_MEM_ADDRESS_WIDTH+14:0]  dmaif_rd_req_pd;
input       dmaif_rd_req_vld;
output      dmaif_rd_req_rdy;
//////////////////////////////////////////////
wire        mc_dma_rd_req_vld;
wire        mc_dma_rd_req_rdy;
wire        mc_rd_req_rdyi;
wire        dma_rd_req_ram_type;
wire        rd_req_rdyi;
//////////////////////////////////////////////
assign dma_rd_req_ram_type = reg2dp_src_ram_type;

assign mc_dma_rd_req_vld = dmaif_rd_req_vld & (dma_rd_req_ram_type == 1'b1);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_ram_type == 1'b1);
assign dmaif_rd_req_rdy= rd_req_rdyi;

//: my $dmabw = ( NVDLA_MEM_ADDRESS_WIDTH + 15 );
//: &eperl::pipe(" -wid $dmabw -is -do mcif_rd_req_pd -vo mcif_rd_req_valid -ri mcif_rd_req_ready -di dmaif_rd_req_pd -vi mc_dma_rd_req_vld -ro mc_dma_rd_req_rdy_f  ");
assign mc_dma_rd_req_rdy = mc_dma_rd_req_rdy_f;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire        cv_dma_rd_req_vld;
wire        cv_rd_req_rdyi;
wire        cv_dma_rd_req_rdy;
assign cv_dma_rd_req_vld = dmaif_rd_req_vld & (dma_rd_req_ram_type == 1'b0);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_ram_type == 1'b0);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;

//: my $dmabw = ( NVDLA_MEM_ADDRESS_WIDTH + 15 );
//: print "wire [${dmabw}-1:0] cv_dma_rd_req_pd; \n";
//: print "assign cv_dma_rd_req_pd = dmaif_rd_req_pd; \n";
//: &eperl::pipe(" -wid $dmabw -is -do cvif_rd_req_pd -vo cvif_rd_req_valid -ri cvif_rd_req_ready -di cv_dma_rd_req_pd -vi cv_dma_rd_req_vld -ro cv_dma_rd_req_rdy_f  ");
assign cv_dma_rd_req_rdy = cv_dma_rd_req_rdy_f;
#else
assign rd_req_rdyi = mc_rd_req_rdyi;
#endif


endmodule
