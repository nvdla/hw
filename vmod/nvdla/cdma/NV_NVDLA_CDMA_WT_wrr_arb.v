// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_WT_wrr_arb.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDMA_WT_wrr_arb (
   req0
  ,req1
  ,wt0
  ,wt1
  ,gnt_busy
  ,clk
  ,reset_
  ,gnt0
  ,gnt1
  );

//Declaring ports

input req0;
input req1;
input [4:0] wt0;
input [4:0] wt1;
input gnt_busy;
input clk;
input reset_;
output gnt0;
output gnt1;


//Declaring clock and reset



//Declaring registers and wires

reg  [1:0] gnt;
reg  [1:0] gnt_pre;
reg  [1:0] wrr_gnt;
reg  [4:0] wt_left;
reg  [4:0] wt_left_nxt;
wire [4:0] new_wt_left0;
wire [4:0] new_wt_left1;
wire [1:0] req;


assign  req = {
  (req1 & (|wt1))
, (req0 & (|wt0)) 
};

assign {
 gnt1
,gnt0
} = gnt;


always @(
  gnt_busy
  or gnt_pre
  ) begin
    gnt = {2{!gnt_busy}} & gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
// verilint 484 off - Possible loss of carry/borrow in addition/subtraction

assign new_wt_left0[4:0] = wt0 - 1'b1;

assign new_wt_left1[4:0] = wt1 - 1'b1;
always @(
  wt_left
  or req
  or wrr_gnt
  or new_wt_left0
  or new_wt_left1
  ) begin
    gnt_pre = {2{1'b0}};
    wt_left_nxt = wt_left;
        if (wt_left == 0 | !(|(req & wrr_gnt)) ) begin
            case (wrr_gnt)
                2'b00 : begin 
                    if      (req[0]) begin
                         gnt_pre = 2'b01;
                         wt_left_nxt = new_wt_left0;
                     end 
                    else if (req[1]) begin
                         gnt_pre = 2'b10;
                         wt_left_nxt = new_wt_left1;
                    end 
                end 
                2'b01 : begin 
                    if      (req[1]) begin
                        gnt_pre = 2'b10;
                        wt_left_nxt = new_wt_left1;
                    end
                    else if (req[0]) begin
                        gnt_pre = 2'b01;
                        wt_left_nxt = new_wt_left0;
                    end
               end
                2'b10 : begin 
                    if      (req[0]) begin
                        gnt_pre = 2'b01;
                        wt_left_nxt = new_wt_left0;
                    end
                    else if (req[1]) begin
                        gnt_pre = 2'b10;
                        wt_left_nxt = new_wt_left1;
                    end
               end
                //VCS coverage off
                default : begin 
                            gnt_pre[1:0] = {2{`x_or_0}};
                            wt_left_nxt[4:0] = {5{`x_or_0}};
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
    wrr_gnt <= {2{1'b0}};
    wt_left <= {5{1'b0}};
  end else begin
    if (!gnt_busy & req != {2{1'b0}}) begin
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
  nv_assert_zero_one_hot #(0,2,0,"gnt not zero one hot")      zzz_grant_zero_one_hot_1x (clk, `ASSERT_RESET, (gnt)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_WT_wrr_arb ::: Client 0 granted ::: (gnt[0])");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_WT_wrr_arb ::: Client 0 granted ::: testpoint_0_goal_0
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
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_WT_wrr_arb ::: Client 0 granted ::: testpoint_0_goal_0");
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_WT_wrr_arb ::: Client 1 granted ::: (gnt[1])");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_WT_wrr_arb ::: Client 1 granted ::: testpoint_1_goal_0
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
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_WT_wrr_arb ::: Client 1 granted ::: testpoint_1_goal_0");
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
                $display("TESTPOINT_HIT: NV_NVDLA_CDMA_WT_wrr_arb ::: All clients requesting at the same time ::: ( req[0] && req[1])");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_CDMA_WT_wrr_arb ::: All clients requesting at the same time ::: testpoint_2_goal_0
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
            if ((( req[0] && req[1])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_CDMA_WT_wrr_arb ::: All clients requesting at the same time ::: testpoint_2_goal_0");
 `endif
            if ((( req[0] && req[1])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk)
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
    wire testpoint_2_goal_0_active = ((( req[0] && req[1])) && testpoint_got_reset_testpoint_2_internal_reset__with_clock_testpoint_2_internal_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt_All_clients_requesting_at_the_same_time_0 (.clk (testpoint_2_internal_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP__All_clients_requesting_at_the_same_time_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END

`endif


endmodule // NV_NVDLA_CDMA_WT_wrr_arb



