// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: simulate_x_tick.vh

`ifdef _SIMULATE_X_VH_
`else
`define _SIMULATE_X_VH_

`ifndef SYNTHESIS
`define SIMULATION_ONLY
`endif

// deprecated tick defines
`ifdef SIMULATION_ONLY
`define x_or_0  1'bx
`define x_or_1  1'bx
`else
`define x_or_0  1'b0
`define x_or_1  1'b1
`endif

// formerly recommended tick defines
`ifdef SIMULATION_ONLY
`define tick_x_or_0  1'bx
`define tick_x_or_1  1'bx
`else
`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`endif

// newly recommended tick defines
// (-sv parsing is enabled everywhere now, and explicit widths are no longer needed)
`ifdef SIMULATION_ONLY
`define sv_x_or_0  'x
`define sv_x_or_1  'x
`else
`define sv_x_or_0  '0
`define sv_x_or_1  '1
`endif

`endif
