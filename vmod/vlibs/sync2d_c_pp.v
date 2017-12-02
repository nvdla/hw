// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sync2d_c_pp.v

module sync2d_c_pp ( d, clk, clr_, q );
input  d, clk, clr_;
output q;
    p_SSYNC2DO_C_PP NV_GENERIC_CELL( .d(d), .clk (clk), .clr_(clr_), .q(q) );
    // synopsys dc_script_begin
    // synopsys dc_script_end
    //g2c if {[find / -null_ok -subdesign sync2d_c_pp] != {} } { set_attr preserve 1 [find / -subdesign sync2d_c_pp] }
endmodule
