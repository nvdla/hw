// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_cfg.v

module NV_NVDLA_CMAC_CORE_cfg (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dp2reg_done
  ,reg2dp_conv_mode
  ,reg2dp_op_en
  ,cfg_is_wg
  ,cfg_reg_en
  );

input        nvdla_core_clk;
input        nvdla_core_rstn;
input        dp2reg_done;
input        reg2dp_conv_mode;
input        reg2dp_op_en;
output       cfg_is_wg;
output       cfg_reg_en;
wire          cfg_is_wg_w;
wire          cfg_reg_en_w;


//: &eperl::flop(" -q  op_en_d1  -d \"reg2dp_op_en\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  op_done_d1  -d \"dp2reg_done\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  cfg_reg_en  -d \"cfg_reg_en_w\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  cfg_is_wg  -d \"cfg_is_wg_w\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 
//: &eperl::flop(" -q  cfg_reg_en_d1  -d \"cfg_reg_en\" -clk nvdla_core_clk -rst nvdla_core_rstn "); 

assign    cfg_reg_en_w = (~op_en_d1 | op_done_d1) & reg2dp_op_en;
assign    cfg_is_wg_w = 1'b0;

endmodule // NV_NVDLA_CMAC_CORE_cfg


