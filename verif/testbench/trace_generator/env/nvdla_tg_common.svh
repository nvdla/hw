`ifndef _NVDLA_TG_COMMON_SV_
`define _NVDLA_TG_COMMON_SV_

`ifdef NVDLA_MEM_ADDRESS_WIDTH
    `define MEM_ADDR_SIZE_MAX       `NVDLA_MEM_ADDRESS_WIDTH
`endif


import uvm_pkg::*;

typedef enum { SCE_CC_SDP
              ,SCE_PDPRDMA_PDP
              ,SCE_CDPRDMA_CDP
              ,SCE_SDPRDMA_SDP
              ,SCE_SDPRDMA_SDP_PDP
              ,SCE_CC_SDP_PDP
              ,SCE_CC_SDPRDMA_SDP
              ,SCE_CC_SDPRDMA_SDP_PDP
              ,ALL_SCENARIOS
} scenario_e;

`endif //_NVDLA_TG_COMMON_SV_
