// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cacc.v

#include "NV_NVDLA_CACC.h"
module NV_NVDLA_cacc (
   cacc2sdp_ready                //|< i
  ,csb2cacc_req_pd               //|< i
  ,csb2cacc_req_pvld             //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,mac_a2accu_data${i}              //|< i
  //: ,mac_b2accu_data${i}              //|< i )
  //: }
  ,mac_a2accu_mask               //|< i
  ,mac_a2accu_mode               //|< i
  ,mac_a2accu_pd                 //|< i
  ,mac_a2accu_pvld               //|< i
  ,mac_b2accu_mask               //|< i
  ,mac_b2accu_mode               //|< i
  ,mac_b2accu_pd                 //|< i
  ,mac_b2accu_pvld               //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,accu2sc_credit_size           //|> o
  ,accu2sc_credit_vld            //|> o
  ,cacc2csb_resp_pd              //|> o
  ,cacc2csb_resp_valid           //|> o
  ,cacc2glb_done_intr_pd         //|> o
  ,cacc2sdp_pd                   //|> o
  ,cacc2sdp_valid                //|> o
  ,csb2cacc_req_prdy             //|> o
  );

//
// NV_NVDLA_cacc_ports.v
//
input  nvdla_core_clk;   /* csb2cacc_req, cacc2csb_resp, mac_a2accu, mac_b2accu, cacc2sdp, accu2sc_credit, cacc2glb_done_intr */
input  nvdla_core_rstn;  /* csb2cacc_req, cacc2csb_resp, mac_a2accu, mac_b2accu, cacc2sdp, accu2sc_credit, cacc2glb_done_intr */

input [31:0] pwrbus_ram_pd;

input         csb2cacc_req_pvld;  /* data valid */
output        csb2cacc_req_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_pd;
output        cacc2csb_resp_valid;  /* data valid */
output [33:0] cacc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         mac_a2accu_pvld;   /* data valid */
input   [CACC_ATOMK/2-1:0] mac_a2accu_mask;
input   mac_a2accu_mode;
//: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
//: print qq(
//: input [CACC_IN_WIDTH-1:0] mac_a2accu_data${i};              //|< i
//: input [CACC_IN_WIDTH-1:0] mac_b2accu_data${i};              //|< i )
//: }
input   [8:0] mac_a2accu_pd;
input         mac_b2accu_pvld;   /* data valid */
input   [CACC_ATOMK/2-1:0] mac_b2accu_mask;
input   mac_b2accu_mode;
input   [8:0] mac_b2accu_pd;

output         cacc2sdp_valid;  /* data valid */
input          cacc2sdp_ready;  /* data return handshake */
output [CACC_SDP_WIDTH-1:0] cacc2sdp_pd;

output       accu2sc_credit_vld;   /* data valid */
output [2:0] accu2sc_credit_size;
output [1:0] cacc2glb_done_intr_pd;

//Port for SLCG
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire [CACC_ABUF_AWIDTH-1:0] abuf_rd_addr;
wire [CACC_ABUF_WIDTH-1:0] abuf_rd_data;
wire abuf_rd_en;
wire [CACC_ABUF_AWIDTH-1:0] abuf_wr_addr;
wire [CACC_ABUF_WIDTH-1:0] abuf_wr_data;
wire abuf_wr_en;
wire [12:0] accu_ctrl_pd;
wire         accu_ctrl_ram_valid;
wire         accu_ctrl_valid;
wire         cfg_in_en_mask;
wire         cfg_is_wg;
wire [4:0] cfg_truncate;
wire [CACC_DBUF_AWIDTH-1:0] dbuf_rd_addr;
wire         dbuf_rd_en;
wire         dbuf_rd_layer_end;
wire         dbuf_rd_ready;
wire [CACC_DBUF_AWIDTH-1:0] dbuf_wr_addr;
wire [CACC_DBUF_WIDTH-1:0] dbuf_wr_data;
wire         dbuf_wr_en;
wire [CACC_DBUF_WIDTH-1:0] dlv_data;
wire         dlv_mask;
wire   [1:0] dlv_pd;
wire         dlv_valid;
wire         dp2reg_done;
wire  [31:0] dp2reg_sat_count;
wire         nvdla_cell_gated_clk;
wire         nvdla_op_gated_clk_0;
wire         nvdla_op_gated_clk_1;
wire         nvdla_op_gated_clk_2;
wire   [4:0] reg2dp_batches;
wire   [4:0] reg2dp_clip_truncate;
wire   [0:0] reg2dp_conv_mode;
wire  [31:0] reg2dp_cya;
wire  [31:0] reg2dp_dataout_addr;
wire  [12:0] reg2dp_dataout_channel;
wire  [12:0] reg2dp_dataout_height;
wire  [12:0] reg2dp_dataout_width;
wire   [0:0] reg2dp_line_packed;
wire  [23:0] reg2dp_line_stride;
wire   [0:0] reg2dp_op_en;
wire   [1:0] reg2dp_proc_precision;
wire   [0:0] reg2dp_surf_packed;
wire  [23:0] reg2dp_surf_stride;
wire         slcg_cell_en;
wire   [6:0] slcg_op_en;
wire         wait_for_op_en;


//==========================================================
// Regfile
//==========================================================
NV_NVDLA_CACC_regfile u_regfile (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.csb2cacc_req_pd               (csb2cacc_req_pd)         //|< i
  ,.csb2cacc_req_pvld             (csb2cacc_req_pvld)             //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< w
  ,.dp2reg_sat_count              (dp2reg_sat_count)        //|< w
  ,.cacc2csb_resp_pd              (cacc2csb_resp_pd)        //|> o
  ,.cacc2csb_resp_valid           (cacc2csb_resp_valid)           //|> o
  ,.csb2cacc_req_prdy             (csb2cacc_req_prdy)             //|> o
  ,.reg2dp_batches                (reg2dp_batches)           //|> w
  ,.reg2dp_clip_truncate          (reg2dp_clip_truncate)     //|> w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)              //|> w
  ,.reg2dp_cya                    (reg2dp_cya)              //|> w *
  ,.reg2dp_dataout_addr           (reg2dp_dataout_addr)     //|> w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel)  //|> w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height)   //|> w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width)    //|> w
  ,.reg2dp_line_packed            (reg2dp_line_packed)            //|> w
  ,.reg2dp_line_stride            (reg2dp_line_stride)      //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                  //|> w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision)    //|> w
  ,.reg2dp_surf_packed            (reg2dp_surf_packed)            //|> w
  ,.reg2dp_surf_stride            (reg2dp_surf_stride)      //|> w
  ,.slcg_op_en                    (slcg_op_en)               //|> w
  );

//==========================================================
// Assembly controller
//==========================================================
NV_NVDLA_CACC_assembly_ctrl u_assembly_ctrl (
   .reg2dp_op_en                  (reg2dp_op_en)               //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)           //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision)    //|< w
  ,.reg2dp_clip_truncate          (reg2dp_clip_truncate)     //|< w
  ,.nvdla_core_clk                (nvdla_op_gated_clk_0)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< w
  ,.mac_a2accu_pd                 (mac_a2accu_pd)            //|< i
  ,.mac_a2accu_pvld               (mac_a2accu_pvld)               //|< i
  ,.mac_b2accu_pd                 (mac_b2accu_pd)            //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_pvld)               //|< i
  ,.abuf_rd_addr                  (abuf_rd_addr)             //|> w
  ,.abuf_rd_en                    (abuf_rd_en)               //|> w
  ,.accu_ctrl_pd                  (accu_ctrl_pd)           //|> w
  ,.accu_ctrl_ram_valid           (  accu_ctrl_ram_valid)    //|> w
  ,.accu_ctrl_valid               (accu_ctrl_valid)               //|> w
  ,.cfg_in_en_mask                (cfg_in_en_mask)         //|> w
  ,.cfg_is_wg                     (cfg_is_wg)               //|> w
  ,.cfg_truncate                  (cfg_truncate)           //|> w
  ,.slcg_cell_en                  (slcg_cell_en)             //|> w
  ,.wait_for_op_en                (wait_for_op_en)                //|> w
  );

//==========================================================
// Assembly buffer
//==========================================================
NV_NVDLA_CACC_assembly_buffer u_assembly_buffer (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.abuf_rd_addr                  (abuf_rd_addr)             //|< w
  ,.abuf_rd_en                    (abuf_rd_en)               //|< w
  ,.abuf_wr_addr                  (abuf_wr_addr)             //|< w
  ,.abuf_wr_data                  (abuf_wr_data)              //|< w
  ,.abuf_wr_en                    (abuf_wr_en)               //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd)           //|< i
  ,.abuf_rd_data                  (abuf_rd_data)                //|> w
  );

//==========================================================
// CACC calculator
//==========================================================
NV_NVDLA_CACC_calculator u_calculator (
   .nvdla_cell_clk                (nvdla_cell_gated_clk)        //|< w
  ,.nvdla_core_clk                (nvdla_op_gated_clk_2)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.abuf_rd_data                  (abuf_rd_data)         //|< w
  ,.accu_ctrl_pd                  (accu_ctrl_pd)           //|< w
  ,.accu_ctrl_ram_valid           (accu_ctrl_ram_valid)    //|< w
  ,.accu_ctrl_valid               (accu_ctrl_valid)               //|< w
  ,.cfg_in_en_mask                (cfg_in_en_mask)         //|< w
  ,.cfg_is_wg                     (cfg_is_wg)               //|< w
  ,.cfg_truncate                  (cfg_truncate)           //|< w
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_a2accu_data${i}       (mac_a2accu_data${i})       //|< i )
  //: }
  ,.mac_a2accu_mask               (mac_a2accu_mask)          //|< i
  ,.mac_a2accu_mode               (mac_a2accu_mode)          //|< i
  ,.mac_a2accu_pvld               (mac_a2accu_pvld)               //|< i
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,.mac_b2accu_data${i}       (mac_b2accu_data${i})       //|< i )
  //: }
  ,.mac_b2accu_mask               (mac_b2accu_mask)          //|< i
  ,.mac_b2accu_mode               (mac_b2accu_mode)          //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_pvld)               //|< i
  ,.abuf_wr_addr                  (abuf_wr_addr)             //|> w
  ,.abuf_wr_data                  (abuf_wr_data)         //|> w
  ,.abuf_wr_en                    (abuf_wr_en)               //|> w
  ,.dlv_data                      (dlv_data)             //|> w
  ,.dlv_mask                      (dlv_mask)                 //|> w
  ,.dlv_pd                        (dlv_pd)                   //|> w
  ,.dlv_valid                     (dlv_valid)                     //|> w
  ,.dp2reg_sat_count              (dp2reg_sat_count)        //|> w
  );

//==========================================================
// Delivery controller
//==========================================================
NV_NVDLA_CACC_delivery_ctrl u_delivery_ctrl (
   .reg2dp_op_en                  (reg2dp_op_en)               //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)           //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision)    //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width)    //|< w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height)   //|< w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel)  //|< w
  ,.reg2dp_dataout_addr           (reg2dp_dataout_addr[31:NVDLA_MEMORY_ATOMIC_LOG2])     //|< w
  ,.reg2dp_line_packed            (reg2dp_line_packed)         //|< w
  ,.reg2dp_surf_packed            (reg2dp_surf_packed)         //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])           //|< w
  ,.reg2dp_line_stride            (reg2dp_line_stride)      //|< w
  ,.reg2dp_surf_stride            (reg2dp_surf_stride)      //|< w
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cacc2sdp_ready                (cacc2sdp_ready)                //|< i
  ,.cacc2sdp_valid                (cacc2sdp_valid)                //|< o
  ,.dbuf_rd_ready                 (dbuf_rd_ready)                 //|< w
  ,.dlv_data                      (dlv_data)             //|< w
  ,.dlv_mask                      (dlv_mask)                 //|< w
  ,.dlv_pd                        (dlv_pd)                   //|< w
  ,.dlv_valid                     (dlv_valid)                     //|< w
  ,.wait_for_op_en                (wait_for_op_en)                //|< w
  ,.dbuf_rd_addr                  (dbuf_rd_addr)             //|> w
  ,.dbuf_rd_en                    (dbuf_rd_en)               //|> w
  ,.dbuf_rd_layer_end             (dbuf_rd_layer_end)             //|> w
  ,.dbuf_wr_addr                  (dbuf_wr_addr)           //|> w
  ,.dbuf_wr_data                  (dbuf_wr_data)         //|> w
  ,.dbuf_wr_en                    (dbuf_wr_en)               //|> w
  ,.dp2reg_done                   (dp2reg_done)                   //|> w
  );

//==========================================================
// Delivery buffer
//==========================================================
NV_NVDLA_CACC_delivery_buffer u_delivery_buffer (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cacc2sdp_ready                (cacc2sdp_ready)                //|< i
  ,.dbuf_rd_addr                  (dbuf_rd_addr)             //|< w
  ,.dbuf_rd_en                    (dbuf_rd_en)               //|< w
  ,.dbuf_rd_layer_end             (dbuf_rd_layer_end)             //|< w
  ,.dbuf_wr_addr                  (dbuf_wr_addr)           //|< w
  ,.dbuf_wr_data                  (dbuf_wr_data)         //|< w
  ,.dbuf_wr_en                    (dbuf_wr_en)               //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd)           //|< i
  ,.cacc2glb_done_intr_pd         (cacc2glb_done_intr_pd)    //|> o
  ,.cacc2sdp_pd                   (cacc2sdp_pd)            //|> o
  ,.cacc2sdp_valid                (cacc2sdp_valid)                //|> o
  ,.dbuf_rd_ready                 (dbuf_rd_ready)                 //|> w
  ,.accu2sc_credit_size           (accu2sc_credit_size)      //|> o
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)            //|> o
  );

//==========================================================
// SLCG groups
//==========================================================

NV_NVDLA_CACC_slcg u_slcg_op_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[0])                 //|< w
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_0)          //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_op_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[1])                 //|< w
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_1)          //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_op_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[2])                 //|< w
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_2)          //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_cell_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[3])                 //|< w
  ,.slcg_en_src_1                 (slcg_cell_en)               //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_cell_gated_clk)        //|> w
  );


endmodule // NV_NVDLA_cacc


