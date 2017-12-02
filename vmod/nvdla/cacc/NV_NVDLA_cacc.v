// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cacc.v

module NV_NVDLA_cacc (
   cacc2sdp_ready                //|< i
  ,csb2cacc_req_pd               //|< i
  ,csb2cacc_req_pvld             //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mac_a2accu_data0              //|< i
  ,mac_a2accu_data1              //|< i
  ,mac_a2accu_data2              //|< i
  ,mac_a2accu_data3              //|< i
  ,mac_a2accu_data4              //|< i
  ,mac_a2accu_data5              //|< i
  ,mac_a2accu_data6              //|< i
  ,mac_a2accu_data7              //|< i
  ,mac_a2accu_mask               //|< i
  ,mac_a2accu_mode               //|< i
  ,mac_a2accu_pd                 //|< i
  ,mac_a2accu_pvld               //|< i
  ,mac_b2accu_data0              //|< i
  ,mac_b2accu_data1              //|< i
  ,mac_b2accu_data2              //|< i
  ,mac_b2accu_data3              //|< i
  ,mac_b2accu_data4              //|< i
  ,mac_b2accu_data5              //|< i
  ,mac_b2accu_data6              //|< i
  ,mac_b2accu_data7              //|< i
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
input   [7:0] mac_a2accu_mask;
input   [7:0] mac_a2accu_mode;
input [175:0] mac_a2accu_data0;
input [175:0] mac_a2accu_data1;
input [175:0] mac_a2accu_data2;
input [175:0] mac_a2accu_data3;
input [175:0] mac_a2accu_data4;
input [175:0] mac_a2accu_data5;
input [175:0] mac_a2accu_data6;
input [175:0] mac_a2accu_data7;
input   [8:0] mac_a2accu_pd;

input         mac_b2accu_pvld;   /* data valid */
input   [7:0] mac_b2accu_mask;
input   [7:0] mac_b2accu_mode;
input [175:0] mac_b2accu_data0;
input [175:0] mac_b2accu_data1;
input [175:0] mac_b2accu_data2;
input [175:0] mac_b2accu_data3;
input [175:0] mac_b2accu_data4;
input [175:0] mac_b2accu_data5;
input [175:0] mac_b2accu_data6;
input [175:0] mac_b2accu_data7;
input   [8:0] mac_b2accu_pd;

output         cacc2sdp_valid;  /* data valid */
input          cacc2sdp_ready;  /* data return handshake */
output [513:0] cacc2sdp_pd;

output       accu2sc_credit_vld;   /* data valid */
output [2:0] accu2sc_credit_size;

output [1:0] cacc2glb_done_intr_pd;

//Port for SLCG
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire   [4:0] abuf_rd_addr;
wire [767:0] abuf_rd_data_0;
wire [767:0] abuf_rd_data_1;
wire [767:0] abuf_rd_data_2;
wire [767:0] abuf_rd_data_3;
wire [543:0] abuf_rd_data_4;
wire [543:0] abuf_rd_data_5;
wire [543:0] abuf_rd_data_6;
wire [543:0] abuf_rd_data_7;
wire   [7:0] abuf_rd_en;
wire   [4:0] abuf_wr_addr;
wire [767:0] abuf_wr_data_0;
wire [767:0] abuf_wr_data_1;
wire [767:0] abuf_wr_data_2;
wire [767:0] abuf_wr_data_3;
wire [543:0] abuf_wr_data_4;
wire [543:0] abuf_wr_data_5;
wire [543:0] abuf_wr_data_6;
wire [543:0] abuf_wr_data_7;
wire   [7:0] abuf_wr_en;
wire [339:0] accu_ctrl_pd;
wire [191:0] accu_ctrl_ram_valid;
wire         accu_ctrl_valid;
wire [191:0] cfg_in_en_mask;
wire  [24:0] cfg_is_fp;
wire  [24:0] cfg_is_int;
wire [126:0] cfg_is_int8;
wire  [95:0] cfg_is_wg;
wire [639:0] cfg_truncate;
wire   [4:0] dbuf_rd_addr;
wire   [7:0] dbuf_rd_en;
wire         dbuf_rd_layer_end;
wire         dbuf_rd_ready;
wire   [4:0] dbuf_wr_addr_0;
wire   [4:0] dbuf_wr_addr_1;
wire   [4:0] dbuf_wr_addr_2;
wire   [4:0] dbuf_wr_addr_3;
wire   [4:0] dbuf_wr_addr_4;
wire   [4:0] dbuf_wr_addr_5;
wire   [4:0] dbuf_wr_addr_6;
wire   [4:0] dbuf_wr_addr_7;
wire [511:0] dbuf_wr_data_0;
wire [511:0] dbuf_wr_data_1;
wire [511:0] dbuf_wr_data_2;
wire [511:0] dbuf_wr_data_3;
wire [511:0] dbuf_wr_data_4;
wire [511:0] dbuf_wr_data_5;
wire [511:0] dbuf_wr_data_6;
wire [511:0] dbuf_wr_data_7;
wire   [7:0] dbuf_wr_en;
wire [511:0] dlv_data_0;
wire [511:0] dlv_data_1;
wire [511:0] dlv_data_2;
wire [511:0] dlv_data_3;
wire [511:0] dlv_data_4;
wire [511:0] dlv_data_5;
wire [511:0] dlv_data_6;
wire [511:0] dlv_data_7;
wire   [7:0] dlv_mask;
wire   [1:0] dlv_pd;
wire         dlv_valid;
wire         dp2reg_done;
wire  [31:0] dp2reg_sat_count;
wire         nvdla_cell_gated_clk_0;
wire         nvdla_cell_gated_clk_1;
wire         nvdla_cell_gated_clk_2;
wire         nvdla_cell_gated_clk_3;
wire         nvdla_op_gated_clk_0;
wire         nvdla_op_gated_clk_1;
wire         nvdla_op_gated_clk_2;
wire   [4:0] reg2dp_batches;
wire   [4:0] reg2dp_clip_truncate;
wire   [0:0] reg2dp_conv_mode;
wire  [31:0] reg2dp_cya;
wire  [26:0] reg2dp_dataout_addr;
wire  [12:0] reg2dp_dataout_channel;
wire  [12:0] reg2dp_dataout_height;
wire  [12:0] reg2dp_dataout_width;
wire   [0:0] reg2dp_line_packed;
wire  [18:0] reg2dp_line_stride;
wire   [0:0] reg2dp_op_en;
wire   [1:0] reg2dp_proc_precision;
wire   [0:0] reg2dp_surf_packed;
wire  [18:0] reg2dp_surf_stride;
wire   [3:0] slcg_cell_en;
wire   [6:0] slcg_op_en;
wire         wait_for_op_en;


//==========================================================
// Regfile
//==========================================================
NV_NVDLA_CACC_regfile u_regfile (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.csb2cacc_req_pd               (csb2cacc_req_pd[62:0])         //|< i
  ,.csb2cacc_req_pvld             (csb2cacc_req_pvld)             //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< w
  ,.dp2reg_sat_count              (dp2reg_sat_count[31:0])        //|< w
  ,.cacc2csb_resp_pd              (cacc2csb_resp_pd[33:0])        //|> o
  ,.cacc2csb_resp_valid           (cacc2csb_resp_valid)           //|> o
  ,.csb2cacc_req_prdy             (csb2cacc_req_prdy)             //|> o
  ,.reg2dp_batches                (reg2dp_batches[4:0])           //|> w
  ,.reg2dp_clip_truncate          (reg2dp_clip_truncate[4:0])     //|> w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)              //|> w
  ,.reg2dp_cya                    (reg2dp_cya[31:0])              //|> w *
  ,.reg2dp_dataout_addr           (reg2dp_dataout_addr[26:0])     //|> w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])  //|> w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])   //|> w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])    //|> w
  ,.reg2dp_line_packed            (reg2dp_line_packed)            //|> w
  ,.reg2dp_line_stride            (reg2dp_line_stride[18:0])      //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                  //|> w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])    //|> w
  ,.reg2dp_surf_packed            (reg2dp_surf_packed)            //|> w
  ,.reg2dp_surf_stride            (reg2dp_surf_stride[18:0])      //|> w
  ,.slcg_op_en                    (slcg_op_en[6:0])               //|> w
  );

//==========================================================
// Assembly controller
//==========================================================
NV_NVDLA_CACC_assembly_ctrl u_assembly_ctrl (
   .reg2dp_op_en                  (reg2dp_op_en[0])               //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])           //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])    //|< w
  ,.reg2dp_clip_truncate          (reg2dp_clip_truncate[4:0])     //|< w
  ,.nvdla_core_clk                (nvdla_op_gated_clk_0)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< w
  ,.mac_a2accu_pd                 (mac_a2accu_pd[8:0])            //|< i
  ,.mac_a2accu_pvld               (mac_a2accu_pvld)               //|< i
  ,.mac_b2accu_pd                 (mac_b2accu_pd[8:0])            //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_pvld)               //|< i
  ,.abuf_rd_addr                  (abuf_rd_addr[4:0])             //|> w
  ,.abuf_rd_en                    (abuf_rd_en[7:0])               //|> w
  ,.accu_ctrl_pd                  (accu_ctrl_pd[339:0])           //|> w
  ,.accu_ctrl_ram_valid           (accu_ctrl_ram_valid[191:0])    //|> w
  ,.accu_ctrl_valid               (accu_ctrl_valid)               //|> w
  ,.cfg_in_en_mask                (cfg_in_en_mask[191:0])         //|> w
  ,.cfg_is_fp                     (cfg_is_fp[24:0])               //|> w
  ,.cfg_is_int                    (cfg_is_int[24:0])              //|> w
  ,.cfg_is_int8                   (cfg_is_int8[126:0])            //|> w
  ,.cfg_is_wg                     (cfg_is_wg[95:0])               //|> w
  ,.cfg_truncate                  (cfg_truncate[639:0])           //|> w
  ,.slcg_cell_en                  (slcg_cell_en[3:0])             //|> w
  ,.wait_for_op_en                (wait_for_op_en)                //|> w
  );

//==========================================================
// Assembly buffer
//==========================================================
NV_NVDLA_CACC_assembly_buffer u_assembly_buffer (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.abuf_rd_addr                  (abuf_rd_addr[4:0])             //|< w
  ,.abuf_rd_en                    (abuf_rd_en[7:0])               //|< w
  ,.abuf_wr_addr                  (abuf_wr_addr[4:0])             //|< w
  ,.abuf_wr_data_0                (abuf_wr_data_0[767:0])         //|< w
  ,.abuf_wr_data_1                (abuf_wr_data_1[767:0])         //|< w
  ,.abuf_wr_data_2                (abuf_wr_data_2[767:0])         //|< w
  ,.abuf_wr_data_3                (abuf_wr_data_3[767:0])         //|< w
  ,.abuf_wr_data_4                (abuf_wr_data_4[543:0])         //|< w
  ,.abuf_wr_data_5                (abuf_wr_data_5[543:0])         //|< w
  ,.abuf_wr_data_6                (abuf_wr_data_6[543:0])         //|< w
  ,.abuf_wr_data_7                (abuf_wr_data_7[543:0])         //|< w
  ,.abuf_wr_en                    (abuf_wr_en[7:0])               //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])           //|< i
  ,.abuf_rd_data_0                (abuf_rd_data_0[767:0])         //|> w
  ,.abuf_rd_data_1                (abuf_rd_data_1[767:0])         //|> w
  ,.abuf_rd_data_2                (abuf_rd_data_2[767:0])         //|> w
  ,.abuf_rd_data_3                (abuf_rd_data_3[767:0])         //|> w
  ,.abuf_rd_data_4                (abuf_rd_data_4[543:0])         //|> w
  ,.abuf_rd_data_5                (abuf_rd_data_5[543:0])         //|> w
  ,.abuf_rd_data_6                (abuf_rd_data_6[543:0])         //|> w
  ,.abuf_rd_data_7                (abuf_rd_data_7[543:0])         //|> w
  );

//==========================================================
// CACC calculator
//==========================================================
NV_NVDLA_CACC_calculator u_calculator (
   .nvdla_cell_clk_0              (nvdla_cell_gated_clk_0)        //|< w
  ,.nvdla_cell_clk_1              (nvdla_cell_gated_clk_1)        //|< w
  ,.nvdla_cell_clk_2              (nvdla_cell_gated_clk_2)        //|< w
  ,.nvdla_cell_clk_3              (nvdla_cell_gated_clk_3)        //|< w
  ,.nvdla_core_clk                (nvdla_op_gated_clk_2)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.abuf_rd_data_0                (abuf_rd_data_0[767:0])         //|< w
  ,.abuf_rd_data_1                (abuf_rd_data_1[767:0])         //|< w
  ,.abuf_rd_data_2                (abuf_rd_data_2[767:0])         //|< w
  ,.abuf_rd_data_3                (abuf_rd_data_3[767:0])         //|< w
  ,.abuf_rd_data_4                (abuf_rd_data_4[543:0])         //|< w
  ,.abuf_rd_data_5                (abuf_rd_data_5[543:0])         //|< w
  ,.abuf_rd_data_6                (abuf_rd_data_6[543:0])         //|< w
  ,.abuf_rd_data_7                (abuf_rd_data_7[543:0])         //|< w
  ,.accu_ctrl_pd                  (accu_ctrl_pd[339:0])           //|< w
  ,.accu_ctrl_ram_valid           (accu_ctrl_ram_valid[191:0])    //|< w
  ,.accu_ctrl_valid               (accu_ctrl_valid)               //|< w
  ,.cfg_in_en_mask                (cfg_in_en_mask[191:0])         //|< w
  ,.cfg_is_fp                     (cfg_is_fp[24:0])               //|< w
  ,.cfg_is_int                    (cfg_is_int[24:0])              //|< w
  ,.cfg_is_int8                   (cfg_is_int8[126:0])            //|< w
  ,.cfg_is_wg                     (cfg_is_wg[95:0])               //|< w
  ,.cfg_truncate                  (cfg_truncate[639:0])           //|< w
  ,.mac_a2accu_data0              (mac_a2accu_data0[175:0])       //|< i
  ,.mac_a2accu_data1              (mac_a2accu_data1[175:0])       //|< i
  ,.mac_a2accu_data2              (mac_a2accu_data2[175:0])       //|< i
  ,.mac_a2accu_data3              (mac_a2accu_data3[175:0])       //|< i
  ,.mac_a2accu_data4              (mac_a2accu_data4[175:0])       //|< i
  ,.mac_a2accu_data5              (mac_a2accu_data5[175:0])       //|< i
  ,.mac_a2accu_data6              (mac_a2accu_data6[175:0])       //|< i
  ,.mac_a2accu_data7              (mac_a2accu_data7[175:0])       //|< i
  ,.mac_a2accu_mask               (mac_a2accu_mask[7:0])          //|< i
  ,.mac_a2accu_mode               (mac_a2accu_mode[7:0])          //|< i
  ,.mac_a2accu_pvld               (mac_a2accu_pvld)               //|< i
  ,.mac_b2accu_data0              (mac_b2accu_data0[175:0])       //|< i
  ,.mac_b2accu_data1              (mac_b2accu_data1[175:0])       //|< i
  ,.mac_b2accu_data2              (mac_b2accu_data2[175:0])       //|< i
  ,.mac_b2accu_data3              (mac_b2accu_data3[175:0])       //|< i
  ,.mac_b2accu_data4              (mac_b2accu_data4[175:0])       //|< i
  ,.mac_b2accu_data5              (mac_b2accu_data5[175:0])       //|< i
  ,.mac_b2accu_data6              (mac_b2accu_data6[175:0])       //|< i
  ,.mac_b2accu_data7              (mac_b2accu_data7[175:0])       //|< i
  ,.mac_b2accu_mask               (mac_b2accu_mask[7:0])          //|< i
  ,.mac_b2accu_mode               (mac_b2accu_mode[7:0])          //|< i
  ,.mac_b2accu_pvld               (mac_b2accu_pvld)               //|< i
  ,.abuf_wr_addr                  (abuf_wr_addr[4:0])             //|> w
  ,.abuf_wr_data_0                (abuf_wr_data_0[767:0])         //|> w
  ,.abuf_wr_data_1                (abuf_wr_data_1[767:0])         //|> w
  ,.abuf_wr_data_2                (abuf_wr_data_2[767:0])         //|> w
  ,.abuf_wr_data_3                (abuf_wr_data_3[767:0])         //|> w
  ,.abuf_wr_data_4                (abuf_wr_data_4[543:0])         //|> w
  ,.abuf_wr_data_5                (abuf_wr_data_5[543:0])         //|> w
  ,.abuf_wr_data_6                (abuf_wr_data_6[543:0])         //|> w
  ,.abuf_wr_data_7                (abuf_wr_data_7[543:0])         //|> w
  ,.abuf_wr_en                    (abuf_wr_en[7:0])               //|> w
  ,.dlv_data_0                    (dlv_data_0[511:0])             //|> w
  ,.dlv_data_1                    (dlv_data_1[511:0])             //|> w
  ,.dlv_data_2                    (dlv_data_2[511:0])             //|> w
  ,.dlv_data_3                    (dlv_data_3[511:0])             //|> w
  ,.dlv_data_4                    (dlv_data_4[511:0])             //|> w
  ,.dlv_data_5                    (dlv_data_5[511:0])             //|> w
  ,.dlv_data_6                    (dlv_data_6[511:0])             //|> w
  ,.dlv_data_7                    (dlv_data_7[511:0])             //|> w
  ,.dlv_mask                      (dlv_mask[7:0])                 //|> w
  ,.dlv_pd                        (dlv_pd[1:0])                   //|> w
  ,.dlv_valid                     (dlv_valid)                     //|> w
  ,.dp2reg_sat_count              (dp2reg_sat_count[31:0])        //|> w
  );

//==========================================================
// Delivery controller
//==========================================================
NV_NVDLA_CACC_delivery_ctrl u_delivery_ctrl (
   .reg2dp_op_en                  (reg2dp_op_en[0])               //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])           //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])    //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])    //|< w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])   //|< w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])  //|< w
  ,.reg2dp_dataout_addr           (reg2dp_dataout_addr[26:0])     //|< w
  ,.reg2dp_line_packed            (reg2dp_line_packed[0])         //|< w
  ,.reg2dp_surf_packed            (reg2dp_surf_packed[0])         //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])           //|< w
  ,.reg2dp_line_stride            (reg2dp_line_stride[18:0])      //|< w
  ,.reg2dp_surf_stride            (reg2dp_surf_stride[18:0])      //|< w
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cacc2sdp_ready                (cacc2sdp_ready)                //|< i
  ,.cacc2sdp_valid                (cacc2sdp_valid)                //|< o
  ,.dbuf_rd_ready                 (dbuf_rd_ready)                 //|< w
  ,.dlv_data_0                    (dlv_data_0[511:0])             //|< w
  ,.dlv_data_1                    (dlv_data_1[511:0])             //|< w
  ,.dlv_data_2                    (dlv_data_2[511:0])             //|< w
  ,.dlv_data_3                    (dlv_data_3[511:0])             //|< w
  ,.dlv_data_4                    (dlv_data_4[511:0])             //|< w
  ,.dlv_data_5                    (dlv_data_5[511:0])             //|< w
  ,.dlv_data_6                    (dlv_data_6[511:0])             //|< w
  ,.dlv_data_7                    (dlv_data_7[511:0])             //|< w
  ,.dlv_mask                      (dlv_mask[7:0])                 //|< w
  ,.dlv_pd                        (dlv_pd[1:0])                   //|< w
  ,.dlv_valid                     (dlv_valid)                     //|< w
  ,.wait_for_op_en                (wait_for_op_en)                //|< w
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])      //|> o
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)            //|> o
  ,.dbuf_rd_addr                  (dbuf_rd_addr[4:0])             //|> w
  ,.dbuf_rd_en                    (dbuf_rd_en[7:0])               //|> w
  ,.dbuf_rd_layer_end             (dbuf_rd_layer_end)             //|> w
  ,.dbuf_wr_addr_0                (dbuf_wr_addr_0[4:0])           //|> w
  ,.dbuf_wr_addr_1                (dbuf_wr_addr_1[4:0])           //|> w
  ,.dbuf_wr_addr_2                (dbuf_wr_addr_2[4:0])           //|> w
  ,.dbuf_wr_addr_3                (dbuf_wr_addr_3[4:0])           //|> w
  ,.dbuf_wr_addr_4                (dbuf_wr_addr_4[4:0])           //|> w
  ,.dbuf_wr_addr_5                (dbuf_wr_addr_5[4:0])           //|> w
  ,.dbuf_wr_addr_6                (dbuf_wr_addr_6[4:0])           //|> w
  ,.dbuf_wr_addr_7                (dbuf_wr_addr_7[4:0])           //|> w
  ,.dbuf_wr_data_0                (dbuf_wr_data_0[511:0])         //|> w
  ,.dbuf_wr_data_1                (dbuf_wr_data_1[511:0])         //|> w
  ,.dbuf_wr_data_2                (dbuf_wr_data_2[511:0])         //|> w
  ,.dbuf_wr_data_3                (dbuf_wr_data_3[511:0])         //|> w
  ,.dbuf_wr_data_4                (dbuf_wr_data_4[511:0])         //|> w
  ,.dbuf_wr_data_5                (dbuf_wr_data_5[511:0])         //|> w
  ,.dbuf_wr_data_6                (dbuf_wr_data_6[511:0])         //|> w
  ,.dbuf_wr_data_7                (dbuf_wr_data_7[511:0])         //|> w
  ,.dbuf_wr_en                    (dbuf_wr_en[7:0])               //|> w
  ,.dp2reg_done                   (dp2reg_done)                   //|> w
  );

//==========================================================
// Delivery buffer
//==========================================================
NV_NVDLA_CACC_delivery_buffer u_delivery_buffer (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cacc2sdp_ready                (cacc2sdp_ready)                //|< i
  ,.dbuf_rd_addr                  (dbuf_rd_addr[4:0])             //|< w
  ,.dbuf_rd_en                    (dbuf_rd_en[7:0])               //|< w
  ,.dbuf_rd_layer_end             (dbuf_rd_layer_end)             //|< w
  ,.dbuf_wr_addr_0                (dbuf_wr_addr_0[4:0])           //|< w
  ,.dbuf_wr_addr_1                (dbuf_wr_addr_1[4:0])           //|< w
  ,.dbuf_wr_addr_2                (dbuf_wr_addr_2[4:0])           //|< w
  ,.dbuf_wr_addr_3                (dbuf_wr_addr_3[4:0])           //|< w
  ,.dbuf_wr_addr_4                (dbuf_wr_addr_4[4:0])           //|< w
  ,.dbuf_wr_addr_5                (dbuf_wr_addr_5[4:0])           //|< w
  ,.dbuf_wr_addr_6                (dbuf_wr_addr_6[4:0])           //|< w
  ,.dbuf_wr_addr_7                (dbuf_wr_addr_7[4:0])           //|< w
  ,.dbuf_wr_data_0                (dbuf_wr_data_0[511:0])         //|< w
  ,.dbuf_wr_data_1                (dbuf_wr_data_1[511:0])         //|< w
  ,.dbuf_wr_data_2                (dbuf_wr_data_2[511:0])         //|< w
  ,.dbuf_wr_data_3                (dbuf_wr_data_3[511:0])         //|< w
  ,.dbuf_wr_data_4                (dbuf_wr_data_4[511:0])         //|< w
  ,.dbuf_wr_data_5                (dbuf_wr_data_5[511:0])         //|< w
  ,.dbuf_wr_data_6                (dbuf_wr_data_6[511:0])         //|< w
  ,.dbuf_wr_data_7                (dbuf_wr_data_7[511:0])         //|< w
  ,.dbuf_wr_en                    (dbuf_wr_en[7:0])               //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])           //|< i
  ,.cacc2glb_done_intr_pd         (cacc2glb_done_intr_pd[1:0])    //|> o
  ,.cacc2sdp_pd                   (cacc2sdp_pd[513:0])            //|> o
  ,.cacc2sdp_valid                (cacc2sdp_valid)                //|> o
  ,.dbuf_rd_ready                 (dbuf_rd_ready)                 //|> w
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
  ,.slcg_en_src_1                 (slcg_cell_en[0])               //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_cell_gated_clk_0)        //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_cell_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[4])                 //|< w
  ,.slcg_en_src_1                 (slcg_cell_en[1])               //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_cell_gated_clk_1)        //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_cell_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[5])                 //|< w
  ,.slcg_en_src_1                 (slcg_cell_en[2])               //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_cell_gated_clk_2)        //|> w
  );


NV_NVDLA_CACC_slcg u_slcg_cell_3 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[6])                 //|< w
  ,.slcg_en_src_1                 (slcg_cell_en[3])               //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_cell_gated_clk_3)        //|> w
  );


// //==========================================================
// // OBS connection
// //==========================================================
// assign obs_bus_cacc_slcg_op_en = slcg_op_en;

endmodule // NV_NVDLA_cacc


