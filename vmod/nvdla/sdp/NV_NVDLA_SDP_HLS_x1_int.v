// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_x1_int.v

#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_HLS_x1_int (
   cfg_alu_algo        //|< i
  ,cfg_alu_bypass      //|< i
  ,cfg_alu_op          //|< i
  ,cfg_alu_shift_value //|< i
  ,cfg_alu_src         //|< i
  ,cfg_mul_bypass      //|< i
  ,cfg_mul_op          //|< i
  ,cfg_mul_prelu       //|< i
  ,cfg_mul_shift_value //|< i
  ,cfg_mul_src         //|< i
  ,cfg_relu_bypass     //|< i
  ,chn_alu_op          //|< i
  ,chn_alu_op_pvld     //|< i
  ,chn_data_in         //|< i
  ,chn_in_pvld         //|< i
  ,chn_mul_op          //|< i
  ,chn_mul_op_pvld     //|< i
  ,chn_out_prdy        //|< i
  ,nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,chn_alu_op_prdy     //|> o
  ,chn_data_out        //|> o
  ,chn_in_prdy         //|> o
  ,chn_mul_op_prdy     //|> o
  ,chn_out_pvld        //|> o
  );

input    [1:0] cfg_alu_algo;
input          cfg_alu_bypass;
input   [15:0] cfg_alu_op;
input    [5:0] cfg_alu_shift_value;
input          cfg_alu_src;
input          cfg_mul_bypass;
input   [15:0] cfg_mul_op;
input          cfg_mul_prelu;
input    [5:0] cfg_mul_shift_value;
input          cfg_mul_src;
input          cfg_relu_bypass;
input  [BS_OP_DW-1:0] chn_alu_op;
input          chn_alu_op_pvld;
input  [BS_IN_DW-1:0] chn_data_in;
input          chn_in_pvld;
input  [BS_OP_DW-1:0] chn_mul_op;
input          chn_mul_op_pvld;
input          chn_out_prdy;
output         chn_alu_op_prdy;
output [BS_OUT_DW-1:0] chn_data_out;
output         chn_in_prdy;
output         chn_mul_op_prdy;
output         chn_out_pvld;

input nvdla_core_clk;
input nvdla_core_rstn;

//: my $k=NVDLA_SDP_BS_THROUGHPUT;
//: foreach my $i (0..${k}-1) {
//: print qq(
//: wire    [32:0] alu_data_out_${i};
//: wire           alu_out_prdy_${i};
//: wire           alu_out_pvld_${i};
//: wire           bypass_trt_out_${i};
//: wire    [15:0] chn_alu_op_${i};
//: wire           chn_alu_op_prdy_${i};
//: wire    [31:0] chn_data_in_${i};
//: wire    [31:0] chn_data_out_${i};
//: wire           chn_in_prdy_${i};
//: wire    [15:0] chn_mul_op_${i};
//: wire           chn_mul_op_prdy_${i};
//: wire           chn_out_pvld_${i};
//: wire    [48:0] mul_data_out_${i};
//: wire           mul_out_prdy_${i};
//: wire           mul_out_pvld_${i};
//: wire    [31:0] trt_data_out_${i};
//: wire           trt_out_prdy_${i};
//: wire           trt_out_pvld_${i};
//: 
//:  );
//: }
    
assign  chn_in_prdy      = chn_in_prdy_0;
assign  chn_alu_op_prdy  = chn_alu_op_prdy_0;
assign  chn_mul_op_prdy  = chn_mul_op_prdy_0;
assign  chn_out_pvld     = chn_out_pvld_0;

//: my $k=NVDLA_SDP_BS_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: assign  chn_data_in_${i}= chn_data_in[32*${i}+31:32*${i}]; 
//: assign  chn_alu_op_${i} = chn_alu_op[16*${i}+15:16*${i}]; 
//: assign  chn_mul_op_${i} = chn_mul_op[16*${i}+15:16*${i}]; 
//: assign  chn_data_out[32*${i}+31:32*${i}] = chn_data_out_${i};
//: 
//: NV_NVDLA_SDP_HLS_X_int_alu u_sdp_x_alu_${i} (
//:    .alu_data_in         (chn_data_in_${i}[31:0])   
//:   ,.alu_in_pvld         (chn_in_pvld)              
//:   ,.alu_op_pvld         (chn_alu_op_pvld)          
//:   ,.alu_out_prdy        (alu_out_prdy_${i})         
//:   ,.cfg_alu_algo        (cfg_alu_algo[1:0])        
//:   ,.cfg_alu_bypass      (cfg_alu_bypass)           
//:   ,.cfg_alu_op          (cfg_alu_op[15:0])         
//:   ,.cfg_alu_shift_value (cfg_alu_shift_value[5:0]) 
//:   ,.cfg_alu_src         (cfg_alu_src)              
//:   ,.chn_alu_op          (chn_alu_op_${i}[15:0])     
//:   ,.nvdla_core_clk      (nvdla_core_clk)           
//:   ,.nvdla_core_rstn     (nvdla_core_rstn)          
//:   ,.alu_data_out        (alu_data_out_${i}[32:0])     
//:   ,.alu_in_prdy         (chn_in_prdy_${i})            
//:   ,.alu_op_prdy         (chn_alu_op_prdy_${i})        
//:   ,.alu_out_pvld        (alu_out_pvld_${i})           
//:   );
//: 
//: NV_NVDLA_SDP_HLS_X_int_mul u_sdp_x_mul_${i} (
//:    .alu_data_out        (alu_data_out_${i}[32:0])  
//:   ,.alu_out_pvld        (alu_out_pvld_${i})        
//:   ,.cfg_mul_bypass      (cfg_mul_bypass)          
//:   ,.cfg_mul_op          (cfg_mul_op[15:0])        
//:   ,.cfg_mul_prelu       (cfg_mul_prelu)           
//:   ,.cfg_mul_src         (cfg_mul_src)             
//:   ,.chn_mul_op          (chn_mul_op_${i}[15:0])    
//:   ,.mul_op_pvld         (chn_mul_op_pvld)         
//:   ,.mul_out_prdy        (mul_out_prdy_${i})        
//:   ,.nvdla_core_clk      (nvdla_core_clk)          
//:   ,.nvdla_core_rstn     (nvdla_core_rstn)         
//:   ,.alu_out_prdy        (alu_out_prdy_${i})          
//:   ,.bypass_trt_out      (bypass_trt_out_${i})        
//:   ,.mul_data_out        (mul_data_out_${i}[48:0])    
//:   ,.mul_op_prdy         (chn_mul_op_prdy_${i})       
//:   ,.mul_out_pvld        (mul_out_pvld_${i})          
//:   );
//: 
//: NV_NVDLA_SDP_HLS_X_int_trt u_sdp_x_trt_${i} (
//:    .nvdla_core_clk      (nvdla_core_clk)           
//:   ,.nvdla_core_rstn     (nvdla_core_rstn)          
//:   ,.cfg_mul_shift_value (cfg_mul_shift_value[5:0]) 
//:   ,.bypass_trt_in       (bypass_trt_out_${i})         
//:   ,.mul_data_out        (mul_data_out_${i}[48:0])     
//:   ,.mul_out_pvld        (mul_out_pvld_${i})           
//:   ,.mul_out_prdy        (mul_out_prdy_${i})           
//:   ,.trt_data_out        (trt_data_out_${i}[31:0])     
//:   ,.trt_out_pvld        (trt_out_pvld_${i})           
//:   ,.trt_out_prdy        (trt_out_prdy_${i})           
//:   );
//: 
//: NV_NVDLA_SDP_HLS_X_int_relu u_sdp_x_relu_${i} (
//:    .nvdla_core_clk      (nvdla_core_clk)           
//:   ,.nvdla_core_rstn     (nvdla_core_rstn)          
//:   ,.cfg_relu_bypass     (cfg_relu_bypass)          
//:   ,.trt_out_pvld        (trt_out_pvld_${i})        
//:   ,.trt_out_prdy        (trt_out_prdy_${i})        
//:   ,.trt_data_out        (trt_data_out_${i}[31:0])  
//:   ,.relu_data_out       (chn_data_out_${i}[31:0])  
//:   ,.relu_out_pvld       (chn_out_pvld_${i})         
//:   ,.relu_out_prdy       (chn_out_prdy)             
//:   );
//: 
//:  );
//: }


endmodule // NV_NVDLA_SDP_HLS_x1_int


