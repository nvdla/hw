// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_XXIF_libs.v

`include "simulate_x_tick.vh"
module read_ig_arb (
   req0
  ,req1
  ,req2
  ,req3
  ,req4
  ,req5
  ,req6
  ,req7
  ,req8
  ,req9
  ,wt0
  ,wt1
  ,wt2
  ,wt3
  ,wt4
  ,wt5
  ,wt6
  ,wt7
  ,wt8
  ,wt9
  ,gnt_busy
  ,clk
  ,reset_
  ,gnt0
  ,gnt1
  ,gnt2
  ,gnt3
  ,gnt4
  ,gnt5
  ,gnt6
  ,gnt7
  ,gnt8
  ,gnt9
  );

//Declaring ports

input req0;
input req1;
input req2;
input req3;
input req4;
input req5;
input req6;
input req7;
input req8;
input req9;
input [7:0] wt0;
input [7:0] wt1;
input [7:0] wt2;
input [7:0] wt3;
input [7:0] wt4;
input [7:0] wt5;
input [7:0] wt6;
input [7:0] wt7;
input [7:0] wt8;
input [7:0] wt9;
input gnt_busy;
input clk;
input reset_;
output gnt0;
output gnt1;
output gnt2;
output gnt3;
output gnt4;
output gnt5;
output gnt6;
output gnt7;
output gnt8;
output gnt9;


//Declaring clock and reset



//Declaring registers and wires

reg  [9:0] gnt;
reg  [9:0] gnt_pre;
reg  [9:0] wrr_gnt;
reg  [7:0] wt_left;
reg  [7:0] wt_left_nxt;
wire [7:0] new_wt_left0;
wire [7:0] new_wt_left1;
wire [7:0] new_wt_left2;
wire [7:0] new_wt_left3;
wire [7:0] new_wt_left4;
wire [7:0] new_wt_left5;
wire [7:0] new_wt_left6;
wire [7:0] new_wt_left7;
wire [7:0] new_wt_left8;
wire [7:0] new_wt_left9;
wire [9:0] req;


assign  req = {
  (req9 & (|wt9))
, (req8 & (|wt8)) 
, (req7 & (|wt7)) 
, (req6 & (|wt6)) 
, (req5 & (|wt5)) 
, (req4 & (|wt4)) 
, (req3 & (|wt3)) 
, (req2 & (|wt2)) 
, (req1 & (|wt1)) 
, (req0 & (|wt0)) 
};

assign {
 gnt9
,gnt8
,gnt7
,gnt6
,gnt5
,gnt4
,gnt3
,gnt2
,gnt1
,gnt0
} = gnt;


always @(
  gnt_busy
  or gnt_pre
  ) begin
    gnt = {10{!gnt_busy}} & gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
// verilint 484 off - Possible loss of carry/borrow in addition/subtraction

assign new_wt_left0[7:0] = wt0 - 1'b1;

assign new_wt_left1[7:0] = wt1 - 1'b1;

assign new_wt_left2[7:0] = wt2 - 1'b1;

assign new_wt_left3[7:0] = wt3 - 1'b1;

assign new_wt_left4[7:0] = wt4 - 1'b1;

assign new_wt_left5[7:0] = wt5 - 1'b1;

assign new_wt_left6[7:0] = wt6 - 1'b1;

assign new_wt_left7[7:0] = wt7 - 1'b1;

assign new_wt_left8[7:0] = wt8 - 1'b1;

assign new_wt_left9[7:0] = wt9 - 1'b1;
always @(
  wt_left
  or req
  or wrr_gnt
  or new_wt_left0
  or new_wt_left1
  or new_wt_left2
  or new_wt_left3
  or new_wt_left4
  or new_wt_left5
  or new_wt_left6
  or new_wt_left7
  or new_wt_left8
  or new_wt_left9
  ) begin
    gnt_pre = {10{1'b0}};
    wt_left_nxt = wt_left;
        if (wt_left == 0 | !(|(req & wrr_gnt)) ) begin
            case (wrr_gnt)
                10'b0000000000 : begin 
                    if      (req[0]) begin
                         gnt_pre = 10'b0000000001;
                         wt_left_nxt = new_wt_left0;
                     end 
                    else if (req[1]) begin
                         gnt_pre = 10'b0000000010;
                         wt_left_nxt = new_wt_left1;
                    end 
                    else if (req[2]) begin
                         gnt_pre = 10'b0000000100;
                         wt_left_nxt = new_wt_left2;
                    end 
                    else if (req[3]) begin
                         gnt_pre = 10'b0000001000;
                         wt_left_nxt = new_wt_left3;
                    end 
                    else if (req[4]) begin
                         gnt_pre = 10'b0000010000;
                         wt_left_nxt = new_wt_left4;
                    end 
                    else if (req[5]) begin
                         gnt_pre = 10'b0000100000;
                         wt_left_nxt = new_wt_left5;
                    end 
                    else if (req[6]) begin
                         gnt_pre = 10'b0001000000;
                         wt_left_nxt = new_wt_left6;
                    end 
                    else if (req[7]) begin
                         gnt_pre = 10'b0010000000;
                         wt_left_nxt = new_wt_left7;
                    end 
                    else if (req[8]) begin
                         gnt_pre = 10'b0100000000;
                         wt_left_nxt = new_wt_left8;
                    end 
                    else if (req[9]) begin
                         gnt_pre = 10'b1000000000;
                         wt_left_nxt = new_wt_left9;
                    end 
                end 
                10'b0000000001 : begin 
                    if      (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
               end
                10'b0000000010 : begin 
                    if      (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
               end
                10'b0000000100 : begin 
                    if      (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
               end
                10'b0000001000 : begin 
                    if      (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
               end
                10'b0000010000 : begin 
                    if      (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
               end
                10'b0000100000 : begin 
                    if      (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
               end
                10'b0001000000 : begin 
                    if      (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
               end
                10'b0010000000 : begin 
                    if      (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
               end
                10'b0100000000 : begin 
                    if      (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
               end
                10'b1000000000 : begin 
                    if      (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
               end
                //VCS coverage off
                default : begin 
                            gnt_pre[9:0] = {10{`x_or_0}};
                            wt_left_nxt[7:0] = {8{`x_or_0}};
                          end  
                //VCS coverage on
            endcase
        end else begin
            gnt_pre = wrr_gnt;
            wt_left_nxt = wt_left - 1'b1;
        end
end
// verilint 69 on - Case statement without default clause, but all the cases are covered
// verilint 71 on - Case statement without default clause
// verilint 264 on - Not all possible cases covered
// verilint 484 on - Possible loss of carry/borrow in addition/subtraction
always @(posedge clk or negedge reset_) begin
  if (!reset_) begin
    wrr_gnt <= {10{1'b0}};
    wt_left <= {8{1'b0}};
  end else begin
    if (!gnt_busy & req != {10{1'b0}}) begin
        wrr_gnt <= gnt;
        wt_left <= wt_left_nxt;
    end 
  end
end
//end of always block

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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,10,0,"gnt not zero one hot")      zzz_grant_zero_one_hot_1x (clk, `ASSERT_RESET, (gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt to a non requesting client")      zzz_grant_to_no_req_2x (clk, `ASSERT_RESET, (|(~req & gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"no gnt even if at least 1 client requesting ")      zzz_no_gnt_when_expected_3x (clk, `ASSERT_RESET, (!gnt_busy & |(req) & !(|gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt when gnt_busy ")      zzz_gnt_when_busy_4x (clk, `ASSERT_RESET, (gnt_busy & |gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

`ifdef COVER


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_0_granted
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // TP__Client_0_granted

`ifdef COVER_OR_TP__Client_0_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 0 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_clk   = clk;
wire testpoint_0_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_reset_
    //  Clock signal: testpoint_0_internal_clk
    reg testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk <= 1'b0;

    always @(posedge testpoint_0_internal_clk or negedge testpoint_0_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_reset_)
            testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 0 granted ::: (gnt[0])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 0 granted ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[0])) && testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 0 granted ::: testpoint_0_goal_0");
 `endif
            if (((gnt[0])) && testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = (((gnt[0])) && testpoint_got_reset_testpoint_0_internal_reset__with_clock_testpoint_0_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_0_granted_0 (.clk (testpoint_0_internal_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_0_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_1_granted
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // TP__Client_1_granted

`ifdef COVER_OR_TP__Client_1_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 1 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_clk   = clk;
wire testpoint_1_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_reset_
    //  Clock signal: testpoint_1_internal_clk
    reg testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk <= 1'b0;

    always @(posedge testpoint_1_internal_clk or negedge testpoint_1_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_reset_)
            testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 1 granted ::: (gnt[1])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 1 granted ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[1])) && testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 1 granted ::: testpoint_1_goal_0");
 `endif
            if (((gnt[1])) && testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = (((gnt[1])) && testpoint_got_reset_testpoint_1_internal_reset__with_clock_testpoint_1_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_1_granted_0 (.clk (testpoint_1_internal_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_1_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_2_granted
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // TP__Client_2_granted

`ifdef COVER_OR_TP__Client_2_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 2 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_clk   = clk;
wire testpoint_2_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_reset_
    //  Clock signal: testpoint_2_internal_clk
    reg testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk <= 1'b0;

    always @(posedge testpoint_2_internal_clk or negedge testpoint_2_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_reset_)
            testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 2 granted ::: (gnt[2])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 2 granted ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[2])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 2 granted ::: testpoint_2_goal_0");
 `endif
            if (((gnt[2])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = (((gnt[2])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_2_granted_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_2_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_3_granted
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // TP__Client_3_granted

`ifdef COVER_OR_TP__Client_3_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 3 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_clk   = clk;
wire testpoint_3_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_reset_
    //  Clock signal: testpoint_3_internal_clk
    reg testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk <= 1'b0;

    always @(posedge testpoint_3_internal_clk or negedge testpoint_3_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_reset_)
            testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 3 granted ::: (gnt[3])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 3 granted ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[3])) && testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 3 granted ::: testpoint_3_goal_0");
 `endif
            if (((gnt[3])) && testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = (((gnt[3])) && testpoint_got_reset_testpoint_3_internal_reset__with_clock_testpoint_3_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_3_granted_0 (.clk (testpoint_3_internal_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_3_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_4_granted
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // TP__Client_4_granted

`ifdef COVER_OR_TP__Client_4_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 4 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_4_internal_clk   = clk;
wire testpoint_4_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_4_internal_reset_
    //  Clock signal: testpoint_4_internal_clk
    reg testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk;

    initial
        testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk <= 1'b0;

    always @(posedge testpoint_4_internal_clk or negedge testpoint_4_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_4
        if (~testpoint_4_internal_reset_)
            testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_4_count_0;

    reg testpoint_4_goal_0;
    initial testpoint_4_goal_0 = 0;
    initial testpoint_4_count_0 = 0;
    always@(testpoint_4_count_0) begin
        if(testpoint_4_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_4_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 4 granted ::: (gnt[4])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 4 granted ::: testpoint_4_goal_0
            testpoint_4_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_4_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_4_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
        if (testpoint_4_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[4])) && testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 4 granted ::: testpoint_4_goal_0");
 `endif
            if (((gnt[4])) && testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk)
                testpoint_4_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk) begin
 `endif
                testpoint_4_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_4_goal_0_active = (((gnt[4])) && testpoint_got_reset_testpoint_4_internal_reset__with_clock_testpoint_4_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_4_granted_0 (.clk (testpoint_4_internal_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_4_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_5_granted
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // TP__Client_5_granted

`ifdef COVER_OR_TP__Client_5_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 5 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_5_internal_clk   = clk;
wire testpoint_5_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_5_internal_reset_
    //  Clock signal: testpoint_5_internal_clk
    reg testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk;

    initial
        testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk <= 1'b0;

    always @(posedge testpoint_5_internal_clk or negedge testpoint_5_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_5
        if (~testpoint_5_internal_reset_)
            testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_5_count_0;

    reg testpoint_5_goal_0;
    initial testpoint_5_goal_0 = 0;
    initial testpoint_5_count_0 = 0;
    always@(testpoint_5_count_0) begin
        if(testpoint_5_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_5_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 5 granted ::: (gnt[5])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 5 granted ::: testpoint_5_goal_0
            testpoint_5_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_5_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_5_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
        if (testpoint_5_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[5])) && testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 5 granted ::: testpoint_5_goal_0");
 `endif
            if (((gnt[5])) && testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk)
                testpoint_5_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk) begin
 `endif
                testpoint_5_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_5_goal_0_active = (((gnt[5])) && testpoint_got_reset_testpoint_5_internal_reset__with_clock_testpoint_5_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_5_granted_0 (.clk (testpoint_5_internal_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_5_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_6_granted
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // TP__Client_6_granted

`ifdef COVER_OR_TP__Client_6_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 6 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_6_internal_clk   = clk;
wire testpoint_6_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_6_internal_reset_
    //  Clock signal: testpoint_6_internal_clk
    reg testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk;

    initial
        testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk <= 1'b0;

    always @(posedge testpoint_6_internal_clk or negedge testpoint_6_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_6
        if (~testpoint_6_internal_reset_)
            testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_6_count_0;

    reg testpoint_6_goal_0;
    initial testpoint_6_goal_0 = 0;
    initial testpoint_6_count_0 = 0;
    always@(testpoint_6_count_0) begin
        if(testpoint_6_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_6_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 6 granted ::: (gnt[6])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 6 granted ::: testpoint_6_goal_0
            testpoint_6_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_6_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_6_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_6
        if (testpoint_6_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[6])) && testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 6 granted ::: testpoint_6_goal_0");
 `endif
            if (((gnt[6])) && testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk)
                testpoint_6_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk) begin
 `endif
                testpoint_6_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_6_goal_0_active = (((gnt[6])) && testpoint_got_reset_testpoint_6_internal_reset__with_clock_testpoint_6_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_6_goal_0 (.clk (testpoint_6_internal_clk), .tp(testpoint_6_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_6_granted_0 (.clk (testpoint_6_internal_clk), .tp(testpoint_6_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_6_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_7_granted
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // TP__Client_7_granted

`ifdef COVER_OR_TP__Client_7_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 7 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_7_internal_clk   = clk;
wire testpoint_7_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_7_internal_reset_
    //  Clock signal: testpoint_7_internal_clk
    reg testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk;

    initial
        testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk <= 1'b0;

    always @(posedge testpoint_7_internal_clk or negedge testpoint_7_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_7
        if (~testpoint_7_internal_reset_)
            testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_7_count_0;

    reg testpoint_7_goal_0;
    initial testpoint_7_goal_0 = 0;
    initial testpoint_7_count_0 = 0;
    always@(testpoint_7_count_0) begin
        if(testpoint_7_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_7_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 7 granted ::: (gnt[7])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 7 granted ::: testpoint_7_goal_0
            testpoint_7_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_7_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_7_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_7
        if (testpoint_7_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[7])) && testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 7 granted ::: testpoint_7_goal_0");
 `endif
            if (((gnt[7])) && testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk)
                testpoint_7_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk) begin
 `endif
                testpoint_7_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_7_goal_0_active = (((gnt[7])) && testpoint_got_reset_testpoint_7_internal_reset__with_clock_testpoint_7_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_7_goal_0 (.clk (testpoint_7_internal_clk), .tp(testpoint_7_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_7_granted_0 (.clk (testpoint_7_internal_clk), .tp(testpoint_7_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_7_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_8_granted
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // TP__Client_8_granted

`ifdef COVER_OR_TP__Client_8_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 8 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_8_internal_clk   = clk;
wire testpoint_8_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_8_internal_reset_
    //  Clock signal: testpoint_8_internal_clk
    reg testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk;

    initial
        testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk <= 1'b0;

    always @(posedge testpoint_8_internal_clk or negedge testpoint_8_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_8
        if (~testpoint_8_internal_reset_)
            testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_8_count_0;

    reg testpoint_8_goal_0;
    initial testpoint_8_goal_0 = 0;
    initial testpoint_8_count_0 = 0;
    always@(testpoint_8_count_0) begin
        if(testpoint_8_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_8_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 8 granted ::: (gnt[8])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 8 granted ::: testpoint_8_goal_0
            testpoint_8_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_8_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_8_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_8
        if (testpoint_8_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[8])) && testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 8 granted ::: testpoint_8_goal_0");
 `endif
            if (((gnt[8])) && testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk)
                testpoint_8_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk) begin
 `endif
                testpoint_8_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_8_goal_0_active = (((gnt[8])) && testpoint_got_reset_testpoint_8_internal_reset__with_clock_testpoint_8_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_8_goal_0 (.clk (testpoint_8_internal_clk), .tp(testpoint_8_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_8_granted_0 (.clk (testpoint_8_internal_clk), .tp(testpoint_8_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_8_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_9_granted
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // TP__Client_9_granted

`ifdef COVER_OR_TP__Client_9_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 9 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_9_internal_clk   = clk;
wire testpoint_9_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_9_internal_reset_
    //  Clock signal: testpoint_9_internal_clk
    reg testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk;

    initial
        testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk <= 1'b0;

    always @(posedge testpoint_9_internal_clk or negedge testpoint_9_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_9
        if (~testpoint_9_internal_reset_)
            testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_9_count_0;

    reg testpoint_9_goal_0;
    initial testpoint_9_goal_0 = 0;
    initial testpoint_9_count_0 = 0;
    always@(testpoint_9_count_0) begin
        if(testpoint_9_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_9_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: Client 9 granted ::: (gnt[9])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: Client 9 granted ::: testpoint_9_goal_0
            testpoint_9_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_9_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_9_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_9
        if (testpoint_9_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[9])) && testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: Client 9 granted ::: testpoint_9_goal_0");
 `endif
            if (((gnt[9])) && testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk)
                testpoint_9_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk) begin
 `endif
                testpoint_9_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_9_goal_0_active = (((gnt[9])) && testpoint_got_reset_testpoint_9_internal_reset__with_clock_testpoint_9_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_9_goal_0 (.clk (testpoint_9_internal_clk), .tp(testpoint_9_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_9_granted_0 (.clk (testpoint_9_internal_clk), .tp(testpoint_9_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_9_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef TP__All_clients_requesting_at_the_same_time
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // TP__All_clients_requesting_at_the_same_time

`ifdef COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="All clients requesting at the same time"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_10_internal_clk   = clk;
wire testpoint_10_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_10_internal_reset_
    //  Clock signal: testpoint_10_internal_clk
    reg testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk;

    initial
        testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk <= 1'b0;

    always @(posedge testpoint_10_internal_clk or negedge testpoint_10_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_10
        if (~testpoint_10_internal_reset_)
            testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_10_count_0;

    reg testpoint_10_goal_0;
    initial testpoint_10_goal_0 = 0;
    initial testpoint_10_count_0 = 0;
    always@(testpoint_10_count_0) begin
        if(testpoint_10_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_10_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_ig_arb ::: All clients requesting at the same time ::: ( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])");
 `endif
            //VCS coverage on
            //coverage name read_ig_arb ::: All clients requesting at the same time ::: testpoint_10_goal_0
            testpoint_10_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_10_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_10_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_10
        if (testpoint_10_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk)
                $display("NVIDIA TESTPOINT: read_ig_arb ::: All clients requesting at the same time ::: testpoint_10_goal_0");
 `endif
            if ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk)
                testpoint_10_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk) begin
 `endif
                testpoint_10_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_10_goal_0_active = ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_10_internal_reset__with_clock_testpoint_10_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_10_goal_0 (.clk (testpoint_10_internal_clk), .tp(testpoint_10_goal_0_active));
 `else
    system_verilog_testpoint svt_All_clients_requesting_at_the_same_time_0 (.clk (testpoint_10_internal_clk), .tp(testpoint_10_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`endif


endmodule // read_ig_arb


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// arbgen2 -m read_eg_arb -n 10 -stdout -t wrr -wt_width 8
// TYPE: wrr 
`include "simulate_x_tick.vh"

module read_eg_arb (
   req0
  ,req1
  ,req2
  ,req3
  ,req4
  ,req5
  ,req6
  ,req7
  ,req8
  ,req9
  ,wt0
  ,wt1
  ,wt2
  ,wt3
  ,wt4
  ,wt5
  ,wt6
  ,wt7
  ,wt8
  ,wt9
  ,clk
  ,reset_
  ,gnt0
  ,gnt1
  ,gnt2
  ,gnt3
  ,gnt4
  ,gnt5
  ,gnt6
  ,gnt7
  ,gnt8
  ,gnt9
  );

//Declaring ports

input req0;
input req1;
input req2;
input req3;
input req4;
input req5;
input req6;
input req7;
input req8;
input req9;
input [7:0] wt0;
input [7:0] wt1;
input [7:0] wt2;
input [7:0] wt3;
input [7:0] wt4;
input [7:0] wt5;
input [7:0] wt6;
input [7:0] wt7;
input [7:0] wt8;
input [7:0] wt9;
input clk;
input reset_;
output gnt0;
output gnt1;
output gnt2;
output gnt3;
output gnt4;
output gnt5;
output gnt6;
output gnt7;
output gnt8;
output gnt9;


//Declaring clock and reset



//Declaring registers and wires

reg  [9:0] gnt;
reg  [9:0] gnt_pre;
reg  [9:0] wrr_gnt;
reg  [7:0] wt_left;
reg  [7:0] wt_left_nxt;
wire [7:0] new_wt_left0;
wire [7:0] new_wt_left1;
wire [7:0] new_wt_left2;
wire [7:0] new_wt_left3;
wire [7:0] new_wt_left4;
wire [7:0] new_wt_left5;
wire [7:0] new_wt_left6;
wire [7:0] new_wt_left7;
wire [7:0] new_wt_left8;
wire [7:0] new_wt_left9;
wire [9:0] req;


assign  req = {
  (req9 & (|wt9))
, (req8 & (|wt8)) 
, (req7 & (|wt7)) 
, (req6 & (|wt6)) 
, (req5 & (|wt5)) 
, (req4 & (|wt4)) 
, (req3 & (|wt3)) 
, (req2 & (|wt2)) 
, (req1 & (|wt1)) 
, (req0 & (|wt0)) 
};

assign {
 gnt9
,gnt8
,gnt7
,gnt6
,gnt5
,gnt4
,gnt3
,gnt2
,gnt1
,gnt0
} = gnt;


always @(
  gnt_pre
  ) begin
    gnt = gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
// verilint 484 off - Possible loss of carry/borrow in addition/subtraction

assign new_wt_left0[7:0] = wt0 - 1'b1;

assign new_wt_left1[7:0] = wt1 - 1'b1;

assign new_wt_left2[7:0] = wt2 - 1'b1;

assign new_wt_left3[7:0] = wt3 - 1'b1;

assign new_wt_left4[7:0] = wt4 - 1'b1;

assign new_wt_left5[7:0] = wt5 - 1'b1;

assign new_wt_left6[7:0] = wt6 - 1'b1;

assign new_wt_left7[7:0] = wt7 - 1'b1;

assign new_wt_left8[7:0] = wt8 - 1'b1;

assign new_wt_left9[7:0] = wt9 - 1'b1;
always @(
  wt_left
  or req
  or wrr_gnt
  or new_wt_left0
  or new_wt_left1
  or new_wt_left2
  or new_wt_left3
  or new_wt_left4
  or new_wt_left5
  or new_wt_left6
  or new_wt_left7
  or new_wt_left8
  or new_wt_left9
  ) begin
    gnt_pre = {10{1'b0}};
    wt_left_nxt = wt_left;
        if (wt_left == 0 | !(|(req & wrr_gnt)) ) begin
            case (wrr_gnt)
                10'b0000000000 : begin 
                    if      (req[0]) begin
                         gnt_pre = 10'b0000000001;
                         wt_left_nxt = new_wt_left0;
                     end 
                    else if (req[1]) begin
                         gnt_pre = 10'b0000000010;
                         wt_left_nxt = new_wt_left1;
                    end 
                    else if (req[2]) begin
                         gnt_pre = 10'b0000000100;
                         wt_left_nxt = new_wt_left2;
                    end 
                    else if (req[3]) begin
                         gnt_pre = 10'b0000001000;
                         wt_left_nxt = new_wt_left3;
                    end 
                    else if (req[4]) begin
                         gnt_pre = 10'b0000010000;
                         wt_left_nxt = new_wt_left4;
                    end 
                    else if (req[5]) begin
                         gnt_pre = 10'b0000100000;
                         wt_left_nxt = new_wt_left5;
                    end 
                    else if (req[6]) begin
                         gnt_pre = 10'b0001000000;
                         wt_left_nxt = new_wt_left6;
                    end 
                    else if (req[7]) begin
                         gnt_pre = 10'b0010000000;
                         wt_left_nxt = new_wt_left7;
                    end 
                    else if (req[8]) begin
                         gnt_pre = 10'b0100000000;
                         wt_left_nxt = new_wt_left8;
                    end 
                    else if (req[9]) begin
                         gnt_pre = 10'b1000000000;
                         wt_left_nxt = new_wt_left9;
                    end 
                end 
                10'b0000000001 : begin 
                    if      (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
               end
                10'b0000000010 : begin 
                    if      (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
               end
                10'b0000000100 : begin 
                    if      (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
               end
                10'b0000001000 : begin 
                    if      (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
               end
                10'b0000010000 : begin 
                    if      (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
               end
                10'b0000100000 : begin 
                    if      (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
               end
                10'b0001000000 : begin 
                    if      (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
               end
                10'b0010000000 : begin 
                    if      (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
               end
                10'b0100000000 : begin 
                    if      (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
                    else if (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
               end
                10'b1000000000 : begin 
                    if      (req[0]) begin
                        gnt_pre = 10'b0000000001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 10'b0000000010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 10'b0000000100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 10'b0000001000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 10'b0000010000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[5]) begin
                        gnt_pre = 10'b0000100000;
                        wt_left_nxt = new_wt_left5;
                    end
                    else if (req[6]) begin
                        gnt_pre = 10'b0001000000;
                        wt_left_nxt = new_wt_left6;
                    end
                    else if (req[7]) begin
                        gnt_pre = 10'b0010000000;
                        wt_left_nxt = new_wt_left7;
                    end
                    else if (req[8]) begin
                        gnt_pre = 10'b0100000000;
                        wt_left_nxt = new_wt_left8;
                    end
                    else if (req[9]) begin
                        gnt_pre = 10'b1000000000;
                        wt_left_nxt = new_wt_left9;
                    end
               end
                //VCS coverage off
                default : begin 
                            gnt_pre[9:0] = {10{`x_or_0}};
                            wt_left_nxt[7:0] = {8{`x_or_0}};
                          end  
                //VCS coverage on
            endcase
        end else begin
            gnt_pre = wrr_gnt;
            wt_left_nxt = wt_left - 1'b1;
        end
end
// verilint 69 on - Case statement without default clause, but all the cases are covered
// verilint 71 on - Case statement without default clause
// verilint 264 on - Not all possible cases covered
// verilint 484 on - Possible loss of carry/borrow in addition/subtraction
always @(posedge clk or negedge reset_) begin
  if (!reset_) begin
    wrr_gnt <= {10{1'b0}};
    wt_left <= {8{1'b0}};
  end else begin
    if (req != {10{1'b0}}) begin
        wrr_gnt <= gnt;
        wt_left <= wt_left_nxt;
    end 
  end
end
//end of always block

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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,10,0,"gnt not zero one hot")      zzz_grant_zero_one_hot_5x (clk, `ASSERT_RESET, (gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt to a non requesting client")      zzz_grant_to_no_req_6x (clk, `ASSERT_RESET, (|(~req & gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"no gnt even if at least 1 client requesting ")      zzz_no_gnt_when_expected_7x (clk, `ASSERT_RESET, (|(req) & !(|gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

`ifdef COVER


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_0_granted
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // TP__Client_0_granted

`ifdef COVER_OR_TP__Client_0_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 0 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_11_internal_clk   = clk;
wire testpoint_11_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_11_internal_reset_
    //  Clock signal: testpoint_11_internal_clk
    reg testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk;

    initial
        testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk <= 1'b0;

    always @(posedge testpoint_11_internal_clk or negedge testpoint_11_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_11
        if (~testpoint_11_internal_reset_)
            testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_11_count_0;

    reg testpoint_11_goal_0;
    initial testpoint_11_goal_0 = 0;
    initial testpoint_11_count_0 = 0;
    always@(testpoint_11_count_0) begin
        if(testpoint_11_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_11_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 0 granted ::: (gnt[0])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 0 granted ::: testpoint_11_goal_0
            testpoint_11_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_11_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_11_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_11
        if (testpoint_11_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[0])) && testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 0 granted ::: testpoint_11_goal_0");
 `endif
            if (((gnt[0])) && testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk)
                testpoint_11_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk) begin
 `endif
                testpoint_11_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_11_goal_0_active = (((gnt[0])) && testpoint_got_reset_testpoint_11_internal_reset__with_clock_testpoint_11_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_11_goal_0 (.clk (testpoint_11_internal_clk), .tp(testpoint_11_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_0_granted_0 (.clk (testpoint_11_internal_clk), .tp(testpoint_11_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_0_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_1_granted
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // TP__Client_1_granted

`ifdef COVER_OR_TP__Client_1_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 1 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_12_internal_clk   = clk;
wire testpoint_12_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_12_internal_reset_
    //  Clock signal: testpoint_12_internal_clk
    reg testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk;

    initial
        testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk <= 1'b0;

    always @(posedge testpoint_12_internal_clk or negedge testpoint_12_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_12
        if (~testpoint_12_internal_reset_)
            testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_12_count_0;

    reg testpoint_12_goal_0;
    initial testpoint_12_goal_0 = 0;
    initial testpoint_12_count_0 = 0;
    always@(testpoint_12_count_0) begin
        if(testpoint_12_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_12_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 1 granted ::: (gnt[1])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 1 granted ::: testpoint_12_goal_0
            testpoint_12_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_12_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_12_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_12
        if (testpoint_12_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[1])) && testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 1 granted ::: testpoint_12_goal_0");
 `endif
            if (((gnt[1])) && testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk)
                testpoint_12_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk) begin
 `endif
                testpoint_12_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_12_goal_0_active = (((gnt[1])) && testpoint_got_reset_testpoint_12_internal_reset__with_clock_testpoint_12_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_12_goal_0 (.clk (testpoint_12_internal_clk), .tp(testpoint_12_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_1_granted_0 (.clk (testpoint_12_internal_clk), .tp(testpoint_12_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_1_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_2_granted
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // TP__Client_2_granted

`ifdef COVER_OR_TP__Client_2_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 2 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_13_internal_clk   = clk;
wire testpoint_13_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_13_internal_reset_
    //  Clock signal: testpoint_13_internal_clk
    reg testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk;

    initial
        testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk <= 1'b0;

    always @(posedge testpoint_13_internal_clk or negedge testpoint_13_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_13
        if (~testpoint_13_internal_reset_)
            testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_13_count_0;

    reg testpoint_13_goal_0;
    initial testpoint_13_goal_0 = 0;
    initial testpoint_13_count_0 = 0;
    always@(testpoint_13_count_0) begin
        if(testpoint_13_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_13_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 2 granted ::: (gnt[2])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 2 granted ::: testpoint_13_goal_0
            testpoint_13_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_13_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_13_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_13
        if (testpoint_13_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[2])) && testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 2 granted ::: testpoint_13_goal_0");
 `endif
            if (((gnt[2])) && testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk)
                testpoint_13_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk) begin
 `endif
                testpoint_13_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_13_goal_0_active = (((gnt[2])) && testpoint_got_reset_testpoint_13_internal_reset__with_clock_testpoint_13_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_13_goal_0 (.clk (testpoint_13_internal_clk), .tp(testpoint_13_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_2_granted_0 (.clk (testpoint_13_internal_clk), .tp(testpoint_13_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_2_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_3_granted
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // TP__Client_3_granted

`ifdef COVER_OR_TP__Client_3_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 3 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_14_internal_clk   = clk;
wire testpoint_14_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_14_internal_reset_
    //  Clock signal: testpoint_14_internal_clk
    reg testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk;

    initial
        testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk <= 1'b0;

    always @(posedge testpoint_14_internal_clk or negedge testpoint_14_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_14
        if (~testpoint_14_internal_reset_)
            testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_14_count_0;

    reg testpoint_14_goal_0;
    initial testpoint_14_goal_0 = 0;
    initial testpoint_14_count_0 = 0;
    always@(testpoint_14_count_0) begin
        if(testpoint_14_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_14_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 3 granted ::: (gnt[3])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 3 granted ::: testpoint_14_goal_0
            testpoint_14_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_14_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_14_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_14
        if (testpoint_14_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[3])) && testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 3 granted ::: testpoint_14_goal_0");
 `endif
            if (((gnt[3])) && testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk)
                testpoint_14_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk) begin
 `endif
                testpoint_14_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_14_goal_0_active = (((gnt[3])) && testpoint_got_reset_testpoint_14_internal_reset__with_clock_testpoint_14_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_14_goal_0 (.clk (testpoint_14_internal_clk), .tp(testpoint_14_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_3_granted_0 (.clk (testpoint_14_internal_clk), .tp(testpoint_14_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_3_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_4_granted
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // TP__Client_4_granted

`ifdef COVER_OR_TP__Client_4_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 4 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_15_internal_clk   = clk;
wire testpoint_15_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_15_internal_reset_
    //  Clock signal: testpoint_15_internal_clk
    reg testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk;

    initial
        testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk <= 1'b0;

    always @(posedge testpoint_15_internal_clk or negedge testpoint_15_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_15
        if (~testpoint_15_internal_reset_)
            testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_15_count_0;

    reg testpoint_15_goal_0;
    initial testpoint_15_goal_0 = 0;
    initial testpoint_15_count_0 = 0;
    always@(testpoint_15_count_0) begin
        if(testpoint_15_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_15_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 4 granted ::: (gnt[4])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 4 granted ::: testpoint_15_goal_0
            testpoint_15_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_15_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_15_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_15
        if (testpoint_15_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[4])) && testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 4 granted ::: testpoint_15_goal_0");
 `endif
            if (((gnt[4])) && testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk)
                testpoint_15_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk) begin
 `endif
                testpoint_15_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_15_goal_0_active = (((gnt[4])) && testpoint_got_reset_testpoint_15_internal_reset__with_clock_testpoint_15_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_15_goal_0 (.clk (testpoint_15_internal_clk), .tp(testpoint_15_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_4_granted_0 (.clk (testpoint_15_internal_clk), .tp(testpoint_15_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_4_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_5_granted
    `define COVER_OR_TP__Client_5_granted_OR_COVER
  `endif // TP__Client_5_granted

`ifdef COVER_OR_TP__Client_5_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 5 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_16_internal_clk   = clk;
wire testpoint_16_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_16_internal_reset_
    //  Clock signal: testpoint_16_internal_clk
    reg testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk;

    initial
        testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk <= 1'b0;

    always @(posedge testpoint_16_internal_clk or negedge testpoint_16_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_16
        if (~testpoint_16_internal_reset_)
            testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_16_count_0;

    reg testpoint_16_goal_0;
    initial testpoint_16_goal_0 = 0;
    initial testpoint_16_count_0 = 0;
    always@(testpoint_16_count_0) begin
        if(testpoint_16_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_16_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 5 granted ::: (gnt[5])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 5 granted ::: testpoint_16_goal_0
            testpoint_16_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_16_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_16_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_16
        if (testpoint_16_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[5])) && testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 5 granted ::: testpoint_16_goal_0");
 `endif
            if (((gnt[5])) && testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk)
                testpoint_16_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk) begin
 `endif
                testpoint_16_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_16_goal_0_active = (((gnt[5])) && testpoint_got_reset_testpoint_16_internal_reset__with_clock_testpoint_16_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_16_goal_0 (.clk (testpoint_16_internal_clk), .tp(testpoint_16_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_5_granted_0 (.clk (testpoint_16_internal_clk), .tp(testpoint_16_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_5_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_6_granted
    `define COVER_OR_TP__Client_6_granted_OR_COVER
  `endif // TP__Client_6_granted

`ifdef COVER_OR_TP__Client_6_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 6 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_17_internal_clk   = clk;
wire testpoint_17_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_17_internal_reset_
    //  Clock signal: testpoint_17_internal_clk
    reg testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk;

    initial
        testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk <= 1'b0;

    always @(posedge testpoint_17_internal_clk or negedge testpoint_17_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_17
        if (~testpoint_17_internal_reset_)
            testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_17_count_0;

    reg testpoint_17_goal_0;
    initial testpoint_17_goal_0 = 0;
    initial testpoint_17_count_0 = 0;
    always@(testpoint_17_count_0) begin
        if(testpoint_17_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_17_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 6 granted ::: (gnt[6])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 6 granted ::: testpoint_17_goal_0
            testpoint_17_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_17_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_17_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_17
        if (testpoint_17_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[6])) && testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 6 granted ::: testpoint_17_goal_0");
 `endif
            if (((gnt[6])) && testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk)
                testpoint_17_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk) begin
 `endif
                testpoint_17_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_17_goal_0_active = (((gnt[6])) && testpoint_got_reset_testpoint_17_internal_reset__with_clock_testpoint_17_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_17_goal_0 (.clk (testpoint_17_internal_clk), .tp(testpoint_17_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_6_granted_0 (.clk (testpoint_17_internal_clk), .tp(testpoint_17_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_6_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_7_granted
    `define COVER_OR_TP__Client_7_granted_OR_COVER
  `endif // TP__Client_7_granted

`ifdef COVER_OR_TP__Client_7_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 7 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_18_internal_clk   = clk;
wire testpoint_18_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_18_internal_reset_
    //  Clock signal: testpoint_18_internal_clk
    reg testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk;

    initial
        testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk <= 1'b0;

    always @(posedge testpoint_18_internal_clk or negedge testpoint_18_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_18
        if (~testpoint_18_internal_reset_)
            testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_18_count_0;

    reg testpoint_18_goal_0;
    initial testpoint_18_goal_0 = 0;
    initial testpoint_18_count_0 = 0;
    always@(testpoint_18_count_0) begin
        if(testpoint_18_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_18_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 7 granted ::: (gnt[7])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 7 granted ::: testpoint_18_goal_0
            testpoint_18_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_18_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_18_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_18
        if (testpoint_18_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[7])) && testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 7 granted ::: testpoint_18_goal_0");
 `endif
            if (((gnt[7])) && testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk)
                testpoint_18_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk) begin
 `endif
                testpoint_18_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_18_goal_0_active = (((gnt[7])) && testpoint_got_reset_testpoint_18_internal_reset__with_clock_testpoint_18_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_18_goal_0 (.clk (testpoint_18_internal_clk), .tp(testpoint_18_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_7_granted_0 (.clk (testpoint_18_internal_clk), .tp(testpoint_18_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_7_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_8_granted
    `define COVER_OR_TP__Client_8_granted_OR_COVER
  `endif // TP__Client_8_granted

`ifdef COVER_OR_TP__Client_8_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 8 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_19_internal_clk   = clk;
wire testpoint_19_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_19_internal_reset_
    //  Clock signal: testpoint_19_internal_clk
    reg testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk;

    initial
        testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk <= 1'b0;

    always @(posedge testpoint_19_internal_clk or negedge testpoint_19_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_19
        if (~testpoint_19_internal_reset_)
            testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_19_count_0;

    reg testpoint_19_goal_0;
    initial testpoint_19_goal_0 = 0;
    initial testpoint_19_count_0 = 0;
    always@(testpoint_19_count_0) begin
        if(testpoint_19_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_19_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 8 granted ::: (gnt[8])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 8 granted ::: testpoint_19_goal_0
            testpoint_19_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_19_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_19_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_19
        if (testpoint_19_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[8])) && testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 8 granted ::: testpoint_19_goal_0");
 `endif
            if (((gnt[8])) && testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk)
                testpoint_19_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk) begin
 `endif
                testpoint_19_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_19_goal_0_active = (((gnt[8])) && testpoint_got_reset_testpoint_19_internal_reset__with_clock_testpoint_19_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_19_goal_0 (.clk (testpoint_19_internal_clk), .tp(testpoint_19_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_8_granted_0 (.clk (testpoint_19_internal_clk), .tp(testpoint_19_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_8_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_9_granted
    `define COVER_OR_TP__Client_9_granted_OR_COVER
  `endif // TP__Client_9_granted

`ifdef COVER_OR_TP__Client_9_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 9 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_20_internal_clk   = clk;
wire testpoint_20_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_20_internal_reset_
    //  Clock signal: testpoint_20_internal_clk
    reg testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk;

    initial
        testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk <= 1'b0;

    always @(posedge testpoint_20_internal_clk or negedge testpoint_20_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_20
        if (~testpoint_20_internal_reset_)
            testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_20_count_0;

    reg testpoint_20_goal_0;
    initial testpoint_20_goal_0 = 0;
    initial testpoint_20_count_0 = 0;
    always@(testpoint_20_count_0) begin
        if(testpoint_20_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_20_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: Client 9 granted ::: (gnt[9])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: Client 9 granted ::: testpoint_20_goal_0
            testpoint_20_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_20_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_20_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_20
        if (testpoint_20_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[9])) && testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: Client 9 granted ::: testpoint_20_goal_0");
 `endif
            if (((gnt[9])) && testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk)
                testpoint_20_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk) begin
 `endif
                testpoint_20_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_20_goal_0_active = (((gnt[9])) && testpoint_got_reset_testpoint_20_internal_reset__with_clock_testpoint_20_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_20_goal_0 (.clk (testpoint_20_internal_clk), .tp(testpoint_20_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_9_granted_0 (.clk (testpoint_20_internal_clk), .tp(testpoint_20_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_9_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef TP__All_clients_requesting_at_the_same_time
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // TP__All_clients_requesting_at_the_same_time

`ifdef COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="All clients requesting at the same time"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_21_internal_clk   = clk;
wire testpoint_21_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_21_internal_reset_
    //  Clock signal: testpoint_21_internal_clk
    reg testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk;

    initial
        testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk <= 1'b0;

    always @(posedge testpoint_21_internal_clk or negedge testpoint_21_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_21
        if (~testpoint_21_internal_reset_)
            testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_21_count_0;

    reg testpoint_21_goal_0;
    initial testpoint_21_goal_0 = 0;
    initial testpoint_21_count_0 = 0;
    always@(testpoint_21_count_0) begin
        if(testpoint_21_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_21_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: read_eg_arb ::: All clients requesting at the same time ::: ( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])");
 `endif
            //VCS coverage on
            //coverage name read_eg_arb ::: All clients requesting at the same time ::: testpoint_21_goal_0
            testpoint_21_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_21_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_21_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_21
        if (testpoint_21_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk)
                $display("NVIDIA TESTPOINT: read_eg_arb ::: All clients requesting at the same time ::: testpoint_21_goal_0");
 `endif
            if ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk)
                testpoint_21_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk) begin
 `endif
                testpoint_21_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_21_goal_0_active = ((( req[0] && req[1] && req[2] && req[3] && req[4] && req[5] && req[6] && req[7] && req[8] && req[9])) && testpoint_got_reset_testpoint_21_internal_reset__with_clock_testpoint_21_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_21_goal_0 (.clk (testpoint_21_internal_clk), .tp(testpoint_21_goal_0_active));
 `else
    system_verilog_testpoint svt_All_clients_requesting_at_the_same_time_0 (.clk (testpoint_21_internal_clk), .tp(testpoint_21_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`endif


endmodule // read_eg_arb



//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// arbgen2 -m write_ig_arb -n 5 -stdout -gnt_busy -t wrr -wt_width 8
// TYPE: wrr 
`include "simulate_x_tick.vh"

module write_ig_arb (
   req0
  ,req1
  ,req2
  ,req3
  ,req4
  ,wt0
  ,wt1
  ,wt2
  ,wt3
  ,wt4
  ,gnt_busy
  ,clk
  ,reset_
  ,gnt0
  ,gnt1
  ,gnt2
  ,gnt3
  ,gnt4
  );

//Declaring ports

input req0;
input req1;
input req2;
input req3;
input req4;
input [7:0] wt0;
input [7:0] wt1;
input [7:0] wt2;
input [7:0] wt3;
input [7:0] wt4;
input gnt_busy;
input clk;
input reset_;
output gnt0;
output gnt1;
output gnt2;
output gnt3;
output gnt4;


//Declaring clock and reset



//Declaring registers and wires

reg  [4:0] gnt;
reg  [4:0] gnt_pre;
reg  [4:0] wrr_gnt;
reg  [7:0] wt_left;
reg  [7:0] wt_left_nxt;
wire [7:0] new_wt_left0;
wire [7:0] new_wt_left1;
wire [7:0] new_wt_left2;
wire [7:0] new_wt_left3;
wire [7:0] new_wt_left4;
wire [4:0] req;


assign  req = {
  (req4 & (|wt4))
, (req3 & (|wt3)) 
, (req2 & (|wt2)) 
, (req1 & (|wt1)) 
, (req0 & (|wt0)) 
};

assign {
 gnt4
,gnt3
,gnt2
,gnt1
,gnt0
} = gnt;


always @(
  gnt_busy
  or gnt_pre
  ) begin
    gnt = {5{!gnt_busy}} & gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
// verilint 484 off - Possible loss of carry/borrow in addition/subtraction

assign new_wt_left0[7:0] = wt0 - 1'b1;

assign new_wt_left1[7:0] = wt1 - 1'b1;

assign new_wt_left2[7:0] = wt2 - 1'b1;

assign new_wt_left3[7:0] = wt3 - 1'b1;

assign new_wt_left4[7:0] = wt4 - 1'b1;
always @(
  wt_left
  or req
  or wrr_gnt
  or new_wt_left0
  or new_wt_left1
  or new_wt_left2
  or new_wt_left3
  or new_wt_left4
  ) begin
    gnt_pre = {5{1'b0}};
    wt_left_nxt = wt_left;
        if (wt_left == 0 | !(|(req & wrr_gnt)) ) begin
            case (wrr_gnt)
                5'b00000 : begin 
                    if      (req[0]) begin
                         gnt_pre = 5'b00001;
                         wt_left_nxt = new_wt_left0;
                     end 
                    else if (req[1]) begin
                         gnt_pre = 5'b00010;
                         wt_left_nxt = new_wt_left1;
                    end 
                    else if (req[2]) begin
                         gnt_pre = 5'b00100;
                         wt_left_nxt = new_wt_left2;
                    end 
                    else if (req[3]) begin
                         gnt_pre = 5'b01000;
                         wt_left_nxt = new_wt_left3;
                    end 
                    else if (req[4]) begin
                         gnt_pre = 5'b10000;
                         wt_left_nxt = new_wt_left4;
                    end 
                end 
                5'b00001 : begin 
                    if      (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
               end
                5'b00010 : begin 
                    if      (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
               end
                5'b00100 : begin 
                    if      (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
               end
                5'b01000 : begin 
                    if      (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
               end
                5'b10000 : begin 
                    if      (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
               end
                //VCS coverage off
                default : begin 
                            gnt_pre[4:0] = {5{`x_or_0}};
                            wt_left_nxt[7:0] = {8{`x_or_0}};
                          end  
                //VCS coverage on
            endcase
        end else begin
            gnt_pre = wrr_gnt;
            wt_left_nxt = wt_left - 1'b1;
        end
end
// verilint 69 on - Case statement without default clause, but all the cases are covered
// verilint 71 on - Case statement without default clause
// verilint 264 on - Not all possible cases covered
// verilint 484 on - Possible loss of carry/borrow in addition/subtraction
always @(posedge clk or negedge reset_) begin
  if (!reset_) begin
    wrr_gnt <= {5{1'b0}};
    wt_left <= {8{1'b0}};
  end else begin
    if (!gnt_busy & req != {5{1'b0}}) begin
        wrr_gnt <= gnt;
        wt_left <= wt_left_nxt;
    end 
  end
end
//end of always block

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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,5,0,"gnt not zero one hot")      zzz_grant_zero_one_hot_8x (clk, `ASSERT_RESET, (gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt to a non requesting client")      zzz_grant_to_no_req_9x (clk, `ASSERT_RESET, (|(~req & gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"no gnt even if at least 1 client requesting ")      zzz_no_gnt_when_expected_10x (clk, `ASSERT_RESET, (!gnt_busy & |(req) & !(|gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt when gnt_busy ")      zzz_gnt_when_busy_11x (clk, `ASSERT_RESET, (gnt_busy & |gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

`ifdef COVER


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_0_granted
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // TP__Client_0_granted

`ifdef COVER_OR_TP__Client_0_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 0 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_22_internal_clk   = clk;
wire testpoint_22_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_22_internal_reset_
    //  Clock signal: testpoint_22_internal_clk
    reg testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk;

    initial
        testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk <= 1'b0;

    always @(posedge testpoint_22_internal_clk or negedge testpoint_22_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_22
        if (~testpoint_22_internal_reset_)
            testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_22_count_0;

    reg testpoint_22_goal_0;
    initial testpoint_22_goal_0 = 0;
    initial testpoint_22_count_0 = 0;
    always@(testpoint_22_count_0) begin
        if(testpoint_22_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_22_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: Client 0 granted ::: (gnt[0])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: Client 0 granted ::: testpoint_22_goal_0
            testpoint_22_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_22_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_22_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_22
        if (testpoint_22_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[0])) && testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: Client 0 granted ::: testpoint_22_goal_0");
 `endif
            if (((gnt[0])) && testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk)
                testpoint_22_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk) begin
 `endif
                testpoint_22_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_22_goal_0_active = (((gnt[0])) && testpoint_got_reset_testpoint_22_internal_reset__with_clock_testpoint_22_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_22_goal_0 (.clk (testpoint_22_internal_clk), .tp(testpoint_22_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_0_granted_0 (.clk (testpoint_22_internal_clk), .tp(testpoint_22_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_0_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_1_granted
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // TP__Client_1_granted

`ifdef COVER_OR_TP__Client_1_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 1 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_23_internal_clk   = clk;
wire testpoint_23_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_23_internal_reset_
    //  Clock signal: testpoint_23_internal_clk
    reg testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk;

    initial
        testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk <= 1'b0;

    always @(posedge testpoint_23_internal_clk or negedge testpoint_23_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_23
        if (~testpoint_23_internal_reset_)
            testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_23_count_0;

    reg testpoint_23_goal_0;
    initial testpoint_23_goal_0 = 0;
    initial testpoint_23_count_0 = 0;
    always@(testpoint_23_count_0) begin
        if(testpoint_23_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_23_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: Client 1 granted ::: (gnt[1])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: Client 1 granted ::: testpoint_23_goal_0
            testpoint_23_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_23_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_23_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_23
        if (testpoint_23_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[1])) && testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: Client 1 granted ::: testpoint_23_goal_0");
 `endif
            if (((gnt[1])) && testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk)
                testpoint_23_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk) begin
 `endif
                testpoint_23_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_23_goal_0_active = (((gnt[1])) && testpoint_got_reset_testpoint_23_internal_reset__with_clock_testpoint_23_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_23_goal_0 (.clk (testpoint_23_internal_clk), .tp(testpoint_23_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_1_granted_0 (.clk (testpoint_23_internal_clk), .tp(testpoint_23_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_1_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_2_granted
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // TP__Client_2_granted

`ifdef COVER_OR_TP__Client_2_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 2 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_24_internal_clk   = clk;
wire testpoint_24_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_24_internal_reset_
    //  Clock signal: testpoint_24_internal_clk
    reg testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk;

    initial
        testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk <= 1'b0;

    always @(posedge testpoint_24_internal_clk or negedge testpoint_24_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_24
        if (~testpoint_24_internal_reset_)
            testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_24_count_0;

    reg testpoint_24_goal_0;
    initial testpoint_24_goal_0 = 0;
    initial testpoint_24_count_0 = 0;
    always@(testpoint_24_count_0) begin
        if(testpoint_24_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_24_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: Client 2 granted ::: (gnt[2])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: Client 2 granted ::: testpoint_24_goal_0
            testpoint_24_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_24_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_24_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_24
        if (testpoint_24_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[2])) && testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: Client 2 granted ::: testpoint_24_goal_0");
 `endif
            if (((gnt[2])) && testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk)
                testpoint_24_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk) begin
 `endif
                testpoint_24_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_24_goal_0_active = (((gnt[2])) && testpoint_got_reset_testpoint_24_internal_reset__with_clock_testpoint_24_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_24_goal_0 (.clk (testpoint_24_internal_clk), .tp(testpoint_24_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_2_granted_0 (.clk (testpoint_24_internal_clk), .tp(testpoint_24_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_2_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_3_granted
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // TP__Client_3_granted

`ifdef COVER_OR_TP__Client_3_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 3 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_25_internal_clk   = clk;
wire testpoint_25_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_25_internal_reset_
    //  Clock signal: testpoint_25_internal_clk
    reg testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk;

    initial
        testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk <= 1'b0;

    always @(posedge testpoint_25_internal_clk or negedge testpoint_25_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_25
        if (~testpoint_25_internal_reset_)
            testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_25_count_0;

    reg testpoint_25_goal_0;
    initial testpoint_25_goal_0 = 0;
    initial testpoint_25_count_0 = 0;
    always@(testpoint_25_count_0) begin
        if(testpoint_25_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_25_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: Client 3 granted ::: (gnt[3])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: Client 3 granted ::: testpoint_25_goal_0
            testpoint_25_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_25_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_25_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_25
        if (testpoint_25_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[3])) && testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: Client 3 granted ::: testpoint_25_goal_0");
 `endif
            if (((gnt[3])) && testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk)
                testpoint_25_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk) begin
 `endif
                testpoint_25_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_25_goal_0_active = (((gnt[3])) && testpoint_got_reset_testpoint_25_internal_reset__with_clock_testpoint_25_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_25_goal_0 (.clk (testpoint_25_internal_clk), .tp(testpoint_25_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_3_granted_0 (.clk (testpoint_25_internal_clk), .tp(testpoint_25_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_3_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_4_granted
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // TP__Client_4_granted

`ifdef COVER_OR_TP__Client_4_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 4 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_26_internal_clk   = clk;
wire testpoint_26_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_26_internal_reset_
    //  Clock signal: testpoint_26_internal_clk
    reg testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk;

    initial
        testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk <= 1'b0;

    always @(posedge testpoint_26_internal_clk or negedge testpoint_26_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_26
        if (~testpoint_26_internal_reset_)
            testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_26_count_0;

    reg testpoint_26_goal_0;
    initial testpoint_26_goal_0 = 0;
    initial testpoint_26_count_0 = 0;
    always@(testpoint_26_count_0) begin
        if(testpoint_26_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_26_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: Client 4 granted ::: (gnt[4])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: Client 4 granted ::: testpoint_26_goal_0
            testpoint_26_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_26_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_26_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_26
        if (testpoint_26_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[4])) && testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: Client 4 granted ::: testpoint_26_goal_0");
 `endif
            if (((gnt[4])) && testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk)
                testpoint_26_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk) begin
 `endif
                testpoint_26_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_26_goal_0_active = (((gnt[4])) && testpoint_got_reset_testpoint_26_internal_reset__with_clock_testpoint_26_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_26_goal_0 (.clk (testpoint_26_internal_clk), .tp(testpoint_26_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_4_granted_0 (.clk (testpoint_26_internal_clk), .tp(testpoint_26_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_4_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef TP__All_clients_requesting_at_the_same_time
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // TP__All_clients_requesting_at_the_same_time

`ifdef COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="All clients requesting at the same time"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_27_internal_clk   = clk;
wire testpoint_27_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_27_internal_reset_
    //  Clock signal: testpoint_27_internal_clk
    reg testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk;

    initial
        testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk <= 1'b0;

    always @(posedge testpoint_27_internal_clk or negedge testpoint_27_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_27
        if (~testpoint_27_internal_reset_)
            testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_27_count_0;

    reg testpoint_27_goal_0;
    initial testpoint_27_goal_0 = 0;
    initial testpoint_27_count_0 = 0;
    always@(testpoint_27_count_0) begin
        if(testpoint_27_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_27_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_ig_arb ::: All clients requesting at the same time ::: ( req[0] && req[1] && req[2] && req[3] && req[4])");
 `endif
            //VCS coverage on
            //coverage name write_ig_arb ::: All clients requesting at the same time ::: testpoint_27_goal_0
            testpoint_27_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_27_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_27_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_27
        if (testpoint_27_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk)
                $display("NVIDIA TESTPOINT: write_ig_arb ::: All clients requesting at the same time ::: testpoint_27_goal_0");
 `endif
            if ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk)
                testpoint_27_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk) begin
 `endif
                testpoint_27_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_27_goal_0_active = ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_27_internal_reset__with_clock_testpoint_27_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_27_goal_0 (.clk (testpoint_27_internal_clk), .tp(testpoint_27_goal_0_active));
 `else
    system_verilog_testpoint svt_All_clients_requesting_at_the_same_time_0 (.clk (testpoint_27_internal_clk), .tp(testpoint_27_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`endif


endmodule // write_ig_arb


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// arbgen2 -m write_eg_arb -n 5 -stdout -t wrr -wt_width 8
// TYPE: wrr 
`include "simulate_x_tick.vh"

module write_eg_arb (
   req0
  ,req1
  ,req2
  ,req3
  ,req4
  ,wt0
  ,wt1
  ,wt2
  ,wt3
  ,wt4
  ,clk
  ,reset_
  ,gnt0
  ,gnt1
  ,gnt2
  ,gnt3
  ,gnt4
  );

//Declaring ports

input req0;
input req1;
input req2;
input req3;
input req4;
input [7:0] wt0;
input [7:0] wt1;
input [7:0] wt2;
input [7:0] wt3;
input [7:0] wt4;
input clk;
input reset_;
output gnt0;
output gnt1;
output gnt2;
output gnt3;
output gnt4;


//Declaring clock and reset



//Declaring registers and wires

reg  [4:0] gnt;
reg  [4:0] gnt_pre;
reg  [4:0] wrr_gnt;
reg  [7:0] wt_left;
reg  [7:0] wt_left_nxt;
wire [7:0] new_wt_left0;
wire [7:0] new_wt_left1;
wire [7:0] new_wt_left2;
wire [7:0] new_wt_left3;
wire [7:0] new_wt_left4;
wire [4:0] req;


assign  req = {
  (req4 & (|wt4))
, (req3 & (|wt3)) 
, (req2 & (|wt2)) 
, (req1 & (|wt1)) 
, (req0 & (|wt0)) 
};

assign {
 gnt4
,gnt3
,gnt2
,gnt1
,gnt0
} = gnt;


always @(
  gnt_pre
  ) begin
    gnt = gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
// verilint 484 off - Possible loss of carry/borrow in addition/subtraction

assign new_wt_left0[7:0] = wt0 - 1'b1;

assign new_wt_left1[7:0] = wt1 - 1'b1;

assign new_wt_left2[7:0] = wt2 - 1'b1;

assign new_wt_left3[7:0] = wt3 - 1'b1;

assign new_wt_left4[7:0] = wt4 - 1'b1;
always @(
  wt_left
  or req
  or wrr_gnt
  or new_wt_left0
  or new_wt_left1
  or new_wt_left2
  or new_wt_left3
  or new_wt_left4
  ) begin
    gnt_pre = {5{1'b0}};
    wt_left_nxt = wt_left;
        if (wt_left == 0 | !(|(req & wrr_gnt)) ) begin
            case (wrr_gnt)
                5'b00000 : begin 
                    if      (req[0]) begin
                         gnt_pre = 5'b00001;
                         wt_left_nxt = new_wt_left0;
                     end 
                    else if (req[1]) begin
                         gnt_pre = 5'b00010;
                         wt_left_nxt = new_wt_left1;
                    end 
                    else if (req[2]) begin
                         gnt_pre = 5'b00100;
                         wt_left_nxt = new_wt_left2;
                    end 
                    else if (req[3]) begin
                         gnt_pre = 5'b01000;
                         wt_left_nxt = new_wt_left3;
                    end 
                    else if (req[4]) begin
                         gnt_pre = 5'b10000;
                         wt_left_nxt = new_wt_left4;
                    end 
                end 
                5'b00001 : begin 
                    if      (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
               end
                5'b00010 : begin 
                    if      (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
               end
                5'b00100 : begin 
                    if      (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
               end
                5'b01000 : begin 
                    if      (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
                    else if (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
               end
                5'b10000 : begin 
                    if      (req[0]) begin
                        gnt_pre = 5'b00001;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 5'b00010;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[2]) begin
                        gnt_pre = 5'b00100;
                        wt_left_nxt = new_wt_left2;
                    end
                    else if (req[3]) begin
                        gnt_pre = 5'b01000;
                        wt_left_nxt = new_wt_left3;
                    end
                    else if (req[4]) begin
                        gnt_pre = 5'b10000;
                        wt_left_nxt = new_wt_left4;
                    end
               end
                //VCS coverage off
                default : begin 
                            gnt_pre[4:0] = {5{`x_or_0}};
                            wt_left_nxt[7:0] = {8{`x_or_0}};
                          end  
                //VCS coverage on
            endcase
        end else begin
            gnt_pre = wrr_gnt;
            wt_left_nxt = wt_left - 1'b1;
        end
end
// verilint 69 on - Case statement without default clause, but all the cases are covered
// verilint 71 on - Case statement without default clause
// verilint 264 on - Not all possible cases covered
// verilint 484 on - Possible loss of carry/borrow in addition/subtraction
always @(posedge clk or negedge reset_) begin
  if (!reset_) begin
    wrr_gnt <= {5{1'b0}};
    wt_left <= {8{1'b0}};
  end else begin
    if (req != {5{1'b0}}) begin
        wrr_gnt <= gnt;
        wt_left <= wt_left_nxt;
    end 
  end
end
//end of always block

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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,5,0,"gnt not zero one hot")      zzz_grant_zero_one_hot_12x (clk, `ASSERT_RESET, (gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"gnt to a non requesting client")      zzz_grant_to_no_req_13x (clk, `ASSERT_RESET, (|(~req & gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`define ASSERT_RESET reset_
`else
`ifdef SYNTHESIS
`define ASSERT_RESET reset_
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === reset_) ? 1'b0 : reset_)
`else
`define ASSERT_RESET ((1'bx === reset_) ? 1'b1 : reset_)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"no gnt even if at least 1 client requesting ")      zzz_no_gnt_when_expected_14x (clk, `ASSERT_RESET, (|(req) & !(|gnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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

`ifdef COVER


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_0_granted
    `define COVER_OR_TP__Client_0_granted_OR_COVER
  `endif // TP__Client_0_granted

`ifdef COVER_OR_TP__Client_0_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 0 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_28_internal_clk   = clk;
wire testpoint_28_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_28_internal_reset_
    //  Clock signal: testpoint_28_internal_clk
    reg testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk;

    initial
        testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk <= 1'b0;

    always @(posedge testpoint_28_internal_clk or negedge testpoint_28_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_28
        if (~testpoint_28_internal_reset_)
            testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_28_count_0;

    reg testpoint_28_goal_0;
    initial testpoint_28_goal_0 = 0;
    initial testpoint_28_count_0 = 0;
    always@(testpoint_28_count_0) begin
        if(testpoint_28_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_28_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: Client 0 granted ::: (gnt[0])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: Client 0 granted ::: testpoint_28_goal_0
            testpoint_28_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_28_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_28_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_28
        if (testpoint_28_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[0])) && testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: Client 0 granted ::: testpoint_28_goal_0");
 `endif
            if (((gnt[0])) && testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk)
                testpoint_28_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk) begin
 `endif
                testpoint_28_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_28_goal_0_active = (((gnt[0])) && testpoint_got_reset_testpoint_28_internal_reset__with_clock_testpoint_28_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_28_goal_0 (.clk (testpoint_28_internal_clk), .tp(testpoint_28_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_0_granted_0 (.clk (testpoint_28_internal_clk), .tp(testpoint_28_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_0_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_1_granted
    `define COVER_OR_TP__Client_1_granted_OR_COVER
  `endif // TP__Client_1_granted

`ifdef COVER_OR_TP__Client_1_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 1 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_29_internal_clk   = clk;
wire testpoint_29_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_29_internal_reset_
    //  Clock signal: testpoint_29_internal_clk
    reg testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk;

    initial
        testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk <= 1'b0;

    always @(posedge testpoint_29_internal_clk or negedge testpoint_29_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_29
        if (~testpoint_29_internal_reset_)
            testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_29_count_0;

    reg testpoint_29_goal_0;
    initial testpoint_29_goal_0 = 0;
    initial testpoint_29_count_0 = 0;
    always@(testpoint_29_count_0) begin
        if(testpoint_29_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_29_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: Client 1 granted ::: (gnt[1])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: Client 1 granted ::: testpoint_29_goal_0
            testpoint_29_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_29_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_29_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_29
        if (testpoint_29_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[1])) && testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: Client 1 granted ::: testpoint_29_goal_0");
 `endif
            if (((gnt[1])) && testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk)
                testpoint_29_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk) begin
 `endif
                testpoint_29_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_29_goal_0_active = (((gnt[1])) && testpoint_got_reset_testpoint_29_internal_reset__with_clock_testpoint_29_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_29_goal_0 (.clk (testpoint_29_internal_clk), .tp(testpoint_29_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_1_granted_0 (.clk (testpoint_29_internal_clk), .tp(testpoint_29_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_1_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_2_granted
    `define COVER_OR_TP__Client_2_granted_OR_COVER
  `endif // TP__Client_2_granted

`ifdef COVER_OR_TP__Client_2_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 2 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_30_internal_clk   = clk;
wire testpoint_30_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_30_internal_reset_
    //  Clock signal: testpoint_30_internal_clk
    reg testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk;

    initial
        testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk <= 1'b0;

    always @(posedge testpoint_30_internal_clk or negedge testpoint_30_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_30
        if (~testpoint_30_internal_reset_)
            testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_30_count_0;

    reg testpoint_30_goal_0;
    initial testpoint_30_goal_0 = 0;
    initial testpoint_30_count_0 = 0;
    always@(testpoint_30_count_0) begin
        if(testpoint_30_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_30_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: Client 2 granted ::: (gnt[2])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: Client 2 granted ::: testpoint_30_goal_0
            testpoint_30_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_30_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_30_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_30
        if (testpoint_30_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[2])) && testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: Client 2 granted ::: testpoint_30_goal_0");
 `endif
            if (((gnt[2])) && testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk)
                testpoint_30_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk) begin
 `endif
                testpoint_30_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_30_goal_0_active = (((gnt[2])) && testpoint_got_reset_testpoint_30_internal_reset__with_clock_testpoint_30_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_30_goal_0 (.clk (testpoint_30_internal_clk), .tp(testpoint_30_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_2_granted_0 (.clk (testpoint_30_internal_clk), .tp(testpoint_30_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_2_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_3_granted
    `define COVER_OR_TP__Client_3_granted_OR_COVER
  `endif // TP__Client_3_granted

`ifdef COVER_OR_TP__Client_3_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 3 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_31_internal_clk   = clk;
wire testpoint_31_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_31_internal_reset_
    //  Clock signal: testpoint_31_internal_clk
    reg testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk;

    initial
        testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk <= 1'b0;

    always @(posedge testpoint_31_internal_clk or negedge testpoint_31_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_31
        if (~testpoint_31_internal_reset_)
            testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_31_count_0;

    reg testpoint_31_goal_0;
    initial testpoint_31_goal_0 = 0;
    initial testpoint_31_count_0 = 0;
    always@(testpoint_31_count_0) begin
        if(testpoint_31_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_31_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: Client 3 granted ::: (gnt[3])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: Client 3 granted ::: testpoint_31_goal_0
            testpoint_31_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_31_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_31_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_31
        if (testpoint_31_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[3])) && testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: Client 3 granted ::: testpoint_31_goal_0");
 `endif
            if (((gnt[3])) && testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk)
                testpoint_31_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk) begin
 `endif
                testpoint_31_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_31_goal_0_active = (((gnt[3])) && testpoint_got_reset_testpoint_31_internal_reset__with_clock_testpoint_31_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_31_goal_0 (.clk (testpoint_31_internal_clk), .tp(testpoint_31_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_3_granted_0 (.clk (testpoint_31_internal_clk), .tp(testpoint_31_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_3_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // COVER

  `ifdef TP__Client_4_granted
    `define COVER_OR_TP__Client_4_granted_OR_COVER
  `endif // TP__Client_4_granted

`ifdef COVER_OR_TP__Client_4_granted_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="Client 4 granted"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_32_internal_clk   = clk;
wire testpoint_32_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_32_internal_reset_
    //  Clock signal: testpoint_32_internal_clk
    reg testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk;

    initial
        testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk <= 1'b0;

    always @(posedge testpoint_32_internal_clk or negedge testpoint_32_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_32
        if (~testpoint_32_internal_reset_)
            testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_32_count_0;

    reg testpoint_32_goal_0;
    initial testpoint_32_goal_0 = 0;
    initial testpoint_32_count_0 = 0;
    always@(testpoint_32_count_0) begin
        if(testpoint_32_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_32_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: Client 4 granted ::: (gnt[4])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: Client 4 granted ::: testpoint_32_goal_0
            testpoint_32_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_32_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_32_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_32
        if (testpoint_32_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((gnt[4])) && testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: Client 4 granted ::: testpoint_32_goal_0");
 `endif
            if (((gnt[4])) && testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk)
                testpoint_32_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk) begin
 `endif
                testpoint_32_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_32_goal_0_active = (((gnt[4])) && testpoint_got_reset_testpoint_32_internal_reset__with_clock_testpoint_32_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_32_goal_0 (.clk (testpoint_32_internal_clk), .tp(testpoint_32_goal_0_active));
 `else
    system_verilog_testpoint svt_Client_4_granted_0 (.clk (testpoint_32_internal_clk), .tp(testpoint_32_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__Client_4_granted_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // COVER

  `ifdef TP__All_clients_requesting_at_the_same_time
    `define COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
  `endif // TP__All_clients_requesting_at_the_same_time

`ifdef COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME="All clients requesting at the same time"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_33_internal_clk   = clk;
wire testpoint_33_internal_reset_ = reset_;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_33_internal_reset_
    //  Clock signal: testpoint_33_internal_clk
    reg testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk;

    initial
        testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk <= 1'b0;

    always @(posedge testpoint_33_internal_clk or negedge testpoint_33_internal_reset_) begin: HAS_RETENTION_TESTPOINT_RESET_33
        if (~testpoint_33_internal_reset_)
            testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_33_count_0;

    reg testpoint_33_goal_0;
    initial testpoint_33_goal_0 = 0;
    initial testpoint_33_count_0 = 0;
    always@(testpoint_33_count_0) begin
        if(testpoint_33_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_33_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: write_eg_arb ::: All clients requesting at the same time ::: ( req[0] && req[1] && req[2] && req[3] && req[4])");
 `endif
            //VCS coverage on
            //coverage name write_eg_arb ::: All clients requesting at the same time ::: testpoint_33_goal_0
            testpoint_33_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_33_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_33_internal_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_33
        if (testpoint_33_internal_reset_) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk)
                $display("NVIDIA TESTPOINT: write_eg_arb ::: All clients requesting at the same time ::: testpoint_33_goal_0");
 `endif
            if ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk)
                testpoint_33_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk) begin
 `endif
                testpoint_33_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_33_goal_0_active = ((( req[0] && req[1] && req[2] && req[3] && req[4])) && testpoint_got_reset_testpoint_33_internal_reset__with_clock_testpoint_33_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_33_goal_0 (.clk (testpoint_33_internal_clk), .tp(testpoint_33_goal_0_active));
 `else
    system_verilog_testpoint svt_All_clients_requesting_at_the_same_time_0 (.clk (testpoint_33_internal_clk), .tp(testpoint_33_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`endif


endmodule // write_eg_arb



