// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_arb.v
#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_arb (
   nvdla_core_clk                    //|< i
  ,nvdla_core_rstn                   //|< i
  //: for (my $i=0;$i<RDMA_NUM;$i++) {
  //: print("  ,reg2dp_rd_weight${i}\n");
  //: }
  //: for (my $i=0;$i<RDMA_NUM;$i++) {
  //: print("  ,bpt2arb_req${i}_valid\n");
  //: print("  ,bpt2arb_req${i}_ready\n");
  //: print("  ,bpt2arb_req${i}_pd\n");
  //: }
  ,arb2spt_req_pd                    //|> o
  ,arb2spt_req_valid                 //|> o
  ,arb2spt_req_ready                 //|< i
  );

input  nvdla_core_clk;
input  nvdla_core_rstn;

//: for (my $i=0;$i<RDMA_NUM;$i++) {
//: print "input   [7:0] reg2dp_rd_weight${i};\n";
//: }
//: for (my $i=0;$i<RDMA_NUM;$i++) {
//: print qq(
//: input         bpt2arb_req${i}_valid;  
//: output        bpt2arb_req${i}_ready;  
//: input  [NVDLA_DMA_RD_IG_PW-1:0] bpt2arb_req${i}_pd;
//: );
//: }

output        arb2spt_req_valid;  
input         arb2spt_req_ready;  
output [NVDLA_DMA_RD_IG_PW-1:0] arb2spt_req_pd;

//: for (my $i=0;$i<RDMA_NUM;$i++) {
//: print qq(
//: wire   [NVDLA_DMA_RD_IG_PW-1:0] arb_src${i}_pd;
//: wire          arb_src${i}_rdy;
//: wire          arb_src${i}_vld;
//: );
//: }

reg    [NVDLA_DMA_RD_IG_PW-1:0] arb_pd;
wire   [NVDLA_DMA_RD_IG_PW-1:0] arb_out_pd;
wire          arb_out_vld;
wire          arb_out_rdy;
wire    [9:0] arb_gnt;
wire          gnt_busy;
wire          src0_gnt;
wire          src0_req;
wire          src1_gnt;
wire          src1_req;
wire          src2_gnt;
wire          src2_req;
wire          src3_gnt;
wire          src3_req;
wire          src4_gnt;
wire          src4_req;
wire          src5_gnt;
wire          src5_req;
wire          src6_gnt;
wire          src6_req;
wire          src7_gnt;
wire          src7_req;
wire          src8_gnt;
wire          src8_req;
wire          src9_gnt;
wire          src9_req;
wire    [7:0] wt0;
wire    [7:0] wt1;
wire    [7:0] wt2;
wire    [7:0] wt3;
wire    [7:0] wt4;
wire    [7:0] wt5;
wire    [7:0] wt6;
wire    [7:0] wt7;
wire    [7:0] wt8;
wire    [7:0] wt9;
    

//: for (my $i=0;$i<RDMA_NUM;$i++) {
//: print qq(
//: NV_NVDLA_MCIF_READ_IG_ARB_pipe pipe_p${i} (
//:    .nvdla_core_clk    (nvdla_core_clk)        
//:   ,.nvdla_core_rstn   (nvdla_core_rstn)       
//:   ,.bpt2arb_req_pd    (bpt2arb_req${i}_pd) 
//:   ,.bpt2arb_req_valid (bpt2arb_req${i}_valid)    
//:   ,.bpt2arb_req_ready (bpt2arb_req${i}_ready)    
//:   ,.arb_src_pd        (arb_src${i}_pd)     
//:   ,.arb_src_vld       (arb_src${i}_vld)          
//:   ,.arb_src_rdy       (arb_src${i}_rdy)          
//:   );
//: assign src${i}_req   = arb_src${i}_vld;
//: assign arb_src${i}_rdy = src${i}_gnt;
//: );
//: }
//: print "\n";
//: for (my $i=RDMA_NUM;$i<10;$i++) {
//: print "assign src${i}_req = 1'b0;\n";
//: }
//: for (my $i=0;$i<RDMA_NUM;$i++) {
//: print "assign wt${i} = reg2dp_rd_weight${i};\n";
//: }
//: for (my $i=RDMA_NUM;$i<10;$i++) {
//: print "assign wt${i} = 8'h0;\n";
//: }

read_ig_arb u_read_ig_arb (
   .req0               (src0_req)              //|< w
  ,.req1               (src1_req)              //|< w
  ,.req2               (src2_req)              //|< w
  ,.req3               (src3_req)              //|< w
  ,.req4               (src4_req)              //|< w
  ,.req5               (src5_req)              //|< w
  ,.req6               (src6_req)              //|< w
  ,.req7               (src7_req)              //|< w
  ,.req8               (src8_req)              //|< w
  ,.req9               (src9_req)              //|< w
  ,.wt0                (wt0[7:0])              //|< w
  ,.wt1                (wt1[7:0])              //|< w
  ,.wt2                (wt2[7:0])              //|< w
  ,.wt3                (wt3[7:0])              //|< w
  ,.wt4                (wt4[7:0])              //|< w
  ,.wt5                (wt5[7:0])              //|< w
  ,.wt6                (wt6[7:0])              //|< w
  ,.wt7                (wt7[7:0])              //|< w
  ,.wt8                (wt8[7:0])              //|< w
  ,.wt9                (wt9[7:0])              //|< w
  ,.gnt_busy           (gnt_busy)              //|< w
  ,.clk                (nvdla_core_clk)        //|< i
  ,.reset_             (nvdla_core_rstn)       //|< i
  ,.gnt0               (src0_gnt)              //|> w
  ,.gnt1               (src1_gnt)              //|> w
  ,.gnt2               (src2_gnt)              //|> w
  ,.gnt3               (src3_gnt)              //|> w
  ,.gnt4               (src4_gnt)              //|> w
  ,.gnt5               (src5_gnt)              //|> w
  ,.gnt6               (src6_gnt)              //|> w
  ,.gnt7               (src7_gnt)              //|> w
  ,.gnt8               (src8_gnt)              //|> w
  ,.gnt9               (src9_gnt)              //|> w
  );


// MUX OUT
always @(
  src0_gnt
  or arb_src0_pd
//: for (my $i=1;$i<RDMA_NUM;$i++) {
//: print "  or src${i}_gnt \n";
//: print "  or arb_src${i}_pd\n";
//: }
  ) begin
//spyglass disable_block W171 W226
    case (1'b1 )
       src0_gnt: arb_pd = arb_src0_pd;
//: for (my $i=1;$i<RDMA_NUM;$i++) {
//: print"       src${i}_gnt: arb_pd = arb_src${i}_pd;\n";
//: }
    default : begin 
                arb_pd[NVDLA_DMA_RD_IG_PW-1:0] = {NVDLA_DMA_RD_IG_PW{`x_or_0}};
              end  
    endcase
//spyglass enable_block W171 W226
end

assign arb_gnt = {src9_gnt, src8_gnt, src7_gnt, src6_gnt, src5_gnt, src4_gnt, src3_gnt, src2_gnt, src1_gnt, src0_gnt};
assign arb_out_vld = |arb_gnt;
assign gnt_busy = !arb_out_rdy;
assign arb_out_pd = arb_pd;


NV_NVDLA_MCIF_READ_IG_ARB_pipe_out   pipe_out (
   .nvdla_core_clk    (nvdla_core_clk)       
  ,.nvdla_core_rstn   (nvdla_core_rstn)      
  ,.arb_out_pd        (arb_out_pd)              
  ,.arb_out_vld       (arb_out_vld)             
  ,.arb_out_rdy       (arb_out_rdy)             
  ,.arb2spt_req_pd    (arb2spt_req_pd)       
  ,.arb2spt_req_valid (arb2spt_req_valid)    
  ,.arb2spt_req_ready (arb2spt_req_ready)    
  );


endmodule // NV_NVDLA_MCIF_READ_IG_arb



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is arb_src_pd (arb_src_vld,arb_src_rdy) <= bpt2arb_req_pd[NVDLA_DMA_RD_IG_PW-1:0] (bpt2arb_req_valid,bpt2arb_req_ready)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_IG_ARB_pipe (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,bpt2arb_req_pd
  ,bpt2arb_req_valid
  ,bpt2arb_req_ready
  ,arb_src_pd
  ,arb_src_vld
  ,arb_src_rdy
);

input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [NVDLA_DMA_RD_IG_PW-1:0] bpt2arb_req_pd;
input         bpt2arb_req_valid;
output        bpt2arb_req_ready;
output [NVDLA_DMA_RD_IG_PW-1:0] arb_src_pd;
output        arb_src_vld;
input         arb_src_rdy;


//: my $mem = NVDLA_DMA_RD_IG_PW;
//: &eperl::pipe(" -wid $mem -is -do arb_src_pd -vo arb_src_vld -ri arb_src_rdy -di bpt2arb_req_pd -vi bpt2arb_req_valid -ro bpt2arb_req_ready ");


endmodule // NV_NVDLA_MCIF_READ_IG_ARB_pipe


module NV_NVDLA_MCIF_READ_IG_ARB_pipe_out (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,arb_out_pd
  ,arb_out_vld
  ,arb_out_rdy
  ,arb2spt_req_pd
  ,arb2spt_req_valid
  ,arb2spt_req_ready
);

input         nvdla_core_clk;
input         nvdla_core_rstn;
output  [NVDLA_DMA_RD_IG_PW-1:0] arb2spt_req_pd;
output         arb2spt_req_valid;
input          arb2spt_req_ready;
input [NVDLA_DMA_RD_IG_PW-1:0] arb_out_pd;
input          arb_out_vld;
output         arb_out_rdy;


//: my $mem = NVDLA_DMA_RD_IG_PW;
//: &eperl::pipe(" -wid $mem -is -di arb_out_pd -vi arb_out_vld -ro arb_out_rdy -do arb2spt_req_pd -vo arb2spt_req_valid -ri arb2spt_req_ready ");


endmodule // NV_NVDLA_MCIF_READ_IG_ARB_pipe



