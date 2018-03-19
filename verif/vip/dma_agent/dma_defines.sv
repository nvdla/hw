`ifndef _DMA_DEFINES_SV_ 
`define _DMA_DEFINES_SV_

// Default define for nv_small project
`ifndef DMA_RD_REQ_PD_WIDTH
`define DMA_RD_REQ_PD_WIDTH 47
`endif

`ifndef DMA_ADDR_WIDTH
`define DMA_ADDR_WIDTH      32
`endif

`ifndef DMA_RD_SIZE_WIDTH
`define DMA_RD_SIZE_WIDTH   15  
`endif

`ifndef DMA_WR_SIZE_WIDTH
`define DMA_WR_SIZE_WIDTH   13  
`endif

`ifndef DMA_RD_RSP_PD_WIDTH
`define DMA_RD_RSP_PD_WIDTH 65
`endif

`ifndef DMA_WR_REQ_PD_WIDTH
`define DMA_WR_REQ_PD_WIDTH 66
`endif

`ifndef DMA_DATA_MASK_WIDTH
`define DMA_DATA_MASK_WIDTH 1 
`endif

`ifndef DMA_DATA_WIDTH
`define DMA_DATA_WIDTH      64 
`endif

`endif  // _DMA_DEFINES_SV_
