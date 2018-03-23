// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cmac.v

#include "NV_NVDLA_CMAC.h"

module NV_NVDLA_cmac (
   csb2cmac_a_req_pd             //|< i
  ,csb2cmac_a_req_pvld           //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_dat_data${i}       //|< i )
  //: }
  ,sc2mac_dat_mask               //|< i
  ,sc2mac_dat_pd                 //|< i
  ,sc2mac_dat_pvld               //|< i
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_wt_data${i}       //|< i )
  //: }
  ,sc2mac_wt_mask                //|< i
  ,sc2mac_wt_pvld                //|< i
  ,sc2mac_wt_sel                 //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,cmac_a2csb_resp_pd            //|> o
  ,cmac_a2csb_resp_valid         //|> o
  ,csb2cmac_a_req_prdy           //|> o
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,mac2accu_data${i}                //|> o )
  //: }
  ,mac2accu_mask                 //|> o
  ,mac2accu_mode                 //|> o
  ,mac2accu_pd                   //|> o
  ,mac2accu_pvld                 //|> o
  );
//
// NV_NVDLA_cmac_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output        cmac_a2csb_resp_valid;  /* data valid */
output [33:0] cmac_a2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         csb2cmac_a_req_pvld;  /* data valid */
output        csb2cmac_a_req_prdy;  /* data return handshake */
input  [62:0] csb2cmac_a_req_pd;

output         mac2accu_pvld;   /* data valid */
output   [CMAC_ATOMK_HALF-1:0] mac2accu_mask;
output                         mac2accu_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: output [CMAC_RESULT_WIDTH-1:0] mac2accu_data${i};                //|> o )
//: }
output   [8:0] mac2accu_pd;

input         sc2mac_dat_pvld;     /* data valid */
input [CMAC_ATOMC-1:0] sc2mac_dat_mask;
//: for(my $i=0; $i<CMAC_ATOMC ; $i++){
//: print qq(
//: input [CMAC_BPE-1:0]  sc2mac_dat_data${i};       //|< i )
//: }
input   [8:0] sc2mac_dat_pd;

input         sc2mac_wt_pvld;     /* data valid */
input [CMAC_ATOMC-1:0] sc2mac_wt_mask;
//: for(my $i=0; $i<CMAC_ATOMC ; $i++){
//: print qq(
//: input [CMAC_BPE-1:0]  sc2mac_wt_data${i};       //|< i )
//: }
input   [CMAC_ATOMK_HALF-1:0] sc2mac_wt_sel;
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire        dp2reg_done;
wire  [0:0] reg2dp_conv_mode;
wire  [0:0] reg2dp_op_en;
wire  [1:0] reg2dp_proc_precision=2'b0;
wire [CMAC_SLCG_NUM-1:0] slcg_op_en;
//==========================================================
// core
//==========================================================
NV_NVDLA_CMAC_core u_core (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.sc2mac_dat_pvld               (sc2mac_dat_pvld)               //|< i
  ,.sc2mac_dat_mask               (sc2mac_dat_mask)        //|< i
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_dat_data${i}      (sc2mac_dat_data${i})         //|< i )
  //: }
  ,.sc2mac_dat_pd                 (sc2mac_dat_pd)            //|< i
  ,.sc2mac_wt_pvld                (sc2mac_wt_pvld)                //|< i
  ,.sc2mac_wt_mask                (sc2mac_wt_mask)         //|< i
  //: for(my $i=0; $i<CMAC_ATOMC ; $i++){
  //: print qq(
  //: ,.sc2mac_wt_data${i}      (sc2mac_wt_data${i})         //|< i )
  //: }
  ,.sc2mac_wt_sel                 (sc2mac_wt_sel)            //|< i
  ,.mac2accu_pvld                 (mac2accu_pvld)                 //|> o
  ,.mac2accu_mask                 (mac2accu_mask)            //|> o
  ,.mac2accu_mode                 (mac2accu_mode)            //|> o
  //: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
  //: print qq(
  //: ,.mac2accu_data${i}                (mac2accu_data${i})         //|> o )
  //: }
  ,.mac2accu_pd                   (mac2accu_pd)              //|> o
  ,.reg2dp_op_en                  (reg2dp_op_en)               //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)           //|< w
  ,.dp2reg_done                   (dp2reg_done)                   //|> w
  ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.slcg_op_en                    (slcg_op_en)              //|< w
  );

//==========================================================
// reg
//==========================================================
wire [1:0] reg2dp_proc_precision_NC;
NV_NVDLA_CMAC_reg u_reg (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.csb2cmac_a_req_pd             (csb2cmac_a_req_pd)       //|< i
  ,.csb2cmac_a_req_pvld           (csb2cmac_a_req_pvld)           //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< w
  ,.cmac_a2csb_resp_pd            (cmac_a2csb_resp_pd)      //|> o
  ,.cmac_a2csb_resp_valid         (cmac_a2csb_resp_valid)         //|> o
  ,.csb2cmac_a_req_prdy           (csb2cmac_a_req_prdy)           //|> o
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)              //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                  //|> w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision_NC)    //|> w  //dangle
  ,.slcg_op_en                    (slcg_op_en)              //|> w
  );


endmodule // NV_NVDLA_cmac

