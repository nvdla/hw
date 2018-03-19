// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_cmux.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_cmux (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,cacc2sdp_pd           //|< i
  ,cacc2sdp_valid        //|< i
  ,op_en_load            //|< i
  ,reg2dp_flying_mode    //|< i
  ,reg2dp_nan_to_zero    //|< i
  ,reg2dp_proc_precision //|< i
  ,sdp_cmux2dp_ready     //|< i
  ,sdp_mrdma2cmux_pd     //|< i
  ,sdp_mrdma2cmux_valid  //|< i
  ,cacc2sdp_ready        //|> o
  ,sdp_cmux2dp_pd        //|> o
  ,sdp_cmux2dp_valid     //|> o
  ,sdp_mrdma2cmux_ready  //|> o
  );

//
// NV_NVDLA_SDP_cmux_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input          cacc2sdp_valid;  /* data valid */
output         cacc2sdp_ready;  /* data return handshake */
input  [DP_IN_DW+1:0] cacc2sdp_pd;

input          sdp_mrdma2cmux_valid;  /* data valid */
output         sdp_mrdma2cmux_ready;  /* data return handshake */
input  [DP_IN_DW+1:0] sdp_mrdma2cmux_pd;

output         sdp_cmux2dp_valid;
input          sdp_cmux2dp_ready;
output [DP_IN_DW-1:0] sdp_cmux2dp_pd;

input          reg2dp_flying_mode;
input          reg2dp_nan_to_zero;
input    [1:0] reg2dp_proc_precision;
input          op_en_load;
reg            cfg_flying_mode_on;
reg            cfg_proc_precision;
reg            cmux_in_en;

wire           cacc_rdy;
wire           cacc_vld;
wire   [DP_IN_DW+1:0] cacc_pd;
wire   [DP_IN_DW+1:0] cmux_pd;
wire           cmux_pd_batch_end;
wire           cmux_pd_layer_end;
wire           cmux_pd_flush_batch_end_NC;
wire   [DP_IN_DW-1:0] cmux_pd_flush_data;
wire           cmux2dp_prdy;
wire           cmux2dp_pvld;
wire   [DP_IN_DW-1:0] cmux2dp_pd;

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
reg            cfg_nan_to_zero;
wire           cfg_nan_to_zero_en;

//: my $k=NVDLA_SDP_MAX_THROUGHPUT;
//: foreach my $e  (0..${k}-1) {
//: print qq(
//: wire    [31:0] data_byte${e};
//: wire     [7:0] data_byte${e}_expo;
//: wire    [22:0] data_byte${e}_mant;
//: wire    [31:0] data_byte${e}_flush;
//: wire           is_data_byte${e}_nan;
//:
//:  );
//: }
#endif

//=======================
// CFG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_flying_mode_on <= 1'b0;
  end else begin
  cfg_flying_mode_on <= reg2dp_flying_mode == 1'h1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_proc_precision <= 1'b0;
  end else begin
  cfg_proc_precision <= reg2dp_proc_precision == 2'h2;
  end
end

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_nan_to_zero <= 1'b0;
  end else begin
  cfg_nan_to_zero <= reg2dp_nan_to_zero == 1'h1;
  end
end
assign cfg_nan_to_zero_en = cfg_nan_to_zero & cfg_proc_precision;
#endif

NV_NVDLA_SDP_CMUX_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.cacc2sdp_pd       (cacc2sdp_pd[DP_IN_DW+1:0])    //|< i
  ,.cacc2sdp_valid    (cacc2sdp_valid)        //|< i
  ,.cacc_rdy          (cacc_rdy)              //|< w
  ,.cacc2sdp_ready    (cacc2sdp_ready)        //|> o
  ,.cacc_pd           (cacc_pd[DP_IN_DW+1:0])        //|> w
  ,.cacc_vld          (cacc_vld)              //|> w
  );

assign cmux2dp_pvld = cmux_in_en & ((cfg_flying_mode_on) ? cacc_vld : sdp_mrdma2cmux_valid);

assign cacc_rdy             = cmux_in_en &   cfg_flying_mode_on  & cmux2dp_prdy;
assign sdp_mrdma2cmux_ready = cmux_in_en & (!cfg_flying_mode_on) & cmux2dp_prdy;


//===========================================
// Layer Switch
//===========================================
assign cmux_pd   = (cfg_flying_mode_on) ? cacc_pd    : sdp_mrdma2cmux_pd;


assign  cmux_pd_batch_end  = cmux_pd[DP_IN_DW];
assign  cmux_pd_layer_end  = cmux_pd[DP_IN_DW+1];
assign  cmux_pd_flush_batch_end_NC = cmux_pd_batch_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmux_in_en <= 1'b0;
  end else begin
    if (op_en_load) begin
       cmux_in_en  <= 1'b1;
    end else if (cmux_pd_layer_end && cmux2dp_pvld && cmux2dp_prdy) begin
       cmux_in_en  <= 1'b0;
    end
  end
end

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
//: my $k=NVDLA_SDP_MAX_THROUGHPUT;
//: foreach my $e  (0..${k}-1) {
//: print qq(
//: assign data_byte${e} = cmux_pd[32*${e}+31:32*${e}];
//: assign data_byte${e}_expo = data_byte${e}[30:23];
//: assign data_byte${e}_mant = data_byte${e}[22:0];
//: assign is_data_byte${e}_nan = (data_byte${e}_expo==8'hff) & (data_byte${e}_mant!=0);
//: 
//: assign data_byte${e}_flush = (cfg_nan_to_zero_en & is_data_byte${e}_nan)? 32'h0 : data_byte${e};
//: assign cmux_pd_flush_data[32*${e}+31:32*${e}] = data_byte${e}_flush;
//:
//:  );
//: }

assign    cmux2dp_pd[DP_IN_DW-1:0] = cmux_pd_flush_data[DP_IN_DW-1:0];
#else
assign    cmux2dp_pd[DP_IN_DW-1:0] = cmux_pd[DP_IN_DW-1:0];
#endif


NV_NVDLA_SDP_CMUX_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.cmux2dp_pd        (cmux2dp_pd[DP_IN_DW-1:0])     //|< w
  ,.cmux2dp_pvld      (cmux2dp_pvld)          //|< w
  ,.sdp_cmux2dp_ready (sdp_cmux2dp_ready)     //|< i
  ,.cmux2dp_prdy      (cmux2dp_prdy)          //|> w
  ,.sdp_cmux2dp_pd    (sdp_cmux2dp_pd[DP_IN_DW-1:0]) //|> o
  ,.sdp_cmux2dp_valid (sdp_cmux2dp_valid)     //|> o
  );


endmodule // NV_NVDLA_SDP_cmux



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cacc_pd (cacc_vld, cacc_rdy) <= cacc2sdp_pd (cacc2sdp_valid, cacc2sdp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2sdp_pd
  ,cacc2sdp_valid
  ,cacc2sdp_ready
  ,cacc_rdy
  ,cacc_pd
  ,cacc_vld
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [DP_IN_DW+1:0] cacc2sdp_pd;
input          cacc2sdp_valid;
output         cacc2sdp_ready;
input          cacc_rdy;
output         cacc_vld;
output [DP_IN_DW+1:0] cacc_pd;


//: my $dw = DP_IN_DW+2;
//: &eperl::pipe("-is -wid $dw -do cacc_pd -vo cacc_vld -ri cacc_rdy -di cacc2sdp_pd -vi cacc2sdp_valid -ro cacc2sdp_ready");



endmodule // NV_NVDLA_SDP_CMUX_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is sdp_cmux2dp_pd (sdp_cmux2dp_valid,sdp_cmux2dp_ready) <= cmux2dp_pd[511:0] (cmux2dp_pvld,cmux2dp_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cmux2dp_pd
  ,cmux2dp_pvld
  ,cmux2dp_prdy
  ,sdp_cmux2dp_ready
  ,sdp_cmux2dp_pd
  ,sdp_cmux2dp_valid
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [DP_IN_DW-1:0] cmux2dp_pd;
input          cmux2dp_pvld;
output         cmux2dp_prdy;
output [DP_IN_DW-1:0] sdp_cmux2dp_pd;
output         sdp_cmux2dp_valid;
input          sdp_cmux2dp_ready;


//: my $dw = DP_IN_DW;
//: &eperl::pipe("-is -wid $dw -do sdp_cmux2dp_pd -vo sdp_cmux2dp_valid -ri sdp_cmux2dp_ready -di cmux2dp_pd -vi cmux2dp_pvld -ro cmux2dp_prdy");



endmodule // NV_NVDLA_SDP_CMUX_pipe_p2


