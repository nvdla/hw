`ifndef _NVDLA_TB_COMMON_SVH_
`define _NVDLA_TB_COMMON_SVH_
//
// Component: ntb_common.svh
//
// Description:
/// @file
/// testbench global defines


`include "project.vh"

`ifdef NVDLA_PRIMARY_MEMIF_WIDTH
    `define DBB_DATA_WIDTH `NVDLA_PRIMARY_MEMIF_WIDTH
`endif

//Get internal DMA interface defines from project define
`ifdef NVDLA_DMA_RD_REQ
    `define DMA_RD_REQ_PD_WIDTH     `NVDLA_DMA_RD_REQ
`endif

`ifdef NVDLA_MEM_ADDRESS_WIDTH
    `define DMA_ADDR_WIDTH          `NVDLA_MEM_ADDRESS_WIDTH
`endif

`ifdef NVDLA_DMA_RD_SIZE
    `define DMA_RD_SIZE_WIDTH       `NVDLA_DMA_RD_SIZE
`endif

`ifdef NVDLA_DMA_WR_SIZE
    `define DMA_WR_SIZE_WIDTH       `NVDLA_DMA_WR_SIZE
`endif

`ifdef NVDLA_DMA_RD_RSP
    `define DMA_RD_RSP_PD_WIDTH     `NVDLA_DMA_RD_RSP
`endif

`ifdef NVDLA_DMA_WR_REQ
    `define DMA_WR_REQ_PD_WIDTH     `NVDLA_DMA_WR_REQ
`endif

`ifdef NVDLA_DMA_MASK_BIT
    `define DMA_DATA_MASK_WIDTH     `NVDLA_DMA_MASK_BIT
`endif

`ifdef NVDLA_MEMIF_WIDTH
    `ifdef NVDLA_DMA_MASK_BIT
        `define DMA_DATA_WIDTH          `NVDLA_MEMIF_WIDTH/`NVDLA_DMA_MASK_BIT
    `endif
`endif


package nvdla_tb_common_pkg;

    //Define global message print verbosity macros
    //Compatiable with UVM_VERBOSITY and extends to add two more print level
    parameter  NVDLA_NONE   =  0;
    parameter  NVDLA_LOW    =  100;
    parameter  NVDLA_MEDIUM =  200;
    parameter  NVDLA_TRACE  =  250;
    parameter  NVDLA_VERIF  =  280;
    parameter  NVDLA_HIGH   =  300;
    parameter  NVDLA_FULL   =  400;
    parameter  NVDLA_DEBUG  =  500;

    // For transaction compare mechanism
    parameter  COMPARE_MODE_RTL_AHEAD       = 1;
    parameter  COMPARE_MODE_RTL_GATING_CMOD = 2;
    parameter  COMPARE_MODE_LOOSE_COMPARE   = 3;
    parameter  COMPARE_MODE_COUNT_TXN_ONLY  = 4;

    parameter  MONITOR_WORKING_MODE_NOT_SAMPLING    = -1;
    parameter  MONITOR_WORKING_MODE_PASSTHROUGH     = -2;
    parameter  MONITOR_WORKING_MODE_RTL_AHEAD       = 0;
    parameter  SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_NOT_SAMPLING    = -1;
    parameter  SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_PASSTHROUGH     = -2;
    parameter  SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_AHEAD       = 0;
    parameter  SCSV_CONVERTOR_INITIAL_CREDIT_WORKING_MODE_RTL_GATING_CMOD = 1;

    // TODO: Remove hard-coded magic numbers and use macros from project.vh once VMOD add them.

`ifdef NV_LARGE
    parameter SDP_DW = 16;
    parameter SDP_DS = 8;
`else
    parameter SDP_DW = 8;
    parameter SDP_DS = 1;
`endif
    parameter SDP_PW    = (`NVDLA_BPE*`NVDLA_SDP_MAX_THROUGHPUT);  // small:8, large:128
    parameter CACC_PW   = (32*`NVDLA_SDP_MAX_THROUGHPUT+2);   // small:34, large:514
    parameter CACC_DW = 32;
    parameter CACC_DS   = `NVDLA_SDP_BS_THROUGHPUT; // small:1, large:16
    parameter CSC_DT_DW = `NVDLA_BPE; // small: 8
    parameter CSC_WT_DW = `NVDLA_BPE;
    parameter CSC_DT_DS = `NVDLA_MAC_ATOMIC_C_SIZE;     // small: 8, large:?
    parameter CSC_WT_DS = `NVDLA_MAC_ATOMIC_C_SIZE;     // small: 8, large:?
    parameter CMAC_DW   = `NVDLA_MAC_RESULT_WIDTH;      // small:19, large:22
    parameter CMAC_DS   = (`NVDLA_MAC_ATOMIC_K_SIZE/2); // small: 4, large:?

endpackage: nvdla_tb_common_pkg

`endif // _NVDLA_TB_COMMON_SVH_
