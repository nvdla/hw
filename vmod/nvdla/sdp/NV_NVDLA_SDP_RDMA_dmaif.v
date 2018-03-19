// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_dmaif.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_RDMA_dmaif (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
  ,sdp2cvif_rd_req_pd           //|> o
  ,sdp2cvif_rd_req_valid        //|> o
  ,sdp2cvif_rd_req_ready        //|< i
  ,cvif2sdp_rd_rsp_pd           //|< i
  ,cvif2sdp_rd_rsp_valid        //|< i
  ,cvif2sdp_rd_rsp_ready        //|> o
  ,sdp2cvif_rd_cdt_lat_fifo_pop //|> o
#endif
  ,sdp2mcif_rd_req_pd           //|> o
  ,sdp2mcif_rd_req_valid        //|> o
  ,sdp2mcif_rd_req_ready        //|< i
  ,mcif2sdp_rd_rsp_pd           //|< i
  ,mcif2sdp_rd_rsp_valid        //|< i
  ,mcif2sdp_rd_rsp_ready        //|> o
  ,sdp2mcif_rd_cdt_lat_fifo_pop //|> o
  ,dma_rd_req_ram_type          //|< i
  ,dma_rd_req_pd                //|< i
  ,dma_rd_req_vld               //|< i
  ,dma_rd_req_rdy               //|> o
  ,dma_rd_rsp_ram_type          //|< i
  ,dma_rd_rsp_pd                //|> o
  ,dma_rd_rsp_vld               //|> o
  ,dma_rd_rsp_rdy               //|< i
  ,dma_rd_cdt_lat_fifo_pop      //|< i
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
output         sdp2cvif_rd_cdt_lat_fifo_pop;
output  [NVDLA_DMA_RD_REQ-1:0] sdp2cvif_rd_req_pd;
output         sdp2cvif_rd_req_valid;
input          sdp2cvif_rd_req_ready;
input  [NVDLA_DMA_RD_RSP-1:0] cvif2sdp_rd_rsp_pd;
input          cvif2sdp_rd_rsp_valid;
output         cvif2sdp_rd_rsp_ready;
#endif
output  [NVDLA_DMA_RD_REQ-1:0] sdp2mcif_rd_req_pd;
output         sdp2mcif_rd_req_valid;
input          sdp2mcif_rd_req_ready;
input  [NVDLA_DMA_RD_RSP-1:0] mcif2sdp_rd_rsp_pd;
input          mcif2sdp_rd_rsp_valid;
output         mcif2sdp_rd_rsp_ready;
output         sdp2mcif_rd_cdt_lat_fifo_pop;
input          dma_rd_req_ram_type;
input          dma_rd_req_vld;
output         dma_rd_req_rdy;
input   [NVDLA_DMA_RD_REQ-1:0] dma_rd_req_pd;
input          dma_rd_rsp_ram_type;
output [NVDLA_DMA_RD_RSP-1:0] dma_rd_rsp_pd;
output         dma_rd_rsp_vld;
input          dma_rd_rsp_rdy;
input          dma_rd_cdt_lat_fifo_pop;

reg            sdp2mcif_rd_cdt_lat_fifo_pop;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE 
reg            sdp2cvif_rd_cdt_lat_fifo_pop;
#endif

NV_NVDLA_DMAIF_rdreq NV_NVDLA_SDP_RDMA_rdreq(
  .nvdla_core_clk         (nvdla_core_clk     )
 ,.nvdla_core_rstn        (nvdla_core_rstn    )
 ,.reg2dp_src_ram_type    (dma_rd_req_ram_type)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 ,.cvif_rd_req_pd         (sdp2cvif_rd_req_pd   )
 ,.cvif_rd_req_valid      (sdp2cvif_rd_req_valid)
 ,.cvif_rd_req_ready      (sdp2cvif_rd_req_ready)
#endif
 ,.mcif_rd_req_pd         (sdp2mcif_rd_req_pd   )
 ,.mcif_rd_req_valid      (sdp2mcif_rd_req_valid)
 ,.mcif_rd_req_ready      (sdp2mcif_rd_req_ready)
 ,.dmaif_rd_req_pd        (dma_rd_req_pd    )
 ,.dmaif_rd_req_vld       (dma_rd_req_vld   )
 ,.dmaif_rd_req_rdy       (dma_rd_req_rdy   )
);


NV_NVDLA_DMAIF_rdrsp NV_NVDLA_SDP_RDMA_rdrsp(
   .nvdla_core_clk     (nvdla_core_clk   )
  ,.nvdla_core_rstn    (nvdla_core_rstn  )
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif_rd_rsp_pd       (cvif2sdp_rd_rsp_pd     )
  ,.cvif_rd_rsp_valid    (cvif2sdp_rd_rsp_valid  )
  ,.cvif_rd_rsp_ready    (cvif2sdp_rd_rsp_ready  )
  #endif
  ,.mcif_rd_rsp_pd       (mcif2sdp_rd_rsp_pd     )
  ,.mcif_rd_rsp_valid    (mcif2sdp_rd_rsp_valid  )
  ,.mcif_rd_rsp_ready    (mcif2sdp_rd_rsp_ready  )
  ,.dmaif_rd_rsp_pd      (dma_rd_rsp_pd    )
  ,.dmaif_rd_rsp_pvld    (dma_rd_rsp_vld  )
  ,.dmaif_rd_rsp_prdy    (dma_rd_rsp_rdy  )
);


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2mcif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp2mcif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b1);
  end
end

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2cvif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  sdp2cvif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b0);
  end
end
#endif


endmodule


