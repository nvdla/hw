// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_regfile.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CSC_regfile (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,csb2csc_req_pd            //|< i
  ,csb2csc_req_pvld          //|< i
  ,dp2reg_done               //|< i
  ,csb2csc_req_prdy          //|> o
  ,csc2csb_resp_pd           //|> o
  ,csc2csb_resp_valid        //|> o
  ,reg2dp_atomics            //|> o
  ,reg2dp_batches            //|> o
  ,reg2dp_conv_mode          //|> o
  ,reg2dp_conv_x_stride_ext  //|> o
  ,reg2dp_conv_y_stride_ext  //|> o
  ,reg2dp_cya                //|> o
  ,reg2dp_data_bank          //|> o
  ,reg2dp_data_reuse         //|> o
  ,reg2dp_datain_channel_ext //|> o
  ,reg2dp_datain_format      //|> o
  ,reg2dp_datain_height_ext  //|> o
  ,reg2dp_datain_width_ext   //|> o
  ,reg2dp_dataout_channel    //|> o
  ,reg2dp_dataout_height     //|> o
  ,reg2dp_dataout_width      //|> o
  ,reg2dp_entries            //|> o
  ,reg2dp_in_precision       //|> o
  ,reg2dp_op_en              //|> o
  ,reg2dp_pad_left           //|> o
  ,reg2dp_pad_top            //|> o
  ,reg2dp_pad_value          //|> o
  ,reg2dp_pra_truncate       //|> o
  ,reg2dp_proc_precision     //|> o
  ,reg2dp_rls_slices         //|> o
  ,reg2dp_skip_data_rls      //|> o
  ,reg2dp_skip_weight_rls    //|> o
  ,reg2dp_weight_bank        //|> o
  ,reg2dp_weight_bytes       //|> o
  ,reg2dp_weight_channel_ext //|> o
  ,reg2dp_weight_format      //|> o
  ,reg2dp_weight_height_ext  //|> o
  ,reg2dp_weight_kernel      //|> o
  ,reg2dp_weight_reuse       //|> o
  ,reg2dp_weight_width_ext   //|> o
  ,reg2dp_wmb_bytes          //|> o
  ,reg2dp_x_dilation_ext     //|> o
  ,reg2dp_y_dilation_ext     //|> o
  ,reg2dp_y_extension        //|> o
  ,slcg_op_en                //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2csc_req_pd;
input         csb2csc_req_pvld;
input         dp2reg_done;
output        csb2csc_req_prdy;
output [33:0] csc2csb_resp_pd;
output        csc2csb_resp_valid;
output [20:0] reg2dp_atomics;
output  [4:0] reg2dp_batches;
output        reg2dp_conv_mode;
output  [2:0] reg2dp_conv_x_stride_ext;
output  [2:0] reg2dp_conv_y_stride_ext;
output [31:0] reg2dp_cya;
output  [3:0] reg2dp_data_bank;
output        reg2dp_data_reuse;
output [12:0] reg2dp_datain_channel_ext;
output        reg2dp_datain_format;
output [12:0] reg2dp_datain_height_ext;
output [12:0] reg2dp_datain_width_ext;
output [12:0] reg2dp_dataout_channel;
output [12:0] reg2dp_dataout_height;
output [12:0] reg2dp_dataout_width;
output [11:0] reg2dp_entries;
output  [1:0] reg2dp_in_precision;
output        reg2dp_op_en;
output  [4:0] reg2dp_pad_left;
output  [4:0] reg2dp_pad_top;
output [15:0] reg2dp_pad_value;
output  [1:0] reg2dp_pra_truncate;
output  [1:0] reg2dp_proc_precision;
output [11:0] reg2dp_rls_slices;
output        reg2dp_skip_data_rls;
output        reg2dp_skip_weight_rls;
output  [3:0] reg2dp_weight_bank;
output [24:0] reg2dp_weight_bytes;
output [12:0] reg2dp_weight_channel_ext;
output        reg2dp_weight_format;
output  [4:0] reg2dp_weight_height_ext;
output [12:0] reg2dp_weight_kernel;
output        reg2dp_weight_reuse;
output  [4:0] reg2dp_weight_width_ext;
output [20:0] reg2dp_wmb_bytes;
output  [4:0] reg2dp_x_dilation_ext;
output  [4:0] reg2dp_y_dilation_ext;
output  [1:0] reg2dp_y_extension;
output  [3:0] slcg_op_en;
wire          csb_rresp_error;
wire   [33:0] csb_rresp_pd_w;
wire   [31:0] csb_rresp_rdat;
wire          csb_wresp_error;
wire   [33:0] csb_wresp_pd_w;
wire   [31:0] csb_wresp_rdat;
wire   [23:0] d0_reg_offset;
wire   [31:0] d0_reg_rd_data;
wire   [31:0] d0_reg_wr_data;
wire          d0_reg_wr_en;
wire   [23:0] d1_reg_offset;
wire   [31:0] d1_reg_rd_data;
wire   [31:0] d1_reg_wr_data;
wire          d1_reg_wr_en;
wire          dp2reg_consumer_w;
wire   [20:0] reg2dp_d0_atomics;
wire    [4:0] reg2dp_d0_batches;
wire          reg2dp_d0_conv_mode;
wire    [2:0] reg2dp_d0_conv_x_stride_ext;
wire    [2:0] reg2dp_d0_conv_y_stride_ext;
wire   [31:0] reg2dp_d0_cya;
wire    [3:0] reg2dp_d0_data_bank;
wire          reg2dp_d0_data_reuse;
wire   [12:0] reg2dp_d0_datain_channel_ext;
wire          reg2dp_d0_datain_format;
wire   [12:0] reg2dp_d0_datain_height_ext;
wire   [12:0] reg2dp_d0_datain_width_ext;
wire   [12:0] reg2dp_d0_dataout_channel;
wire   [12:0] reg2dp_d0_dataout_height;
wire   [12:0] reg2dp_d0_dataout_width;
wire   [11:0] reg2dp_d0_entries;
wire    [1:0] reg2dp_d0_in_precision;
wire          reg2dp_d0_op_en_trigger;
wire    [4:0] reg2dp_d0_pad_left;
wire    [4:0] reg2dp_d0_pad_top;
wire   [15:0] reg2dp_d0_pad_value;
wire    [1:0] reg2dp_d0_pra_truncate;
wire    [1:0] reg2dp_d0_proc_precision;
wire   [11:0] reg2dp_d0_rls_slices;
wire          reg2dp_d0_skip_data_rls;
wire          reg2dp_d0_skip_weight_rls;
wire    [3:0] reg2dp_d0_weight_bank;
wire   [24:0] reg2dp_d0_weight_bytes;
wire   [12:0] reg2dp_d0_weight_channel_ext;
wire          reg2dp_d0_weight_format;
wire    [4:0] reg2dp_d0_weight_height_ext;
wire   [12:0] reg2dp_d0_weight_kernel;
wire          reg2dp_d0_weight_reuse;
wire    [4:0] reg2dp_d0_weight_width_ext;
wire   [20:0] reg2dp_d0_wmb_bytes;
wire    [4:0] reg2dp_d0_x_dilation_ext;
wire    [4:0] reg2dp_d0_y_dilation_ext;
wire    [1:0] reg2dp_d0_y_extension;
wire   [20:0] reg2dp_d1_atomics;
wire    [4:0] reg2dp_d1_batches;
wire          reg2dp_d1_conv_mode;
wire    [2:0] reg2dp_d1_conv_x_stride_ext;
wire    [2:0] reg2dp_d1_conv_y_stride_ext;
wire   [31:0] reg2dp_d1_cya;
wire    [3:0] reg2dp_d1_data_bank;
wire          reg2dp_d1_data_reuse;
wire   [12:0] reg2dp_d1_datain_channel_ext;
wire          reg2dp_d1_datain_format;
wire   [12:0] reg2dp_d1_datain_height_ext;
wire   [12:0] reg2dp_d1_datain_width_ext;
wire   [12:0] reg2dp_d1_dataout_channel;
wire   [12:0] reg2dp_d1_dataout_height;
wire   [12:0] reg2dp_d1_dataout_width;
wire   [11:0] reg2dp_d1_entries;
wire    [1:0] reg2dp_d1_in_precision;
wire          reg2dp_d1_op_en_trigger;
wire    [4:0] reg2dp_d1_pad_left;
wire    [4:0] reg2dp_d1_pad_top;
wire   [15:0] reg2dp_d1_pad_value;
wire    [1:0] reg2dp_d1_pra_truncate;
wire    [1:0] reg2dp_d1_proc_precision;
wire   [11:0] reg2dp_d1_rls_slices;
wire          reg2dp_d1_skip_data_rls;
wire          reg2dp_d1_skip_weight_rls;
wire    [3:0] reg2dp_d1_weight_bank;
wire   [24:0] reg2dp_d1_weight_bytes;
wire   [12:0] reg2dp_d1_weight_channel_ext;
wire          reg2dp_d1_weight_format;
wire    [4:0] reg2dp_d1_weight_height_ext;
wire   [12:0] reg2dp_d1_weight_kernel;
wire          reg2dp_d1_weight_reuse;
wire    [4:0] reg2dp_d1_weight_width_ext;
wire   [20:0] reg2dp_d1_wmb_bytes;
wire    [4:0] reg2dp_d1_x_dilation_ext;
wire    [4:0] reg2dp_d1_y_dilation_ext;
wire    [1:0] reg2dp_d1_y_extension;
wire    [2:0] reg2dp_op_en_reg_w;
wire          reg2dp_producer;
wire   [23:0] reg_offset;
wire   [31:0] reg_rd_data;
wire          reg_rd_en;
wire   [31:0] reg_wr_data;
wire          reg_wr_en;
wire   [21:0] req_addr;
wire    [1:0] req_level;
wire          req_nposted;
wire          req_srcpriv;
wire   [31:0] req_wdat;
wire    [3:0] req_wrbe;
wire          req_write;
wire   [23:0] s_reg_offset;
wire   [31:0] s_reg_rd_data;
wire   [31:0] s_reg_wr_data;
wire          s_reg_wr_en;
wire          select_d0;
wire          select_d1;
wire          select_s;
wire    [3:0] slcg_op_en_d0;
reg    [33:0] csc2csb_resp_pd;
reg           csc2csb_resp_valid;
reg           dp2reg_consumer;
reg     [1:0] dp2reg_status_0;
reg     [1:0] dp2reg_status_1;
reg    [20:0] reg2dp_atomics;
reg     [4:0] reg2dp_batches;
reg           reg2dp_conv_mode;
reg     [2:0] reg2dp_conv_x_stride_ext;
reg     [2:0] reg2dp_conv_y_stride_ext;
reg    [31:0] reg2dp_cya;
reg           reg2dp_d0_op_en;
reg           reg2dp_d0_op_en_w;
reg           reg2dp_d1_op_en;
reg           reg2dp_d1_op_en_w;
reg     [3:0] reg2dp_data_bank;
reg           reg2dp_data_reuse;
reg    [12:0] reg2dp_datain_channel_ext;
reg           reg2dp_datain_format;
reg    [12:0] reg2dp_datain_height_ext;
reg    [12:0] reg2dp_datain_width_ext;
reg    [12:0] reg2dp_dataout_channel;
reg    [12:0] reg2dp_dataout_height;
reg    [12:0] reg2dp_dataout_width;
reg    [11:0] reg2dp_entries;
reg     [1:0] reg2dp_in_precision;
reg           reg2dp_op_en_ori;
reg     [2:0] reg2dp_op_en_reg;
reg     [4:0] reg2dp_pad_left;
reg     [4:0] reg2dp_pad_top;
reg    [15:0] reg2dp_pad_value;
reg     [1:0] reg2dp_pra_truncate;
reg     [1:0] reg2dp_proc_precision;
reg    [11:0] reg2dp_rls_slices;
reg           reg2dp_skip_data_rls;
reg           reg2dp_skip_weight_rls;
reg     [3:0] reg2dp_weight_bank;
reg    [24:0] reg2dp_weight_bytes;
reg    [12:0] reg2dp_weight_channel_ext;
reg           reg2dp_weight_format;
reg     [4:0] reg2dp_weight_height_ext;
reg    [12:0] reg2dp_weight_kernel;
reg           reg2dp_weight_reuse;
reg     [4:0] reg2dp_weight_width_ext;
reg    [20:0] reg2dp_wmb_bytes;
reg     [4:0] reg2dp_x_dilation_ext;
reg     [4:0] reg2dp_y_dilation_ext;
reg     [1:0] reg2dp_y_extension;
reg    [62:0] req_pd;
reg           req_pvld;
reg     [3:0] slcg_op_en_d1;
reg     [3:0] slcg_op_en_d2;
reg     [3:0] slcg_op_en_d3;


//Instance single register group
NV_NVDLA_CSC_single_reg u_single_reg (
   .reg_rd_data        (s_reg_rd_data[31:0])                //|> w
  ,.reg_offset         (s_reg_offset[11:0])                 //|< w
  ,.reg_wr_data        (s_reg_wr_data[31:0])                //|< w
  ,.reg_wr_en          (s_reg_wr_en)                        //|< w
  ,.nvdla_core_clk     (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)                    //|< i
  ,.producer           (reg2dp_producer)                    //|> w
  ,.consumer           (dp2reg_consumer)                    //|< r
  ,.status_0           (dp2reg_status_0[1:0])               //|< r
  ,.status_1           (dp2reg_status_1[1:0])               //|< r
  );

//Instance two duplicated register groups

NV_NVDLA_CSC_dual_reg u_dual_reg_d0 (
   .reg_rd_data        (d0_reg_rd_data[31:0])               //|> w
  ,.reg_offset         (d0_reg_offset[11:0])                //|< w
  ,.reg_wr_data        (d0_reg_wr_data[31:0])               //|< w
  ,.reg_wr_en          (d0_reg_wr_en)                       //|< w
  ,.nvdla_core_clk     (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)                    //|< i
  ,.atomics            (reg2dp_d0_atomics[20:0])            //|> w
  ,.data_bank          (reg2dp_d0_data_bank[3:0])           //|> w
  ,.weight_bank        (reg2dp_d0_weight_bank[3:0])         //|> w
  ,.batches            (reg2dp_d0_batches[4:0])             //|> w
  ,.conv_x_stride_ext  (reg2dp_d0_conv_x_stride_ext[2:0])   //|> w
  ,.conv_y_stride_ext  (reg2dp_d0_conv_y_stride_ext[2:0])   //|> w
  ,.cya                (reg2dp_d0_cya[31:0])                //|> w
  ,.datain_format      (reg2dp_d0_datain_format)            //|> w
  ,.datain_height_ext  (reg2dp_d0_datain_height_ext[12:0])  //|> w
  ,.datain_width_ext   (reg2dp_d0_datain_width_ext[12:0])   //|> w
  ,.datain_channel_ext (reg2dp_d0_datain_channel_ext[12:0]) //|> w
  ,.dataout_height     (reg2dp_d0_dataout_height[12:0])     //|> w
  ,.dataout_width      (reg2dp_d0_dataout_width[12:0])      //|> w
  ,.dataout_channel    (reg2dp_d0_dataout_channel[12:0])    //|> w
  ,.x_dilation_ext     (reg2dp_d0_x_dilation_ext[4:0])      //|> w
  ,.y_dilation_ext     (reg2dp_d0_y_dilation_ext[4:0])      //|> w
  ,.entries            (reg2dp_d0_entries[11:0])            //|> w
  ,.conv_mode          (reg2dp_d0_conv_mode)                //|> w
  ,.data_reuse         (reg2dp_d0_data_reuse)               //|> w
  ,.in_precision       (reg2dp_d0_in_precision[1:0])        //|> w
  ,.proc_precision     (reg2dp_d0_proc_precision[1:0])      //|> w
  ,.skip_data_rls      (reg2dp_d0_skip_data_rls)            //|> w
  ,.skip_weight_rls    (reg2dp_d0_skip_weight_rls)          //|> w
  ,.weight_reuse       (reg2dp_d0_weight_reuse)             //|> w
  ,.op_en_trigger      (reg2dp_d0_op_en_trigger)            //|> w
  ,.y_extension        (reg2dp_d0_y_extension[1:0])         //|> w
  ,.pra_truncate       (reg2dp_d0_pra_truncate[1:0])        //|> w
  ,.rls_slices         (reg2dp_d0_rls_slices[11:0])         //|> w
  ,.weight_bytes       (reg2dp_d0_weight_bytes[24:0])       //|> w
  ,.weight_format      (reg2dp_d0_weight_format)            //|> w
  ,.weight_height_ext  (reg2dp_d0_weight_height_ext[4:0])   //|> w
  ,.weight_width_ext   (reg2dp_d0_weight_width_ext[4:0])    //|> w
  ,.weight_channel_ext (reg2dp_d0_weight_channel_ext[12:0]) //|> w
  ,.weight_kernel      (reg2dp_d0_weight_kernel[12:0])      //|> w
  ,.wmb_bytes          (reg2dp_d0_wmb_bytes[20:0])          //|> w
  ,.pad_left           (reg2dp_d0_pad_left[4:0])            //|> w
  ,.pad_top            (reg2dp_d0_pad_top[4:0])             //|> w
  ,.pad_value          (reg2dp_d0_pad_value[15:0])          //|> w
  ,.op_en              (reg2dp_d0_op_en)                    //|< r
  );
        
NV_NVDLA_CSC_dual_reg u_dual_reg_d1 (
   .reg_rd_data        (d1_reg_rd_data[31:0])               //|> w
  ,.reg_offset         (d1_reg_offset[11:0])                //|< w
  ,.reg_wr_data        (d1_reg_wr_data[31:0])               //|< w
  ,.reg_wr_en          (d1_reg_wr_en)                       //|< w
  ,.nvdla_core_clk     (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)                    //|< i
  ,.atomics            (reg2dp_d1_atomics[20:0])            //|> w
  ,.data_bank          (reg2dp_d1_data_bank[3:0])           //|> w
  ,.weight_bank        (reg2dp_d1_weight_bank[3:0])         //|> w
  ,.batches            (reg2dp_d1_batches[4:0])             //|> w
  ,.conv_x_stride_ext  (reg2dp_d1_conv_x_stride_ext[2:0])   //|> w
  ,.conv_y_stride_ext  (reg2dp_d1_conv_y_stride_ext[2:0])   //|> w
  ,.cya                (reg2dp_d1_cya[31:0])                //|> w
  ,.datain_format      (reg2dp_d1_datain_format)            //|> w
  ,.datain_height_ext  (reg2dp_d1_datain_height_ext[12:0])  //|> w
  ,.datain_width_ext   (reg2dp_d1_datain_width_ext[12:0])   //|> w
  ,.datain_channel_ext (reg2dp_d1_datain_channel_ext[12:0]) //|> w
  ,.dataout_height     (reg2dp_d1_dataout_height[12:0])     //|> w
  ,.dataout_width      (reg2dp_d1_dataout_width[12:0])      //|> w
  ,.dataout_channel    (reg2dp_d1_dataout_channel[12:0])    //|> w
  ,.x_dilation_ext     (reg2dp_d1_x_dilation_ext[4:0])      //|> w
  ,.y_dilation_ext     (reg2dp_d1_y_dilation_ext[4:0])      //|> w
  ,.entries            (reg2dp_d1_entries[11:0])            //|> w
  ,.conv_mode          (reg2dp_d1_conv_mode)                //|> w
  ,.data_reuse         (reg2dp_d1_data_reuse)               //|> w
  ,.in_precision       (reg2dp_d1_in_precision[1:0])        //|> w
  ,.proc_precision     (reg2dp_d1_proc_precision[1:0])      //|> w
  ,.skip_data_rls      (reg2dp_d1_skip_data_rls)            //|> w
  ,.skip_weight_rls    (reg2dp_d1_skip_weight_rls)          //|> w
  ,.weight_reuse       (reg2dp_d1_weight_reuse)             //|> w
  ,.op_en_trigger      (reg2dp_d1_op_en_trigger)            //|> w
  ,.y_extension        (reg2dp_d1_y_extension[1:0])         //|> w
  ,.pra_truncate       (reg2dp_d1_pra_truncate[1:0])        //|> w
  ,.rls_slices         (reg2dp_d1_rls_slices[11:0])         //|> w
  ,.weight_bytes       (reg2dp_d1_weight_bytes[24:0])       //|> w
  ,.weight_format      (reg2dp_d1_weight_format)            //|> w
  ,.weight_height_ext  (reg2dp_d1_weight_height_ext[4:0])   //|> w
  ,.weight_width_ext   (reg2dp_d1_weight_width_ext[4:0])    //|> w
  ,.weight_channel_ext (reg2dp_d1_weight_channel_ext[12:0]) //|> w
  ,.weight_kernel      (reg2dp_d1_weight_kernel[12:0])      //|> w
  ,.wmb_bytes          (reg2dp_d1_wmb_bytes[20:0])          //|> w
  ,.pad_left           (reg2dp_d1_pad_left[4:0])            //|> w
  ,.pad_top            (reg2dp_d1_pad_top[4:0])             //|> w
  ,.pad_value          (reg2dp_d1_pad_value[15:0])          //|> w
  ,.op_en              (reg2dp_d1_op_en)                    //|< r
  );
        
////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE CONSUMER PIONTER IN GENERAL SINGLE REGISTER GROUP         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
assign dp2reg_consumer_w = ~dp2reg_consumer;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_consumer <= 1'b0;
  end else begin
  if ((dp2reg_done) == 1'b1) begin
    dp2reg_consumer <= dp2reg_consumer_w;
  // VCS coverage off
  end else if ((dp2reg_done) == 1'b0) begin
  end else begin
    dp2reg_consumer <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dp2reg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE TWO STATUS FIELDS IN GENERAL SINGLE REGISTER GROUP        //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  reg2dp_d0_op_en
  or dp2reg_consumer
  ) begin
    dp2reg_status_0 = (reg2dp_d0_op_en == 1'h0 ) ? 2'h0  :
                      (dp2reg_consumer == 1'h1 ) ? 2'h2  :
                      2'h1 ;
end

always @(
  reg2dp_d1_op_en
  or dp2reg_consumer
  ) begin
    dp2reg_status_1 = (reg2dp_d1_op_en == 1'h0 ) ? 2'h0  :
                      (dp2reg_consumer == 1'h0 ) ? 2'h2  :
                      2'h1 ;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OP_EN LOGIC                                               //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  reg2dp_d0_op_en
  or reg2dp_d0_op_en_trigger
  or reg_wr_data
  or dp2reg_done
  or dp2reg_consumer
  ) begin
    reg2dp_d0_op_en_w = (~reg2dp_d0_op_en & reg2dp_d0_op_en_trigger) ? reg_wr_data[0 ] :
                        (dp2reg_done && dp2reg_consumer == 1'h0 ) ? 1'b0 :
                        reg2dp_d0_op_en;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_d0_op_en <= 1'b0;
  end else begin
  reg2dp_d0_op_en <= reg2dp_d0_op_en_w;
  end
end

always @(
  reg2dp_d1_op_en
  or reg2dp_d1_op_en_trigger
  or reg_wr_data
  or dp2reg_done
  or dp2reg_consumer
  ) begin
    reg2dp_d1_op_en_w = (~reg2dp_d1_op_en & reg2dp_d1_op_en_trigger) ? reg_wr_data[0 ] :
                        (dp2reg_done && dp2reg_consumer == 1'h1 ) ? 1'b0 :
                        reg2dp_d1_op_en;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_d1_op_en <= 1'b0;
  end else begin
  reg2dp_d1_op_en <= reg2dp_d1_op_en_w;
  end
end

always @(
  dp2reg_consumer
  or reg2dp_d1_op_en
  or reg2dp_d0_op_en
  ) begin
    reg2dp_op_en_ori = dp2reg_consumer ? reg2dp_d1_op_en : reg2dp_d0_op_en;
end

assign reg2dp_op_en_reg_w = dp2reg_done ? 3'b0 :
                            {reg2dp_op_en_reg[1:0], reg2dp_op_en_ori};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_op_en_reg <= {3{1'b0}};
  end else begin
  reg2dp_op_en_reg <= reg2dp_op_en_reg_w;
  end
end

assign reg2dp_op_en = reg2dp_op_en_reg[3-1];

assign slcg_op_en_d0 = {4{reg2dp_op_en_ori}};

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d1 <= {4{1'b0}};
  end else begin
  slcg_op_en_d1 <= slcg_op_en_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d2 <= {4{1'b0}};
  end else begin
  slcg_op_en_d2 <= slcg_op_en_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_op_en_d3 <= {4{1'b0}};
  end else begin
  slcg_op_en_d3 <= slcg_op_en_d2;
  end
end



assign slcg_op_en = slcg_op_en_d3;

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE ACCESS LOGIC TO EACH REGISTER GROUP                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//EACH subunit has 4KB address space
assign select_s  = (reg_offset[11:0] < (32'h6008  & 32'hfff)) ? 1'b1: 1'b0;
assign select_d0 = (reg_offset[11:0] >= (32'h6008  & 32'hfff)) & (reg2dp_producer == 1'h0 );
assign select_d1 = (reg_offset[11:0] >= (32'h6008  & 32'hfff)) & (reg2dp_producer == 1'h1 );

assign s_reg_wr_en  = reg_wr_en & select_s;
assign d0_reg_wr_en = reg_wr_en & select_d0 & ~reg2dp_d0_op_en;
assign d1_reg_wr_en = reg_wr_en & select_d1 & ~reg2dp_d1_op_en;

assign s_reg_offset  = reg_offset;
assign d0_reg_offset = reg_offset;
assign d1_reg_offset = reg_offset;

assign s_reg_wr_data  = reg_wr_data;
assign d0_reg_wr_data = reg_wr_data;
assign d1_reg_wr_data = reg_wr_data;

assign reg_rd_data = ({32{select_s}}  & s_reg_rd_data)  |
                     ({32{select_d0}} & d0_reg_rd_data) |
                     ({32{select_d1}} & d1_reg_rd_data);

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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Write group 0 registers when OP_EN is set!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (reg_wr_en & select_d0 & reg2dp_d0_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Write group 1 registers when OP_EN is set!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (reg_wr_en & select_d1 & reg2dp_d1_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE CSB TO REGISTER CONNECTION LOGIC                          //
//                                                                    //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pvld <= 1'b0;
  end else begin
  req_pvld <= csb2csc_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2csc_req_pvld) == 1'b1) begin
    req_pd <= csb2csc_req_pd;
  // VCS coverage off
  end else if ((csb2csc_req_pvld) == 1'b0) begin
  end else begin
    req_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(csb2csc_req_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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


// PKT_UNPACK_WIRE( csb2xx_16m_be_lvl ,  req_ ,  req_pd )
assign        req_addr[21:0] =     req_pd[21:0];
assign        req_wdat[31:0] =     req_pd[53:22];
assign         req_write  =     req_pd[54];
assign         req_nposted  =     req_pd[55];
assign         req_srcpriv  =     req_pd[56];
assign        req_wrbe[3:0] =     req_pd[60:57];
assign        req_level[1:0] =     req_pd[62:61];

assign csb2csc_req_prdy = 1'b1;


//Address in CSB master is word aligned while address in regfile is byte aligned.
assign reg_offset = {req_addr, 2'b0};
assign reg_wr_data = req_wdat;
assign reg_wr_en = req_pvld & req_write;
assign reg_rd_en = req_pvld & ~req_write;


// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_rd_erpt ,  csb_rresp_ ,  csb_rresp_pd_w )
assign       csb_rresp_pd_w[31:0] =     csb_rresp_rdat[31:0];
assign       csb_rresp_pd_w[32] =     csb_rresp_error ;

assign   csb_rresp_pd_w[33:33] = 1'd0  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_rd_erpt_ID  */ ;

// PKT_PACK_WIRE_ID( nvdla_xx2csb_resp ,  dla_xx2csb_wr_erpt ,  csb_wresp_ ,  csb_wresp_pd_w )
assign       csb_wresp_pd_w[31:0] =     csb_wresp_rdat[31:0];
assign       csb_wresp_pd_w[32] =     csb_wresp_error ;

assign   csb_wresp_pd_w[33:33] = 1'd1  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_wr_erpt_ID  */ ;

assign csb_rresp_rdat = reg_rd_data;
assign csb_rresp_error = 1'b0;
assign csb_wresp_rdat = {32{1'b0}};
assign csb_wresp_error = 1'b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csc2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        csc2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        csc2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    csc2csb_resp_valid <= 1'b0;
  end else begin
    csc2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE OUTPUT REGISTER FILED FROM DUPLICATED REGISTER GROUPS     //
//                                                                    //
////////////////////////////////////////////////////////////////////////
always @(
  dp2reg_consumer
  or reg2dp_d1_atomics
  or reg2dp_d0_atomics
  ) begin
    reg2dp_atomics = dp2reg_consumer ? reg2dp_d1_atomics : reg2dp_d0_atomics;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_data_bank
  or reg2dp_d0_data_bank
  ) begin
    reg2dp_data_bank = dp2reg_consumer ? reg2dp_d1_data_bank : reg2dp_d0_data_bank;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_bank
  or reg2dp_d0_weight_bank
  ) begin
    reg2dp_weight_bank = dp2reg_consumer ? reg2dp_d1_weight_bank : reg2dp_d0_weight_bank;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_batches
  or reg2dp_d0_batches
  ) begin
    reg2dp_batches = dp2reg_consumer ? reg2dp_d1_batches : reg2dp_d0_batches;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_x_stride_ext
  or reg2dp_d0_conv_x_stride_ext
  ) begin
    reg2dp_conv_x_stride_ext = dp2reg_consumer ? reg2dp_d1_conv_x_stride_ext : reg2dp_d0_conv_x_stride_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_y_stride_ext
  or reg2dp_d0_conv_y_stride_ext
  ) begin
    reg2dp_conv_y_stride_ext = dp2reg_consumer ? reg2dp_d1_conv_y_stride_ext : reg2dp_d0_conv_y_stride_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_cya
  or reg2dp_d0_cya
  ) begin
    reg2dp_cya = dp2reg_consumer ? reg2dp_d1_cya : reg2dp_d0_cya;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_format
  or reg2dp_d0_datain_format
  ) begin
    reg2dp_datain_format = dp2reg_consumer ? reg2dp_d1_datain_format : reg2dp_d0_datain_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_height_ext
  or reg2dp_d0_datain_height_ext
  ) begin
    reg2dp_datain_height_ext = dp2reg_consumer ? reg2dp_d1_datain_height_ext : reg2dp_d0_datain_height_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_width_ext
  or reg2dp_d0_datain_width_ext
  ) begin
    reg2dp_datain_width_ext = dp2reg_consumer ? reg2dp_d1_datain_width_ext : reg2dp_d0_datain_width_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_datain_channel_ext
  or reg2dp_d0_datain_channel_ext
  ) begin
    reg2dp_datain_channel_ext = dp2reg_consumer ? reg2dp_d1_datain_channel_ext : reg2dp_d0_datain_channel_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dataout_height
  or reg2dp_d0_dataout_height
  ) begin
    reg2dp_dataout_height = dp2reg_consumer ? reg2dp_d1_dataout_height : reg2dp_d0_dataout_height;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dataout_width
  or reg2dp_d0_dataout_width
  ) begin
    reg2dp_dataout_width = dp2reg_consumer ? reg2dp_d1_dataout_width : reg2dp_d0_dataout_width;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_dataout_channel
  or reg2dp_d0_dataout_channel
  ) begin
    reg2dp_dataout_channel = dp2reg_consumer ? reg2dp_d1_dataout_channel : reg2dp_d0_dataout_channel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_x_dilation_ext
  or reg2dp_d0_x_dilation_ext
  ) begin
    reg2dp_x_dilation_ext = dp2reg_consumer ? reg2dp_d1_x_dilation_ext : reg2dp_d0_x_dilation_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_y_dilation_ext
  or reg2dp_d0_y_dilation_ext
  ) begin
    reg2dp_y_dilation_ext = dp2reg_consumer ? reg2dp_d1_y_dilation_ext : reg2dp_d0_y_dilation_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_entries
  or reg2dp_d0_entries
  ) begin
    reg2dp_entries = dp2reg_consumer ? reg2dp_d1_entries : reg2dp_d0_entries;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_conv_mode
  or reg2dp_d0_conv_mode
  ) begin
    reg2dp_conv_mode = dp2reg_consumer ? reg2dp_d1_conv_mode : reg2dp_d0_conv_mode;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_data_reuse
  or reg2dp_d0_data_reuse
  ) begin
    reg2dp_data_reuse = dp2reg_consumer ? reg2dp_d1_data_reuse : reg2dp_d0_data_reuse;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_in_precision
  or reg2dp_d0_in_precision
  ) begin
    reg2dp_in_precision = dp2reg_consumer ? reg2dp_d1_in_precision : reg2dp_d0_in_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_proc_precision
  or reg2dp_d0_proc_precision
  ) begin
    reg2dp_proc_precision = dp2reg_consumer ? reg2dp_d1_proc_precision : reg2dp_d0_proc_precision;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_skip_data_rls
  or reg2dp_d0_skip_data_rls
  ) begin
    reg2dp_skip_data_rls = dp2reg_consumer ? reg2dp_d1_skip_data_rls : reg2dp_d0_skip_data_rls;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_skip_weight_rls
  or reg2dp_d0_skip_weight_rls
  ) begin
    reg2dp_skip_weight_rls = dp2reg_consumer ? reg2dp_d1_skip_weight_rls : reg2dp_d0_skip_weight_rls;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_reuse
  or reg2dp_d0_weight_reuse
  ) begin
    reg2dp_weight_reuse = dp2reg_consumer ? reg2dp_d1_weight_reuse : reg2dp_d0_weight_reuse;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_y_extension
  or reg2dp_d0_y_extension
  ) begin
    reg2dp_y_extension = dp2reg_consumer ? reg2dp_d1_y_extension : reg2dp_d0_y_extension;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pra_truncate
  or reg2dp_d0_pra_truncate
  ) begin
    reg2dp_pra_truncate = dp2reg_consumer ? reg2dp_d1_pra_truncate : reg2dp_d0_pra_truncate;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_rls_slices
  or reg2dp_d0_rls_slices
  ) begin
    reg2dp_rls_slices = dp2reg_consumer ? reg2dp_d1_rls_slices : reg2dp_d0_rls_slices;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_bytes
  or reg2dp_d0_weight_bytes
  ) begin
    reg2dp_weight_bytes = dp2reg_consumer ? reg2dp_d1_weight_bytes : reg2dp_d0_weight_bytes;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_format
  or reg2dp_d0_weight_format
  ) begin
    reg2dp_weight_format = dp2reg_consumer ? reg2dp_d1_weight_format : reg2dp_d0_weight_format;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_height_ext
  or reg2dp_d0_weight_height_ext
  ) begin
    reg2dp_weight_height_ext = dp2reg_consumer ? reg2dp_d1_weight_height_ext : reg2dp_d0_weight_height_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_width_ext
  or reg2dp_d0_weight_width_ext
  ) begin
    reg2dp_weight_width_ext = dp2reg_consumer ? reg2dp_d1_weight_width_ext : reg2dp_d0_weight_width_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_channel_ext
  or reg2dp_d0_weight_channel_ext
  ) begin
    reg2dp_weight_channel_ext = dp2reg_consumer ? reg2dp_d1_weight_channel_ext : reg2dp_d0_weight_channel_ext;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_weight_kernel
  or reg2dp_d0_weight_kernel
  ) begin
    reg2dp_weight_kernel = dp2reg_consumer ? reg2dp_d1_weight_kernel : reg2dp_d0_weight_kernel;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_wmb_bytes
  or reg2dp_d0_wmb_bytes
  ) begin
    reg2dp_wmb_bytes = dp2reg_consumer ? reg2dp_d1_wmb_bytes : reg2dp_d0_wmb_bytes;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_left
  or reg2dp_d0_pad_left
  ) begin
    reg2dp_pad_left = dp2reg_consumer ? reg2dp_d1_pad_left : reg2dp_d0_pad_left;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_top
  or reg2dp_d0_pad_top
  ) begin
    reg2dp_pad_top = dp2reg_consumer ? reg2dp_d1_pad_top : reg2dp_d0_pad_top;
end

always @(
  dp2reg_consumer
  or reg2dp_d1_pad_value
  or reg2dp_d0_pad_value
  ) begin
    reg2dp_pad_value = dp2reg_consumer ? reg2dp_d1_pad_value : reg2dp_d0_pad_value;
end

////////////////////////////////////////////////////////////////////////
//                                                                    //
// PASTE ADDIFITON LOGIC HERE FROM EXTRA FILE                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
//No extra logic

endmodule // NV_NVDLA_CSC_regfile

