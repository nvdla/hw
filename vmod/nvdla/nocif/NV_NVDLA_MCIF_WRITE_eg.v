// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_eg.v

#include "NV_NVDLA_MCIF_define.h"
`include "NV_NVDLA_MCIF_define.vh"
`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_eg (
   nvdla_core_clk
  ,nvdla_core_rstn
  //:for(my $i=0;$i<WDMA_MAX_NUM;$i++) {
  //:print"  ,cq_rd${i}_pvld \n";
  //:print"  ,cq_rd${i}_pd   \n";
  //:print"  ,cq_rd${i}_prdy \n";
  //:}
  //:my @wdma_name = WDMA_NAME;
  //:foreach my $client (@wdma_name) {
  //:print"  ,mcif2${client}_wr_rsp_complete\n";
  //:}
  ,eg2ig_axi_len
  ,eg2ig_axi_vld
  ,noc2mcif_axi_b_bid
  ,noc2mcif_axi_b_bvalid
  ,noc2mcif_axi_b_bready
);


input  nvdla_core_clk;
input  nvdla_core_rstn;

//:for(my $i=0;$i<WDMA_MAX_NUM;$i++) {
//:print qq(
//:input       cq_rd${i}_pvld;
//:output      cq_rd${i}_prdy;
//:input [2:0] cq_rd${i}_pd;
//:);
//:}

output [1:0] eg2ig_axi_len;
output       eg2ig_axi_vld;

input        noc2mcif_axi_b_bvalid;  
output       noc2mcif_axi_b_bready; 
input  [7:0] noc2mcif_axi_b_bid;

//:my @wdma_name = WDMA_NAME;
//:foreach my $client (@wdma_name) {
//:print"output reg  mcif2${client}_wr_rsp_complete;\n";
//:}


reg    [1:0] eg2ig_axi_len;
wire   [2:0] iflop_axi_axid;
wire         iflop_axi_vld;
wire         iflop_axi_rdy;



NV_NVDLA_MCIF_WRITE_EG_pipe  u_pipe(
   .nvdla_core_clk             (nvdla_core_clk)
  ,.nvdla_core_rstn            (nvdla_core_rstn)
  ,.iflop_axi_axid             (iflop_axi_axid)
  ,.iflop_axi_vld              (iflop_axi_vld)
  ,.iflop_axi_rdy              (iflop_axi_rdy)
  ,.noc2mcif_axi_b_bid         (noc2mcif_axi_b_bid[2:0])
  ,.noc2mcif_axi_b_bvalid      (noc2mcif_axi_b_bvalid)
  ,.noc2mcif_axi_b_bready      (noc2mcif_axi_b_bready)
  );


//:for(my $i=0;$i<WDMA_MAX_NUM;$i++) {
//:print qq(
//:wire        iflop_axi_rdy${i} = cq_rd${i}_pvld & (iflop_axi_axid == $i);  
//:wire        iflop_axi_vld${i} = iflop_axi_vld & (iflop_axi_axid == $i);   
//:wire [1:0]  cq_rd${i}_len = cq_rd${i}_pd[2:1];
//:assign      cq_rd${i}_prdy = iflop_axi_vld${i};
//:);
//:}


assign iflop_axi_rdy = iflop_axi_rdy0 
//:for(my $i=1;$i<WDMA_MAX_NUM;$i++) {
//:print " | iflop_axi_rdy${i} ";
//:}
//:print";\n";


assign eg2ig_axi_vld = iflop_axi_vld & iflop_axi_rdy;

always @(
iflop_axi_vld0 or
cq_rd0_len 
//:for(my $i=1;$i<WDMA_MAX_NUM;$i++) {
//:print qq(
//:or iflop_axi_vld${i}
//:or cq_rd${i}_len);
//:}
) begin
   //spyglass disable_block W171 W226
   case (1'b1)
   //:for(my $i=0;$i<WDMA_MAX_NUM;$i++) {
   //:print" iflop_axi_vld${i}: eg2ig_axi_len = cq_rd${i}_len;\n";
   //:}
      //VCS coverage off
    default : begin 
                eg2ig_axi_len[1:0] = {2{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end



//:my $i;
//:my @wdma_name = WDMA_NAME;
//:foreach my $client (@wdma_name) {
//:print "wire  ${client}_cq_rd_pvld = (`tieoff_axid_${client} == 0 ) ? cq_rd0_pvld ";  
//:for($i=1;$i<WDMA_MAX_NUM;$i++) {
//:if($i==WDMA_MAX_NUM-1){
//:print ": cq_rd${i}_pvld;\n";
//:}
//:else {
//:print ": (`tieoff_axid_${client} == ${i}) ? cq_rd${i}_pvld ";
//:}
//:}
//:print "wire  ${client}_cq_rd_ack = (`tieoff_axid_${client} == 0 ) ? cq_rd0_pd[0] ";  
//:for($i=1;$i<WDMA_MAX_NUM;$i++) {
//:if($i==WDMA_MAX_NUM-1){
//:print ": cq_rd${i}_pd[0];\n";
//:}
//:else {
//:print ": (`tieoff_axid_${client} == ${i}) ? cq_rd${i}_pd[0] ";
//:}
//:}
//:print qq(
//:wire  ${client}_axi_vld = iflop_axi_vld & (iflop_axi_axid == `tieoff_axid_${client});
//:always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//: if (!nvdla_core_rstn) begin
//:    mcif2${client}_wr_rsp_complete <= 1'b0;
//:  end else begin
//:    mcif2${client}_wr_rsp_complete <= ${client}_axi_vld & ${client}_cq_rd_ack & ${client}_cq_rd_pvld;  //dma${i}_vld & cq_rd${i}_pvld & cq_rd${i}_require_ack;
//:  end
//:end
//:);
//:print"\n"; 
//:}



endmodule // NV_NVDLA_CVIF_WRITE_eg





module NV_NVDLA_MCIF_WRITE_EG_pipe (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,iflop_axi_axid
  ,iflop_axi_vld
  ,iflop_axi_rdy
  ,noc2mcif_axi_b_bid
  ,noc2mcif_axi_b_bvalid
  ,noc2mcif_axi_b_bready
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
output [2:0]  iflop_axi_axid;
output        iflop_axi_vld;
input         iflop_axi_rdy;
input  [2:0]  noc2mcif_axi_b_bid;
input         noc2mcif_axi_b_bvalid;
output        noc2mcif_axi_b_bready;

//: &eperl::pipe(" -wid 3 -is -di noc2mcif_axi_b_bid -vi noc2mcif_axi_b_bvalid -ro noc2mcif_axi_b_bready -do iflop_axi_axid -vo iflop_axi_vld -ri iflop_axi_rdy ");


endmodule 
