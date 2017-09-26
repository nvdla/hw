// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_ssync3d_c.v

module NV_NVDLA_ssync3d_c (
   i_clk
  ,i_rstn
  ,sync_i
  ,o_clk
  ,o_rstn
  ,sync_o
  );

input        i_clk;
input        i_rstn;
input        sync_i;
input        o_clk;
input        o_rstn;
output       sync_o;


wire [0:0] sync_i_o_clk_sync_src_data_next;
// verilint 528 off
wire [0:0] sync_i_o_clk_sync_src_data;
// verilint 528 on
wire [0:0] sync_i_o_clk_sync_dst_data;

assign sync_i_o_clk_sync_src_data_next = sync_i;
assign sync_o = sync_i_o_clk_sync_dst_data;

p_STRICTSYNC3DOTM_C_PPP sync_i_o_clk_sync_0 (
    .SRC_CLK           (i_clk)
  , .SRC_CLRN        (i_rstn)
  , .SRC_D_NEXT        (sync_i_o_clk_sync_src_data_next[0])
  , .SRC_D             (sync_i_o_clk_sync_src_data[0])
  , .DST_CLK           (o_clk)
  , .DST_CLRN        (o_rstn)
  , .DST_Q             (sync_i_o_clk_sync_dst_data[0])
  , .ATPG_CTL          (1'b0)
  , .TEST_MODE         (1'b0)
  );

endmodule

