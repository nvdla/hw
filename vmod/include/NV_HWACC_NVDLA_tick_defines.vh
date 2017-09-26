// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_HWACC_NVDLA_tick_defines.vh

`include "NV_HWACC_common_tick_defines.vh"
`ifndef NV_HWACC_NVDLA_tick_defines_vh
`define NV_HWACC_NVDLA_tick_defines_vh

//this section contains IP specific defines
`ifdef NV_FPGA_SYSTEM
`ifndef  NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`define NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`endif
`ifndef  NV_HWACC_NVDLA_SFPGA_UFPGA
`define NV_HWACC_NVDLA_SFPGA_UFPGA
`endif
`ifndef  NV_HWACC_NVDLA_SFPGA_EMU
`define NV_HWACC_NVDLA_SFPGA_EMU
`endif
`endif
`ifdef NV_FPGA_UNIT
`ifndef  NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`define NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`endif
`ifndef  NV_HWACC_NVDLA_SFPGA_UFPGA
`define NV_HWACC_NVDLA_SFPGA_UFPGA
`endif
`ifndef  NV_HWACC_NVDLA_UFPGA_EMU
`define NV_HWACC_NVDLA_UFPGA_EMU
`endif
`endif
`ifdef NV_EMULATION
`ifndef  NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`define NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
`endif
`ifndef  NV_HWACC_NVDLA_SFPGA_EMU
`define NV_HWACC_NVDLA_SFPGA_EMU
`endif
`ifndef  NV_HWACC_NVDLA_UFPGA_EMU
`define NV_HWACC_NVDLA_UFPGA_EMU
`endif
`endif

//DEFINES
//defines shared between system fpga and unit fpga and emulation
`ifdef NV_HWACC_NVDLA_SFPGA_UFPGA_EMU
//add defines here
`endif

//defines shared between system fpga and unit fpga
`ifdef NV_HWACC_NVDLA_SFPGA_UFPGA
//add defines here
`endif

//defines shared between system fpga and emulation
`ifdef NV_HWACC_NVDLA_SFPGA_EMU
//add defines here
`endif

//defines shared between unit fpga and emulation
`ifdef NV_HWACC_NVDLA_UFPGA_EMU
//add defines here
`endif

//defines used only in system fpga
`ifdef NV_FPGA_SYSTEM
//add defines here
`endif

//defines used only in unit fpga
`ifdef NV_FPGA_UNIT
//add defines here
`endif

//defines used only in emulation
`ifdef NV_EMULATION
//add defines here
`endif

`endif //NV_HWACC_NVDLA_tick_defines_vh

