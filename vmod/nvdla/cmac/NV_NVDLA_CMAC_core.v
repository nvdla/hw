// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_core.v

#include "NV_NVDLA_CMAC.h"

module NV_NVDLA_CMAC_core (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,reg2dp_conv_mode              //|< i
  ,reg2dp_op_en                  //|< i
  //: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
  //: print qq(
  //: ,sc2mac_dat_data${i}       //|< i)
  //: }
  ,sc2mac_dat_mask               //|< i
  ,sc2mac_dat_pd                 //|< i
  ,sc2mac_dat_pvld               //|< i
  //: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
  //: print qq(
  //: ,sc2mac_wt_data${i}        //|< i)
  //: }
  ,sc2mac_wt_mask                //|< i
  ,sc2mac_wt_pvld                //|< i
  ,sc2mac_wt_sel                 //|< i
  ,slcg_op_en                    //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,dp2reg_done                   //|> o
  //: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
  //: print qq(
  //: ,mac2accu_data${i}        //|< i )
  //: }
  ,mac2accu_mask                 //|> o
  ,mac2accu_mode                 //|> o
  ,mac2accu_pd                   //|> o
  ,mac2accu_pvld                 //|> o
  );

//
// NV_NVDLA_CMAC_core_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         sc2mac_dat_pvld;     /* data valid */
input [CMAC_ATOMC-1:0] sc2mac_dat_mask;
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input [CMAC_BPE-1:0] sc2mac_dat_data${i};    )
//: }
input   [8:0] sc2mac_dat_pd;
input         sc2mac_wt_pvld;     /* data valid */
input [CMAC_ATOMC-1:0] sc2mac_wt_mask;
//: for(my $i=0; $i<CMAC_INPUT_NUM; $i++){
//: print qq(
//: input [CMAC_BPE-1:0] sc2mac_wt_data${i};    )
//: }
input  [CMAC_ATOMK_HALF-1:0] sc2mac_wt_sel;
output         mac2accu_pvld;   /* data valid */
output [CMAC_ATOMK_HALF-1:0] mac2accu_mask;
output                       mac2accu_mode;
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: output [CMAC_RESULT_WIDTH-1:0] mac2accu_data${i};        //|< i )
//: }
output   [8:0] mac2accu_pd;


input   [0:0]             reg2dp_op_en;
input   [0:0]          reg2dp_conv_mode;
output                      dp2reg_done;

//Port for SLCG
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;
input   [CMAC_SLCG_NUM-1:0]  slcg_op_en;

wire cfg_is_wg;
wire cfg_reg_en;


// interface with register config   
//==========================================================
//: my $i=CMAC_ATOMK_HALF;
//: print qq(
//:    wire nvdla_op_gated_clk_${i};  );
//: print qq(
//: NV_NVDLA_CMAC_CORE_cfg u_cfg (
//:    .nvdla_core_clk                (nvdla_op_gated_clk_${i})          //|< w
//:   ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
//:   ,.dp2reg_done                   (dp2reg_done)                   //|< o
//:   ,.reg2dp_conv_mode              (reg2dp_conv_mode)              //|< i
//:   ,.reg2dp_op_en                  (reg2dp_op_en)                  //|< i
//:   ,.cfg_is_wg                     (cfg_is_wg)                     //|> w
//:   ,.cfg_reg_en                    (cfg_reg_en)                    //|> w
//:   );
//: );

wire in_dat_pvld;
assign mac2accu_mode = 1'b0;
wire [8:0] in_dat_pd;
wire [CMAC_ATOMC-1:0] in_wt_mask;
wire in_wt_pvld;
wire [CMAC_ATOMK_HALF-1:0] in_wt_sel;
wire [CMAC_ATOMC-1:0] in_dat_mask;
wire in_dat_stripe_end;
wire in_dat_stripe_st;
wire [CMAC_ATOMK_HALF-1:0] out_mask;

//: for (my $i=0; $i < CMAC_ATOMC; ++$i) {
//:   print qq(
//:     wire [CMAC_BPE-1:0] in_dat_data${i};
//:     wire [CMAC_BPE-1:0] in_wt_data${i};  );
//: }

//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//:   print qq(
//:      wire [CMAC_BPE*CMAC_ATOMC-1:0] dat${i}_actv_data;
//:      wire [CMAC_ATOMC-1:0] dat${i}_actv_nz;
//:      wire [CMAC_ATOMC-1:0] dat${i}_actv_pvld;
//:      wire [CMAC_ATOMC-1:0] dat${i}_pre_mask;
//:      wire dat${i}_pre_pvld;
//:      wire dat${i}_pre_stripe_end;
//:      wire dat${i}_pre_stripe_st;
//:      wire [CMAC_BPE*CMAC_ATOMC-1:0] wt${i}_actv_data;
//:      wire [CMAC_ATOMC-1:0] wt${i}_actv_nz;
//:      wire [CMAC_ATOMC-1:0] wt${i}_actv_pvld;
//:      wire [CMAC_ATOMC-1:0] wt${i}_sd_mask;
//:      wire wt${i}_sd_pvld;
//:   );
//: }


//: my $i=MAC_PD_LATENCY;
//: &eperl::retime("-stage ${i} -wid 9 -i in_dat_pd -o out_pd -cg_en_i in_dat_pvld -cg_en_o out_pvld -cg_en_rtm");

//==========================================================
// input retiming logic            
//==========================================================
 NV_NVDLA_CMAC_CORE_rt_in u_rt_in (
//: my $i= CMAC_ATOMK_HALF;
//: print qq(
//: .nvdla_core_clk                (nvdla_op_gated_clk_${i})          //|< w  );
 ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
 //: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
 //: print qq(
 //: ,.sc2mac_dat_data${i}        (sc2mac_dat_data${i})         //|< i )
 //: }
  ,.sc2mac_dat_mask               (sc2mac_dat_mask)        //|< i
  ,.sc2mac_dat_pd                 (sc2mac_dat_pd)            //|< i
  ,.sc2mac_dat_pvld               (sc2mac_dat_pvld)               //|< i
 //: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
 //: print qq(
 //: ,.sc2mac_wt_data${i}        (sc2mac_wt_data${i})         //|< i )
 //: }
  ,.sc2mac_wt_mask                (sc2mac_wt_mask)         //|< i
  ,.sc2mac_wt_pvld                (sc2mac_wt_pvld)                //|< i
  ,.sc2mac_wt_sel                 (sc2mac_wt_sel)            //|< i
 //: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
 //: print qq(
 //: ,.in_dat_data${i}           (in_dat_data${i})         //|< i )
 //: }
  ,.in_dat_mask                   (in_dat_mask)            //|> w
  ,.in_dat_pd                     (in_dat_pd)                //|> w
  ,.in_dat_pvld                   (in_dat_pvld)                   //|> w
  ,.in_dat_stripe_end             (in_dat_stripe_end)             //|> w
  ,.in_dat_stripe_st              (in_dat_stripe_st)              //|> w
 //: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
 //: print qq(
 //: ,.in_wt_data${i}           (in_wt_data${i})         //|< i )
 //: }
  ,.in_wt_mask                    (in_wt_mask)             //|> w
  ,.in_wt_pvld                    (in_wt_pvld)                    //|> w
  ,.in_wt_sel                     (in_wt_sel)                //|> w
  );

//==========================================================
// input shadow and active pipeline
//==========================================================
//: my $i = CMAC_ATOMK_HALF+1;
//: print qq(
//:    wire nvdla_op_gated_clk_${i};  );
NV_NVDLA_CMAC_CORE_active u_active (
//: my $i=CMAC_ATOMK_HALF+1;
//: print qq(
//:  .nvdla_core_clk                (nvdla_op_gated_clk_${i})         //|< w );
 ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
//: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
//: print qq(
//: ,.in_dat_data${i}           (in_dat_data${i})     //|< i )
//: }
 ,.in_dat_mask                   (in_dat_mask)            //|< w
 ,.in_dat_pvld                   (in_dat_pvld)                   //|< w
 ,.in_dat_stripe_end             (in_dat_stripe_end)             //|< w
 ,.in_dat_stripe_st              (in_dat_stripe_st)              //|< w
//: for(my $i=0; $i<CMAC_INPUT_NUM ; $i++){
//: print qq(
//: ,.in_wt_data${i}           (in_wt_data${i})         //|< i )
//: }
 ,.in_wt_mask                    (in_wt_mask)             //|< w
 ,.in_wt_pvld                    (in_wt_pvld)                    //|< w
 ,.in_wt_sel                     (in_wt_sel)                //|< w
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: ,.dat${i}_actv_data                (dat${i}_actv_data)        //|> w
//: ,.dat${i}_actv_nz                  (dat${i}_actv_nz)           //|> w
//: ,.dat${i}_actv_pvld                (dat${i}_actv_pvld)         //|> w
//: ,.dat${i}_pre_mask                 (dat${i}_pre_mask)           //|> w
//: ,.dat${i}_pre_pvld                 (dat${i}_pre_pvld)                 //|> w
//: ,.dat${i}_pre_stripe_end           (dat${i}_pre_stripe_end)           //|> w
//: ,.dat${i}_pre_stripe_st            (dat${i}_pre_stripe_st)            //|> w
//: )
//: }
//: for(my $i=0; $i<CMAC_ATOMK_HALF ; $i++){
//: print qq(
//: ,.wt${i}_actv_data                 (wt${i}_actv_data)         //|> w
//: ,.wt${i}_actv_nz                   (wt${i}_actv_nz)            //|> w
//: ,.wt${i}_actv_pvld                 (wt${i}_actv_pvld)          //|> w
//: ,.wt${i}_sd_mask                   (wt${i}_sd_mask)           //|> w
//: ,.wt${i}_sd_pvld                   (wt${i}_sd_pvld)           //|> w
//: )
//: }
);

//==========================================================
// MAC CELLs
//==========================================================
//:     my $total_num = CMAC_ATOMK_HALF;
//:     for(my $i = 0; $i < $total_num; $i ++) {
//:         print qq {
//: wire nvdla_op_gated_clk_${i};
//: wire nvdla_wg_gated_clk_${i};
//: wire [CMAC_RESULT_WIDTH-1:0] out_data${i};
//: NV_NVDLA_CMAC_CORE_mac u_mac_${i} (
//:    .nvdla_core_clk                (nvdla_op_gated_clk_${i})          //|< w
//:   ,.nvdla_wg_clk                  (nvdla_op_gated_clk_${i})          //|< w , need update for winograd
//:   ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
//:   ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
//:   ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
//:   ,.dat_actv_data                 (dat${i}_actv_data)        //|< w
//:   ,.dat_actv_nz                   (dat${i}_actv_nz)           //|< w
//:   ,.dat_actv_pvld                 (dat${i}_actv_pvld)         //|< w
//:   ,.wt_actv_data                  (wt${i}_actv_data)         //|< w
//:   ,.wt_actv_nz                    (wt${i}_actv_nz)            //|< w
//:   ,.wt_actv_pvld                  (wt${i}_actv_pvld)          //|< w
//:   ,.mac_out_data                  (out_data${i})              //|> w
//:   ,.mac_out_pvld                  (out_mask[${i}])            //|> w
//:   );
//:     }
//:}

//==========================================================
// output retiming logic            
//==========================================================
//: my $i = CMAC_ATOMK_HALF+2;
//: print qq(
//:    wire nvdla_op_gated_clk_${i};  );
NV_NVDLA_CMAC_CORE_rt_out u_rt_out (
//: my $i=CMAC_ATOMK_HALF+2;
//: print qq(
//:  .nvdla_core_clk                (nvdla_op_gated_clk_${i})          //|< w 
//: ,.nvdla_wg_clk                  (nvdla_op_gated_clk_${i})          //|< w );
 ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
 ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
 ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: ,.out_data${i}                     (out_data${i})              //|< w )
//: }
 ,.out_mask                      (out_mask)                 //|< w
 ,.out_pd                        (out_pd)                   //|< w
 ,.out_pvld                      (out_pvld)                      //|< w
 ,.dp2reg_done                   (dp2reg_done)                   //|> o
//: for(my $i=0; $i<CMAC_ATOMK_HALF; $i++){
//: print qq(
//: ,.mac2accu_data${i}                (mac2accu_data${i})         //|> o )
//: }
 ,.mac2accu_mask                 (mac2accu_mask)            //|> o
 ,.mac2accu_pd                   (mac2accu_pd)              //|> o
 ,.mac2accu_pvld                 (mac2accu_pvld)                 //|> o
 );

//==========================================================
// SLCG groups
//==========================================================
//:     for(my $i = 0; $i < CMAC_SLCG_NUM; $i ++) {
//:         print qq {
//: NV_NVDLA_CMAC_CORE_slcg u_slcg_op_${i} (
//:    .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
//:   ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
//:   ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
//:   ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
//:   ,.slcg_en_src_0                 (slcg_op_en[${i}])                 //|< i
//:   ,.slcg_en_src_1                 (1'b1)                          //|< ?
//:   ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
//:   ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_${i})          //|> w
//:   );
//:     }
//: }


`ifndef SYNTHESIS
wire    [8:0] dbg_mac2accu_pd;
wire          dbg_mac2accu_pvld;
wire    [8:0] dbg_out_pd_d0;
wire          dbg_out_pvld_d0;
`endif

//////// for valid forwarding ///////
`ifndef SYNTHESIS
//: print qq (
//: assign dbg_out_pvld_d0 = out_pvld;
//: assign dbg_out_pd_d0 = out_pd;
//: );
//: 
//: my $delay = CMAC_DATA_LATENCY-CMAC_IN_RT_LATENCY-MAC_PD_LATENCY;
//: my $i;
//: 
//: for($i = 0; $i < $delay; $i ++) {
//: my $j = $i + 1;
//: &eperl::flop("-q dbg_out_pvld_d${j} -d dbg_out_pvld_d${i}"); 
//: &eperl::flop("-wid 9 -q dbg_out_pd_d${j} -en dbg_out_pvld_d${i} -d dbg_out_pd_d${i}");
//: }
//: 
//: print qq (
//: assign dbg_mac2accu_pvld = dbg_out_pvld_d${delay};
//: assign dbg_mac2accu_pd = dbg_out_pd_d${delay};
//: );
`endif
endmodule
