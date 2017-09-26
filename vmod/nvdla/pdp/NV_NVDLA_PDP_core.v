// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_core.v

module NV_NVDLA_PDP_core (
   nvdla_core_clk                 //|< i
  ,nvdla_core_rstn                //|< i
  ,datin_src_cfg                  //|< i
  ,dp2reg_done                    //|< i
  ,nvdla_op_gated_clk_fp16        //|< i
  ,padding_h_cfg                  //|< i
  ,padding_v_cfg                  //|< i
  ,pdp_dp2wdma_ready              //|< i
  ,pdp_rdma2dp_pd                 //|< i
  ,pdp_rdma2dp_valid              //|< i
  ,pooling_channel_cfg            //|< i
  ,pooling_fwidth_cfg             //|< i
  ,pooling_lwidth_cfg             //|< i
  ,pooling_mwidth_cfg             //|< i
  ,pooling_out_fwidth_cfg         //|< i
  ,pooling_out_lwidth_cfg         //|< i
  ,pooling_out_mwidth_cfg         //|< i
  ,pooling_size_h_cfg             //|< i
  ,pooling_size_v_cfg             //|< i
  ,pooling_splitw_num_cfg         //|< i
  ,pooling_stride_h_cfg           //|< i
  ,pooling_stride_v_cfg           //|< i
  ,pooling_type_cfg               //|< i
  ,pwrbus_ram_pd                  //|< i
  ,reg2dp_cube_in_channel         //|< i
  ,reg2dp_cube_in_height          //|< i
  ,reg2dp_cube_in_width           //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_flying_mode             //|< i
  ,reg2dp_input_data              //|< i
  ,reg2dp_kernel_height           //|< i
  ,reg2dp_kernel_stride_width     //|< i
  ,reg2dp_kernel_width            //|< i
  ,reg2dp_op_en                   //|< i
  ,reg2dp_pad_bottom_cfg          //|< i
  ,reg2dp_pad_left                //|< i
  ,reg2dp_pad_right               //|< i
  ,reg2dp_pad_right_cfg           //|< i
  ,reg2dp_pad_top                 //|< i
  ,reg2dp_pad_value_1x_cfg        //|< i
  ,reg2dp_pad_value_2x_cfg        //|< i
  ,reg2dp_pad_value_3x_cfg        //|< i
  ,reg2dp_pad_value_4x_cfg        //|< i
  ,reg2dp_pad_value_5x_cfg        //|< i
  ,reg2dp_pad_value_6x_cfg        //|< i
  ,reg2dp_pad_value_7x_cfg        //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_recip_height_cfg        //|< i
  ,reg2dp_recip_width_cfg         //|< i
  ,sdp2pdp_pd                     //|< i
  ,sdp2pdp_valid                  //|< i
  ,pdp_dp2wdma_pd                 //|> o
  ,pdp_dp2wdma_valid              //|> o
  ,pdp_rdma2dp_ready              //|> o
  ,sdp2pdp_ready                  //|> o
  );

 input          nvdla_core_clk;
 input          nvdla_core_rstn;
 input          datin_src_cfg;
 input          dp2reg_done;
 input          nvdla_op_gated_clk_fp16;
 input    [2:0] padding_h_cfg;
 input    [2:0] padding_v_cfg;
 input          pdp_dp2wdma_ready;
 input   [75:0] pdp_rdma2dp_pd;
 input          pdp_rdma2dp_valid;
 input   [12:0] pooling_channel_cfg;
 input    [9:0] pooling_fwidth_cfg;
 input    [9:0] pooling_lwidth_cfg;
 input    [9:0] pooling_mwidth_cfg;
 input    [9:0] pooling_out_fwidth_cfg;
 input    [9:0] pooling_out_lwidth_cfg;
 input    [9:0] pooling_out_mwidth_cfg;
 input    [2:0] pooling_size_h_cfg;
 input    [2:0] pooling_size_v_cfg;
 input    [7:0] pooling_splitw_num_cfg;
 input    [3:0] pooling_stride_h_cfg;
 input    [3:0] pooling_stride_v_cfg;
 input    [1:0] pooling_type_cfg;
 input   [31:0] pwrbus_ram_pd;
 input   [12:4] reg2dp_cube_in_channel;
 input   [12:0] reg2dp_cube_in_height;
 input   [12:0] reg2dp_cube_in_width;
 input   [12:0] reg2dp_cube_out_width;
 input          reg2dp_flying_mode;
 input    [1:0] reg2dp_input_data;
 input    [2:0] reg2dp_kernel_height;
 input    [3:0] reg2dp_kernel_stride_width;
 input    [2:0] reg2dp_kernel_width;
 input          reg2dp_op_en;
 input    [2:0] reg2dp_pad_bottom_cfg;
 input    [2:0] reg2dp_pad_left;
 input    [2:0] reg2dp_pad_right;
 input    [2:0] reg2dp_pad_right_cfg;
 input    [2:0] reg2dp_pad_top;
 input   [18:0] reg2dp_pad_value_1x_cfg;
 input   [18:0] reg2dp_pad_value_2x_cfg;
 input   [18:0] reg2dp_pad_value_3x_cfg;
 input   [18:0] reg2dp_pad_value_4x_cfg;
 input   [18:0] reg2dp_pad_value_5x_cfg;
 input   [18:0] reg2dp_pad_value_6x_cfg;
 input   [18:0] reg2dp_pad_value_7x_cfg;
 input    [9:0] reg2dp_partial_width_out_first;
 input    [9:0] reg2dp_partial_width_out_last;
 input    [9:0] reg2dp_partial_width_out_mid;
 input   [16:0] reg2dp_recip_height_cfg;
 input   [16:0] reg2dp_recip_width_cfg;
 input  [255:0] sdp2pdp_pd;
 input          sdp2pdp_valid;
 output  [63:0] pdp_dp2wdma_pd;
 output         pdp_dp2wdma_valid;
 output         pdp_rdma2dp_ready;
 output         sdp2pdp_ready;
 //wire 
 wire           pdp_op_start;
 wire   [111:0] pooling1d_pd;
 wire           pooling1d_prdy;
 wire           pooling1d_pvld;
 wire    [75:0] pre2cal1d_pd;
 wire           pre2cal1d_prdy;
 wire           pre2cal1d_pvld;

 //reg
 reg      [1:0] pooling_type_cfg_d;
 reg            reg2dp_fp16_en;
 reg      [1:0] reg2dp_input_data_d;
 reg            reg2dp_int16_en;
 reg            reg2dp_int8_en;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_input_data_d[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_input_data_d[1:0] <= reg2dp_input_data[1:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_int16_en <= 1'b0;
  end else begin
  reg2dp_int16_en <= reg2dp_input_data[1:0] == 2'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_int8_en <= 1'b0;
  end else begin
  reg2dp_int8_en <= reg2dp_input_data[1:0] == 2'h0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_fp16_en <= 1'b0;
  end else begin
  reg2dp_fp16_en <= reg2dp_input_data[1:0] == 2'h2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling_type_cfg_d[1:0] <= {2{1'b0}};
  end else begin
  pooling_type_cfg_d[1:0] <= pooling_type_cfg[1:0];
  end
end

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"PDP reg2dp_pad_value_1x not sign extend")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (pooling_type_cfg== 2'h0 ) & (((reg2dp_input_data== 2'h0 ) & ((|reg2dp_pad_value_1x_cfg[18:7]) != (&reg2dp_pad_value_1x_cfg[18:7]))) | ((reg2dp_input_data== 2'h1 ) & ((|reg2dp_pad_value_1x_cfg[18:15]) != (&reg2dp_pad_value_1x_cfg[18:15]))) | ((reg2dp_input_data== 2'h2 ) & ((|reg2dp_pad_value_1x_cfg[18:16]) != (&reg2dp_pad_value_1x_cfg[18:16]))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//====================================================================
//Instance--pooling 1D
//
//--------------------------------------------------------------------
NV_NVDLA_PDP_CORE_preproc u_preproc (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.pre2cal1d_prdy                 (pre2cal1d_prdy)                      //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.reg2dp_cube_in_channel         (reg2dp_cube_in_channel[12:4])        //|< i
  ,.reg2dp_cube_in_height          (reg2dp_cube_in_height[12:0])         //|< i
  ,.reg2dp_cube_in_width           (reg2dp_cube_in_width[12:0])          //|< i
  ,.reg2dp_flying_mode             (reg2dp_flying_mode)                  //|< i
  ,.reg2dp_input_data              (reg2dp_input_data_d[1:0])            //|< r
  ,.reg2dp_op_en                   (reg2dp_op_en)                        //|< i
  ,.sdp2pdp_pd                     (sdp2pdp_pd[255:0])                   //|< i
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                       //|< i
  ,.pre2cal1d_pd                   (pre2cal1d_pd[75:0])                  //|> w
  ,.pre2cal1d_pvld                 (pre2cal1d_pvld)                      //|> w
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                       //|> o
  );
//====================================================================
//Instance--pooling 1D
//
//--------------------------------------------------------------------
NV_NVDLA_PDP_CORE_cal1d u_cal1d (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.datin_src_cfg                  (datin_src_cfg)                       //|< i
  ,.dp2reg_done                    (dp2reg_done)                         //|< i
  ,.nvdla_op_gated_clk_fp16        (nvdla_op_gated_clk_fp16)             //|< i
  ,.padding_h_cfg                  (padding_h_cfg[2:0])                  //|< i
  ,.pdp_rdma2dp_pd                 (pdp_rdma2dp_pd[75:0])                //|< i
  ,.pdp_rdma2dp_valid              (pdp_rdma2dp_valid)                   //|< i
  ,.pooling1d_prdy                 (pooling1d_prdy)                      //|< w
  ,.pooling_channel_cfg            (pooling_channel_cfg[12:0])           //|< i
  ,.pooling_fwidth_cfg             (pooling_fwidth_cfg[9:0])             //|< i
  ,.pooling_lwidth_cfg             (pooling_lwidth_cfg[9:0])             //|< i
  ,.pooling_mwidth_cfg             (pooling_mwidth_cfg[9:0])             //|< i
  ,.pooling_out_fwidth_cfg         (pooling_out_fwidth_cfg[9:0])         //|< i
  ,.pooling_out_lwidth_cfg         (pooling_out_lwidth_cfg[9:0])         //|< i
  ,.pooling_out_mwidth_cfg         (pooling_out_mwidth_cfg[9:0])         //|< i
  ,.pooling_size_h_cfg             (pooling_size_h_cfg[2:0])             //|< i
  ,.pooling_splitw_num_cfg         (pooling_splitw_num_cfg[7:0])         //|< i
  ,.pooling_stride_h_cfg           (pooling_stride_h_cfg[3:0])           //|< i
  ,.pooling_type_cfg               (pooling_type_cfg_d[1:0])             //|< r
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.reg2dp_cube_in_height          (reg2dp_cube_in_height[12:0])         //|< i
  ,.reg2dp_cube_in_width           (reg2dp_cube_in_width[12:0])          //|< i
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         //|< i
  ,.reg2dp_fp16_en                 (reg2dp_fp16_en)                      //|< r
  ,.reg2dp_input_data              (reg2dp_input_data_d[1:0])            //|< r
  ,.reg2dp_int16_en                (reg2dp_int16_en)                     //|< r
  ,.reg2dp_int8_en                 (reg2dp_int8_en)                      //|< r
  ,.reg2dp_kernel_stride_width     (reg2dp_kernel_stride_width[3:0])     //|< i
  ,.reg2dp_kernel_width            (reg2dp_kernel_width[2:0])            //|< i
  ,.reg2dp_op_en                   (reg2dp_op_en)                        //|< i
  ,.reg2dp_pad_left                (reg2dp_pad_left[2:0])                //|< i
  ,.reg2dp_pad_right               (reg2dp_pad_right[2:0])               //|< i
  ,.reg2dp_pad_right_cfg           (reg2dp_pad_right_cfg[2:0])           //|< i
  ,.reg2dp_pad_value_1x_cfg        (reg2dp_pad_value_1x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_2x_cfg        (reg2dp_pad_value_2x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_3x_cfg        (reg2dp_pad_value_3x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_4x_cfg        (reg2dp_pad_value_4x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_5x_cfg        (reg2dp_pad_value_5x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_6x_cfg        (reg2dp_pad_value_6x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_7x_cfg        (reg2dp_pad_value_7x_cfg[18:0])       //|< i
  ,.sdp2pdp_pd                     (pre2cal1d_pd[75:0])                  //|< w
  ,.sdp2pdp_valid                  (pre2cal1d_pvld)                      //|< w
  ,.pdp_op_start                   (pdp_op_start)                        //|> w
  ,.pdp_rdma2dp_ready              (pdp_rdma2dp_ready)                   //|> o
  ,.pooling1d_pd                   (pooling1d_pd[111:0])                 //|> w
  ,.pooling1d_pvld                 (pooling1d_pvld)                      //|> w
  ,.sdp2pdp_ready                  (pre2cal1d_prdy)                      //|> w
  );
//====================================================================
//Instanfce--pooling 2D
//
//--------------------------------------------------------------------
NV_NVDLA_PDP_CORE_cal2d u_cal2d (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.nvdla_op_gated_clk_fp16        (nvdla_op_gated_clk_fp16)             //|< i
  ,.padding_v_cfg                  (padding_v_cfg[2:0])                  //|< i
  ,.pdp_dp2wdma_ready              (pdp_dp2wdma_ready)                   //|< i
  ,.pdp_op_start                   (pdp_op_start)                        //|< w
  ,.pooling1d_pd                   (pooling1d_pd[111:0])                 //|< w
  ,.pooling1d_pvld                 (pooling1d_pvld)                      //|< w
  ,.pooling_channel_cfg            (pooling_channel_cfg[12:0])           //|< i
  ,.pooling_out_fwidth_cfg         (pooling_out_fwidth_cfg[9:0])         //|< i
  ,.pooling_out_lwidth_cfg         (pooling_out_lwidth_cfg[9:0])         //|< i
  ,.pooling_out_mwidth_cfg         (pooling_out_mwidth_cfg[9:0])         //|< i
  ,.pooling_size_v_cfg             (pooling_size_v_cfg[2:0])             //|< i
  ,.pooling_splitw_num_cfg         (pooling_splitw_num_cfg[7:0])         //|< i
  ,.pooling_stride_v_cfg           (pooling_stride_v_cfg[3:0])           //|< i
  ,.pooling_type_cfg               (pooling_type_cfg_d[1:0])             //|< r
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.reg2dp_cube_in_height          (reg2dp_cube_in_height[12:0])         //|< i
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         //|< i
  ,.reg2dp_fp16_en                 (reg2dp_fp16_en)                      //|< r
  ,.reg2dp_input_data              (reg2dp_input_data_d[1:0])            //|< r
  ,.reg2dp_int16_en                (reg2dp_int16_en)                     //|< r
  ,.reg2dp_int8_en                 (reg2dp_int8_en)                      //|< r
  ,.reg2dp_kernel_height           (reg2dp_kernel_height[2:0])           //|< i
  ,.reg2dp_kernel_width            (reg2dp_kernel_width[2:0])            //|< i
  ,.reg2dp_pad_bottom_cfg          (reg2dp_pad_bottom_cfg[2:0])          //|< i
  ,.reg2dp_pad_top                 (reg2dp_pad_top[2:0])                 //|< i
  ,.reg2dp_pad_value_1x_cfg        (reg2dp_pad_value_1x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_2x_cfg        (reg2dp_pad_value_2x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_3x_cfg        (reg2dp_pad_value_3x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_4x_cfg        (reg2dp_pad_value_4x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_5x_cfg        (reg2dp_pad_value_5x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_6x_cfg        (reg2dp_pad_value_6x_cfg[18:0])       //|< i
  ,.reg2dp_pad_value_7x_cfg        (reg2dp_pad_value_7x_cfg[18:0])       //|< i
  ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) //|< i
  ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  //|< i
  ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   //|< i
  ,.reg2dp_recip_height_cfg        (reg2dp_recip_height_cfg[16:0])       //|< i
  ,.reg2dp_recip_width_cfg         (reg2dp_recip_width_cfg[16:0])        //|< i
  ,.pdp_dp2wdma_pd                 (pdp_dp2wdma_pd[63:0])                //|> o
  ,.pdp_dp2wdma_valid              (pdp_dp2wdma_valid)                   //|> o
  ,.pooling1d_prdy                 (pooling1d_prdy)                      //|> w
  );

////==============
////OBS signals
////==============
//assign obs_bus_pdp_rdma2dp_vld = pdp_rdma2dp_valid;
//assign obs_bus_pdp_rdma2dp_rdy = pdp_rdma2dp_ready;
//assign obs_bus_pdp_sdp2dp_vld  = pre2cal1d_pvld;
//assign obs_bus_pdp_sdp2dp_rdy  = pre2cal1d_prdy;
//assign obs_bus_pdp_cal1d_vld   = pooling1d_pvld;
//assign obs_bus_pdp_cal1d_rdy   = pooling1d_prdy;
//assign obs_bus_pdp_cal2d_vld   = pdp_dp2wdma_valid;
//assign obs_bus_pdp_cal2d_rdy   = pdp_dp2wdma_ready;


endmodule // NV_NVDLA_PDP_core


