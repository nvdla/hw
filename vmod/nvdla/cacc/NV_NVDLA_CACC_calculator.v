// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_calculator.v

#include "NV_NVDLA_CACC.h"

module NV_NVDLA_CACC_calculator (
   nvdla_core_clk //|< i
  ,nvdla_core_rstn //|< i
  ,abuf_rd_data //|< i
  ,accu_ctrl_pd //|< i
  ,accu_ctrl_ram_valid //|< i
  ,accu_ctrl_valid //|< i
  ,cfg_in_en_mask //|< i
  ,cfg_is_wg //|< i
  ,cfg_truncate //|< i
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,mac_a2accu_data${i} //|< i )
  //: }
  ,mac_a2accu_mask //|< i
  ,mac_a2accu_mode //|< i
  ,mac_a2accu_pvld //|< i
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: ,mac_b2accu_data${i} //|< i )
  //: }
  ,mac_b2accu_mask //|< i
  ,mac_b2accu_mode //|< i
  ,mac_b2accu_pvld //|< i
  ,nvdla_cell_clk  //|< i
  ,abuf_wr_addr //|> o
  ,abuf_wr_data //|> o
  ,abuf_wr_en //|> o
  ,dlv_data //|> o
  ,dlv_mask //|> o
  ,dlv_pd //|> o
  ,dlv_valid //|> o
  ,dp2reg_sat_count //|> o
  );


input nvdla_cell_clk;

input nvdla_core_clk;
input nvdla_core_rstn;
input [CACC_ABUF_WIDTH-1:0] abuf_rd_data;
input [12:0] accu_ctrl_pd;
input        accu_ctrl_ram_valid;
input accu_ctrl_valid;
input  cfg_in_en_mask;
input  cfg_is_wg;
input [4:0] cfg_truncate;
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: input [CACC_IN_WIDTH-1:0] mac_a2accu_data${i}; )
  //: }
input [CACC_ATOMK/2-1:0] mac_a2accu_mask;
input mac_a2accu_mode;
input mac_a2accu_pvld;
  //: for(my $i=0; $i<CACC_ATOMK/2 ; $i++){
  //: print qq(
  //: input [CACC_IN_WIDTH-1:0] mac_b2accu_data${i}; )
  //: }
input [CACC_ATOMK/2-1:0] mac_b2accu_mask;
input mac_b2accu_mode;
input mac_b2accu_pvld;
output [CACC_ABUF_AWIDTH-1:0] abuf_wr_addr;
output [CACC_ABUF_WIDTH-1:0] abuf_wr_data;
output abuf_wr_en;
output [CACC_DBUF_WIDTH-1:0] dlv_data;
output dlv_mask;
output [1:0] dlv_pd;
output dlv_valid;
output [31:0] dp2reg_sat_count;

// spyglass disable_block NoWidthInBasedNum-ML
// spyglass disable_block STARC-2.10.1.6

// unpack abuffer read data
//: my $kk=CACC_PARSUM_WIDTH;
//: for(my $i=0; $i<CACC_ATOMK ; $i++){
//: print qq(
//: wire [${kk}-1:0] abuf_in_data_${i} = abuf_rd_data[($i+1)*${kk}-1:$i*${kk}]; )
//: }

//1T delay, the same T with data/mask
//: &eperl::flop("-wid 13 -q accu_ctrl_pd_d1 -en accu_ctrl_valid -d accu_ctrl_pd");
wire calc_valid_in  = (mac_b2accu_pvld | mac_a2accu_pvld);
// spyglass disable_block STARC05-3.3.1.4b
//: &eperl::retime("-stage 3 -o calc_valid -i calc_valid_in");  
// spyglass enable_block STARC05-3.3.1.4b

// unpack pd form abuffer control
wire [5:0]      calc_addr           =     accu_ctrl_pd_d1[5:0];
wire [2:0]      calc_mode           =     accu_ctrl_pd_d1[8:6];
wire            calc_stripe_end     =     accu_ctrl_pd_d1[9];
wire            calc_channel_end    =     accu_ctrl_pd_d1[10];
wire            calc_layer_end      =     accu_ctrl_pd_d1[11];
wire            calc_dlv_elem_mask  =     accu_ctrl_pd_d1[12];

//: my $kk=CACC_IN_WIDTH;
//: for(my $i = 0; $i < CACC_ATOMK/2; $i ++) {
//: print "wire [${kk}-1:0] calc_elem_${i} = mac_a2accu_data${i}; \n";
//: }
//: for(my $i = CACC_ATOMK/2; $i < CACC_ATOMK; $i ++) {
//: my $j = $i - CACC_ATOMK/2;
//: print "wire [${kk}-1:0] calc_elem_${i} = mac_b2accu_data${j}; \n";
//: }

wire [CACC_ATOMK-1:0] calc_in_mask  = {mac_b2accu_mask, mac_a2accu_mask};
wire [CACC_ATOMK-1:0] calc_op_en    = calc_in_mask & {CACC_ATOMK{cfg_in_en_mask}};
wire [CACC_ATOMK-1:0] calc_op1_vld  = calc_in_mask & {CACC_ATOMK{cfg_in_en_mask & accu_ctrl_ram_valid}};
wire calc_dlv_valid                 = calc_valid & calc_channel_end;
wire calc_wr_en                     = calc_valid & (~calc_channel_end);
//: my $hh= 22-CACC_IN_WIDTH;
//: my $pp= CACC_PARSUM_WIDTH;
//: my $bb= CACC_IN_WIDTH;
//: for(my $i = 0; $i <CACC_ATOMK; $i ++) {
//: if($hh == 0) {
//: print qq( 
//: wire [21:0]calc_op0_${i} = {calc_elem_${i}};   
//: wire [${pp}-1:0] calc_op1_${i} = abuf_in_data_${i};  
//: );
//: } 
//: elsif($hh > 0) {
//: print qq( 
//: wire [21:0]calc_op0_${i} = {{${hh}{calc_elem_${i}[${bb}-1]}},calc_elem_${i}};   
//: wire [${pp}-1:0] calc_op1_${i} = abuf_in_data_${i};  
//: );
//: }
//: }

// instance int8 adders
wire [CACC_ATOMK-1:0] calc_fout_sat;
wire [CACC_ATOMK-1:0] calc_pout_vld;
wire [CACC_ATOMK-1:0] calc_fout_vld;
//: for(my $i = 0; $i <CACC_ATOMK; $i ++) {
//: print qq(
//: wire [CACC_PARSUM_WIDTH-1:0] calc_pout_${i}_sum;
//: wire [CACC_FINAL_WIDTH-1:0] calc_fout_${i}_sum;
//: )
//: }

//: for(my $i = 0; $i <CACC_ATOMK; $i ++) {
//: print qq(
//: NV_NVDLA_CACC_CALC_int8 u_cell_int8_${i} (
//:    .cfg_truncate      (cfg_truncate)        //|< w
//:   ,.in_data           (calc_op0_${i})    //|< r
//:   ,.in_op             (calc_op1_${i})    //|< r
//:   ,.in_op_valid       (calc_op1_vld[${i}])     //|< r
//:   ,.in_sel            (calc_dlv_valid)            //|< r
//:   ,.in_valid          (calc_op_en[${i}])      //|< r
//:   ,.out_final_data    (calc_fout_${i}_sum)        //|> w
//:   ,.out_final_sat     (calc_fout_sat[${i}])       //|> w
//:   ,.out_final_valid   (calc_fout_vld[${i}])       //|> w
//:   ,.out_partial_data  (calc_pout_${i}_sum)        //|> w
//:   ,.out_partial_valid (calc_pout_vld[${i}])       //|> w
//:   ,.nvdla_core_clk    (nvdla_cell_clk)            //|< i
//:   ,.nvdla_core_rstn   (nvdla_core_rstn)           //|< i
//:   );
//: )
//: }

wire calc_valid_d0 = calc_valid;
wire calc_wr_en_d0 = calc_wr_en;
wire [5:0] calc_addr_d0 = calc_addr;
wire calc_dlv_valid_d0 = calc_dlv_valid;
wire calc_stripe_end_d0 = calc_stripe_end;
wire calc_layer_end_d0 = calc_layer_end;
// Latency pipeline to balance with calc cells, signal for both abuffer & dbuffer
//: my $start = 0;
//: for(my $i = $start; $i < $start + CACC_CELL_PARTIAL_LATENCY; $i ++) {
//: my $j = $i + 1;
//: &eperl::flop(" -q  calc_valid_d${j}  -d \"calc_valid_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  calc_wr_en_d${j}  -d  \"calc_wr_en_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid 6 -q  calc_addr_d${j}  -en \"calc_valid_d${i}\" -d  \"calc_addr_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: }
//: my $pin = $start + CACC_CELL_PARTIAL_LATENCY;
//: print qq(
//: wire calc_valid_out = calc_valid_d${pin};
//: wire calc_wr_en_out = calc_wr_en_d${pin};
//: wire [5:0] calc_addr_out  = calc_addr_d${pin};
//: );
//:
//: for(my $i = $start; $i < $start + CACC_CELL_FINAL_LATENCY; $i ++) {
//: my $j = $i + 1;
//: &eperl::flop(" -q  calc_dlv_valid_d${j}  -d \"calc_dlv_valid_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  calc_stripe_end_d${j}  -en \"calc_dlv_valid_d${i}\" -d  \"calc_stripe_end_d${i}\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  calc_layer_end_d${j}  -en \"calc_dlv_valid_d${i}\" -d  \"calc_layer_end_d${i} \" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: }
//: my $fin = $start + CACC_CELL_FINAL_LATENCY;
//: print qq(
//: wire calc_dlv_valid_out   = calc_dlv_valid_d${fin};
//: wire calc_stripe_end_out  = calc_stripe_end_d${fin};
//: wire calc_layer_end_out   = calc_layer_end_d${fin};
//: );


// Gather of accumulator result      
//: my $int8_out = CACC_PARSUM_WIDTH;
//: my $final_out = CACC_FINAL_WIDTH;
//: for(my $i=0; $i <CACC_ATOMK; $i ++) {
//: print qq(
//:  wire [${int8_out}-1:0] calc_pout_${i} = ({${int8_out}{calc_pout_vld[${i}]}} & calc_pout_${i}_sum););
//: }
//: for(my $i = 0; $i <CACC_ATOMK; $i ++) {
//: print qq(
//:  wire [${final_out}-1:0] calc_fout_${i} = ({${final_out}{calc_fout_vld[${i}]}} & calc_fout_${i}_sum););
//: }


// to abuffer, 1 pipe
wire [CACC_ABUF_WIDTH-1:0] abuf_wr_data_w;
// spyglass disable_block STARC05-3.3.1.4b
//: my $kk=CACC_ABUF_WIDTH;
//: my $jj=CACC_ABUF_AWIDTH;
//: for(my $i = 0; $i < CACC_ATOMK; $i ++) {
//: print qq (
//: assign abuf_wr_data_w[CACC_PARSUM_WIDTH*($i+1)-1:CACC_PARSUM_WIDTH*$i] = calc_pout_${i}; );
//: }
//: &eperl::flop(" -q  abuf_wr_en  -d \"calc_wr_en_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid ${jj} -q  abuf_wr_addr  -en \"calc_wr_en_out\" -d  \"calc_addr_out[${jj}-1:0]\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-wid ${kk} -q  abuf_wr_data  -en \"calc_wr_en_out\" -d  \"abuf_wr_data_w\" -clk nvdla_core_clk -norst"); 
// spyglass enable_block STARC05-3.3.1.4b


// to dbuffer, 1 pipe.
wire [CACC_DBUF_WIDTH-1:0] dlv_data_w;
// spyglass disable_block STARC05-3.3.1.4b

//: my $kk=CACC_DBUF_WIDTH;
//: for(my $i = 0; $i < CACC_ATOMK; $i ++) {
//: print qq(
//: assign dlv_data_w[CACC_FINAL_WIDTH*($i+1)-1:CACC_FINAL_WIDTH*$i] = calc_fout_${i};);
//: }
//:
//: &eperl::flop("-wid ${kk} -q  dlv_data  -en \"calc_dlv_valid_out\" -d  \"dlv_data_w\" -clk nvdla_core_clk -norst"); 
//: &eperl::flop(" -q  dlv_valid  -d \"calc_dlv_valid_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dlv_mask   -d  \"calc_dlv_valid_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dlv_stripe_end  -en \"calc_dlv_valid_out\" -d  \"calc_stripe_end_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dlv_layer_end  -en \"calc_dlv_valid_out\" -d  \"calc_layer_end_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
// spyglass enable_block STARC05-3.3.1.4b
assign       dlv_pd[0] =     dlv_stripe_end ;
assign       dlv_pd[1] =     dlv_layer_end ;


// overflow count                   
reg dlv_sat_end_d1;
wire [CACC_ATOMK-1:0] dlv_sat_bit = calc_fout_sat;
wire dlv_sat_end = calc_layer_end_out & calc_stripe_end_out;
wire dlv_sat_clr = calc_dlv_valid_out & ~dlv_sat_end & dlv_sat_end_d1;
//: my $kk= CACC_ATOMK;
//: my $jj= CACC_ATOMK_LOG2;
//: &eperl::flop(" -q  dlv_sat_vld_d1  -d \"calc_dlv_valid_out\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop("-nodeclare  -q  dlv_sat_end_d1  -en \"calc_dlv_valid_out\" -d  \"dlv_sat_end\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 1"); 
//: &eperl::flop(" -wid ${kk} -q  dlv_sat_bit_d1  -en \"calc_dlv_valid_out\" -d  \"dlv_sat_bit\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: &eperl::flop(" -q  dlv_sat_clr_d1  -d \"dlv_sat_clr\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
//: print "wire [${jj}-1:0] sat_sum = "; 
//: for(my $i=0; $i<CACC_ATOMK-1 ; $i++){
//:     print "dlv_sat_bit_d1[${i}]+";
//: }
//: my $i=CACC_ATOMK-1;
//: print "dlv_sat_bit_d1[${i}]; \n";
wire [31:0] sat_count_inc;
reg [31:0] sat_count;
wire sat_carry;
wire [31:0] sat_count_w;
wire sat_reg_en;
assign {sat_carry, sat_count_inc[31:0]} = sat_count + sat_sum;
assign sat_count_w = (dlv_sat_clr_d1) ? {24'b0, sat_sum} : sat_carry ? {32{1'b1}} : sat_count_inc;
assign sat_reg_en = dlv_sat_vld_d1 & ((|sat_sum) | dlv_sat_clr_d1);
//: &eperl::flop("-nodeclare -q  sat_count  -en \"sat_reg_en\" -d  \"sat_count_w\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0");
// spyglass enable_block NoWidthInBasedNum-ML
// spyglass enable_block STARC-2.10.1.6

assign dp2reg_sat_count = sat_count;

endmodule
