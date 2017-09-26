// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: oneHotClk_async_read_clock.v

`timescale 1ps/1ps
module oneHotClk_async_read_clock (
   enable_r
  );

output	enable_r;

// If one_hot_enable = 0, (functional mode, 	i.e. enable_w = 1 	& enable_r = 1)
// If one_hot_enable = 1, (test mode,		i.e. enable_w = TP 	& enable_r = ~TP) due to ANDing with functional enable either read or write CG will be off for the pattern.
//	enable_w = ~one_hot_enable |  TP
//		enable_w & func_en
//	enable_r = ~one_hot_enable | ~TP
//		enable_r & func_en

wire one_hot_enable;
wire tp;

// synopsys template
NV_BLKBOX_SRC0 UJ_dft_xclamp_ctrl_asyncfifo_onehotclk_read (.Y(one_hot_enable));
NV_BLKBOX_SRC0 UJ_dft_xclamp_scan_asyncfifo_onehotclk_read (.Y(tp));

assign enable_r = ((!one_hot_enable) || (!tp));

// synopsys dc_script_begin
// synopsys dc_script_end

endmodule
