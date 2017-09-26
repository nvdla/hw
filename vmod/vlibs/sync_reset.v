// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sync_reset.v

module sync_reset (  clk , inreset_ , direct_reset_ , test_mode , outreset_);
input clk;
input inreset_, direct_reset_, test_mode;
output outreset_;
    wire    reset_, inreset_tm_;
wire    inreset_xclamp_, dft_xclamp_ctrl_cdc_sync_reset;

NV_BLKBOX_SRC0 UJ_dft_xclamp_ctrl_cdc_sync_reset(.Y(dft_xclamp_ctrl_cdc_sync_reset));

OR2D1 UJ_inreset_x_clamp (.A1(inreset_),
                          .A2(dft_xclamp_ctrl_cdc_sync_reset),
                          .Z (inreset_xclamp_));

    MUX2D4 UI_test_mode_inmux (.S(test_mode),.I1(direct_reset_),.I0(inreset_),.Z(inreset_tm_)); 
    p_SSYNC2DO_C_PP NV_GENERIC_CELL (.clk(clk), .clr_(inreset_tm_), .d(inreset_xclamp_), .q(reset_));
    MUX2D4 UI_test_mode_outmux (.S(test_mode),.I1(direct_reset_),.I0(reset_),.Z(outreset_)); 
    // synopsys dc_script_begin
    // synopsys dc_script_end
    //g2c if {[find / -null_ok -subdesign sync_reset] != {} } { set_attr preserve 1 [find / -subdesign sync_reset] }
endmodule
