// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_delivery_buffer.v

#include "NV_NVDLA_CACC.h"
module NV_NVDLA_CACC_delivery_buffer (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,cacc2sdp_ready        //|< i
  ,dbuf_rd_addr          //|< i
  ,dbuf_rd_en            //|< i
  ,dbuf_rd_layer_end     //|< i
  ,dbuf_wr_addr        //|< i
  ,dbuf_wr_data        //|< i
  ,dbuf_wr_en            //|< i
  ,pwrbus_ram_pd         //|< i
  ,cacc2glb_done_intr_pd //|> o
  ,cacc2sdp_pd           //|> o
  ,cacc2sdp_valid        //|> o
  ,dbuf_rd_ready         //|> o
  ,accu2sc_credit_size   //|> o
  ,accu2sc_credit_vld   //|> o
  );
input                           nvdla_core_clk;
input                           nvdla_core_rstn;
input                           cacc2sdp_ready;
input   [CACC_ABUF_AWIDTH-1:0]  dbuf_rd_addr;
input                           dbuf_rd_en;
input                           dbuf_rd_layer_end;
input   [CACC_DBUF_AWIDTH-1:0]  dbuf_wr_addr;
input   [CACC_DBUF_WIDTH-1:0]   dbuf_wr_data;
input                           dbuf_wr_en;
input   [31:0]                  pwrbus_ram_pd;
output  [1:0]                   cacc2glb_done_intr_pd;
output  [CACC_SDP_WIDTH-1:0]    cacc2sdp_pd;
output                          cacc2sdp_valid;
output                          dbuf_rd_ready;
output   [2:0]              accu2sc_credit_size;
output                      accu2sc_credit_vld;

// Instance RAMs                        
wire [CACC_DBUF_WIDTH-1:0] dbuf_rd_data;
reg  [CACC_DWIDTH_DIV_SWIDTH-1:0] data_left_mask;
wire dbuf_rd_en_new = ~(|data_left_mask) & dbuf_rd_en;

// spyglass disable_block NoWidthInBasedNum-ML
//: my $dep= CACC_DBUF_DEPTH;
//: my $wid= CACC_DBUF_WIDTH;
//: print qq(
//: nv_ram_rws_${dep}x${wid} u_accu_dbuf (
//:    .clk           (nvdla_core_clk)            //|< i
//:   ,.ra            (dbuf_rd_addr)      //|< r
//:   ,.re            (dbuf_rd_en_new)          //|< r
//:   ,.dout          (dbuf_rd_data) //|> w
//:   ,.wa            (dbuf_wr_addr)    //|< r
//:   ,.we            (dbuf_wr_en)          //|< r
//:   ,.di            (dbuf_wr_data)  //|< r
//:   ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
//:   );
//: );


//get signal for SDP
//: &eperl::flop("-q  dbuf_rd_valid  -d \"dbuf_rd_en_new\" -clk nvdla_core_clk -rst nvdla_core_rstn ");
//: my $kk=CACC_DWIDTH_DIV_SWIDTH;
//: print qq(
//: reg [${kk}-1:0] rd_data_mask;   //which data to be fetched by sdp.
//: wire [${kk}-1:0] rd_data_mask_pre; );
//: if(${kk}>=2){
//: print "assign rd_data_mask_pre = cacc2sdp_valid & cacc2sdp_ready ? {rd_data_mask[${kk}-2:0],rd_data_mask[${kk}-1]} : rd_data_mask; \n";
//: } else {
//: print "assign rd_data_mask_pre = rd_data_mask; \n";
//:}
//: &eperl::flop("-nodeclare -q rd_data_mask -d rd_data_mask_pre -rval \" 'b1\" "); 
//: print qq(
//: wire [${kk}-1:0] data_left_mask_pre = dbuf_rd_en_new ? {${kk}{1'b1}} : (cacc2sdp_valid & cacc2sdp_ready) ? (data_left_mask<<1'b1) : data_left_mask;
//: );
//: &eperl::flop("-nodeclare -q data_left_mask   -d data_left_mask_pre "); 
wire cacc2sdp_valid       = (|data_left_mask);
wire dbuf_rd_ready        = ~(|data_left_mask);
//: my $t1="";
//: my $kk= CACC_SDP_DATA_WIDTH;
//: print "wire [${kk}-1:0] cacc2sdp_pd_data= ";
//: for (my $i=0; $i<CACC_DWIDTH_DIV_SWIDTH; $i++){
//: $t1 .= "dbuf_rd_data[($i+1)*${kk}-1:$i*${kk}]&{${kk}{rd_data_mask[${i}]}} |";
//: }
//: my $t2= "{${kk}{1'b0}}";
//: print "$t1"."$t2".";\n";

//layer_end handle
reg dbuf_rd_layer_end_latch;
wire dbuf_rd_layer_end_latch_w = dbuf_rd_layer_end? 1'b1 : ~(|data_left_mask) ? 1'b0 : dbuf_rd_layer_end_latch;
//: &eperl::flop("-q dbuf_rd_layer_end_latch -d dbuf_rd_layer_end_latch_w -nodeclare");


////regout to SDP
////: my $kk=CACC_SDP_DATA_WIDTH;
////: &eperl::flop("-q cacc2sdp_valid -d cacc2sdp_valid_w");
////: &eperl::flop("-wid ${kk} -q cacc2sdp_pd_data -d cacc2sdp_pd_data_w");
wire   last_data;
wire   cacc2sdp_batch_end   = 1'b0;
wire   cacc2sdp_layer_end   = dbuf_rd_layer_end_latch&last_data&cacc2sdp_valid&cacc2sdp_ready; //data_left_mask=0;
assign cacc2sdp_pd[CACC_SDP_DATA_WIDTH-1:0] =   cacc2sdp_pd_data;
assign cacc2sdp_pd[CACC_SDP_WIDTH-2]        =   cacc2sdp_batch_end;
assign cacc2sdp_pd[CACC_SDP_WIDTH-1]        =   cacc2sdp_layer_end;


// generate CACC done interrupt  
wire [1:0] cacc_done_intr_w;
reg intr_sel;
wire cacc_done = cacc2sdp_valid & cacc2sdp_ready & cacc2sdp_layer_end;
assign cacc_done_intr_w[0] = cacc_done & ~intr_sel;
assign cacc_done_intr_w[1] = cacc_done & intr_sel;
wire intr_sel_w = cacc_done ? ~intr_sel : intr_sel;
//: &eperl::flop("-nodeclare -q  intr_sel  -d \"intr_sel_w \" -clk nvdla_core_clk -rst nvdla_core_rstn ");
//: &eperl::flop(" -q  cacc_done_intr  -d \"cacc_done_intr_w \" -wid 2  -clk nvdla_core_clk -rst nvdla_core_rstn ");
assign cacc2glb_done_intr_pd = cacc_done_intr;

///// generate credit signal
assign accu2sc_credit_size = 3'h1;
assign last_data = (data_left_mask=={1'b1,{CACC_DWIDTH_DIV_SWIDTH-1{1'b0}}});
//: &eperl::flop(" -q  accu2sc_credit_vld  -d \"cacc2sdp_valid & cacc2sdp_ready & last_data\" -clk nvdla_core_clk -rst nvdla_core_rstn -rval 0"); 
// spyglass enable_block NoWidthInBasedNum-ML

endmodule // NV_NVDLA_CACC_delivery_buffer


