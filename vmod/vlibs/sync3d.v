// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sync3d.v

module sync3d ( d, clk, q);
input d, clk;
output q;
    p_SSYNC3DO NV_GENERIC_CELL( .d(d), .clk(clk), .q(q) );
    // synopsys dc_script_begin
    // synopsys dc_script_end
    //g2c if {[find / -null_ok -subdesign sync3d] != {} } { set_attr preserve 1 [find / -subdesign sync3d] }
endmodule
