// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_CLK_gate_power.v

module NV_CLK_gate_power (clk, reset_, clk_en, clk_gated);
input clk, reset_, clk_en;
output clk_gated;

`ifdef VLIB_BYPASS_POWER_CG
assign clk_gated = clk;
`else

CKLNQD12 p_clkgate (.TE(1'b0), .CP(clk), .E(clk_en), .Q(clk_gated));

`endif // VLIB_BYPASS_POWER_CG

// the gated clk better not be x after reset
//
`ifdef VERILINT
`else
// synopsys translate_off

reg disable_asserts; initial disable_asserts = $test$plusargs( "disable_nv_clk_gate_asserts" ) != 0;

nv_assert_no_x #(0, 1, 0, "clk_gated is X after reset" )
    clk_not_x( .clk( clk ), .reset_( reset_ || disable_asserts ), .start_event( 1'b1 ), .test_expr( clk_gated ) );

// Above assert is not reliable for catching X on clk_en.  See bug 872824.
nv_assert_no_x #(0, 1, 0, "clk_en is X after reset" )
    clk_en_not_x( .clk( clk ), .reset_( reset_ || disable_asserts ), .start_event( 1'b1 ), .test_expr( clk_en ) );

// synopsys translate_on
`endif

endmodule // NV_CLK_gate

