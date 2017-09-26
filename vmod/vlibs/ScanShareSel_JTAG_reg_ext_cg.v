// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: ScanShareSel_JTAG_reg_ext_cg.v

`timescale 1ps/1ps
module ScanShareSel_JTAG_reg_ext_cg (
   D
  ,clk
  ,reset_
  ,scanin
  ,sel
  ,shiftDR
  ,Q
  ,scanout
  );

input   clk;
input   reset_;
input   scanin;
input   sel;
input   shiftDR;
output  scanout;


// synopsys template
// These parameters should be overridden by the module that instantiates this
parameter JTAG_REG_WIDTH = 16;
parameter HAS_RESET = 0;                //default is to use 1'b1 as reset_
parameter [JTAG_REG_WIDTH-1:0] RESET_VALUE = {JTAG_REG_WIDTH{1'b0}}; // spyglass disable W557a -- default to all 0's at reset

input [JTAG_REG_WIDTH-1:0]     D;
output [JTAG_REG_WIDTH-1:0]     Q;
wire [JTAG_REG_WIDTH-1:0]     Q_conn;
wire [JTAG_REG_WIDTH-1:0]     next_Q;

wire scanen_wire;
wire scanin_wire;
wire scanout_wire;

NV_BLKBOX_SRC0 UJ_testInst_ess_scanin_buf (.Y(scanin_wire));
NV_BLKBOX_SRC0 UJ_testInst_ess_scanen_buf (.Y(scanen_wire));
NV_BLKBOX_BUFFER UJ_testInst_ess_scanout_buf (.A(scanout_wire), .Y(scanout));

// synopsys dc_tcl_script_begin
// synopsys dc_tcl_script_end



wire qualified_scanin_wire = sel ? scanin : scanin_wire;
wire qualified_scanen_wire = sel ? shiftDR : scanen_wire;

wire clk_wire;


assign next_Q = D;
assign clk_wire = clk;

genvar i;
generate
if (JTAG_REG_WIDTH == 1) begin: sg
  assign Q_conn[0] = qualified_scanin_wire;
end else begin: mul
  assign Q_conn[JTAG_REG_WIDTH-1:0] = {qualified_scanin_wire, Q[JTAG_REG_WIDTH-1:1]};
end
for(i=0; i<JTAG_REG_WIDTH; i=i+1) begin: Jreg_ff
if (HAS_RESET == 0) begin: SSS
  SDFQD1 nr ( .D(next_Q[i]), .SI(Q_conn[i]), .SE(qualified_scanen_wire), .CP(clk_wire), .Q(Q[i]) );
end else if (RESET_VALUE[i] == 0) begin: SSS
  SDFCNQD1 rz ( .D(next_Q[i]), .SI(Q_conn[i]), .SE(qualified_scanen_wire), .CP(clk_wire), .Q(Q[i]), .CDN(reset_) );
end else begin: SSS
  SDFSNQD1 ro ( .D(next_Q[i]), .SI(Q_conn[i]), .SE(qualified_scanen_wire), .CP(clk_wire), .Q(Q[i]), .SDN(reset_) );
end
end
endgenerate
assign scanout_wire = Q[0];

endmodule // ScanShareSel_JTAG_reg_ext_cg


